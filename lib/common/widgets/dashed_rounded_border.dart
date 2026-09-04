// import 'dart:math' as math;

// import 'package:flutter/material.dart';

// /// Paints a dashed stroke along a rounded rectangle around [child].
// class DashedRoundedBorder extends StatelessWidget {
//   const DashedRoundedBorder({
//     super.key,
//     required this.child,
//     required this.borderColor,
//     this.borderRadius = 8,
//     this.strokeWidth = 1.2,
//     this.dashWidth = 5,
//     this.dashGap = 4,
//   });

//   final Widget child;
//   final Color borderColor;
//   final double borderRadius;
//   final double strokeWidth;
//   final double dashWidth;
//   final double dashGap;

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       foregroundPainter: _DashedRRectPainter(
//         color: borderColor,
//         borderRadius: borderRadius,
//         strokeWidth: strokeWidth,
//         dashWidth: dashWidth,
//         dashGap: dashGap,
//       ),
//       child: child,
//     );
//   }
// }

// class _DashedRRectPainter extends CustomPainter {
//   _DashedRRectPainter({
//     required this.color,
//     required this.borderRadius,
//     required this.strokeWidth,
//     required this.dashWidth,
//     required this.dashGap,
//   });

//   final Color color;
//   final double borderRadius;
//   final double strokeWidth;
//   final double dashWidth;
//   final double dashGap;

//   @override
//   void paint(Canvas canvas, Size size) {
//     final inset = strokeWidth / 2;
//     final rect = Rect.fromLTWH(
//       inset,
//       inset,
//       math.max(0, size.width - strokeWidth),
//       math.max(0, size.height - strokeWidth),
//     );
//     final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
//     final path = Path()..addRRect(rrect);
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth;

//     for (final metric in path.computeMetrics()) {
//       var distance = 0.0;
//       while (distance < metric.length) {
//         final next = distance + dashWidth;
//         final end = math.min(next, metric.length);
//         canvas.drawPath(metric.extractPath(distance, end), paint);
//         distance = end + dashGap;
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
//     return oldDelegate.color != color ||
//         oldDelegate.borderRadius != borderRadius ||
//         oldDelegate.strokeWidth != strokeWidth ||
//         oldDelegate.dashWidth != dashWidth ||
//         oldDelegate.dashGap != dashGap;
//   }
// }
