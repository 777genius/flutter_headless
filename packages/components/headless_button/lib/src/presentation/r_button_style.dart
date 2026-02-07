import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:headless_contracts/headless_contracts.dart';

/// Simple, Flutter-like styling sugar for [RTextButton].
///
/// This type is NOT a new renderer contract.
/// It is a convenience layer that is internally converted to
/// `RenderOverrides.only(RButtonOverrides.tokens(...))`.
///
/// Priority (strong -> weak):
/// 1) `overrides: RenderOverrides(...)`
/// 2) `style: RButtonStyle(...)`
/// 3) theme/preset defaults (token resolvers)
@immutable
final class RButtonStyle {
  const RButtonStyle({
    this.textStyle,
    this.foregroundColor,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.minSize,
    this.radius,
    this.borderRadius,
    this.disabledOpacity,
  }) : assert(
          radius == null || borderRadius == null,
          'Provide either radius or borderRadius, not both.',
        );

  final TextStyle? textStyle;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final Size? minSize;

  /// Convenience border radius (circular).
  final double? radius;

  /// Full control when circular radius is not enough.
  final BorderRadius? borderRadius;

  final double? disabledOpacity;

  RButtonOverrides toOverrides() {
    final resolvedBorderRadius = borderRadius ??
        (radius == null ? null : BorderRadius.all(Radius.circular(radius!)));

    return RButtonOverrides.tokens(
      textStyle: textStyle,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      padding: padding,
      minSize: minSize,
      borderRadius: resolvedBorderRadius,
      disabledOpacity: disabledOpacity,
    );
  }
}
