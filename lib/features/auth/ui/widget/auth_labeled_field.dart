import 'package:flutter/material.dart';
import 'package:shopnepal/common/theme/app_spacing.dart';
import 'package:shopnepal/common/theme/theme.dart';

class AuthLabeledField extends StatelessWidget {
  final String label;
  final Widget field;
  final bool required;
  final String? helperText;
  final Widget? helper;
  final Widget? trailing;

  const AuthLabeledField({
    super.key,
    required this.label,
    required this.field,
    this.required = false,
    this.helperText,
    this.helper,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final helperWidget =
        helper ??
        (helperText != null
            ? Text(
                helperText!,
                style: const TextStyle(
                  color: ThemeColors.lightTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.35,
                ),
              )
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: label,
                  style: const TextStyle(
                    color: ThemeColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  children: required
                      ? const [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: ThemeColors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ]
                      : null,
                ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.s8),
              trailing!,
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.s10),
        field,
        if (helperWidget != null) ...[
          const SizedBox(height: AppSpacing.s8),
          helperWidget,
        ],
      ],
    );
  }
}
