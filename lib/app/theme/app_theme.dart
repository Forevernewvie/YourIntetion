import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Purpose: Centralize app light and dark theme tokens.
final class AppTheme {
  AppTheme._();

  static const _paperLight = Color(0xFFFFFCF7);
  static const _paperDark = Color(0xFF14201E);
  static const _shellLight = Color(0xFFF3FAF8);
  static const _shellDark = Color(0xFF0C1414);
  static const _mistLight = Color(0xFFE4F3EF);
  static const _mistDark = Color(0xFF1D302D);
  static const _inkLight = Color(0xFF153936);
  static const _inkDark = Color(0xFFF0F5F4);
  static const _mutedLight = Color(0xFF58706B);
  static const _mutedDark = Color(0xFFA3BBB6);
  static const _strokeLight = Color(0xFFD2E4DF);
  static const _strokeDark = Color(0xFF2A403D);
  static const _tealLight = Color(0xFF0D9488);
  static const _tealDark = Color(0xFF48D0C2);
  static const _orangeLight = Color(0xFFF97316);
  static const _orangeDark = Color(0xFFFFA062);
  static const _dangerLight = Color(0xFFB94F46);
  static const _dangerDark = Color(0xFFFF8F84);

  /// Purpose: Build the light mode theme.
  static ThemeData get lightTheme {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: _tealLight,
          brightness: Brightness.light,
        ).copyWith(
          primary: _tealLight,
          onPrimary: Colors.white,
          secondary: const Color(0xFFB4E4DB),
          onSecondary: _inkLight,
          tertiary: _orangeLight,
          onTertiary: Colors.white,
          surface: _paperLight,
          onSurface: _inkLight,
          error: _dangerLight,
          onError: Colors.white,
        );

    return _buildTheme(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _shellLight,
      cardColor: _paperLight,
      altSurfaceColor: _mistLight,
      textColor: _inkLight,
      mutedTextColor: _mutedLight,
      dividerColor: _strokeLight,
      shadowColor: const Color(0x33153936),
    );
  }

  /// Purpose: Build the dark mode theme.
  static ThemeData get darkTheme {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: _tealDark,
          brightness: Brightness.dark,
        ).copyWith(
          primary: _tealDark,
          onPrimary: const Color(0xFF032C28),
          secondary: const Color(0xFF24403B),
          onSecondary: _inkDark,
          tertiary: _orangeDark,
          onTertiary: const Color(0xFF412007),
          surface: _paperDark,
          onSurface: _inkDark,
          error: _dangerDark,
          onError: const Color(0xFF40100C),
        );

    return _buildTheme(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _shellDark,
      cardColor: _paperDark,
      altSurfaceColor: _mistDark,
      textColor: _inkDark,
      mutedTextColor: _mutedDark,
      dividerColor: _strokeDark,
      shadowColor: const Color(0x73000000),
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color scaffoldBackgroundColor,
    required Color cardColor,
    required Color altSurfaceColor,
    required Color textColor,
    required Color mutedTextColor,
    required Color dividerColor,
    required Color shadowColor,
  }) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      shadowColor: shadowColor,
      splashFactory: InkRipple.splashFactory,
    );

    final bodyTheme = GoogleFonts.robotoTextTheme(
      baseTheme.textTheme,
    ).apply(bodyColor: textColor, displayColor: textColor);

    final textTheme = bodyTheme.copyWith(
      displaySmall: GoogleFonts.newsreader(
        color: textColor,
        fontSize: 42,
        fontWeight: FontWeight.w600,
        height: 1.04,
        letterSpacing: -0.8,
      ),
      headlineMedium: GoogleFonts.newsreader(
        color: textColor,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.08,
        letterSpacing: -0.5,
      ),
      headlineSmall: GoogleFonts.newsreader(
        color: textColor,
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 1.12,
        letterSpacing: -0.2,
      ),
      titleLarge: GoogleFonts.newsreader(
        color: textColor,
        fontSize: 21,
        fontWeight: FontWeight.w600,
        height: 1.15,
      ),
      titleMedium: GoogleFonts.roboto(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      titleSmall: GoogleFonts.roboto(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 1.25,
      ),
      bodyLarge: GoogleFonts.roboto(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.55,
      ),
      bodyMedium: GoogleFonts.roboto(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.55,
      ),
      bodySmall: GoogleFonts.roboto(
        color: mutedTextColor,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.45,
      ),
      labelLarge: GoogleFonts.roboto(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.roboto(
        color: mutedTextColor,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.2,
      ),
      labelSmall: GoogleFonts.roboto(
        color: mutedTextColor,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.15,
        letterSpacing: 0.3,
      ),
    );

    return baseTheme.copyWith(
      textTheme: textTheme,
      dividerColor: dividerColor,
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: textColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.headlineSmall,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        hintStyle: textTheme.bodyMedium?.copyWith(color: mutedTextColor),
        labelStyle: textTheme.labelLarge?.copyWith(color: mutedTextColor),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        prefixIconColor: mutedTextColor,
        suffixIconColor: mutedTextColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.tertiary,
          foregroundColor: colorScheme.onTertiary,
          disabledBackgroundColor: altSurfaceColor,
          disabledForegroundColor: mutedTextColor,
          minimumSize: const Size(double.infinity, 54),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          minimumSize: const Size(double.infinity, 54),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          side: BorderSide(color: dividerColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.secondary.withValues(alpha: 0.55),
        thumbColor: colorScheme.tertiary,
        overlayColor: colorScheme.primary.withValues(alpha: 0.12),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return cardColor;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return altSurfaceColor;
        }),
        trackOutlineColor: WidgetStatePropertyAll(dividerColor),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textColor,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: cardColor),
        behavior: SnackBarBehavior.floating,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        circularTrackColor: altSurfaceColor,
      ),
      iconTheme: IconThemeData(color: mutedTextColor, size: 20),
    );
  }
}
