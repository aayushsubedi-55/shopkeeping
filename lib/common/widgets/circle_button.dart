import 'package:flutter/material.dart';
import 'package:shopnepal/common/theme/app_spacing.dart';
import 'package:shopnepal/common/theme/theme_colors.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color backgroundColor;

  const CircleIconButton({
    required this.icon,
    this.onTap,
    this.backgroundColor = ThemeColors.pageBackGroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: AppSpacing.s2, top: AppSpacing.s2),
      child: SizedBox(
        width: AppSpacing.s40,
        height: AppSpacing.s40,
        child: Material(
          color: backgroundColor,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Center(
              child: Icon(icon, size: 16, color: ThemeColors.primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}
