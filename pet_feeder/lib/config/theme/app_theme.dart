import 'package:flutter/material.dart';

abstract class AppTheme {
  static const primaryColor = 0xFF592507;
  static const secondaryColor = 0xFFF2C879;
  static const terciaryColor = 0xFFBF6F41;

  static ThemeData get theme {
    const outlineInputBorder = OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Color(primaryColor),
          ),
        );
    return ThemeData(
      scaffoldBackgroundColor: const Color(secondaryColor),
      canvasColor: const Color(secondaryColor),
      focusColor: const Color(primaryColor),
      hoverColor: const Color(primaryColor),
      primaryColor: const Color(primaryColor),
      inputDecorationTheme: const InputDecorationTheme(
        border: outlineInputBorder,
        hoverColor: Color(primaryColor),
        focusColor: Color(primaryColor),
        focusedBorder: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        labelStyle: TextStyle(
          color: Color(primaryColor),
        ),
      ),
      indicatorColor: const Color(primaryColor),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(
            const Color(primaryColor),
          ),
          overlayColor: WidgetStateProperty.all<Color>(
            const Color(secondaryColor),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
            const Color(primaryColor),
          ),
          foregroundColor: WidgetStateProperty.all<Color>(
            const Color(secondaryColor),
          ),
          elevation: WidgetStateProperty.all<double>(0.0),
          surfaceTintColor: WidgetStateProperty.all<Color>(
            const Color(primaryColor),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(primaryColor),
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Color(secondaryColor),
        ),
        iconTheme: IconThemeData(
          color: Color(secondaryColor),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(secondaryColor),
        elevation: 20,
        indicatorColor: Colors.transparent,
        shadowColor: Color(primaryColor),
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: Color(terciaryColor),
        titleTextStyle: TextStyle(
          color: Color(secondaryColor),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        contentTextStyle: TextStyle(
          color: Color(secondaryColor),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(secondaryColor);
            }
            return const Color(primaryColor);
          }),
          side: WidgetStateProperty.all<BorderSide>(
            const BorderSide(color: Color(primaryColor)),
          ),
          splashFactory: NoSplash.splashFactory, //sin animación
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(primaryColor);
            }
            return null;
          }),
        ),
      ),
    );
  }
}
