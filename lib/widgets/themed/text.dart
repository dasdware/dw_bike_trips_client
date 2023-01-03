import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

enum ThemedTextSize { normal, small }
enum ThemedTextColor { normal, main, highlight }

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
      this.textSize = ThemedTextSize.normal,
      this.textColor = ThemedTextColor.normal,
      this.deemphasized = false})
      : super(key: key);

  get _color {
    var color = AppThemeData.textColor;
    if (textColor == ThemedTextColor.main) {
      color = AppThemeData.mainLighterColor;
    } else if (textColor == ThemedTextColor.highlight) {
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
        fontSize: (textSize == ThemedTextSize.small)
            ? AppThemeData.textSmallSize
            : AppThemeData.textSize,
      ),
      textAlign: textAlign,
    );
  }
}
