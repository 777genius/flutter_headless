import 'package:flutter/material.dart';
import 'package:headless_theme/headless_theme.dart';

/// Material tap target policy based on Flutter's `ButtonStyleButton._InputPadding`.
///
/// Uses [MaterialTapTargetSize] and [VisualDensity] from [ThemeData] to
/// compute the minimum tap target size:
/// - `padded` → `Size(max(0, 48 + density.horizontal * 4), max(0, 48 + density.vertical * 4))`
/// - `shrinkWrap` → `Size.zero`
class MaterialTapTargetPolicy implements HeadlessTapTargetPolicy {
  const MaterialTapTargetPolicy();

  @override
  Size minTapTargetSize({
    required BuildContext context,
    required HeadlessTapTargetComponent component,
  }) {
    final theme = Theme.of(context);
    return computeMinTapTargetSize(
      tapTargetSize: theme.materialTapTargetSize,
      density: theme.visualDensity,
    );
  }

  /// Pure computation for testing without BuildContext.
  static Size computeMinTapTargetSize({
    required MaterialTapTargetSize tapTargetSize,
    VisualDensity density = VisualDensity.standard,
  }) {
    switch (tapTargetSize) {
      case MaterialTapTargetSize.padded:
        return Size(
          (48.0 + density.horizontal * 4).clampToPositive(),
          (48.0 + density.vertical * 4).clampToPositive(),
        );
      case MaterialTapTargetSize.shrinkWrap:
        return Size.zero;
    }
  }
}

extension on double {
  double clampToPositive() => this < 0 ? 0 : this;
}
