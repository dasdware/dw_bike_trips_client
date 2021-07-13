import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:dw_bike_trips_client/widgets/themed/icon.dart';
import 'package:flutter/material.dart';

class ThemedIconButton extends StatelessWidget {
  final IconData icon;
  final String overlayText;
  final IconData overlayIcon;
  final Function() onPressed;
  final String tooltip;

  const ThemedIconButton(
      {Key key,
      this.icon,
      this.overlayText,
      this.overlayIcon,
      this.onPressed,
      this.tooltip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: ThemedIcon(
        icon: icon,
        overlayIcon: overlayIcon,
        overlayText: overlayText,
        color: AppThemeData.activeColor,
      ),
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }
}
