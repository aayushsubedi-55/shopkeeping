import 'package:flutter/material.dart';
import 'package:shopnepal/core/constants/text_styles.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';
import 'package:shopnepal/core/theme/theme.dart';

class TertiaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isLoading;

  final double? hPadding;

  const TertiaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.hPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (isLoading) {
          return;
        }
        onPressed?.call();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeColors.primaryMaterialColor.shade100.withOpacity(
          0.4,
        ),

        elevation: 0,

        padding: hPadding != null
            ? EdgeInsets.symmetric(
                horizontal: hPadding!,
                vertical: AppSpacing.s14,
              )
            : AppInsets.v14,
        shape: RoundedRectangleBorder(borderRadius: AppShapes.radiusPill),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (prefixIcon != null) ...[
            Icon(prefixIcon, color: ThemeColors.primaryColor),
            const SizedBox(width: AppSpacing.s8),
          ],
          Text(
            text,
            style: AppTextStyles.button.copyWith(
              color: ThemeColors.primaryColor,
            ),
          ),

          if (isLoading) ...[
            SizedBox(width: 4),
            const SizedBox(
              width: AppSpacing.s18,
              height: AppSpacing.s18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  ThemeColors.primaryColor,
                ),
              ),
            ),
          ],
          if (suffixIcon != null) ...[
            const SizedBox(width: AppSpacing.s8),
            Icon(suffixIcon, color: ThemeColors.primaryColor),
          ],
        ],
      ),
    );
  }
}
