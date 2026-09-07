import 'package:flutter/material.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';
import 'package:shopnepal/core/theme/theme_colors.dart';
import 'package:shopnepal/core/widgets/app_bar/common_app_bar.dart';

class PageWrapper extends StatelessWidget {
  final String? title;
  final VoidCallback? onBackButtonPressed;
  final Widget body;

  final Color backGroundColor;

  final EdgeInsetsGeometry padding;

  final Widget? bottomNavigationBar;

  final double? appBarToolbarHeight;
  final Color? appBarLeadingBackgroundColor;
  final Color? appBarLeadingIconColor;

  const PageWrapper({
    super.key,
    this.title,
    this.onBackButtonPressed,
    required this.body,
    this.padding = AppInsets.all16,
    this.bottomNavigationBar,
    this.backGroundColor = ThemeColors.pageBackGroundColor,
    this.appBarToolbarHeight,
    this.appBarLeadingBackgroundColor,
    this.appBarLeadingIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.commonAppBar(
        title ?? "",
        onBackButtonPressed,
        toolbarHeight: appBarToolbarHeight,
        leadingBackgroundColor: appBarLeadingBackgroundColor,
        appBarBackgroundColor: backGroundColor,
        leadingIconColor: appBarLeadingIconColor,
        statusBarColor: backGroundColor,
      ),
      backgroundColor: backGroundColor,
      body: SafeArea(
        bottom: bottomNavigationBar == null,
        child: Padding(padding: padding, child: body),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
