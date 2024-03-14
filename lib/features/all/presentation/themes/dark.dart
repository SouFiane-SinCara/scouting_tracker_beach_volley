import 'package:flutter/material.dart';
import 'package:scouting_tracker_beach_volley/core/constants/colors/colors.dart';

ThemeData darkTheme = ThemeData(
  primaryColor: darkfont,
  brightness: Brightness.dark,
  primarySwatch: Colors.deepPurple,
  shadowColor: darkprimery,
  
  colorScheme: ColorScheme.fromSeed(
      secondary: darksecondry,
      onSecondaryContainer: darksecondryDark,

      seedColor: Colors.deepPurple,
      onSecondary: darkfontSecondery,
      brightness: Brightness.dark,
      primary: darkprimery),
);
