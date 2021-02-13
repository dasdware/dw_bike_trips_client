import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

class ThemedDot extends StatelessWidget {
  final double size;
  final double horzSpacing;
  final double vertSpacing;

  const ThemedDot({
    Key key,
    this.size = 3.0,
    this.horzSpacing = 8.0,
    this.vertSpacing = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horzSpacing,
        vertSpacing,
        horzSpacing,
        vertSpacing,
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppThemeData.headingColor,
          borderRadius: BorderRadius.circular(size),
        ),
      ),
    );
  }
}
