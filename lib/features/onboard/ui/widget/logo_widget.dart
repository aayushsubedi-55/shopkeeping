import 'package:flutter/material.dart';
import 'package:shopnepal/common/constants/constant_assets.dart';

class LogoWidget extends StatelessWidget {
  final bool isWhite;
  const LogoWidget({super.key, this.isWhite = false});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      isWhite ? Assets.logoWhite : Assets.logoBlack,
      height: 50,
    );
  }
}
