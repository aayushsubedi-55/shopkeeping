import 'package:flutter/material.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';
import 'package:shopnepal/core/theme/theme_colors.dart';
import 'package:shopnepal/core/widgets/primary_button.dart';
import 'package:shopnepal/core/theme/app_shapes.dart';

enum AppDialogType {
  warning,
  success,
  error,
  confirmation,
  location,
  notification,
}

class _DialogStyle {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

  const _DialogStyle({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });
}

_DialogStyle _styleForType(AppDialogType type) {
  switch (type) {
    case AppDialogType.warning:
      return const _DialogStyle(
        icon: Icons.warning_amber_rounded,
        iconColor: Color(0xFFE1AD01),
        iconBackground: Color(0xFFFFF8E1),
      );
    case AppDialogType.success:
      return const _DialogStyle(
        icon: Icons.check_circle_rounded,
        iconColor: ThemeColors.green,
        iconBackground: Color(0xFFE8F5E9),
      );
    case AppDialogType.error:
      return const _DialogStyle(
        icon: Icons.error_outline_rounded,
        iconColor: ThemeColors.primaryColor,
        iconBackground: Color(0xFFFDECEC),
      );
    case AppDialogType.confirmation:
      return _DialogStyle(
        icon: Icons.help_outline_rounded,
        iconColor: ThemeColors.primaryColor,
        iconBackground: ThemeColors.primaryMaterialColor.shade50,
      );
    case AppDialogType.location:
      return _DialogStyle(
        icon: Icons.location_on_rounded,
        iconColor: ThemeColors.primaryColor,
        iconBackground: ThemeColors.primaryMaterialColor.shade50,
      );
    case AppDialogType.notification:
      return const _DialogStyle(
        icon: Icons.notifications_active_rounded,
        iconColor: ThemeColors.primaryColor,
        iconBackground: Color(0xFFFDECEC),
      );
  }
}

/// Reusable app dialog matching the standard design: icon, title, description,
/// primary/secondary actions, and optional close button.
class AppDialog extends StatelessWidget {
  final AppDialogType type;
  final String title;
  final String? message;
  final IconData? icon;
  final String primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final bool showCloseButton;
  final bool isPrimaryLoading;

  const AppDialog({
    super.key,
    required this.type,
    required this.title,
    this.message,
    this.icon,
    required this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.showCloseButton = true,
    this.isPrimaryLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = _styleForType(type);
    final dialogIcon = icon ?? style.icon;

    return Dialog(
      backgroundColor: ThemeColors.pageBackGroundColor,
      insetPadding: AppInsets.h24,
      shape: const RoundedRectangleBorder(borderRadius: AppShapes.radiusLg),
      child: Padding(
        padding: AppInsets.all24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCloseButton)
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    size: AppSpacing.s22,
                    color: ThemeColors.darkGrey,
                  ),
                ),
              )
            else
              const SizedBox(height: AppSpacing.s22),
            Container(
              width: AppSpacing.s56,
              height: AppSpacing.s56,
              decoration: BoxDecoration(
                color: style.iconBackground,
                borderRadius: AppShapes.radiusMd,
              ),
              child: Icon(
                dialogIcon,
                color: style.iconColor,
                size: AppSpacing.s28,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: ThemeColors.black,
              ),
            ),
            if (message != null && message!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.s8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: ThemeColors.darkGrey,
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.s24),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: primaryButtonText,
                isLoading: isPrimaryLoading,
                onPressed:
                    onPrimaryPressed ?? () => Navigator.of(context).pop(true),
              ),
            ),
            if (secondaryButtonText != null) ...[
              const SizedBox(height: AppSpacing.s10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed:
                      onSecondaryPressed ??
                      () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: ThemeColors.pageBackGroundColor,
                    side: const BorderSide(color: ThemeColors.lightGrey),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppShapes.radiusPill,
                    ),
                    padding: AppInsets.v14,
                  ),
                  child: Text(
                    secondaryButtonText!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.darkGrey,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Shows [AppDialog] and returns `true` for primary, `false` for secondary,
/// or `null` when dismissed via the close button or barrier tap.
Future<bool?> showAppDialog({
  required BuildContext context,
  required AppDialogType type,
  required String title,
  String? message,
  IconData? icon,
  required String primaryButtonText,
  String? secondaryButtonText,
  VoidCallback? onPrimaryPressed,
  VoidCallback? onSecondaryPressed,
  bool showCloseButton = true,
  bool barrierDismissible = true,
  bool isPrimaryLoading = false,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) {
      return AppDialog(
        type: type,
        title: title,
        message: message,
        icon: icon,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        onSecondaryPressed: onSecondaryPressed,
        showCloseButton: showCloseButton,
        isPrimaryLoading: isPrimaryLoading,
      );
    },
  );
}
