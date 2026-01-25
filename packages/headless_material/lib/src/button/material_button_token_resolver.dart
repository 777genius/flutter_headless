import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import '../overrides/material_button_overrides.dart';
import '../overrides/material_override_types.dart';

/// Material 3 token resolver for Button components.
///
/// Implements [RButtonTokenResolver] with Material Design 3 styling.
///
  /// Token resolution priority (v1.1):
  /// 1. Preset-specific overrides: `overrides.get<MaterialButtonOverrides>()`
  /// 2. Contract overrides: `overrides.get<RButtonOverrides>()`
  /// 3. Theme defaults / preset defaults
///
/// Deterministic: same inputs always produce same outputs.
///
/// See `docs/V1_DECISIONS.md` → "Token Resolution Layer".
class MaterialButtonTokenResolver implements RButtonTokenResolver {
  /// Creates a Material button token resolver.
  ///
  /// [colorScheme] - Optional color scheme override.
  /// [textTheme] - Optional text theme override.
  const MaterialButtonTokenResolver({
    this.colorScheme,
    this.textTheme,
    this.defaults,
  });

  /// Optional color scheme override.
  final ColorScheme? colorScheme;

  /// Optional text theme override.
  final TextTheme? textTheme;

  /// Optional theme-level defaults.
  final MaterialButtonOverrides? defaults;

  @override
  RButtonResolvedTokens resolve({
    required BuildContext context,
    required RButtonSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    final motionTheme = HeadlessThemeProvider.of(context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.material;

    // Get theme from context or use overrides
    final scheme = colorScheme ?? Theme.of(context).colorScheme;
    final text = textTheme ?? Theme.of(context).textTheme;

    // Get per-instance overrides
    final materialOverrides = overrides?.get<MaterialButtonOverrides>();
    final buttonOverrides = overrides?.get<RButtonOverrides>();

    // Resolve base colors based on variant
    final baseColors = _resolveBaseColors(spec.variant, scheme);

    final q = HeadlessWidgetStateQuery(states);

    // Apply state modifiers
    final stateColors = _applyStateModifiers(
      baseColors,
      q,
      scheme,
    );

    // Resolve size-dependent values
    final sizeTokens = _resolveSizeTokens(spec.size, text);
    final density = materialOverrides?.density ?? defaults?.density;

    final padding = density == null
        ? buttonOverrides?.padding ?? sizeTokens.padding
        : _applyDensityToPadding(sizeTokens.padding, density);

    // Resolve minimum size (respect constraints for accessibility)
    final minSize = _resolveMinSize(
      constraints: constraints,
      density: density,
      override: density == null ? buttonOverrides?.minSize : null,
    );

    final borderRadius = _resolveCornerRadius(
          materialOverrides?.cornerStyle ?? defaults?.cornerStyle,
        ) ??
        buttonOverrides?.borderRadius ??
        const BorderRadius.all(Radius.circular(20));

    final resolvedTextStyle = buttonOverrides?.textStyle ?? sizeTokens.textStyle;
    final resolvedForeground =
        buttonOverrides?.foregroundColor ?? stateColors.foreground;
    final resolvedBackground =
        buttonOverrides?.backgroundColor ?? stateColors.background;
    final resolvedBorder = buttonOverrides?.borderColor ?? stateColors.border;
    final resolvedDisabledOpacity = buttonOverrides?.disabledOpacity ?? 0.38;
    final resolvedPressOverlayColor =
        resolvedForeground.withValues(alpha: 0.12);

    // Apply overrides (priority 1 wins)
    return RButtonResolvedTokens(
      textStyle: resolvedTextStyle,
      foregroundColor: resolvedForeground,
      backgroundColor: resolvedBackground,
      borderColor: resolvedBorder,
      padding: padding,
      minSize: minSize,
      borderRadius: borderRadius,
      disabledOpacity: resolvedDisabledOpacity,
      pressOverlayColor: resolvedPressOverlayColor,
      pressOpacity: 1.0,
      motion: motionTheme.button,
    );
  }

  /// Resolve base colors based on variant.
  _ColorSet _resolveBaseColors(RButtonVariant variant, ColorScheme scheme) {
    switch (variant) {
      case RButtonVariant.primary:
        return _ColorSet(
          foreground: scheme.onPrimary,
          background: scheme.primary,
          border: Colors.transparent,
        );
      case RButtonVariant.secondary:
        return _ColorSet(
          foreground: scheme.primary,
          background: Colors.transparent,
          border: scheme.outline,
        );
    }
  }

  /// Apply state-dependent color modifiers.
  _ColorSet _applyStateModifiers(
    _ColorSet base,
    HeadlessWidgetStateQuery q,
    ColorScheme scheme,
  ) {
    switch (q.interactionVisualState) {
      case HeadlessInteractionVisualState.disabled:
        return _ColorSet(
          foreground: scheme.onSurface.withValues(alpha: 0.38),
          background: base.background == Colors.transparent
              ? Colors.transparent
              : scheme.onSurface.withValues(alpha: 0.12),
          border: base.border == Colors.transparent
              ? Colors.transparent
              : scheme.onSurface.withValues(alpha: 0.12),
        );
      case HeadlessInteractionVisualState.pressed:
        return _ColorSet(
          foreground: base.foreground,
          background: base.background == Colors.transparent
              ? scheme.primary.withValues(alpha: 0.12)
              : Color.alphaBlend(
                  scheme.onPrimary.withValues(alpha: 0.12),
                  base.background,
                ),
          border: base.border,
        );
      case HeadlessInteractionVisualState.hovered:
        return _ColorSet(
          foreground: base.foreground,
          background: base.background == Colors.transparent
              ? scheme.primary.withValues(alpha: 0.08)
              : Color.alphaBlend(
                  scheme.onPrimary.withValues(alpha: 0.08),
                  base.background,
                ),
          border: base.border,
        );
      case HeadlessInteractionVisualState.focused:
        return _ColorSet(
          foreground: base.foreground,
          background: base.background == Colors.transparent
              ? scheme.primary.withValues(alpha: 0.12)
              : base.background,
          border: base.border == Colors.transparent
              ? Colors.transparent
              : scheme.primary,
        );
      case HeadlessInteractionVisualState.none:
        return base;
    }
  }

  /// Resolve size-dependent tokens.
  _SizeTokens _resolveSizeTokens(RButtonSize size, TextTheme text) {
    switch (size) {
      case RButtonSize.small:
        return _SizeTokens(
          textStyle: text.labelMedium ?? const TextStyle(fontSize: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        );
      case RButtonSize.medium:
        return _SizeTokens(
          textStyle: text.labelLarge ?? const TextStyle(fontSize: 14),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        );
      case RButtonSize.large:
        return _SizeTokens(
          textStyle: text.titleMedium ?? const TextStyle(fontSize: 16),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        );
    }
  }

  /// Resolve minimum size respecting constraints and overrides.
  Size _resolveMinSize({
    required BoxConstraints? constraints,
    required MaterialComponentDensity? density,
    required Size? override,
  }) {
    // Default Material minimum touch target
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
}

/// Internal helper for color sets.
class _ColorSet {
  const _ColorSet({
    required this.foreground,
    required this.background,
    required this.border,
  });

  final Color foreground;
  final Color background;
  final Color border;
}

/// Internal helper for size-dependent tokens.
class _SizeTokens {
  const _SizeTokens({
    required this.textStyle,
    required this.padding,
  });

  final TextStyle textStyle;
  final EdgeInsets padding;
}
