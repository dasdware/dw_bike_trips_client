import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

class ThemedIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final IconData overlayIcon;
  final String overlayText;
  final Color color;

  const ThemedIcon(
      {Key key,
      this.icon,
      this.size = 24.0,
      this.color = AppThemeData.textColor,
      this.overlayText,
      this.overlayIcon})
      : super(key: key);

  bool get _haveOverlay {
    return (overlayText != null) || (overlayIcon != null);
  }

  double get _paddedSize => _haveOverlay ? size * 1.75 : size;
  double get _overlayIconSize => size * 0.55;

  _buildOverlay() {
    if (overlayText != null) {
      var text = Text(
        overlayText,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppThemeData.activeLighterColor,
        ),
      );

      if (overlayText.length == 1) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 3.0), child: text);
      }

      return text;
    } else {
      return Icon(
        this.overlayIcon,
        color: this.color,
        size: _overlayIconSize,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _paddedSize,
      height: _paddedSize,
      child: Stack(
        children: [
          Center(
            child: Icon(
              this.icon,
              color: color,
              size: this.size,
            ),
          ),
          if (_haveOverlay)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: _buildOverlay(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
