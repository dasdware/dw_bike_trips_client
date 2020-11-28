import 'package:dw_bike_trips_client/session.dart';
import 'package:dw_bike_trips_client/theme.dart' as AppTheme;
import 'package:flutter/material.dart';

class ThemedText extends StatelessWidget {
  static const double FONT_SIZE_TEXT = 18;
  static const double FONT_SIZE_SUBTITLE = 14;

  final String _text;
  final Color _color;
  final double _fontSize;
  final TextAlign _textAlign;

  ThemedText(
      {Key key,
      String text,
      Color color = AppTheme.secondaryColor_2,
      double fontSize = FONT_SIZE_TEXT,
      TextAlign textAlign = TextAlign.start})
      : _text = text,
        _color = color,
        _fontSize = fontSize,
        _textAlign = textAlign,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(color: _color, fontSize: _fontSize),
      textAlign: _textAlign,
    );
  }
}

class ThemedAvatar extends StatelessWidget {
  const ThemedAvatar({
    Key key,
    @required this.user,
    this.onPressed,
  }) : super(key: key);

  final User user;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    var initials = user.firstname.substring(0, 1).toUpperCase() +
        user.lastname.substring(0, 1).toUpperCase();

    if (onPressed != null) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: FlatButton(
          onPressed: onPressed,
          child: Text(
            initials,
            style: TextStyle(
                color: AppTheme.primaryColors[3], fontWeight: FontWeight.bold),
          ),
          shape: CircleBorder(),
          clipBehavior: Clip.hardEdge,
          color: AppTheme.primaryColors[1],
          splashColor: AppTheme.primaryColors[2],
          minWidth: 0.0,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: CircleAvatar(
          backgroundColor: AppTheme.primaryColors[1],
          child: Text(
            initials,
            style: TextStyle(
                color: AppTheme.primaryColors[3], fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }
}
