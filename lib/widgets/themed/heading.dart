import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

enum ThemedHeadingStyle { tiny, small, medium, big }

class ThemedHeading extends StatelessWidget {
  final String caption;
  final ThemedHeadingStyle style;

  const ThemedHeading(
      {Key key, this.caption, this.style = ThemedHeadingStyle.medium})
      : super(key: key);

  _fontSize() {
    switch (style) {
      case ThemedHeadingStyle.tiny:
        return AppThemeData.headingSmallFontSize;
      case ThemedHeadingStyle.small:
        return AppThemeData.headingSmallFontSize;
      case ThemedHeadingStyle.medium:
        return AppThemeData.headingMediumFontSize;
      case ThemedHeadingStyle.big:
        return AppThemeData.headingBigFontSize;
    }
    return AppThemeData.headingMediumFontSize;
  }

  _fontWeight() {
    if (style == ThemedHeadingStyle.tiny) {
      return FontWeight.normal;
    } else if (style == ThemedHeadingStyle.small ||
        style == ThemedHeadingStyle.medium) {
      return FontWeight.w500;
    }
    return FontWeight.w500;
  }

  _fontColor() {
    if (style == ThemedHeadingStyle.big) {
      return AppThemeData.headingBigColor;
    } else if (style == ThemedHeadingStyle.medium) {
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
