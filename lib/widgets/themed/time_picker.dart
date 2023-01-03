import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

Widget themedTimePickerBuilder(BuildContext context, Widget child) {
  return Theme(
    data: ThemeData.dark().copyWith(
      colorScheme: const ColorScheme.dark(
        primary: AppThemeData.highlightLighterColor,
        secondary: AppThemeData.highlightLighterColor,
        onPrimary: AppThemeData.highlightDarkerColor,
        surface: AppThemeData.mainDarkerColor,
        onSurface: AppThemeData.mainLightestColor,
      ),
      dialogBackgroundColor: AppThemeData.mainDarkerColor,
    ),
    child: child,
  );
}

Future<DateTime> showThemedTimePicker(
    BuildContext context, DateTime initialTime) async {
  var selectedTimeOfDay = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialTime),
    builder: themedTimePickerBuilder,
  );
  if (selectedTimeOfDay == null) {
    return null;
  }

  return DateTime(
    initialTime.year,
    initialTime.month,
    initialTime.day,
    selectedTimeOfDay.hour,
    selectedTimeOfDay.minute,
    initialTime.second,
    0,
    0,
  );
}
