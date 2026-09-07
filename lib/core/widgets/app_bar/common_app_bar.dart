import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';
import 'package:shopnepal/core/theme/theme_colors.dart';
import 'package:shopnepal/navigation/app_navigator.dart';

class CustomAppBar {
  static AppBar commonAppBar(
    String title,
    VoidCallback? onBackButtonPressed, {
    double? toolbarHeight,
    Color? leadingBackgroundColor,
    Color? leadingIconColor,
    Color? appBarBackgroundColor,
    Color? statusBarColor,
  }) => AppBar(
    toolbarHeight: toolbarHeight,
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor:
          statusBarColor ??
          appBarBackgroundColor ??
          ThemeColors.pageBackGroundColor,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
    backgroundColor: appBarBackgroundColor ?? ThemeColors.pageBackGroundColor,
    elevation: 0,
    scrolledUnderElevation: 0,
    title: Text(
      title,
      style: const TextStyle(
        color: ThemeColors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    leading: Padding(
      padding: const EdgeInsets.only(left: AppSpacing.s10),
      child: _CircleIconButton(
        icon: Icons.arrow_back_ios_new,
        backgroundColor:
            leadingBackgroundColor ?? ThemeColors.pageBackGroundColor,
        iconColor: leadingIconColor ?? ThemeColors.primaryColor,
        onTap: onBackButtonPressed ?? () => AppNavigator.context.pop(),
      ),
    ),
  );
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color iconColor;

  const _CircleIconButton({
    required this.icon,
    this.onTap,
    this.backgroundColor = ThemeColors.white,
    this.iconColor = ThemeColors.primaryColor,
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
            child: Center(child: Icon(icon, size: 16, color: iconColor)),
          ),
        ),
      ),
    );
  }
}
