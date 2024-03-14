import 'package:flutter/material.dart';
import 'package:scouting_tracker_beach_volley/core/constants/colors/colors.dart';

ThemeData lightTheme = ThemeData(
  shadowColor: Colors.black,
  primaryColor: font,
  primarySwatch: Colors.deepPurple,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
      onSecondaryContainer: secondryDark,
      secondary: secondry,
      seedColor: Colors.deepPurple,
      onSecondary: fontSecondery,
      brightness: Brightness.light,
      primary: primery),
);
