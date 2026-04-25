import 'package:flutter/material.dart';

const _primaryColor = Color(0xFF6366F1); // indigo
const _secondaryColor = Color(0xFF22D3EE); // cyan
const _errorColor = Color(0xFFEF4444);

const _textTheme = TextTheme(
  displayLarge: TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
  ),
  displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w700),
  headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
  headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
  titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
  bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
  bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
  labelLarge: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  ),
);

class AppTheme {
  AppTheme._();

  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.light,
    ).copyWith(secondary: _secondaryColor, error: _errorColor),
    textTheme: _textTheme,
  );
  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.dark,
    ).copyWith(secondary: _secondaryColor, error: _errorColor),
    textTheme: _textTheme,
  );
}
