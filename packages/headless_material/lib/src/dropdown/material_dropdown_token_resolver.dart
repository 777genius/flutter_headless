import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

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
      spec: spec,
      scheme: scheme,
      overrides: dropdownOverrides,
      density: density,
      cornerStyle: cornerStyle,
      motionTheme: motionTheme,
    );

    // Resolve item tokens
    final item = _resolveItemTokens(
      spec: spec,
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
    final sizeTokens = _triggerSizeTokens(spec.size, text);

    // Resolve minimum size
    final minSize = _resolveMinSize(
      constraints: constraints,
      density: density,
      override: density == null ? overrides?.triggerMinSize : null,
    );
    final triggerPadding = density == null
        ? overrides?.triggerPadding ?? sizeTokens.padding
        : _applyDensityToPadding(sizeTokens.padding, density);
    final triggerBorderRadius = _resolveCornerRadius(cornerStyle) ??
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

  /// Get trigger size-dependent tokens.
  _TriggerSizeTokens _triggerSizeTokens(RDropdownSize size, TextTheme text) {
    switch (size) {
      case RDropdownSize.small:
        return _TriggerSizeTokens(
          textStyle: text.bodySmall ?? const TextStyle(fontSize: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        );
      case RDropdownSize.medium:
        return _TriggerSizeTokens(
          textStyle: text.bodyMedium ?? const TextStyle(fontSize: 14),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        );
      case RDropdownSize.large:
        return _TriggerSizeTokens(
          textStyle: text.bodyLarge ?? const TextStyle(fontSize: 16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        );
    }
  }

  /// Resolve menu surface tokens.
  RDropdownMenuTokens _resolveMenuTokens({
    required RDropdownButtonSpec spec,
    required ColorScheme scheme,
    RDropdownOverrides? overrides,
    MaterialComponentDensity? density,
    MaterialCornerStyle? cornerStyle,
    required HeadlessMotionTheme motionTheme,
  }) {
    final menuPadding = density == null
        ? overrides?.menuPadding ?? const EdgeInsets.symmetric(vertical: 8)
        : _applyDensityToMenuPadding(
            const EdgeInsets.symmetric(vertical: 8),
            density,
          );
    final menuBorderRadius = _resolveCornerRadius(cornerStyle) ??
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
    required RDropdownButtonSpec spec,
    required ColorScheme scheme,
    required TextTheme text,
    RDropdownOverrides? overrides,
    MaterialComponentDensity? density,
  }) {
    final itemPadding = density == null
        ? overrides?.itemPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
        : _applyDensityToPadding(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            density,
          );
    final itemMinHeight = density == null
        ? overrides?.itemMinHeight ?? 48
        : _densityMinHeight(density);

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

  /// Resolve minimum size respecting constraints and overrides.
  Size _resolveMinSize({
    required BoxConstraints? constraints,
    required MaterialComponentDensity? density,
    required Size? override,
  }) {
    const defaultMinSize = Size(48, 48);
    final base = density == null
        ? defaultMinSize
        : _applyDensityToMinSize(defaultMinSize, density);
    final withOverride = override ?? base;

    if (constraints != null) {
      return Size(
        math.max(
          withOverride.width,
          constraints.minWidth > 0 ? constraints.minWidth : withOverride.width,
        ),
        math.max(
          withOverride.height,
          constraints.minHeight > 0
              ? constraints.minHeight
              : withOverride.height,
        ),
      );
    }

    return withOverride;
  }

  BorderRadius? _resolveCornerRadius(MaterialCornerStyle? style) {
    switch (style) {
      case MaterialCornerStyle.sharp:
        return const BorderRadius.all(Radius.circular(4));
      case MaterialCornerStyle.rounded:
        return const BorderRadius.all(Radius.circular(12));
      case MaterialCornerStyle.pill:
        return const BorderRadius.all(Radius.circular(999));
      case null:
        return null;
    }
  }

  EdgeInsets _applyDensityToPadding(
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

  EdgeInsets _applyDensityToMenuPadding(
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

  Size _applyDensityToMinSize(
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

  double _densityMinHeight(MaterialComponentDensity density) {
    return switch (density) {
      MaterialComponentDensity.compact => 40,
      MaterialComponentDensity.standard => 48,
      MaterialComponentDensity.comfortable => 56,
    };
  }
}

/// Internal helper for trigger size tokens.
class _TriggerSizeTokens {
  const _TriggerSizeTokens({
    required this.textStyle,
    required this.padding,
  });

  final TextStyle textStyle;
  final EdgeInsets padding;
}
