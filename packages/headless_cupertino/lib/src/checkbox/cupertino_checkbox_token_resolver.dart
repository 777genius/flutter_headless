import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

/// Cupertino token resolver for Checkbox components.
///
/// Implements [RCheckboxTokenResolver] with Cupertino styling.
///
/// Token resolution priority (v1):
/// 1. Contract overrides: `overrides.get<RCheckboxOverrides>()`
/// 2. Theme defaults / preset defaults
class CupertinoCheckboxTokenResolver implements RCheckboxTokenResolver {
  const CupertinoCheckboxTokenResolver({
    this.brightness,
  });

  final Brightness? brightness;

  @override
  RCheckboxResolvedTokens resolve({
    required BuildContext context,
    required RCheckboxSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    final motionTheme =
        HeadlessThemeProvider.of(context)?.capability<HeadlessMotionTheme>() ??
            HeadlessMotionTheme.cupertino;

    final q = HeadlessWidgetStateQuery(states);
    final contractOverrides = overrides?.get<RCheckboxOverrides>();

    final isError = spec.isError || q.isError;
    final isSelected = spec.value == true || q.isSelected;

    final resolvedBrightness =
        brightness ?? CupertinoTheme.of(context).brightness;
    final isDark = resolvedBrightness == Brightness.dark;

    final activeColor =
        isError ? CupertinoColors.systemRed : CupertinoColors.activeBlue;
    final checkColor = CupertinoColors.white;
    final borderColor = isError
        ? CupertinoColors.systemRed
        : (isDark ? CupertinoColors.systemGrey2 : CupertinoColors.systemGrey3);

    final inactiveColor = CupertinoColors.transparent;

    Color effectiveBorder = borderColor;
    Color effectiveActive = activeColor;
    Color effectiveCheck = checkColor;

    if (q.isDisabled) {
      effectiveBorder =
          (isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey2)
              .withValues(alpha: 0.6);
      effectiveActive = effectiveBorder;
      effectiveCheck = (isDark ? CupertinoColors.black : CupertinoColors.white)
          .withValues(alpha: 0.9);
    } else if (isSelected || (spec.tristate && spec.value == null)) {
      effectiveBorder = effectiveActive;
    }

    final minTapTargetSize = _resolveMinTapTargetSize(
      constraints: constraints,
      override: contractOverrides?.minTapTargetSize,
    );

    return RCheckboxResolvedTokens(
      boxSize: contractOverrides?.boxSize ?? 18,
      borderRadius: contractOverrides?.borderRadius ??
          const BorderRadius.all(Radius.circular(4)),
      borderWidth: contractOverrides?.borderWidth ?? 2,
      borderColor: contractOverrides?.borderColor ?? effectiveBorder,
      activeColor: contractOverrides?.activeColor ?? effectiveActive,
      inactiveColor: contractOverrides?.inactiveColor ?? inactiveColor,
      checkColor: contractOverrides?.checkColor ?? effectiveCheck,
      indeterminateColor:
          contractOverrides?.indeterminateColor ?? effectiveCheck,
      disabledOpacity: contractOverrides?.disabledOpacity ?? 0.6,
      pressOverlayColor: contractOverrides?.pressOverlayColor ??
          CupertinoColors.activeBlue.withValues(alpha: 0.12),
      pressOpacity: contractOverrides?.pressOpacity ?? 0.4,
      minTapTargetSize: minTapTargetSize,
      motion: contractOverrides?.motion ??
          RCheckboxMotionTokens(
            stateChangeDuration: motionTheme.button.stateChangeDuration,
          ),
    );
  }

  Size _resolveMinTapTargetSize({
    required BoxConstraints? constraints,
    required Size? override,
  }) {
    const fallback = Size(44, 44);
    final base = override ?? fallback;
    if (constraints == null) return base;
    return Size(
      constraints.minWidth > 0 ? constraints.minWidth : base.width,
      constraints.minHeight > 0 ? constraints.minHeight : base.height,
    );
  }
}
