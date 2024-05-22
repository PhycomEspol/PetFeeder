import 'package:flutter/material.dart';

abstract class AppTheme {
  static const backgroundColor = 0xFFF2C879;
  static const primaryColor = 0xFF592507;

  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: const Color(backgroundColor),
      focusColor: const Color(primaryColor),
      hoverColor: const Color(primaryColor),
      primaryColor: const Color(primaryColor),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Color(primaryColor),
          ),
        ),
        hoverColor: Color(primaryColor),
        focusColor: Color(primaryColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
            const Color(primaryColor),
          ),
          foregroundColor: WidgetStateProperty.all<Color>(
            const Color(backgroundColor),
          ),
          elevation: WidgetStateProperty.all<double>(0.0),
          surfaceTintColor: WidgetStateProperty.all<Color>(
            const Color(primaryColor),
          ),
        ),
      ),
    );
  }
}
