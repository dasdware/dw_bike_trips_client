// Main colors
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const primaryColor_0 = Color(0xFF393276);
const primaryColor_1 = Color(0xFF837EB1);
const primaryColor_2 = Color(0xFF5B5494);
const primaryColor_3 = Color(0xFF1F1959);
const primaryColor_4 = Color(0xFF0D083B);

const primaryColors = [
  primaryColor_0,
  primaryColor_1,
  primaryColor_2,
  primaryColor_3,
  primaryColor_4,
];

// Complementary colors
const secondaryColor_0 = Color(0xFFAA9139);
const secondaryColor_1 = Color(0xFFFFECAA);
const secondaryColor_2 = Color(0xFFD4BD6A);
const secondaryColor_3 = Color(0xFF806815);
const secondaryColor_4 = Color(0xFF554200);

const secondaryColors = [
  secondaryColor_0,
  secondaryColor_1,
  secondaryColor_2,
  secondaryColor_3,
  secondaryColor_4,
];

const errorColor = Colors.redAccent;

var themeData = ThemeData(
  appBarTheme: AppBarTheme(
    color: Colors.transparent,
  ),
  primaryColor: primaryColors[2],
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Colors.transparent,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: secondaryColors[2],
    foregroundColor: secondaryColors[4],
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.white70),
    filled: true,
    fillColor: primaryColors[3],
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
  ),
  textTheme: TextTheme(
    subtitle1: TextStyle(
      color: Colors.white,
    ),
  ),
);
