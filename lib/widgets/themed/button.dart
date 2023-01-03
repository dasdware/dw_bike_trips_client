import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:dw_bike_trips_client/widgets/themed/icon.dart';
import 'package:flutter/material.dart';

class ThemedButton extends StatelessWidget {
  final IconData icon;
  final String overlayText;
  final IconData overlayIcon;
  final String caption;
  final Function onPressed;
  final bool flat;

  const ThemedButton(
      {Key key,
      this.icon,
      this.overlayIcon,
      this.overlayText,
      this.caption,
      this.onPressed,
      this.flat = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (flat)
        ? TextButton.icon(
            icon: ThemedIcon(
              icon: icon,
              overlayIcon: overlayIcon,
              overlayText: overlayText,
              color: AppThemeData.activeColor,
              size: 22.0,
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
            ),
            label: Text(
              caption.toUpperCase(),
              style: const TextStyle(
                color: AppThemeData.activeColor,
              ),
            ),
            onPressed: onPressed,
          )
        : ElevatedButton.icon(
            icon: ThemedIcon(
              icon: icon,
              overlayIcon: overlayIcon,
              overlayText: overlayText,
              color: AppThemeData.activeDarkestColor,
              size: 22.0,
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
              backgroundColor: AppThemeData.activeColor,
            ),
            label: Text(
              caption.toUpperCase(),
              style: const TextStyle(
                color: AppThemeData.activeDarkestColor,
              ),
            ),
            onPressed: onPressed,
          );
  }
}
