import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/widgets/page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({
    Key key,
    // @required this.operationContext,
  }) : super(key: key);

  // final OperationContext operationContext;

  @override
  Widget build(BuildContext context) {
    String pageName = ApplicationPage.of(context).pageName;
    return StreamBuilder<OperationResult>(
        stream: context
            .watch<Session>()
            .operationContext
            .lastOperationResultStreamOf(pageName),
        initialData: OperationResult.withSuccess(),
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.data.success) {
            return Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
              left: 16.0,
              right: 16.0,
              child: Material(
                color: Colors.transparent,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.redAccent[100].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.redAccent[100]),
                    ),
                    child: Column(
                      children: snapshot.data.errors
                          .map(
                            (error) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.error,
                                    color: Colors.redAccent[100],
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '$pageName: ${error.message}',
                                      // overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.redAccent[100],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    )),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
