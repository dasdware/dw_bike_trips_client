import 'package:dw_bike_trips_client/theme.dart' as AppTheme;
import 'package:flutter/material.dart';

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

class ErrorList extends StatelessWidget {
  final OperationResult result;
  final EdgeInsets padding;

  const ErrorList(
      {Key key,
      this.result,
      this.padding = const EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 8.0)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (result.success || result.errors.isEmpty) {
      return Container();
    }

    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.errorColor),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
          child: Column(
            children: result.errors
                .map(
                  (error) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(children: [
                      Icon(
                        Icons.error,
                        color: AppTheme.errorColor,
                        size: 16,
                      ),
                      SizedBox(width: 8.0),
                      Flexible(
                        child: Text(
                          error.message,
                          style: TextStyle(color: AppTheme.errorColor),
                        ),
                      ),
                    ]),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
