import 'package:flutter/material.dart';
import 'package:shopnepal/common/theme/theme_colors.dart';

class AnimatedShimmer extends StatefulWidget {
  final Widget child;
  final BorderRadius? borderRadius;

  const AnimatedShimmer({
    super.key,
    required this.child,
    this.borderRadius,
  });

  @override
  State<AnimatedShimmer> createState() => _AnimatedShimmerState();
}

class _AnimatedShimmerState extends State<AnimatedShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shimmer = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                ThemeColors.midGrayColor,
                ThemeColors.cardBackGroundColor,
                ThemeColors.midGrayColor,
              ],
              stops: [
                (_controller.value - 0.3).clamp(0.0, 1.0),
                _controller.value.clamp(0.0, 1.0),
                (_controller.value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );

    if (widget.borderRadius == null) {
      return shimmer;
    }

    return ClipRRect(
      borderRadius: widget.borderRadius!,
      child: shimmer,
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius borderRadius;
  final Color color;

  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = BorderRadius.zero,
    this.color = ThemeColors.highlightBackGroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
    );
  }
}
