import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../overrides/material_override_types.dart';

/// Density-aware adjustments for Material button tokens.
///
/// Applies compact/standard/comfortable deltas to padding and minimum size.
abstract final class MaterialButtonDensityHelpers {
  /// Adjusts [padding] by density delta.
  static EdgeInsets applyDensityToPadding(
    EdgeInsets padding,
    MaterialComponentDensity density,
  ) {
    final deltaH = switch (density) {
      MaterialComponentDensity.compact => -4.0,
      MaterialComponentDensity.standard => 0.0,
      MaterialComponentDensity.comfortable => 4.0,
    };
    final deltaV = switch (density) {
      MaterialComponentDensity.compact => -2.0,
      MaterialComponentDensity.standard => 0.0,
      MaterialComponentDensity.comfortable => 2.0,
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
    MaterialComponentDensity density,
  ) {
    final delta = switch (density) {
      MaterialComponentDensity.compact => -8.0,
      MaterialComponentDensity.standard => 0.0,
      MaterialComponentDensity.comfortable => 8.0,
    };
    return Size(
      math.max(0, base.width + delta),
      math.max(0, base.height + delta),
    );
  }
}
