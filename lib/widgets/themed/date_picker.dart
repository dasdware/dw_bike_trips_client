import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

Widget themedDatePickerBuilder(BuildContext context, Widget child) {
  return Theme(
    data: ThemeData.dark().copyWith(
      colorScheme: const ColorScheme.dark(
        primary: AppThemeData.mainLightestColor,
        secondary: AppThemeData.highlightLighterColor,
        onPrimary: AppThemeData.mainDarkerColor,
        surface: AppThemeData.mainColor,
        onSurface: AppThemeData.highlightLighterColor,
      ),
      dialogBackgroundColor: AppThemeData.mainDarkerColor,
    ),
    child: child,
  );
}

Future<DateTime> showThemedDatePicker(
    BuildContext context, DateTime initialDate) {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(1970),
    lastDate: DateTime(2170),
    builder: themedDatePickerBuilder,
  );
}
