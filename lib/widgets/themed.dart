import 'dart:ui';

import 'package:dw_bike_trips_client/session/operations.dart';
import 'package:dw_bike_trips_client/session/session.dart';
import 'package:dw_bike_trips_client/session/user.dart';
import 'package:dw_bike_trips_client/theme.dart' as AppTheme;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Widget buildInitials() {
    var initials = user.firstname.substring(0, 1).toUpperCase() +
        user.lastname.substring(0, 1).toUpperCase();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FittedBox(
        fit: BoxFit.cover,
        child: Text(
          initials,
          style: TextStyle(
              color: AppTheme.secondaryColors[4],
              fontWeight: FontWeight.bold,
              fontSize: 400),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (onPressed != null) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: FlatButton(
          onPressed: onPressed,
          child: buildInitials(),
          shape: CircleBorder(),
          clipBehavior: Clip.hardEdge,
          color: AppTheme.secondaryColors[2],
          splashColor: AppTheme.secondaryColors[1],
          minWidth: 0.0,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: CircleAvatar(
          backgroundColor: AppTheme.secondaryColors[2],
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: FittedBox(
              fit: BoxFit.cover,
              child: buildInitials(),
            ),
          ),
        ),
      );
    }
  }
}

class ThemedBackground extends StatelessWidget {
  final Widget child;

  ThemedBackground({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.3, 0.7, 0.9],
            colors: [
              AppTheme.primaryColors[4],
              AppTheme.primaryColors[3],
              AppTheme.primaryColors[3],
              AppTheme.primaryColors[4],
            ],
          ),
        ),
        child: child);
  }
}

class ThemedScaffold extends StatelessWidget {
  final Key innerKey;
  final Widget body;
  final Widget appBar;
  final Widget floatingActionButton;
  final Widget endDrawer;

  const ThemedScaffold(
      {Key key,
      this.innerKey,
      this.body,
      this.appBar,
      this.floatingActionButton,
      this.endDrawer})
      : super(key: key);

  _buildBody() {
    return Stack(
      children: [
        body,
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5.0,
            sigmaY: 5.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(10),
            ),
          ),
        ),
        Container(
          color: Colors.redAccent.withAlpha(50),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemedBackground(
      child: StreamBuilder<Operation>(
          stream:
              context.watch<Session>().operationContext.activeOperationStream,
          initialData:
              context.watch<Session>().operationContext.activeOperation,
          builder: (context, snapshot) {
            var operationContext = context.watch<Session>().operationContext;
            return Stack(
              children: [
                Scaffold(
                  key: innerKey,
                  backgroundColor: Colors.transparent,
                  endDrawer: endDrawer,
                  appBar: appBar,
                  body: body,
                  floatingActionButton: floatingActionButton,
                  extendBodyBehindAppBar: true,
                ),
                if (operationContext.hasActiveOperation)
                  ThemedProgressIndicator(
                      operationContext.activeOperation.title),
              ],
            );
          }),
    );
  }
}

class ThemedProgressIndicator extends StatelessWidget {
  final String text;

  const ThemedProgressIndicator(
    this.text, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5.0,
            sigmaY: 5.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(10),
            ),
          ),
        ),
        Container(
          color: Colors.black.withAlpha(175),
        ),
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LinearProgressIndicator(
                  backgroundColor: AppTheme.primaryColors[3],
                  valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.secondaryColors[2]),
                ),
                SizedBox(
                  height: 8.0,
                  width: double.infinity,
                ),
                ThemedText(
                  text: text,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ThemedIcon extends StatelessWidget {
  final IconData icon;

  const ThemedIcon({Key key, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      this.icon,
      color: AppTheme.secondaryColor_2,
    );
  }
}

class ThemedIconButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;

  const ThemedIconButton({Key key, this.icon, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      color: AppTheme.secondaryColor_2,
      onPressed: onPressed,
    );
  }
}

Widget themedAppBar({Key key, List<Widget> actions, Widget title}) {
  return AppBar(
    key: key,
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    title: title,
    actions: actions,
  );
}

Widget themedDatePickerBuilder(BuildContext context, Widget child) {
  return Theme(
    data: ThemeData.dark().copyWith(
      colorScheme: ColorScheme.dark(
        primary: AppTheme.primaryColor_1,
        secondary: AppTheme.secondaryColor_1,
        secondaryVariant: AppTheme.secondaryColor_1,
        onPrimary: AppTheme.primaryColor_3,
        surface: AppTheme.primaryColor_2,
        onSurface: AppTheme.secondaryColor_1,
      ),
      dialogBackgroundColor: AppTheme.primaryColor_3,
    ),
    child: child,
  );
}

Widget themedTimePickerBuilder(BuildContext context, Widget child) {
  return Theme(
    data: ThemeData.dark().copyWith(
      colorScheme: ColorScheme.dark(
        primary: AppTheme.secondaryColor_1,
        secondary: AppTheme.secondaryColor_1,
        secondaryVariant: AppTheme.secondaryColor_1,
        onPrimary: AppTheme.secondaryColor_3,
        surface: AppTheme.primaryColor_3,
        onSurface: AppTheme.primaryColor_1,
      ),
      dialogBackgroundColor: AppTheme.primaryColor_3,
    ),
    child: child,
  );
}
