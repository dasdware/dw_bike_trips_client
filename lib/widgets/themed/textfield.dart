import 'package:dw_bike_trips_client/theme_data.dart';
import 'package:flutter/material.dart';

class ThemedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  final bool obscureText;
  final TextInputType keyboardType;

  const ThemedTextField(
      {Key key,
      this.controller,
      this.labelText,
      this.obscureText = false,
      this.keyboardType = TextInputType.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: new ThemeData(
        primaryColor: AppThemeData.activeLighterColor,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: AppThemeData.activeColor),
          filled: false,
          fillColor: AppThemeData.mainDarkerColor,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppThemeData.activeColor,
            ),
          ),
          focusColor: AppThemeData.activeColor,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppThemeData.activeColor,
            ),
          ),
        ),
        textTheme: TextTheme(
          subtitle1: TextStyle(
            color: AppThemeData.activeColor,
          ),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
        ),
      ),
    );
  }
}
