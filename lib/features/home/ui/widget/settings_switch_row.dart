import 'package:flutter/material.dart';
import 'package:shopnepal/common/theme/app_spacing.dart';
import 'package:shopnepal/common/theme/theme_colors.dart';

class SettingsSwitchRow extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  const SettingsSwitchRow({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: ThemeColors.black,
                ),
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: ThemeColors.pageBackGroundColor              ,
              inactiveThumbColor: ThemeColors.pageBackGroundColor,
              inactiveTrackColor: ThemeColors.lightGrey,
              trackOutlineColor: MaterialStateProperty.all(ThemeColors.pageBackGroundColor),
              activeTrackColor: ThemeColors.primaryColor,
            ),
          ],
        ),
        if (showDivider) ...[
          const SizedBox(height: AppSpacing.s6),
          const Divider(height: 1, thickness: 1, color: ThemeColors.lightGrey),
          const SizedBox(height: AppSpacing.s6),
        ],
      ],
    );
  }
}
