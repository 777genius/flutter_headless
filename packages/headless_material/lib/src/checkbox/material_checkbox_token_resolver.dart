import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

/// Material 3 token resolver for Checkbox components.
///
/// Implements [RCheckboxTokenResolver] with Material Design 3 styling.
///
/// Token resolution priority (v1):
/// 1. Contract overrides: `overrides.get<RCheckboxOverrides>()`
/// 2. Theme defaults / preset defaults
class MaterialCheckboxTokenResolver implements RCheckboxTokenResolver {
  const MaterialCheckboxTokenResolver({
    this.colorScheme,
  });

  final ColorScheme? colorScheme;

  @override
  RCheckboxResolvedTokens resolve({
    required BuildContext context,
    required RCheckboxSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    final motionTheme = HeadlessThemeProvider.of(context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.material;

    final scheme = colorScheme ?? Theme.of(context).colorScheme;
    final q = HeadlessWidgetStateQuery(states);

    final contractOverrides = overrides?.get<RCheckboxOverrides>();

    // Baseline values (Material checkbox is a square glyph).
    const defaultBoxSize = 18.0;
    const defaultBorderWidth = 2.0;
    const defaultBorderRadius = BorderRadius.all(Radius.circular(2));

    final isError = spec.isError || q.isError;
    final isSelected = spec.value == true || q.isSelected;

    Color activeColor = isError ? scheme.error : scheme.primary;
    Color checkColor = isError ? scheme.onError : scheme.onPrimary;
    Color borderColor = isError ? scheme.error : scheme.outline;
    Color inactiveColor = Colors.transparent;

    if (q.isDisabled) {
      final disabledColor = scheme.onSurface.withValues(alpha: 0.38);
      activeColor = disabledColor;
      checkColor = scheme.surface;
      borderColor = disabledColor;
      inactiveColor = Colors.transparent;
    } else if (isSelected || (spec.tristate && spec.value == null)) {
      borderColor = activeColor;
    }

    final minTapTargetSize = _resolveMinTapTargetSize(
      constraints: constraints,
      override: contractOverrides?.minTapTargetSize,
    );

    final resolvedForeground =
        contractOverrides?.checkColor ?? checkColor;
    final resolvedIndeterminate =
        contractOverrides?.indeterminateColor ?? resolvedForeground;

    return RCheckboxResolvedTokens(
      boxSize: contractOverrides?.boxSize ?? defaultBoxSize,
      borderRadius: contractOverrides?.borderRadius ?? defaultBorderRadius,
      borderWidth: contractOverrides?.borderWidth ?? defaultBorderWidth,
      borderColor: contractOverrides?.borderColor ?? borderColor,
      activeColor: contractOverrides?.activeColor ?? activeColor,
      inactiveColor: contractOverrides?.inactiveColor ?? inactiveColor,
      checkColor: resolvedForeground,
      indeterminateColor: resolvedIndeterminate,
      disabledOpacity: contractOverrides?.disabledOpacity ?? 0.38,
      pressOverlayColor:
          contractOverrides?.pressOverlayColor ??
              scheme.primary.withValues(alpha: 0.12),
      pressOpacity: contractOverrides?.pressOpacity ?? 1.0,
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
    const fallback = Size(48, 48);
    final base = override ?? fallback;
    if (constraints == null) return base;
    return Size(
      constraints.minWidth > 0 ? constraints.minWidth : base.width,
      constraints.minHeight > 0 ? constraints.minHeight : base.height,
    );
  }
}

