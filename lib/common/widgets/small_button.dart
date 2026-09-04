import 'package:flutter/material.dart';
import 'package:shopnepal/common/theme/app_spacing.dart';
import 'package:shopnepal/common/theme/theme.dart';

class SmallButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;

  const SmallButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeColors.primaryColor,
        foregroundColor: ThemeColors.pageBackGroundColor,
        padding: AppInsets.h10,
        shape: RoundedRectangleBorder(borderRadius: AppShapes.radiusMd),
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          ),
          if (icon != null) ...[const SizedBox(width: AppSpacing.s6), icon!],
        ],
      ),
    );
  }
}
