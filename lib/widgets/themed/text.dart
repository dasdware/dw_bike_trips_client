import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

class ThemedText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const ThemedText({Key key, this.text, this.textAlign = TextAlign.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: AppThemeData.textColor,
        fontSize: AppThemeData.textSize,
      ),
      textAlign: textAlign,
    );
  }
}
