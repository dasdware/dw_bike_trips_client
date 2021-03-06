import 'package:flutter/material.dart';

class AppThemeData {
  static const panelBackground = const Color.fromRGBO(255, 255, 255, 0.1);
  static const panelEmphasizedBackground =
      const Color.fromRGBO(255, 255, 255, 0.15);
  static const panelMostEmphasizedBackground =
      const Color.fromRGBO(255, 255, 255, 0.2);
  static const panelBorderRadius = 4.0;

  static const headingColor = const Color.fromRGBO(255, 255, 255, 0.7);
  static const headingMediumColor = const Color.fromRGBO(255, 255, 255, 0.8);
  static const headingBigColor = const Color.fromRGBO(255, 255, 255, 0.9);
  static const headingSmallFontSize = 12.0;
  static const headingMediumFontSize = 16.0;
  static const headingBigFontSize = 20.0;

  static const highlightColor = Color(0xFFD4BD6A);
  static const highlightLighterColor = Color(0xFFFFECAA);
  static const highlightDarkerColor = Color(0xFF806815);
  static const highlightDarkestColor = Color(0xFF554200);

  static const activeColor = highlightColor;
  static const activeLighterColor = highlightLighterColor;
  static const activeDarkerColor = highlightDarkerColor;
  static const activeDarkestColor = highlightDarkestColor;

  static const tooltipBackground = const Color.fromRGBO(0, 0, 0, 0.6);
}
