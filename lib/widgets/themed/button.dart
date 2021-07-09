import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

class ThemedButton extends StatelessWidget {
  final IconData icon;
  final String caption;
  final Function onPressed;
  final bool flat;

  const ThemedButton(
      {Key key, this.icon, this.caption, this.onPressed, this.flat = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (flat)
        ? FlatButton.icon(
            icon: Icon(
              icon,
              color: AppThemeData.activeColor,
            ),
            label: Text(
              caption.toUpperCase(),
              style: TextStyle(
                color: AppThemeData.activeColor,
              ),
            ),
            onPressed: onPressed,
          )
        : RaisedButton.icon(
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
