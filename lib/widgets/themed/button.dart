import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

class ThemedButton extends StatelessWidget {
  final IconData icon;
  final String caption;
  final Function onPressed;

  const ThemedButton({Key key, this.icon, this.caption, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      icon: Icon(
        icon,
        color: AppThemeData.activeDarkestColor,
      ),
      color: AppThemeData.activeColor,
      label: Text(
        caption.toUpperCase(),
        style: TextStyle(
          color: AppThemeData.activeDarkestColor,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
