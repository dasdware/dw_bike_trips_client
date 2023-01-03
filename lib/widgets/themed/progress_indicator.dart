import 'dart:ui';

import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:dw_bike_trips_client/widgets/themed/text.dart';
import 'package:flutter/material.dart';

class ThemedProgressIndicator extends StatelessWidget {
  final String text;

  const ThemedProgressIndicator(
    this.text, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5.0,
            sigmaY: 5.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(10),
            ),
          ),
        ),
        Container(
          color: Colors.black.withAlpha(175),
        ),
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const LinearProgressIndicator(
                  backgroundColor: AppThemeData.mainDarkestColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppThemeData.activeColor,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                  width: double.infinity,
                ),
                ThemedText(
                  text: text,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
