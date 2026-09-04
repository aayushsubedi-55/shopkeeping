import 'package:flutter/material.dart';
import 'package:shopnepal/common/theme/theme_colors.dart';

class CommonLoader extends StatelessWidget {
  final double size;
  final Color? color;

  const CommonLoader({super.key, this.size = 28, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? ThemeColors.primaryColor,
        ),
      ),
    );
  }
}

class CommonLoaderOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Color barrierColor;

  const CommonLoaderOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.barrierColor = ThemeColors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          child,
          if (isLoading)
            Positioned.fill(
              child: AbsorbPointer(
                absorbing: true,
                child: ColoredBox(color: barrierColor),
              ),
            ),
          if (isLoading)
            const Positioned.fill(child: Center(child: CommonLoader())),
        ],
      ),
    );
  }
}
