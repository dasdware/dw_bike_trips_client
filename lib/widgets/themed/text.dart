import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

enum ThemedTextSize { Normal, Small }
enum ThemedTextColor { Normal, Main, Highlight }

class ThemedText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final ThemedTextSize textSize;
  final ThemedTextColor textColor;
  final bool deemphasized;

  const ThemedText(
      {Key key,
      this.text,
      this.textAlign = TextAlign.center,
      this.textSize = ThemedTextSize.Normal,
      this.textColor = ThemedTextColor.Normal,
      this.deemphasized = false})
      : super(key: key);

  get _color {
    var color = AppThemeData.textColor;
    if (textColor == ThemedTextColor.Main) {
      color = AppThemeData.mainLighterColor;
    } else if (textColor == ThemedTextColor.Highlight) {
      color = AppThemeData.highlightColor;
    }

    if (deemphasized) {
      return color.withOpacity(AppThemeData.deemphesizedOpacity);
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: _color,
        fontSize: (textSize == ThemedTextSize.Small)
            ? AppThemeData.textSmallSize
            : AppThemeData.textSize,
      ),
      textAlign: textAlign,
    );
  }
}
