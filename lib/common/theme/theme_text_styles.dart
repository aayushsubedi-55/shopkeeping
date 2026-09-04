import 'package:flutter/material.dart';
import 'package:shopnepal/common/theme/app_fonts.dart';

/// Text styles for the app
/// Change font family, sizes, and weights here
class ThemeTextStyles {
  // ── Font Family ─────────────────────────────────────────────────────────

  // Alternative font families (uncomment to use)
  // static const String fontFamily = 'Roboto';
  // static const String fontFamily = 'Inter';
  // static const String fontFamily = 'Montserrat';

  // ── Display Styles (largest text) ───────────────────────────────────────

  static const TextStyle displayLarge = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 45,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  // ── Headline Styles ─────────────────────────────────────────────────────

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  // ── Title Styles ────────────────────────────────────────────────────────

  static const TextStyle titleLarge = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  // ── Body Styles ─────────────────────────────────────────────────────────

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  // ── Label Styles (buttons, tabs) ────────────────────────────────────────

  static const TextStyle labelLarge = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // ── Custom Styles (app-specific) ────────────────────────────────────────

  static const TextStyle button = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
  );

  // ── Helper Methods ──────────────────────────────────────────────────────

  /// Create a custom text style with specific properties
  static TextStyle custom({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: AppFonts.primary,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );
  }
}
