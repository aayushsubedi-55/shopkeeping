import 'package:flutter/material.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';
import 'package:shopnepal/core/theme/theme.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  final Color? buttonColor;
  final Widget? leading;
  final Widget? prefix;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.leading,
    this.buttonColor,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: buttonColor ?? ThemeColors.primaryColor,
        side: BorderSide(
          color: buttonColor?.withOpacity(0.2) ?? ThemeColors.primaryColor,
          width: 1.2,
        ),
        padding: AppInsets.v14,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: AppShapes.radiusPill),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppSpacing.s10),
          ],
          Text(
            text,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),

          if (prefix != null) ...[
            const SizedBox(width: AppSpacing.s10),
            prefix!,
          ],
        ],
      ),
    );
  }
}
