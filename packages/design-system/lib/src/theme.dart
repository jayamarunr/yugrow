import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';
import 'radius.dart';
import 'typography.dart';
import 'elevation.dart';

/// YDS Theme Builder — constructs Flutter ThemeData from YDS tokens.
///
/// Usage:
/// ```dart
/// MaterialApp(
///   theme: YTheme.light,
///   darkTheme: YTheme.dark,
/// )
/// ```
class YTheme {
  YTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: YTypography.fontFamily,
    primaryColor: YColors.primary,
    scaffoldBackgroundColor: YColors.background,
    colorScheme: const ColorScheme.light(
      primary: YColors.primary,
      surface: YColors.surface,
      error: YColors.error,
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: YTypography.h1Style(color: YColors.textPrimary),
      headlineMedium: YTypography.h2Style(color: YColors.textPrimary),
      titleLarge: YTypography.h3Style(color: YColors.textPrimary),
      titleMedium: YTypography.bodyBoldStyle(color: YColors.textPrimary),
      bodyLarge: YTypography.bodyStyle(color: YColors.textPrimary),
      bodyMedium: YTypography.bodySmallStyle(color: YColors.textSecondary),
      bodySmall: YTypography.captionStyle(color: YColors.textSecondary),
      labelLarge: YTypography.buttonStyle(color: YColors.textInverse),
      labelSmall: YTypography.captionStyle(color: YColors.textPrimary),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: YColors.surface,
      foregroundColor: YColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: YColors.surface,
    ),
    cardTheme: CardThemeData(
      color: YColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: YRadius.xlCircular,
        side: const BorderSide(color: YColors.border),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: YColors.primary,
        foregroundColor: YColors.textInverse,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: YRadius.lgCircular),
        textStyle: YTypography.buttonStyle(color: YColors.textInverse),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: YColors.primary,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: YRadius.lgCircular),
        side: const BorderSide(color: YColors.border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: YColors.surface,
      border: OutlineInputBorder(
        borderRadius: YRadius.mdCircular,
        borderSide: const BorderSide(color: YColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: YRadius.mdCircular,
        borderSide: const BorderSide(color: YColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: YRadius.mdCircular,
        borderSide: const BorderSide(color: YColors.borderActive, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      labelStyle: YTypography.captionStyle(color: YColors.textSecondary),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: YColors.surface,
      selectedItemColor: YColors.primary,
      unselectedItemColor: YColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: YTypography.captionStyle(),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: YTypography.fontFamily,
    primaryColor: YColors.primaryDark,
    scaffoldBackgroundColor: YColors.backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: YColors.primaryDark,
      surface: YColors.surfaceDark,
      error: YColors.errorDark,
    ),
    cardTheme: CardThemeData(
      color: YColors.surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: YRadius.xlCircular,
        side: const BorderSide(color: YColors.borderDark),
      ),
    ),
  );
}
