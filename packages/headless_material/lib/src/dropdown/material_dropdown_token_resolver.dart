import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import 'material_dropdown_density.dart';
import 'material_dropdown_geometry.dart';
import '../overrides/material_dropdown_overrides.dart';
import '../overrides/material_override_types.dart';

/// Material 3 token resolver for Dropdown components.
///
/// Implements [RDropdownTokenResolver] with Material Design 3 styling.
///
/// Token resolution priority (v1):
/// 1. Per-instance contract overrides: `overrides.get<RDropdownOverrides>()`
/// 2. Theme defaults / preset defaults
///
/// Note: Preset-specific overrides (e.g., MaterialDropdownOverrides) may be
/// added in future versions as an advanced customization layer.
///
/// Deterministic: same inputs always produce same outputs.
///
/// Note: [overlayPhase] affects trigger tokens (e.g., border color when opened).
///
/// See `docs/V1_DECISIONS.md` → "Token Resolution Layer".
class MaterialDropdownTokenResolver implements RDropdownTokenResolver {
  /// Creates a Material dropdown token resolver.
  ///
  /// [colorScheme] - Optional color scheme override.
  /// [textTheme] - Optional text theme override.
  const MaterialDropdownTokenResolver({
    this.colorScheme,
    this.textTheme,
    this.defaults,
  });

  /// Optional color scheme override.
  final ColorScheme? colorScheme;

  /// Optional text theme override.
  final TextTheme? textTheme;

  /// Optional theme-level defaults.
  final MaterialDropdownOverrides? defaults;

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
            HeadlessMotionTheme.material;

    // Get theme from context or use overrides
    final scheme = colorScheme ?? Theme.of(context).colorScheme;
    final text = textTheme ?? Theme.of(context).textTheme;

    // Get per-instance overrides
    final materialOverrides = overrides?.get<MaterialDropdownOverrides>();
    final dropdownOverrides = overrides?.get<RDropdownOverrides>();

    final q = HeadlessWidgetStateQuery(triggerStates);

    // Resolve trigger tokens
    final density = materialOverrides?.density ?? defaults?.density;
    final cornerStyle = materialOverrides?.cornerStyle ?? defaults?.cornerStyle;

    final trigger = _resolveTriggerTokens(
      spec: spec,
      q: q,
      overlayPhase: overlayPhase,
      scheme: scheme,
      text: text,
      constraints: constraints,
      overrides: dropdownOverrides,
      density: density,
      cornerStyle: cornerStyle,
    );

    // Resolve menu tokens
    final menu = _resolveMenuTokens(
      scheme: scheme,
      overrides: dropdownOverrides,
      density: density,
      cornerStyle: cornerStyle,
      motionTheme: motionTheme,
    );

    // Resolve item tokens
    final item = _resolveItemTokens(
      scheme: scheme,
      text: text,
      overrides: dropdownOverrides,
      density: density,
    );

    return RDropdownResolvedTokens(
      trigger: trigger,
      menu: menu,
      item: item,
    );
  }

  /// Resolve trigger button tokens.
  RDropdownTriggerTokens _resolveTriggerTokens({
    required RDropdownButtonSpec spec,
    required HeadlessWidgetStateQuery q,
    required ROverlayPhase overlayPhase,
    required ColorScheme scheme,
    required TextTheme text,
    BoxConstraints? constraints,
    RDropdownOverrides? overrides,
    MaterialComponentDensity? density,
    MaterialCornerStyle? cornerStyle,
  }) {
    final visualState = resolveDropdownTriggerVisualState(
      q: q,
      overlayPhase: overlayPhase,
    );
    final isDisabled =
        visualState == HeadlessDropdownTriggerVisualState.disabled;
    final isOpen = visualState == HeadlessDropdownTriggerVisualState.open;
    final isFocused = visualState == HeadlessDropdownTriggerVisualState.focused;
    final isHovered = visualState == HeadlessDropdownTriggerVisualState.hovered;
    final isPressed = visualState == HeadlessDropdownTriggerVisualState.pressed;

    // Base colors for variant
    Color backgroundColor;
    Color borderColor;
    Color foregroundColor;

    switch (spec.variant) {
      case RDropdownVariant.filled:
        backgroundColor = isDisabled
            ? scheme.surfaceContainerHighest.withValues(alpha: 0.38)
            : scheme.surfaceContainerHighest;
        borderColor = Colors.transparent;
        foregroundColor = isDisabled
            ? scheme.onSurface.withValues(alpha: 0.38)
            : scheme.onSurface;
      case RDropdownVariant.outlined:
        backgroundColor = Colors.transparent;
        borderColor = isDisabled
            ? scheme.outline.withValues(alpha: 0.38)
            : isOpen || isFocused
                ? scheme.primary
                : isHovered || isPressed
                    ? scheme.onSurface
                    : scheme.outline;
        foregroundColor = isDisabled
            ? scheme.onSurface.withValues(alpha: 0.38)
            : scheme.onSurface;
    }

    // Size-based tokens
    final sizeTokens = materialDropdownTriggerSizeTokens(spec.size, text);

    // Resolve minimum size
    final minSize = materialDropdownResolveMinSize(
      constraints: constraints,
      density: density,
      override: density == null ? overrides?.triggerMinSize : null,
    );
    final triggerPadding = density == null
        ? overrides?.triggerPadding ?? sizeTokens.padding
        : MaterialDropdownDensity.applyPadding(sizeTokens.padding, density);
    final triggerBorderRadius =
        materialDropdownResolveCornerRadius(cornerStyle) ??
            overrides?.triggerBorderRadius ??
            const BorderRadius.all(Radius.circular(4));

    return RDropdownTriggerTokens(
      textStyle: overrides?.triggerTextStyle ?? sizeTokens.textStyle,
      foregroundColor: overrides?.triggerForegroundColor ?? foregroundColor,
      backgroundColor: overrides?.triggerBackgroundColor ?? backgroundColor,
      borderColor: overrides?.triggerBorderColor ?? borderColor,
      padding: triggerPadding,
      minSize: minSize,
      borderRadius: triggerBorderRadius,
      iconColor: overrides?.triggerIconColor ?? foregroundColor,
      pressOverlayColor: foregroundColor.withValues(alpha: 0.12),
      pressOpacity: 1.0,
    );
  }

  /// Resolve menu surface tokens.
  RDropdownMenuTokens _resolveMenuTokens({
    required ColorScheme scheme,
    RDropdownOverrides? overrides,
    MaterialComponentDensity? density,
    MaterialCornerStyle? cornerStyle,
    required HeadlessMotionTheme motionTheme,
  }) {
    final menuPadding = density == null
        ? overrides?.menuPadding ?? const EdgeInsets.symmetric(vertical: 8)
        : MaterialDropdownDensity.applyMenuPadding(
            const EdgeInsets.symmetric(vertical: 8),
            density,
          );
    final menuBorderRadius = materialDropdownResolveCornerRadius(cornerStyle) ??
        overrides?.menuBorderRadius ??
        const BorderRadius.all(Radius.circular(4));

    return RDropdownMenuTokens(
      backgroundColor:
          overrides?.menuBackgroundColor ?? scheme.surfaceContainer,
      backgroundOpacity: 1.0,
      borderColor: overrides?.menuBorderColor ?? scheme.outlineVariant,
      borderRadius: menuBorderRadius,
      elevation: overrides?.menuElevation ?? 3,
      maxHeight: overrides?.menuMaxHeight ?? 300,
      padding: menuPadding,
      backdropBlurSigma: 0,
      shadowColor: const Color(0x00000000),
      shadowBlurRadius: 0,
      shadowOffset: Offset.zero,
      motion: motionTheme.dropdownMenu,
    );
  }

  /// Resolve menu item tokens.
  RDropdownItemTokens _resolveItemTokens({
    required ColorScheme scheme,
    required TextTheme text,
    RDropdownOverrides? overrides,
    MaterialComponentDensity? density,
  }) {
    final itemPadding = density == null
        ? overrides?.itemPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
        : MaterialDropdownDensity.applyPadding(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            density,
          );
    final itemMinHeight = density == null
        ? overrides?.itemMinHeight ?? 48
        : MaterialDropdownDensity.minHeight(density);

    return RDropdownItemTokens(
      textStyle: overrides?.itemTextStyle ??
          text.bodyMedium ??
          const TextStyle(fontSize: 14),
      foregroundColor: scheme.onSurface,
      backgroundColor: Colors.transparent,
      highlightBackgroundColor: scheme.onSurface.withValues(alpha: 0.08),
      selectedBackgroundColor: scheme.primaryContainer.withValues(alpha: 0.12),
      disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
      padding: itemPadding,
      minHeight: itemMinHeight,
      selectedMarkerColor: scheme.primary,
    );
  }
}
