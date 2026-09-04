import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopnepal/core/theme/app_fonts.dart';
import 'package:shopnepal/core/theme/app_shapes.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';
import 'package:shopnepal/core/theme/theme_colors.dart';
import 'package:shopnepal/core/theme/theme.dart';

/// App theme configuration
/// Contains complete ThemeData with all widget themes configured
class AppTheme {
  // ── Light Theme ─────────────────────────────────────────────────────────

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Primary colors
      primarySwatch: ThemeColors.primaryMaterialColor,
      primaryColor: ThemeColors.primaryMaterialColor.shade400,
      primaryColorDark: ThemeColors.primaryColor,

      // Color Scheme
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: ThemeColors.primaryMaterialColor.shade500,
        onPrimary: ThemeColors.pageBackGroundColor,
        secondary: ThemeColors.secondaryColor,
        onSecondary: ThemeColors.pageBackGroundColor,
        error: ThemeColors.red,
        onError: ThemeColors.pageBackGroundColor,
        background: ThemeColors.pageBackGroundColor,
        onBackground: ThemeColors.black,
        surface: ThemeColors.pageBackGroundColor,
        onSurface: ThemeColors.black,
        tertiary: ThemeColors.primaryShadowColor,
      ),

      // Background & Surface
      scaffoldBackgroundColor: ThemeColors.pageBackGroundColor,
      shadowColor: ThemeColors.shadowColor,
      dividerColor: ThemeColors.grey,

      // Typography
      fontFamily: AppFonts.primary,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: ThemeColors.black,
          fontWeight: FontWeight.bold,
          fontSize: 25,
          height: 1.35,
          letterSpacing: 0.5,
        ),
        displayMedium: TextStyle(
          color: ThemeColors.black,
          fontWeight: FontWeight.bold,
          fontSize: 23,
          letterSpacing: 0.5,
          height: 1.35,
        ),
        displaySmall: TextStyle(
          color: ThemeColors.black,
          fontWeight: FontWeight.bold,
          fontSize: 21,
          letterSpacing: 0.5,
          height: 1.35,
        ),
        headlineMedium: TextStyle(
          fontSize: 19,
          color: ThemeColors.black,
          letterSpacing: 0.5,
          height: 1.35,
        ),
        headlineSmall: TextStyle(
          color: ThemeColors.black,
          fontSize: 17,
          letterSpacing: 0.5,
          height: 1.35,
        ),
        titleLarge: TextStyle(
          color: ThemeColors.black,
          fontSize: 13,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.5,
          height: 1.35,
        ),
        titleMedium: TextStyle(
          color: ThemeColors.black,
          fontSize: 11,
          letterSpacing: 0.5,
          height: 1.35,
        ),
        titleSmall: TextStyle(
          color: ThemeColors.black,
          fontSize: 13,
          letterSpacing: 0.5,
          height: 1.35,
        ),
        bodyLarge: TextStyle(
          fontSize: 13,
          color: ThemeColors.black,
          letterSpacing: 0.5,
          height: 1.35,
        ),
        bodyMedium: TextStyle(
          fontSize: 11,
          color: ThemeColors.black,
          letterSpacing: 0.5,
          height: 1.35,
        ),
        bodySmall: TextStyle(
          color: ThemeColors.black,
          fontSize: 9,
          letterSpacing: 0.5,
          height: 1.35,
        ),
        labelLarge: TextStyle(
          color: ThemeColors.black,
          fontSize: 13,
          letterSpacing: 0.5,
          height: 1.35,
        ),
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeColors.primaryColor,
        foregroundColor: ThemeColors.pageBackGroundColor,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ThemeColors.primaryColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          color: ThemeColors.pageBackGroundColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: ThemeColors.black),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.primaryColor,
          foregroundColor: ThemeColors.pageBackGroundColor,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s12,
          ),
          shape: AppShapes.buttonShape,
          elevation: 2,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ThemeColors.primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s12,
          ),
          side: const BorderSide(color: ThemeColors.primaryColor, width: 2),
          shape: AppShapes.buttonShape,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: ThemeColors.primaryColor),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ThemeColors.pageBackGroundColor,
        border: OutlineInputBorder(
          borderRadius: AppShapes.radiusMd,
          borderSide: const BorderSide(color: ThemeColors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppShapes.radiusMd,
          borderSide: const BorderSide(color: ThemeColors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppShapes.radiusMd,
          borderSide: const BorderSide(
            color: ThemeColors.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppShapes.radiusMd,
          borderSide: const BorderSide(color: ThemeColors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s16,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        color: ThemeColors.pageBackGroundColor,
        surfaceTintColor: ThemeColors.pageBackGroundColor,
        shape: AppShapes.cardShape,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        surfaceTintColor: ThemeColors.pageBackGroundColor,
        backgroundColor: ThemeColors.pageBackGroundColor,
        shape: AppShapes.dialogShape,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ThemeColors.pageBackGroundColor,
        selectedItemColor: ThemeColors.primaryColor,
        unselectedItemColor: ThemeColors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Bottom App Bar Theme
      bottomAppBarTheme: const BottomAppBarThemeData(
        surfaceTintColor: ThemeColors.pageBackGroundColor,
        color: ThemeColors.pageBackGroundColor,
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeColors.primaryColor;
          }
          return ThemeColors.lightGrey;
        }),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ThemeColors.primaryColor,
        circularTrackColor: ThemeColors.grey,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ThemeColors.primaryColor,
        foregroundColor: ThemeColors.pageBackGroundColor,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeColors.primaryColor;
          }
          return ThemeColors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeColors.primaryColor.withOpacity(0.5);
          }
          return ThemeColors.lightGrey;
        }),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeColors.primaryColor;
          }
          return ThemeColors.grey;
        }),
      ),

      // Slider Theme
      sliderTheme: const SliderThemeData(
        activeTrackColor: ThemeColors.primaryColor,
        inactiveTrackColor: ThemeColors.lightGrey,
        thumbColor: ThemeColors.primaryColor,
      ),
    );
  }

  // ── Dark Theme ──────────────────────────────────────────────────────────

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Primary colors
      primarySwatch: ThemeColors.primaryMaterialColor,
      primaryColor: ThemeColors.primaryColor,
      primaryColorDark: ThemeColors.darkRed,

      // Color Scheme
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: ThemeColors.primaryColor,
        onPrimary: ThemeColors.pageBackGroundColor,
        secondary: ThemeColors.secondaryColor,
        onSecondary: ThemeColors.black,
        error: ThemeColors.red,
        onError: ThemeColors.pageBackGroundColor,
        background: Color(0xFF121212),
        onBackground: ThemeColors.pageBackGroundColor,
        surface: Color(0xFF1E1E1E),
        onSurface: ThemeColors.pageBackGroundColor,
        tertiary: ThemeColors.primaryShadowColor,
      ),

      // Background & Surface
      scaffoldBackgroundColor: const Color(0xFF121212),
      shadowColor: const Color(0x33000000),
      dividerColor: const Color(0xFF424242),

      // Typography
      fontFamily: AppFonts.primary,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: ThemeColors.pageBackGroundColor,
          fontWeight: FontWeight.bold,
          fontSize: 25,
          height: 1.35,
          letterSpacing: 0.5,
        ),
        displayMedium: TextStyle(
          color: ThemeColors.pageBackGroundColor,
          fontWeight: FontWeight.bold,
          fontSize: 23,
          letterSpacing: 0.5,
          height: 1.35,
        ),
        displaySmall: TextStyle(
          color: ThemeColors.pageBackGroundColor,
          fontWeight: FontWeight.bold,
          fontSize: 21,
          letterSpacing: 0.5,
          height: 1.35,
        ),
        headlineMedium: TextStyle(
          fontSize: 19,
          color: ThemeColors.pageBackGroundColor,
          letterSpacing: 0.5,
          height: 1.35,
        ),
        headlineSmall: TextStyle(
          color: ThemeColors.pageBackGroundColor,
          fontSize: 17,
          letterSpacing: 0.5,
          height: 1.35,
        ),
        titleLarge: TextStyle(
          color: ThemeColors.pageBackGroundColor,
          fontSize: 13,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.5,
          height: 1.35,
        ),
        titleMedium: TextStyle(
          color: ThemeColors.pageBackGroundColor,
          fontSize: 11,
          letterSpacing: 0.5,
          height: 1.35,
        ),
        titleSmall: TextStyle(
          color: ThemeColors.pageBackGroundColor,
          fontSize: 13,
          letterSpacing: 0.5,
          height: 1.35,
        ),
        bodyLarge: TextStyle(
          fontSize: 13,
          color: ThemeColors.pageBackGroundColor,
          letterSpacing: 0.5,
          height: 1.35,
        ),
        bodyMedium: TextStyle(
          fontSize: 11,
          color: ThemeColors.pageBackGroundColor,
          letterSpacing: 0.5,
          height: 1.35,
        ),
        bodySmall: TextStyle(
          color: ThemeColors.pageBackGroundColor,
          fontSize: 9,
          letterSpacing: 0.5,
          height: 1.35,
        ),
        labelLarge: TextStyle(
          color: ThemeColors.pageBackGroundColor,
          fontSize: 13,
          letterSpacing: 0.5,
          height: 1.35,
        ),
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: ThemeColors.pageBackGroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: ThemeColors.pageBackGroundColor),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color(0xFF1E1E1E),
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          color: ThemeColors.pageBackGroundColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: ThemeColors.pageBackGroundColor),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.primaryColor,
          foregroundColor: ThemeColors.pageBackGroundColor,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s12,
          ),
          shape: AppShapes.buttonShape,
          elevation: 2,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ThemeColors.primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s12,
          ),
          side: const BorderSide(color: ThemeColors.primaryColor, width: 2),
          shape: AppShapes.buttonShape,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: ThemeColors.primaryColor),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: AppShapes.radiusMd,
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppShapes.radiusMd,
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppShapes.radiusMd,
          borderSide: const BorderSide(
            color: ThemeColors.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppShapes.radiusMd,
          borderSide: const BorderSide(color: ThemeColors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s16,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        color: const Color(0xFF2C2C2C),
        surfaceTintColor: const Color(0xFF2C2C2C),
        shape: AppShapes.cardShape,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        surfaceTintColor: const Color(0xFF2C2C2C),
        backgroundColor: const Color(0xFF2C2C2C),
        shape: AppShapes.dialogShape,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: ThemeColors.primaryColor,
        unselectedItemColor: ThemeColors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Bottom App Bar Theme
      bottomAppBarTheme: const BottomAppBarThemeData(
        surfaceTintColor: Color(0xFF1E1E1E),
        color: Color(0xFF1E1E1E),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeColors.primaryColor;
          }
          return const Color(0xFF424242);
        }),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ThemeColors.primaryColor,
        circularTrackColor: Color(0xFF424242),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ThemeColors.primaryColor,
        foregroundColor: ThemeColors.pageBackGroundColor,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeColors.primaryColor;
          }
          return ThemeColors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeColors.primaryColor.withOpacity(0.5);
          }
          return const Color(0xFF424242);
        }),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeColors.primaryColor;
          }
          return ThemeColors.grey;
        }),
      ),

      // Slider Theme
      sliderTheme: const SliderThemeData(
        activeTrackColor: ThemeColors.primaryColor,
        inactiveTrackColor: Color(0xFF424242),
        thumbColor: ThemeColors.primaryColor,
      ),
    );
  }
}
