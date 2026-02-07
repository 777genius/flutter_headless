import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import '../overrides/cupertino_button_overrides.dart';
import '../overrides/cupertino_override_types.dart';
import 'cupertino_button_density_helpers.dart';

/// Cupertino token resolver for Button components.
///
/// Implements [RButtonTokenResolver] with iOS styling.
///
/// Token resolution priority (v1.1):
/// 1. Preset-specific overrides: `overrides.get<CupertinoButtonOverrides>()`
/// 2. Contract overrides: `overrides.get<RButtonOverrides>()`
/// 3. Theme defaults / preset defaults
///
/// Deterministic: same inputs always produce same outputs.
class CupertinoButtonTokenResolver implements RButtonTokenResolver {
  /// Creates a Cupertino button token resolver.
  ///
  /// [brightness] - Optional brightness override (light/dark).
  const CupertinoButtonTokenResolver({
    this.brightness,
  });

  /// Optional brightness override.
  final Brightness? brightness;

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
        HeadlessMotionTheme.cupertino;

    // Get brightness from context or use override
    final effectiveBrightness =
        brightness ?? CupertinoTheme.brightnessOf(context);
    final isDark = effectiveBrightness == Brightness.dark;

    // Get per-instance overrides
    final cupertinoOverrides = overrides?.get<CupertinoButtonOverrides>();
    final buttonOverrides = overrides?.get<RButtonOverrides>();
    final density = cupertinoOverrides?.density;

    // Resolve base colors based on variant
    final baseColors = _resolveBaseColors(spec.variant, isDark);

    // Apply state modifiers
    final stateColors = _applyStateModifiers(
      baseColors,
      HeadlessWidgetStateQuery(states),
      isDark,
    );

    // Resolve size-dependent values
    final sizeTokens = _resolveSizeTokens(spec.size);

    // Resolve minimum visual size (tap target is handled by policy at component level)
    final minSize = _resolveMinSize(
      constraints: constraints,
      density: density,
      override: density == null ? buttonOverrides?.minSize : null,
      size: spec.size,
    );
    final padding = density == null
        ? buttonOverrides?.padding ?? sizeTokens.padding
        : CupertinoButtonDensityHelpers.applyDensityToPadding(
            sizeTokens.padding, density);
    final borderRadius =
        _resolveCornerRadius(cupertinoOverrides?.cornerStyle) ??
            buttonOverrides?.borderRadius ??
            const BorderRadius.all(Radius.circular(8));

    final resolvedTextStyle = buttonOverrides?.textStyle ?? sizeTokens.textStyle;
    final resolvedForeground =
        buttonOverrides?.foregroundColor ?? stateColors.foreground;
    final resolvedBackground =
        buttonOverrides?.backgroundColor ?? stateColors.background;
    final resolvedBorder = buttonOverrides?.borderColor ?? stateColors.border;
    final resolvedDisabledOpacity = buttonOverrides?.disabledOpacity ?? 0.38;
    const resolvedPressOverlayColor = CupertinoColors.transparent;
    const resolvedPressOpacity = 0.4;

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
      pressOpacity: resolvedPressOpacity,
      motion: motionTheme.button,
    );
  }

  /// Resolve base colors based on variant.
  _ColorSet _resolveBaseColors(RButtonVariant variant, bool isDark) {
    final primary = isDark ? CupertinoColors.systemBlue : CupertinoColors.activeBlue;
    switch (variant) {
      case RButtonVariant.filled:
        return _ColorSet(
          foreground: CupertinoColors.white,
          background: primary,
          border: CupertinoColors.transparent,
        );
      case RButtonVariant.tonal:
        return _ColorSet(
          foreground: primary,
          background: primary.withValues(
            alpha: isDark ? 0.26 : 0.12,
          ),
          border: CupertinoColors.transparent,
        );
      case RButtonVariant.outlined:
        return _ColorSet(
          foreground: primary,
          background: CupertinoColors.transparent,
          border: primary,
        );
      case RButtonVariant.text:
        return _ColorSet(
          foreground: primary,
          background: CupertinoColors.transparent,
          border: CupertinoColors.transparent,
        );
    }
  }

  /// Apply state-dependent color modifiers.
  _ColorSet _applyStateModifiers(
    _ColorSet base,
    HeadlessWidgetStateQuery q,
    bool isDark,
  ) {
    switch (q.interactionVisualState) {
      case HeadlessInteractionVisualState.disabled:
        final disabledColor = isDark
            ? CupertinoColors.systemGrey
            : CupertinoColors.inactiveGray;
        return _ColorSet(
          foreground: disabledColor,
          background: base.background == CupertinoColors.transparent
              ? CupertinoColors.transparent
              : disabledColor.withValues(alpha: 0.3),
          border: base.border == CupertinoColors.transparent
              ? CupertinoColors.transparent
              : disabledColor.withValues(alpha: 0.3),
        );
      case HeadlessInteractionVisualState.pressed:
        return _ColorSet(
          foreground: base.foreground.withValues(alpha: 0.6),
          background: base.background == CupertinoColors.transparent
              ? CupertinoColors.transparent
              : base.background.withValues(alpha: 0.8),
          border: base.border.withValues(alpha: 0.6),
        );
      case HeadlessInteractionVisualState.focused:
        return _ColorSet(
          foreground: base.foreground,
          background: base.background,
          border: base.border == CupertinoColors.transparent
              ? CupertinoColors.transparent
              : CupertinoColors.systemBlue,
        );
      case HeadlessInteractionVisualState.hovered:
      case HeadlessInteractionVisualState.none:
        return base;
    }
  }

  /// Resolve size-dependent tokens.
  _SizeTokens _resolveSizeTokens(RButtonSize size) {
    switch (size) {
      case RButtonSize.small:
        return const _SizeTokens(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: '.SF Pro Text',
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        );
      case RButtonSize.medium:
        return const _SizeTokens(
          textStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            fontFamily: '.SF Pro Text',
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        );
      case RButtonSize.large:
        return const _SizeTokens(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: '.SF Pro Display',
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        );
    }
  }

  /// Resolve minimum size respecting constraints and overrides.
  Size _resolveMinSize({
    required BoxConstraints? constraints,
    required CupertinoComponentDensity? density,
    required Size? override,
    required RButtonSize size,
  }) {
    final defaultMinDim = switch (size) {
      RButtonSize.small => 28.0,
      RButtonSize.medium => 32.0,
      RButtonSize.large => 44.0,
    };
    final defaultMinSize = Size(defaultMinDim, defaultMinDim);
    final base = density == null
        ? defaultMinSize
        : CupertinoButtonDensityHelpers.applyDensityToMinSize(
            defaultMinSize, density);
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
