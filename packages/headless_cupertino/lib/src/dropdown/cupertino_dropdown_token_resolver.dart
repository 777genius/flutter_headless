import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import '../overrides/cupertino_dropdown_overrides.dart';
import '../overrides/cupertino_override_types.dart';

/// Cupertino token resolver for Dropdown components.
///
/// Implements [RDropdownTokenResolver] (non-generic) with iOS styling.
///
/// Token resolution priority (v1.1):
/// 1. Preset-specific overrides: `overrides.get<CupertinoDropdownOverrides>()`
/// 2. Contract overrides: `overrides.get<RDropdownOverrides>()`
/// 3. Theme defaults / preset defaults
///
/// Deterministic: same inputs always produce same outputs.
class CupertinoDropdownTokenResolver implements RDropdownTokenResolver {
  /// Creates a Cupertino dropdown token resolver.
  ///
  /// [brightness] - Optional brightness override (light/dark).
  const CupertinoDropdownTokenResolver({
    this.brightness,
  });

  /// Optional brightness override.
  final Brightness? brightness;

  @override
  RDropdownResolvedTokens resolve({
    required BuildContext context,
    required RDropdownButtonSpec spec,
    required Set<WidgetState> triggerStates,
    required ROverlayPhase overlayPhase,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    final motionTheme =
        HeadlessThemeProvider.of(context)?.capability<HeadlessMotionTheme>() ??
            HeadlessMotionTheme.cupertino;

    // Get brightness from context or use override
    final effectiveBrightness =
        brightness ?? CupertinoTheme.brightnessOf(context);
    final isDark = effectiveBrightness == Brightness.dark;

    // Get per-instance overrides
    final cupertinoOverrides = overrides?.get<CupertinoDropdownOverrides>();
    final dropdownOverrides = overrides?.get<RDropdownOverrides>();
    final density = cupertinoOverrides?.density;

    return RDropdownResolvedTokens(
      trigger: _resolveTriggerTokens(
        HeadlessWidgetStateQuery(triggerStates),
        overlayPhase,
        isDark,
        dropdownOverrides,
        density,
        cupertinoOverrides?.cornerStyle,
      ),
      menu: _resolveMenuTokens(
        isDark,
        dropdownOverrides,
        density,
        cupertinoOverrides?.cornerStyle,
        motionTheme,
      ),
      item: _resolveItemTokens(isDark, dropdownOverrides, density),
    );
  }

  /// Resolve trigger tokens.
  RDropdownTriggerTokens _resolveTriggerTokens(
    HeadlessWidgetStateQuery q,
    ROverlayPhase overlayPhase,
    bool isDark,
    RDropdownOverrides? overrides,
    CupertinoComponentDensity? density,
    CupertinoCornerStyle? cornerStyle,
  ) {
    final visualState = resolveDropdownTriggerVisualState(
      q: q,
      overlayPhase: overlayPhase,
    );
    final isDisabled =
        visualState == HeadlessDropdownTriggerVisualState.disabled;
    final isFocused =
        visualState == HeadlessDropdownTriggerVisualState.focused ||
            visualState == HeadlessDropdownTriggerVisualState.open;

    // iOS-style colors
    final foregroundColor = isDisabled
        ? CupertinoColors.inactiveGray
        : (isDark ? CupertinoColors.white : CupertinoColors.black);

    final backgroundColor = isDark
        ? CupertinoColors.tertiarySystemBackground
        : CupertinoColors.white;

    final borderColor = isFocused
        ? CupertinoColors.activeBlue
        : (isDark ? CupertinoColors.systemGrey4 : CupertinoColors.systemGrey3);

    final padding = density == null
        ? overrides?.triggerPadding ??
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
        : _applyDensityToPadding(
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            density,
          );
    final minSize = _resolveMinSize(
      density: density,
      override: density == null ? overrides?.triggerMinSize : null,
    );
    final borderRadius = _resolveCornerRadius(cornerStyle) ??
        overrides?.triggerBorderRadius ??
        const BorderRadius.all(Radius.circular(8));

    return RDropdownTriggerTokens(
      textStyle: overrides?.triggerTextStyle ??
          TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            fontFamily: '.SF Pro Text',
            color: foregroundColor,
          ),
      foregroundColor: overrides?.triggerForegroundColor ?? foregroundColor,
      backgroundColor: overrides?.triggerBackgroundColor ?? backgroundColor,
      borderColor: overrides?.triggerBorderColor ?? borderColor,
      borderRadius: borderRadius,
      padding: padding,
      minSize: minSize,
      iconColor: overrides?.triggerIconColor ?? foregroundColor,
      pressOverlayColor: CupertinoColors.transparent,
      pressOpacity: 0.6,
    );
  }

  /// Resolve menu tokens.
  RDropdownMenuTokens _resolveMenuTokens(
    bool isDark,
    RDropdownOverrides? overrides,
    CupertinoComponentDensity? density,
    CupertinoCornerStyle? cornerStyle,
    HeadlessMotionTheme motionTheme,
  ) {
    final menuPadding = density == null
        ? overrides?.menuPadding ?? const EdgeInsets.symmetric(vertical: 6)
        : _applyDensityToMenuPadding(
            const EdgeInsets.symmetric(vertical: 6),
            density,
          );
    final borderRadius = _resolveCornerRadius(cornerStyle) ??
        overrides?.menuBorderRadius ??
        const BorderRadius.all(Radius.circular(14));

    final baseBackgroundColor = overrides?.menuBackgroundColor ??
        (isDark
            ? CupertinoColors.tertiarySystemBackground
            : CupertinoColors.white);
    return RDropdownMenuTokens(
      backgroundColor: baseBackgroundColor,
      backgroundOpacity: 0.85,
      borderColor: overrides?.menuBorderColor ??
          (isDark ? CupertinoColors.systemGrey4 : CupertinoColors.systemGrey4),
      borderRadius: borderRadius,
      elevation: 0, // iOS uses shadow, not elevation
      maxHeight: overrides?.menuMaxHeight ?? 300,
      padding: menuPadding,
      backdropBlurSigma: 20,
      shadowColor: CupertinoColors.black.withValues(alpha: 0.15),
      shadowBlurRadius: 20,
      shadowOffset: const Offset(0, 10),
      motion: motionTheme.dropdownMenu,
    );
  }

  /// Resolve item tokens.
  RDropdownItemTokens _resolveItemTokens(
    bool isDark,
    RDropdownOverrides? overrides,
    CupertinoComponentDensity? density,
  ) {
    final foregroundColor =
        isDark ? CupertinoColors.white : CupertinoColors.black;

    // Note: Item colors are resolved by the token resolver based on state,
    // not overridden directly via RDropdownOverrides (contract-level).
    // Only textStyle, padding, minHeight are overridable at contract level.
    final itemPadding = density == null
        ? overrides?.itemPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
        : _applyDensityToPadding(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            density,
          );
    final minHeight = density == null
        ? overrides?.itemMinHeight ?? 44
        : _densityMinHeight(density);

    return RDropdownItemTokens(
      textStyle: overrides?.itemTextStyle ??
          const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            fontFamily: '.SF Pro Text',
          ),
      foregroundColor: foregroundColor,
      disabledForegroundColor: CupertinoColors.inactiveGray,
      backgroundColor: CupertinoColors.transparent,
      highlightBackgroundColor:
          isDark ? CupertinoColors.systemGrey5 : CupertinoColors.systemGrey5,
      selectedBackgroundColor:
          CupertinoColors.activeBlue.withValues(alpha: 0.1),
      selectedMarkerColor: CupertinoColors.activeBlue,
      padding: itemPadding,
      minHeight: minHeight,
    );
  }

  Size _resolveMinSize({
    required CupertinoComponentDensity? density,
    required Size? override,
  }) {
    const base = Size(44, 44);
    final size = density == null ? base : _applyDensityToMinSize(base, density);
    return override ?? size;
  }

  BorderRadius? _resolveCornerRadius(CupertinoCornerStyle? style) {
    switch (style) {
      case CupertinoCornerStyle.sharp:
        return const BorderRadius.all(Radius.circular(4));
      case CupertinoCornerStyle.rounded:
        return const BorderRadius.all(Radius.circular(8));
      case CupertinoCornerStyle.pill:
        return const BorderRadius.all(Radius.circular(999));
      case null:
        return null;
    }
  }

  EdgeInsets _applyDensityToPadding(
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

  EdgeInsets _applyDensityToMenuPadding(
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

  Size _applyDensityToMinSize(
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

  double _densityMinHeight(CupertinoComponentDensity density) {
    return switch (density) {
      CupertinoComponentDensity.compact => 40,
      CupertinoComponentDensity.standard => 44,
      CupertinoComponentDensity.comfortable => 52,
    };
  }
}
