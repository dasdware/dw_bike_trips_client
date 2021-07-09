import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

class ThemedIconButton extends StatelessWidget {
  final IconData _icon;
  final Function() _onPressed;

  const ThemedIconButton({Key key, IconData icon, Function() onPressed})
      : _icon = icon,
        _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_icon),
      color: AppThemeData.activeColor,
      onPressed: _onPressed,
    );
  }
}
