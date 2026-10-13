import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: brightness,
        appBarTheme: const AppBarTheme(centerTitle: false),
      );
}
