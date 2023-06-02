import 'package:flutter/material.dart';

ThemeData getTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: const Color(0x00ff5a5f),
    primaryColorDark: const Color(0xFF333333),
    appBarTheme: base.appBarTheme.copyWith(
      color: const Color(0x00ff5a5f),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0x00ff5a5f),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0x00ff5a5f),
      ),
    ),
    iconTheme: const IconThemeData(
      color: Color(0x00ff5a5f),
    ),
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: const Color(0x00ff5a5f)),
  );
}

ThemeData getDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    primaryColor: const Color(0x00ff5a5f),
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: base.appBarTheme.copyWith(
      color: Colors.grey[900],
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0x00ff5a5f),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0x00ff5a5f),
      ),
    ),
    iconTheme: const IconThemeData(
      color: Color(0x00ff5a5f),
    ),
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: const Color(0x00ff5a5f)),
  );
}
