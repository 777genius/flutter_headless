import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import 'cupertino_dropdown_density.dart';
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
    // iOS-style colors
    final foregroundColor = isDisabled
        ? CupertinoColors.inactiveGray
        : (isDark ? CupertinoColors.white : CupertinoColors.black);

    final backgroundColor = CupertinoColors.tertiarySystemFill;
    final borderColor = CupertinoColors.separator;

    final padding = density == null
        ? overrides?.triggerPadding ??
            const EdgeInsets.symmetric(horizontal: 14)
        : CupertinoDropdownDensity.applyPadding(
            const EdgeInsets.symmetric(horizontal: 14),
            density,
          );
    final minSize = _resolveMinSize(
      density: density,
      override: density == null ? overrides?.triggerMinSize : null,
    );
    final borderRadius = _resolveCornerRadius(cornerStyle) ??
        overrides?.triggerBorderRadius ??
        const BorderRadius.all(Radius.circular(14));

    return RDropdownTriggerTokens(
      textStyle: overrides?.triggerTextStyle ??
          TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: foregroundColor,
            decoration: TextDecoration.none,
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
        : CupertinoDropdownDensity.applyMenuPadding(
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
        : CupertinoDropdownDensity.applyPadding(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            density,
          );
    final minHeight = density == null
        ? overrides?.itemMinHeight ?? 44
        : CupertinoDropdownDensity.minHeight(density);

    return RDropdownItemTokens(
      textStyle: overrides?.itemTextStyle ??
          const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.none,
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
    final size = density == null
        ? base
        : CupertinoDropdownDensity.applyMinSize(base, density);
    return override ?? size;
  }

  BorderRadius? _resolveCornerRadius(CupertinoCornerStyle? style) {
    switch (style) {
      case CupertinoCornerStyle.sharp:
        return const BorderRadius.all(Radius.circular(4));
      case CupertinoCornerStyle.rounded:
        return const BorderRadius.all(Radius.circular(14));
      case CupertinoCornerStyle.pill:
        return const BorderRadius.all(Radius.circular(999));
      case null:
        return null;
    }
  }
}
