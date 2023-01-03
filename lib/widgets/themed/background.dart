import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

class ThemedBackground extends StatelessWidget {
  final Widget child;

  const ThemedBackground({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.3, 0.7, 0.9],
            colors: [
              AppThemeData.mainDarkestColor,
              AppThemeData.mainDarkerColor,
              AppThemeData.mainDarkerColor,
              AppThemeData.mainDarkestColor,
            ],
          ),
        ),
        child: child);
  }
}
