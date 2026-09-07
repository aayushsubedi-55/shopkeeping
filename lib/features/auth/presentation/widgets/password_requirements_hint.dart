import 'package:flutter/material.dart';
import 'package:shopnepal/core/theme/theme_colors.dart';

class PasswordRequirementsHint extends StatelessWidget {
  const PasswordRequirementsHint({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Use 8+ characters with upper, lower, number & special character.',
      style: TextStyle(
        color: ThemeColors.lightTextColor,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
    );
  }
}
