import 'package:flutter/material.dart';
import 'package:shopnepal/common/theme/theme_colors.dart';
import 'package:shopnepal/navigation/app_navigator.dart';

class AuthBackButton extends StatelessWidget {
  const AuthBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BackButton(
      backgroundColor: ThemeColors.black.withOpacity(0.2),
      iconColor: ThemeColors.pageBackGroundColor,
    );
  }
}

class OtpBackButton extends StatelessWidget {
  const OtpBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BackButton(
      backgroundColor: ThemeColors.pageBackGroundColor,
      iconColor: ThemeColors.primaryColor,
    );
  }
}

class BackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  const BackButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onPressed ?? () => AppNavigator.pop(),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color:
                  backgroundColor ??
                  ThemeColors.lightGrey.withValues(alpha: 120),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: iconColor ?? ThemeColors.black,
            ),
          ),
        ),
      ],
    );
  }
}
