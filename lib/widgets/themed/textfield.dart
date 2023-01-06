import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

class ThemedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Function onEditingComplete;

  const ThemedTextField(
      {Key key,
      this.controller,
      this.labelText,
      this.obscureText = false,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.onEditingComplete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppThemeData.activeColor,
        ),
        primaryColor: AppThemeData.activeLighterColor,
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: AppThemeData.activeColor),
          filled: false,
          fillColor: AppThemeData.mainDarkerColor,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppThemeData.activeColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppThemeData.activeColor,
              width: 2,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppThemeData.activeColor,
            ),
          ),
        ),
        textTheme: const TextTheme(
          subtitle1: TextStyle(
            color: AppThemeData.activeColor,
          ),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        textInputAction: textInputAction,
        onEditingComplete: onEditingComplete,
        decoration: InputDecoration(
          labelText: labelText,
        ),
      ),
    );
  }
}
