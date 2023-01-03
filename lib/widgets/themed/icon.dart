import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

class _IconClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    const s = 8.0;
    path.lineTo(0.0, size.height);

    path.lineTo(size.width - s, size.height);

    // path.lineTo(size.width, 5);

    path.arcToPoint(
      Offset(size.width - 2 * s, size.height - s),
      clockwise: true,
      radius: const Radius.circular(s),
    );
    path.arcToPoint(
      Offset(size.width, size.height - s),
      clockwise: true,
      radius: const Radius.circular(s),
    );

    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

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
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppThemeData.activeLighterColor,
        ),
      );

      if (overlayText.length == 1) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 3.0), child: text);
      }

      return text;
    } else {
      return Icon(
        overlayIcon,
        color: color,
        size: _overlayIconSize,
      );
    }
  }

  get _clipper {
    if (!_haveOverlay) {
      return null;
    }
    return _IconClipper();
  }

  @override
  Widget build(BuildContext context) {
    var overlay = _haveOverlay
        ? Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.5),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: _buildOverlay(),
            ),
          )
        : null;

    return SizedBox(
      width: _paddedSize,
      height: _paddedSize,
      child: Stack(
        children: [
          ClipPath(
            clipper: _clipper,
            child: Center(
              child: Icon(
                icon,
                color: color,
                size: size,
              ),
            ),
          ),
          if (_haveOverlay)
            Positioned(
              right: 0,
              bottom: 0,
              child: overlay,
            ),
          // Expanded(
          //     child: ClipPath(
          //         clipper: _clipper, child: Container(color: Colors.red))),
        ],
      ),
    );
  }
}
