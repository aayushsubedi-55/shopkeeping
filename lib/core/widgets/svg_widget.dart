import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgWidget extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  const SvgWidget({
    super.key,
    required this.assetName,
    this.width = 120,
    this.height = 180,
    this.color,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: SvgPicture.asset(
        assetName,
        width: width,
        height: height,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
      ),
    );
  }
}
