import 'package:flutter/material.dart';
import 'package:shopnepal/core/constants/constant_assets.dart';
import 'package:shopnepal/core/theme/theme_colors.dart';
import 'package:shopnepal/core/widgets/svg_widget.dart';

class AuthAppLogo extends StatelessWidget {
  final double expandedHeight;
  final double collapsedHeight;
  final bool? isKeyboardOpen;

  const AuthAppLogo({
    super.key,
    this.expandedHeight = 180,
    this.collapsedHeight = 120,
    this.isKeyboardOpen,
  });

  @override
  Widget build(BuildContext context) {
    // Detect if the keyboard is open by checking viewInsets, unless explicitly passed in
    final keyboardOpen =
        isKeyboardOpen ?? MediaQuery.viewInsetsOf(context).bottom > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      // This makes the red top section shrink when the keyboard opens!
      height: keyboardOpen ? collapsedHeight : expandedHeight,
      decoration: const BoxDecoration(color: ThemeColors.primaryColor),
      // Use Center to guarantee the logo stays perfectly in the middle
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: const SvgWidget(
            assetName: Assets.logoWhiteSvg,
            color: ThemeColors.pageBackGroundColor,
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
