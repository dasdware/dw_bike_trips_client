import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stack/stack.dart';

class OperationError {
  final String message;

  OperationError(this.message);
}

class OperationResult {
  final bool success;
  final List<OperationError> errors;

  OperationResult(this.success, this.errors);

  factory OperationResult.withSuccess() => OperationResult(true, []);
  factory OperationResult.withErrors(List<OperationError> errors) =>
      OperationResult(false, errors);
}

class Operation {
  final String name;
  final String title;

  Operation(this.name, this.title);
}

class ValuedOperationResult<T> extends OperationResult {
  final T value;

  ValuedOperationResult(bool success, List<OperationError> errors, this.value)
      : super(success, errors);

  ValuedOperationResult<U> asWithErrors<U>() {
    return ValuedOperationResult<U>(false, errors, null);
  }

  factory ValuedOperationResult.withSuccess(T value) =>
      ValuedOperationResult(true, [], value);
  factory ValuedOperationResult.withErrors(List<OperationError> errors) =>
      ValuedOperationResult(false, errors, null);
}

abstract class ValuedOperation<T> extends Operation {
  ValuedOperation(String name, String title) : super(name, title);

  Future<ValuedOperationResult<T>> perform(OperationContext context);
}

class OperationContext {
  Stack<Operation> _activeOperations = Stack<Operation>();
  StreamController<Operation> _activeOperationStreamController =
      StreamController<Operation>.broadcast();

  Map<String, OperationResult> _lastOperationResults =
      Map<String, OperationResult>();
  Map<String, StreamController<OperationResult>>
      _lastOperationResultStreamControllers =
      Map<String, StreamController<OperationResult>>();

  Operation get activeOperation {
    if (_activeOperations.isNotEmpty) {
      return _activeOperations.top();
    } else {
      return null;
    }
  }

  Stream<Operation> get activeOperationStream =>
      _activeOperationStreamController.stream;

  bool get hasActiveOperation => _activeOperations.isNotEmpty;

  Future<ValuedOperationResult<T>> perform<T>(
      ValuedOperation<T> operation) async {
    _lastOperationResults.remove(operation.name);
    _activeOperations.push(operation);
    _activeOperationStreamController.sink.add(activeOperation);
    try {
      ValuedOperationResult<T> result = await operation.perform(this);
      _lastOperationResults[operation.name] = result;
      _lastOperationResultStreamControllerOf(operation.name).sink.add(result);
      return result;
    } finally {
      _activeOperations.pop();
      _activeOperationStreamController.sink.add(activeOperation);
    }
  }

  OperationResult lastOperationResultOf(String name) {
    if (_lastOperationResults.containsKey(name)) {
      return _lastOperationResults[name];
    }
    return OperationResult.withSuccess();
  }

  StreamController<OperationResult> _lastOperationResultStreamControllerOf(
      String name) {
    if (_lastOperationResultStreamControllers.containsKey(name)) {
      return _lastOperationResultStreamControllers[name];
    }

    var result = StreamController<OperationResult>.broadcast();
    _lastOperationResultStreamControllers[name] = result;
    return result;
  }

  Stream<OperationResult> lastOperationResultStreamOf(String name) {
    return _lastOperationResultStreamControllerOf(name).stream;
  }

  void close() {
    for (var streamController in _lastOperationResultStreamControllers.values) {
      streamController.close();
    }
    _activeOperationStreamController.close();
  }
}
