import 'package:dw_bike_trips_client/theme.dart' as AppTheme;
import 'package:dw_bike_trips_client/widgets/themed.dart';
import 'package:flutter/material.dart';

class ProgressPage extends StatelessWidget {
  final String _text;

  ProgressPage({Key key, String text})
      : _text = text,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Logo(),
            // SizedBox(
            //   height: 16.0,
            //   width: double.infinity,
            // ),
            LinearProgressIndicator(
              backgroundColor: AppTheme.primaryColors[3],
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppTheme.secondaryColors[2]),
            ),
            SizedBox(
              height: 8.0,
              width: double.infinity,
            ),
            ThemedText(text: _text)
          ],
        ),
      ),
    );
  }
}
