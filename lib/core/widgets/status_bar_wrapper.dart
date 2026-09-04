import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusBarWrapper extends StatelessWidget {
  final Widget child;
  final Color statusBarColor;
  final bool isDark;

  const StatusBarWrapper({
    super.key,
    required this.child,
    this.isDark = false,
    this.statusBarColor = Colors.transparent,
  });

  SystemUiOverlayStyle get _overlayStyle => SystemUiOverlayStyle(
    statusBarColor: statusBarColor,
    statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    // iOS uses statusBarBrightness inverted from icon brightness.
    statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
  );

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.viewPaddingOf(context).top;
    final paintStatusBar = statusBarColor.a > 0 && topInset > 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle,
      child: paintStatusBar
          ? Stack(
              children: [
                child,
                // iOS ignores statusBarColor; paint the color under the
                // system status bar so it always matches the header.
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: topInset,
                  child: IgnorePointer(
                    child: ColoredBox(color: statusBarColor),
                  ),
                ),
              ],
            )
          : child,
    );
  }
}
