import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

enum ThemedTextSize { Normal, Small }

class ThemedText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final ThemedTextSize textSize;

  const ThemedText(
      {Key key,
      this.text,
      this.textAlign = TextAlign.center,
      this.textSize = ThemedTextSize.Normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: AppThemeData.textColor,
        fontSize: (textSize == ThemedTextSize.Small)
            ? AppThemeData.textSmallSize
            : AppThemeData.textSize,
      ),
      textAlign: textAlign,
    );
  }
}
