import 'package:flutter/material.dart';

/// Theme colors for the app
/// Change colors here to customize the entire app theme
class ThemeColors {
  // ── Primary Brand Colors ────────────────────────────────────────────────

  static const Color primaryColor = Color(0xFFD01F24);
  static const Color secondaryColor = Color(0xFFF0BD29);

  // ── Basic Colors ────────────────────────────────────────────────────────

  static const Color black = Color(0xFF050000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color cream = Color(0xFFFCF4D6);
  static const Color transparent = Colors.transparent;

  // ── Gray Scale ──────────────────────────────────────────────────────────

  static const Color lightGrey = Color(0xFFCAC3AB);
  static const Color lighterGrey = Color(0xFFF9F9F9);
  static const Color grey = Color(0xFFB0AB96);
  static const Color midGrayColor = Color(0xFFE3DCC1);
  static const Color darkGrey = Color(0xFF8B8676);

  // ── Status Colors ───────────────────────────────────────────────────────

  static const Color red = Color(0xFFEC5C5C);
  static const Color darkRed = Color(0xFFC62D38);
  static const Color yellow = Color(0xFFE1AD01);
  static const Color textGreenColor = Color(0xFF40826D);

  // ── Accent Colors ───────────────────────────────────────────────────────

  static const Color pinkColor = Color(0xFFFF8C94);
  static const Color blueShadowColor = Color(0xFFA8E6CE);
  static const Color greenShadowColor = Color(0xFFDCEDC2);
  static const Color lightYellow = Color(0xFFFFD3B5);
  static const Color lightRedColor = Color(0xFFFFAAA6);
  static const Color lightPurpleColor = Color(0xFFD1BBFF);
  static const Color primaryShadowColor = Color(0xFF8DBDFF);
  static const Color blueLight = Color(0xFFE9EFF8);
  static const Color skyBlue = Color(0xFFE6F8FB);
  static const Color primaryShade = Color(0xFFF8FFF8);

  // ── Shadow & Overlay ────────────────────────────────────────────────────

  static const Color shadowColor = Color(0x1A000000);

  // ── Social Media Colors ─────────────────────────────────────────────────

  static const Color google = Color(0xFF4285F4);
  static const Color apple = Color(0xFF050000);
  static const Color facebook = Color(0xFF1877F2);

  // ── Spacing ─────────────────────────────────────────────────────────────

  static const double symmetricHozPadding = 12.0;

  // ── Material Color Swatch ───────────────────────────────────────────────

  static const MaterialColor primaryMaterialColor =
      MaterialColor(_primaryValue, <int, Color>{
        50: Color(0xFFFCE9EA),
        100: Color(0xFFF9D0D1),
        200: Color(0xFFF3A0A2),
        300: Color(0xFFED7174),
        400: Color(0xFFE84145),
        500: Color(_primaryValue),
        600: Color(0xFFD01F24),
        700: Color(0xFFB91B1F),
        800: Color(0xFFA1181B),
        900: Color(0xFF7A1216),
      });
  static const int _primaryValue = 0xFFE72227;

  static const MaterialColor primaryAccentColor =
      MaterialColor(_accentValue, <int, Color>{
        100: Color(0xFFFCF0D0),
        200: Color(_accentValue),
        400: Color(0xFFE0AD20),
        700: Color(0xFFC99615),
      });
  static const int _accentValue = 0xFFF0BD29;

  static const MaterialColor creamMaterialColor =
      MaterialColor(_creamValue, <int, Color>{
        50: Color(0xFFFFFDF9),
        100: Color(0xFFFEF9ED),
        200: Color(0xFFFDF6E4),
        300: Color(0xFFFCF1D9),
        400: Color(0xFFFCF2D8),
        500: Color(_creamValue),
        600: Color(0xFFE3DCC1),
        700: Color(0xFFCAC3AB),
        800: Color(0xFFB0AB96),
        900: Color(0xFF8B8676),
      });
  static const int _creamValue = 0xFFFCF4D6;

  static const Color mascotBackground = Color(0xFFFFB300);
  static const Color green = Color(0xFF4CAF50);
  static const Color darkGreen = Color.fromARGB(255, 20, 143, 100);
  static const Color lightGreen = Color(0xFFD5FFE1);

  static const Color highlightBackGroundColor = Color(0xFFFCF1D9);
  static const Color pageBackGroundColor = Color(0xFFFDF6E4);
  static const Color cardBackGroundColor = Color(0xFFFEF9ED);

  // ── Text Colors ─────────────────────────────────────────────────────────

  static const Color lightTextColor = Color.fromARGB(255, 96, 91, 75);
}
