import 'package:flutter/material.dart';

class Config {
  static const Color firmColor = Colors.orange;

  static final _baseTheme = ThemeData.dark();

  static final ThemeData appTheme = _baseTheme.copyWith(
    accentColor: firmColor,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: firmColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: firmColor,
      ),
    ),
    iconTheme: const IconThemeData(
      color: firmColor,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: firmColor),
      helperStyle: TextStyle(color: firmColor),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: firmColor),
      ),
    ),
  );
}
