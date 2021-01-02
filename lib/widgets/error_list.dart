import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/theme.dart' as AppTheme;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ErrorList extends StatelessWidget {
  final String operationName;
  final EdgeInsets padding;

  const ErrorList(
      {Key key,
      this.operationName,
      this.padding = const EdgeInsets.fromLTRB(16.0, 0, 16.0, 32.0)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var operationContext = context.watch<Session>().operationContext;
    return StreamBuilder<OperationResult>(
      stream: operationContext.lastOperationResultStreamOf(operationName),
      initialData: operationContext.lastOperationResultOf(operationName),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.errors.length > 0) {
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
                  children: snapshot.data.errors
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
        } else {
          return Container();
        }
      },
    );
  }
}
