import 'package:dw_bike_trips_client/session/user.dart';
import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

class ThemedAvatar extends StatelessWidget {
  const ThemedAvatar({
    Key key,
    @required this.user,
    this.onPressed,
  }) : super(key: key);

  final User user;
  final Function onPressed;

  buildInitialsText() {
    return user.firstname.substring(0, 1).toUpperCase() +
        user.lastname.substring(0, 1).toUpperCase();
  }

  Widget buildInitials() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FittedBox(
        fit: BoxFit.cover,
        child: Text(
          buildInitialsText(),
          style: TextStyle(
              color: (onPressed != null)
                  ? AppThemeData.activeDarkestColor
                  : AppThemeData.headingColor,
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
        child: TextButton(
          onPressed: onPressed,
          clipBehavior: Clip.hardEdge,
          style: TextButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: AppThemeData.activeColor,
            surfaceTintColor: AppThemeData.activeDarkerColor,
          ),
          child: Text(
            buildInitialsText(), 
            style: const TextStyle(
              color: AppThemeData.activeDarkestColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: CircleAvatar(
          backgroundColor: AppThemeData.panelBackgroundColor
              .withOpacity(AppThemeData.panelBackgroundMostEmphasizedOpacity),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
