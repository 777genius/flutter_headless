import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../overrides/cupertino_override_types.dart';

/// Density-aware adjustments for Cupertino button tokens.
///
/// Applies compact/standard/comfortable deltas to padding and minimum size.
abstract final class CupertinoButtonDensityHelpers {
  /// Adjusts [padding] by density delta.
  static EdgeInsets applyDensityToPadding(
    EdgeInsets padding,
    CupertinoComponentDensity density,
  ) {
    final deltaH = switch (density) {
      CupertinoComponentDensity.compact => -4.0,
      CupertinoComponentDensity.standard => 0.0,
      CupertinoComponentDensity.comfortable => 4.0,
    };
    final deltaV = switch (density) {
      CupertinoComponentDensity.compact => -2.0,
      CupertinoComponentDensity.standard => 0.0,
      CupertinoComponentDensity.comfortable => 2.0,
    };

    return EdgeInsets.fromLTRB(
      math.max(0, padding.left + deltaH),
      math.max(0, padding.top + deltaV),
      math.max(0, padding.right + deltaH),
      math.max(0, padding.bottom + deltaV),
    );
  }

  /// Adjusts minimum [base] size by density delta.
  static Size applyDensityToMinSize(
    Size base,
    CupertinoComponentDensity density,
  ) {
    final delta = switch (density) {
      CupertinoComponentDensity.compact => -6.0,
      CupertinoComponentDensity.standard => 0.0,
      CupertinoComponentDensity.comfortable => 6.0,
    };
    return Size(
      math.max(0, base.width + delta),
      math.max(0, base.height + delta),
    );
  }
}
