import 'package:flutter/widgets.dart';

import 'package:liquid_glass_apple/src/glass_border.dart';

/// Internal widget for the tint and border layer of glass effect.
///
/// Renders a semi-transparent tint color with a gradient border on top.
/// The border creates a 3D bevel effect with:
/// - Lighter highlight on top-left edge
/// - Darker shadow on bottom-right edge
///
/// This is a separate widget to avoid _build methods and maintain SRP.
class GlassTint extends StatelessWidget {
  /// Creates a glass tint layer.
  const GlassTint({
    super.key,
    required this.tintColor,
    required this.tintOpacity,
    required this.borderRadius,
    required this.highlightOpacity,
    required this.shadowOpacity,
    required this.child,
  });

  /// The tint color to overlay.
  final Color tintColor;

  /// Opacity of the tint (0.0 - 1.0).
  final double tintOpacity;

  /// Border radius matching the container.
  final BorderRadius borderRadius;

  /// Opacity of the border highlight (top-left, lighter).
  final double highlightOpacity;

  /// Opacity of the border shadow (bottom-right, darker).
  final double shadowOpacity;

  /// The content to display on top of the tint.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GlassBorder(
      borderRadius: borderRadius,
      strokeWidth: 0.5,
      highlightColor: tintColor.withValues(alpha: highlightOpacity),
      shadowColor: tintColor.withValues(alpha: shadowOpacity),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tintColor.withValues(alpha: tintOpacity),
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }
}
