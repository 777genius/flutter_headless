import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../overrides/material_override_types.dart';

final class MaterialDropdownDensity {
  static EdgeInsets applyPadding(
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

  static EdgeInsets applyMenuPadding(
    EdgeInsets padding,
    MaterialComponentDensity density,
  ) {
    final deltaV = switch (density) {
      MaterialComponentDensity.compact => -2.0,
      MaterialComponentDensity.standard => 0.0,
      MaterialComponentDensity.comfortable => 2.0,
    };

    return EdgeInsets.fromLTRB(
      padding.left,
      math.max(0, padding.top + deltaV),
      padding.right,
      math.max(0, padding.bottom + deltaV),
    );
  }

  static Size applyMinSize(Size base, MaterialComponentDensity density) {
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

  static double minHeight(MaterialComponentDensity density) {
    return switch (density) {
      MaterialComponentDensity.compact => 40,
      MaterialComponentDensity.standard => 48,
      MaterialComponentDensity.comfortable => 56,
    };
  }
}
