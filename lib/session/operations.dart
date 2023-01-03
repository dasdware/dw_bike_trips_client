import 'dart:async';

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

  Future<ValuedOperationResult<T>> perform(
      String pageName, OperationContext context);
}

class OperationContext {
  final Stack<Operation> _activeOperations = Stack<Operation>();
  final StreamController<Operation> _activeOperationStreamController =
      StreamController<Operation>.broadcast();

  final Map<String, OperationResult> _lastOperationResults =
      <String, OperationResult>{};
  final Map<String, StreamController<OperationResult>>
      _lastOperationResultStreamControllers =
      <String, StreamController<OperationResult>>{};

  final StreamController<OperationResult> _lastOperationResultStreamController =
      StreamController<OperationResult>.broadcast();

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

  Stream<OperationResult> get lastOperationResultStream =>
      _lastOperationResultStreamController.stream;

  Future<ValuedOperationResult<T>> perform<T>(
      String pageName, ValuedOperation<T> operation) async {
    ValuedOperationResult<T> result;
    _lastOperationResults.remove(pageName);
    _activeOperations.push(operation);
    _activeOperationStreamController.sink.add(activeOperation);
    try {
      result = await operation.perform(pageName, this);
      _lastOperationResults[pageName] = result;
      _lastOperationResultStreamControllerOf(pageName).sink.add(result);
      return result;
    } finally {
      _activeOperations.pop();
      _activeOperationStreamController.sink.add(activeOperation);
      if (_activeOperations.isEmpty) {
        _lastOperationResultStreamController.sink.add(result);
      }
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
    _lastOperationResultStreamController.close();
  }
}
