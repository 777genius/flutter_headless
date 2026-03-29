import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../overrides/cupertino_override_types.dart';

final class CupertinoDropdownDensity {
  static EdgeInsets applyPadding(
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

  static EdgeInsets applyMenuPadding(
    EdgeInsets padding,
    CupertinoComponentDensity density,
  ) {
    final deltaV = switch (density) {
      CupertinoComponentDensity.compact => -2.0,
      CupertinoComponentDensity.standard => 0.0,
      CupertinoComponentDensity.comfortable => 2.0,
    };

    return EdgeInsets.fromLTRB(
      padding.left,
      math.max(0, padding.top + deltaV),
      padding.right,
      math.max(0, padding.bottom + deltaV),
    );
  }

  static Size applyMinSize(Size base, CupertinoComponentDensity density) {
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

  static double minHeight(CupertinoComponentDensity density) {
    return switch (density) {
      CupertinoComponentDensity.compact => 40,
      CupertinoComponentDensity.standard => 44,
      CupertinoComponentDensity.comfortable => 52,
    };
  }
}
