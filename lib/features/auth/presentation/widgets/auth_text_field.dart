import 'package:flutter/material.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';
import 'package:shopnepal/core/theme/theme.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool enabled;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final bool obscureText;

  const AuthTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.suffix,
    this.validator,
    this.autovalidateMode,
    this.onChanged,
    this.textInputAction,
    this.onFieldSubmitted,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      style: const TextStyle(
        color: ThemeColors.black,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        // fontFamily: AppFonts.primary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: ThemeColors.lightTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          // fontFamily: AppFonts.primary,
        ),
        errorStyle: const TextStyle(
          color: ThemeColors.primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s18,
          vertical: AppSpacing.s14,
        ),
        suffixIcon: suffix == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(right: AppSpacing.s12),
                child: suffix,
              ),
        suffixIconConstraints: const BoxConstraints(
          minHeight: 40,
          minWidth: 40,
        ),
        filled: true,
        fillColor: ThemeColors.pageBackGroundColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: AppShapes.radiusPill,
          borderSide: const BorderSide(color: ThemeColors.lightGrey, width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppShapes.radiusPill,
          borderSide: const BorderSide(color: ThemeColors.lightGrey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppShapes.radiusPill,
          borderSide: const BorderSide(
            color: ThemeColors.primaryColor,
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppShapes.radiusPill,
          borderSide: const BorderSide(
            color: ThemeColors.primaryColor,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppShapes.radiusPill,
          borderSide: const BorderSide(
            color: ThemeColors.primaryColor,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}
