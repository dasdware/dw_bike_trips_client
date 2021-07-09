import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

class ThemedIcon extends StatelessWidget {
  final IconData icon;
  final double size;

  const ThemedIcon({Key key, this.icon, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      this.icon,
      color: AppThemeData.textColor,
      size: this.size,
    );
  }
}
