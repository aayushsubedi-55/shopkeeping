import 'package:flutter/widgets.dart';
import 'package:shopnepal/core/theme/theme_colors.dart';

class CardBoxShadowUtils {
  static BoxShadow cardBoxShadow = BoxShadow(
    color: ThemeColors.shadowColor,
    blurRadius: 6,
    offset: const Offset(0, 4),
    // spreadRadius: -20,
  );
}
