import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:headless_contracts/headless_contracts.dart';

/// Simple, Flutter-like styling sugar for [RCheckbox].
///
/// This type is NOT a new renderer contract.
/// It is a convenience layer that is internally converted to
/// `RenderOverrides.only(RCheckboxOverrides.tokens(...))`.
///
/// Priority (strong -> weak):
/// 1) `overrides: RenderOverrides(...)`
/// 2) `style: RCheckboxStyle(...)`
/// 3) theme/preset defaults (token resolvers)
@immutable
final class RCheckboxStyle {
  const RCheckboxStyle({
    this.boxSize,
    this.radius,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.activeColor,
    this.inactiveColor,
    this.checkColor,
    this.indeterminateColor,
    this.disabledOpacity,
    this.minTapTargetSize,
  }) : assert(
          radius == null || borderRadius == null,
          'Provide either radius or borderRadius, not both.',
        );

  final double? boxSize;
  final double? radius;
  final BorderRadius? borderRadius;
  final double? borderWidth;
  final Color? borderColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? checkColor;
  final Color? indeterminateColor;
  final double? disabledOpacity;
  final Size? minTapTargetSize;

  RCheckboxOverrides toOverrides() {
    final resolvedRadius = borderRadius ??
        (radius == null ? null : BorderRadius.all(Radius.circular(radius!)));

    return RCheckboxOverrides.tokens(
      boxSize: boxSize,
      borderRadius: resolvedRadius,
      borderWidth: borderWidth,
      borderColor: borderColor,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      checkColor: checkColor,
      indeterminateColor: indeterminateColor,
      disabledOpacity: disabledOpacity,
      minTapTargetSize: minTapTargetSize,
    );
  }
}
