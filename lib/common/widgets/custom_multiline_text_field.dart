import 'package:flutter/material.dart';
import 'package:shopnepal/common/theme/app_spacing.dart';
import 'package:shopnepal/common/theme/theme_colors.dart';
import 'package:shopnepal/common/theme/app_shapes.dart';

class CustomMultilineTextField extends StatelessWidget {
  const CustomMultilineTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.s120,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        expands: true,
        maxLines: null,
        minLines: null,
        textAlignVertical: TextAlignVertical.top,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        style: const TextStyle(
          color: ThemeColors.black,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: ThemeColors.lightTextColor,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: ThemeColors.pageBackGroundColor,
          contentPadding: AppInsets.all14,
          border: OutlineInputBorder(
            borderRadius: AppShapes.radiusMd,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppShapes.radiusMd,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppShapes.radiusMd,
            borderSide: const BorderSide(
              color: ThemeColors.primaryColor,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
