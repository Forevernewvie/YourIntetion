import 'package:flutter/material.dart';

/// Purpose: Centralize app light and dark theme tokens.
final class AppTheme {
  AppTheme._();

  static const _lightBg = Color(0xFFF3F5F4);
  static const _darkBg = Color(0xFF0F1417);
  static const _lightSurface = Color(0xFFFFFFFF);
  static const _darkSurface = Color(0xFF172026);
  static const _lightSurfaceAlt = Color(0xFFEEF2F3);
  static const _darkSurfaceAlt = Color(0xFF1E2A31);
  static const _lightText = Color(0xFF0F1720);
  static const _darkText = Color(0xFFF2F6F8);
  static const _lightTextMuted = Color(0xFF52606B);
  static const _darkTextMuted = Color(0xFFA7B3BC);
  static const _accentLight = Color(0xFF2F7D8C);
  static const _accentDark = Color(0xFF4FA4B4);
  static const _dangerLight = Color(0xFFC2403D);
  static const _dangerDark = Color(0xFFF27470);

  /// Purpose: Build the light mode theme.
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: _accentLight,
      onPrimary: Color(0xFFFFFFFF),
      secondary: _lightSurfaceAlt,
      onSecondary: _lightText,
      error: _dangerLight,
      onError: Color(0xFFFFFFFF),
      surface: _lightSurface,
      onSurface: _lightText,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _lightBg,
      dividerColor: const Color(0xFFD1DDE2),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: _lightSurface,
        foregroundColor: _lightText,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: _lightSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: _lightText),
        bodyMedium: TextStyle(color: _lightText),
        bodySmall: TextStyle(color: _lightTextMuted),
        titleLarge: TextStyle(color: _lightText),
        titleMedium: TextStyle(color: _lightText),
        titleSmall: TextStyle(color: _lightText),
        labelLarge: TextStyle(color: _lightText),
        labelMedium: TextStyle(color: _lightTextMuted),
        labelSmall: TextStyle(color: _lightTextMuted),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: Color(0xFFD1DDE2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: Color(0xFFD1DDE2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: _accentLight, width: 1.4),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _accentLight,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _lightText,
          minimumSize: const Size(double.infinity, 48),
          side: const BorderSide(color: Color(0xFFD1DDE2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: _lightText,
        contentTextStyle: TextStyle(color: _lightSurface),
      ),
    );
  }

  /// Purpose: Build the dark mode theme.
  static ThemeData get darkTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: _accentDark,
      onPrimary: Color(0xFF05242B),
      secondary: _darkSurfaceAlt,
      onSecondary: _darkText,
      error: _dangerDark,
      onError: Color(0xFF2F0C0C),
      surface: _darkSurface,
      onSurface: _darkText,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _darkBg,
      dividerColor: const Color(0xFF2D3A42),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: _darkSurface,
        foregroundColor: _darkText,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: _darkSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: _darkText),
        bodyMedium: TextStyle(color: _darkText),
        bodySmall: TextStyle(color: _darkTextMuted),
        titleLarge: TextStyle(color: _darkText),
        titleMedium: TextStyle(color: _darkText),
        titleSmall: TextStyle(color: _darkText),
        labelLarge: TextStyle(color: _darkText),
        labelMedium: TextStyle(color: _darkTextMuted),
        labelSmall: TextStyle(color: _darkTextMuted),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: Color(0xFF2D3A42)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: Color(0xFF2D3A42)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: _accentDark, width: 1.4),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _accentDark,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _darkText,
          minimumSize: const Size(double.infinity, 48),
          side: const BorderSide(color: Color(0xFF2D3A42)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: _darkSurfaceAlt,
        contentTextStyle: TextStyle(color: _darkText),
      ),
    );
  }
}
