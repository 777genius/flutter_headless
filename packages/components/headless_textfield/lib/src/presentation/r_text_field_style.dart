import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:headless_contracts/headless_contracts.dart';

/// Simple, Flutter-like styling sugar for [RTextField].
///
/// This type is NOT a new renderer contract.
/// It is a convenience layer that is internally converted to
/// `RenderOverrides.only(RTextFieldOverrides.tokens(...))`.
///
/// Priority (strong -> weak):
/// 1) `overrides: RenderOverrides(...)`
/// 2) `style: RTextFieldStyle(...)`
/// 3) theme/preset defaults (token resolvers)
@immutable
final class RTextFieldStyle {
  const RTextFieldStyle({
    this.containerPadding,
    this.containerBackgroundColor,
    this.containerBorderColor,
    this.containerBorderWidth,
    this.containerRadius,
    this.containerBorderRadius,
    this.textStyle,
    this.textColor,
    this.placeholderColor,
    this.labelColor,
    this.minSize,
  }) : assert(
          containerRadius == null || containerBorderRadius == null,
          'Provide either containerRadius or containerBorderRadius, not both.',
        );

  final EdgeInsetsGeometry? containerPadding;
  final Color? containerBackgroundColor;
  final Color? containerBorderColor;
  final double? containerBorderWidth;
  final double? containerRadius;
  final BorderRadius? containerBorderRadius;

  final TextStyle? textStyle;
  final Color? textColor;
  final Color? placeholderColor;
  final Color? labelColor;
  final Size? minSize;

  RTextFieldOverrides toOverrides() {
    final resolvedRadius = containerBorderRadius ??
        (containerRadius == null
            ? null
            : BorderRadius.all(Radius.circular(containerRadius!)));

    return RTextFieldOverrides.tokens(
      containerPadding: containerPadding,
      containerBackgroundColor: containerBackgroundColor,
      containerBorderColor: containerBorderColor,
      containerBorderRadius: resolvedRadius,
      containerBorderWidth: containerBorderWidth,
      textStyle: textStyle,
      textColor: textColor,
      placeholderColor: placeholderColor,
      labelColor: labelColor,
      minSize: minSize,
    );
  }
}

