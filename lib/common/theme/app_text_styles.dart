import 'package:flutter/material.dart';
import 'package:shopnepal/common/theme/theme_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  // Theme-aware approach without changing every Text widget:
  // - Most styles omit `color` so they inherit from Theme (light/dark)
  // - Keep only "safe" fixed colors that work in both themes

  static const TextStyle heading1 = TextStyle(
    color: ThemeColors.black,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle heading2 = TextStyle(
    color: ThemeColors.primaryColor,
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle subtitle = TextStyle(
    color: ThemeColors.grey,
    fontSize: 16,
  );

  static const TextStyle button = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );

  static const TextStyle body = TextStyle(fontSize: 16);
}
