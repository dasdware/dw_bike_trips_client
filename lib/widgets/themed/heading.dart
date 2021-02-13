import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

enum ThemedHeadingStyle { Tiny, Small, Medium, Big }

class ThemedHeading extends StatelessWidget {
  final String caption;
  final ThemedHeadingStyle style;

  const ThemedHeading(
      {Key key, this.caption, this.style = ThemedHeadingStyle.Medium})
      : super(key: key);

  _fontSize() {
    switch (style) {
      case ThemedHeadingStyle.Tiny:
        return AppThemeData.headingSmallFontSize;
      case ThemedHeadingStyle.Small:
        return AppThemeData.headingSmallFontSize;
      case ThemedHeadingStyle.Medium:
        return AppThemeData.headingMediumFontSize;
      case ThemedHeadingStyle.Big:
        return AppThemeData.headingBigFontSize;
    }
    return AppThemeData.headingMediumFontSize;
  }

  _fontWeight() {
    if (style == ThemedHeadingStyle.Tiny) {
      return FontWeight.normal;
    } else if (style == ThemedHeadingStyle.Small ||
        style == ThemedHeadingStyle.Medium) {
      return FontWeight.w500;
    }
    return FontWeight.w500;
  }

  _fontColor() {
    if (style == ThemedHeadingStyle.Big) {
      return AppThemeData.headingBigColor;
    } else if (style == ThemedHeadingStyle.Medium) {
      return AppThemeData.headingMediumColor;
    }
    return AppThemeData.headingColor;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      caption.toUpperCase(),
      style: TextStyle(
        color: _fontColor(),
        fontWeight: _fontWeight(),
        letterSpacing: 0.6,
        fontSize: _fontSize(),
      ),
    );
  }
}
