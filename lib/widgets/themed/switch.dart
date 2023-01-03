import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:dw_bike_trips_client/widgets/themed/text.dart';
import 'package:flutter/material.dart';

class ThemedSwitch extends StatelessWidget {
  final String text;
  final bool value;
  final Function(bool) onChanged;

  const ThemedSwitch({
    Key key,
    this.text,
    this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          activeTrackColor: AppThemeData.highlightDarkerColor,
          activeColor: AppThemeData.highlightColor,
          inactiveTrackColor:
              Color.lerp(AppThemeData.highlightDarkerColor, Colors.black, 0.35),
          inactiveThumbColor: AppThemeData.highlightDarkerColor,
          value: value,
          onChanged: onChanged,
        ),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: ThemedText(
              text: text,
              textColor:
                  value ? ThemedTextColor.highlight : ThemedTextColor.normal),
        ),
      ],
    );
  }
}
