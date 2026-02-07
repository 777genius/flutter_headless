import 'dart:math';

import 'package:flutter/widgets.dart';

/// Painter for iOS-style gradient border on glass surfaces.
///
/// Creates a 3D bevel effect with:
/// - Lighter highlight on top-left edge
/// - Darker shadow on bottom-right edge
///
/// This mimics the subtle depth effect seen in iOS glass materials.
class GlassBorderPainter extends CustomPainter {
  /// Creates a gradient border painter.
  const GlassBorderPainter({
    required this.borderRadius,
    required this.strokeWidth,
    required this.highlightColor,
    required this.shadowColor,
  });

  /// Border radius matching the container shape.
  final BorderRadius borderRadius;

  /// Width of the border stroke.
  final double strokeWidth;

  /// Color for the highlight edge (top-left, lighter).
  final Color highlightColor;

  /// Color for the shadow edge (bottom-right, darker).
  final Color shadowColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect).deflate(strokeWidth / 2);

    // Sweep gradient creates the 3D bevel effect:
    // - Starts light at top-left (135° = 0.75π)
    // - Transitions to dark at bottom-right
    // - Returns to light completing the circle
    final gradient = SweepGradient(
      center: Alignment.center,
      startAngle: 0.75 * pi,
      endAngle: 2.75 * pi,
      colors: [highlightColor, shadowColor, shadowColor, highlightColor],
      stops: const [0.0, 0.25, 0.75, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(GlassBorderPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.highlightColor != highlightColor ||
        oldDelegate.shadowColor != shadowColor;
  }
}

/// Widget wrapper for [GlassBorderPainter].
///
/// Renders a gradient border with a 3D bevel effect on top of [child].
class GlassBorder extends StatelessWidget {
  /// Creates a glass border widget.
  const GlassBorder({
    super.key,
    required this.borderRadius,
    required this.strokeWidth,
    required this.highlightColor,
    required this.shadowColor,
    required this.child,
  });

  /// Border radius matching the container shape.
  final BorderRadius borderRadius;

  /// Width of the border stroke.
  final double strokeWidth;

  /// Color for the highlight edge (top-left, lighter).
  final Color highlightColor;

  /// Color for the shadow edge (bottom-right, darker).
  final Color shadowColor;

  /// The content to display inside the border.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: GlassBorderPainter(
        borderRadius: borderRadius,
        strokeWidth: strokeWidth,
        highlightColor: highlightColor,
        shadowColor: shadowColor,
      ),
      child: child,
    );
  }
}
