import 'package:flutter/material.dart';

/// M3 Expressive button size constants.
///
/// Pinned from the Material Design 3 Expressive specification.
///
/// Size mapping (RButtonSize → M3 Expressive):
/// - small → S (36dp)
/// - medium → M (40dp) — Flutter's default
/// - large → L (48dp)
abstract final class MaterialButtonParityConstants {
  static const double kSmallMinHeight = 36.0;
  static const double kMediumMinHeight = 40.0;
  static const double kLargeMinHeight = 48.0;

  static const EdgeInsets kSmallPadding =
      EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets kMediumPadding =
      EdgeInsets.symmetric(horizontal: 24);
  static const EdgeInsets kLargePadding =
      EdgeInsets.symmetric(horizontal: 32);
}
