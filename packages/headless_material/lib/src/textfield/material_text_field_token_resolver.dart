import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

/// Material 3 token resolver for TextField components.
///
/// Provides resolved visual tokens consumed by the **component** (RTextField)
/// for `EditableText` configuration (textStyle, cursorColor, selectionColor).
///
/// NOTE: In Material parity mode, the **renderer** does NOT read these tokens.
/// Container, label, helper, and icon tokens are resolved but ignored by
/// `MaterialTextFieldRenderer` — `InputDecorator` provides M3 defaults directly.
/// These tokens remain for non-parity renderers and per-instance overrides.
///
/// Token resolution priority (v1):
/// 1. Per-instance contract overrides: `overrides.get<RTextFieldOverrides>()`
/// 2. Theme defaults / preset defaults
///
/// Deterministic: same inputs always produce same outputs.
class MaterialTextFieldTokenResolver implements RTextFieldTokenResolver {
  /// Creates a Material text field token resolver.
  ///
  /// [colorScheme] - Optional color scheme override.
  /// [textTheme] - Optional text theme override.
  const MaterialTextFieldTokenResolver({
    this.colorScheme,
    this.textTheme,
  });

  /// Optional color scheme override.
  final ColorScheme? colorScheme;

  /// Optional text theme override.
  final TextTheme? textTheme;

  @override
  RTextFieldResolvedTokens resolve({
    required BuildContext context,
    required RTextFieldSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    // Get theme from context or use overrides
    final scheme = colorScheme ?? Theme.of(context).colorScheme;
    final text = textTheme ?? Theme.of(context).textTheme;

    // Get per-instance overrides (priority 1)
    final fieldOverrides = overrides?.get<RTextFieldOverrides>();

    // Resolve state-dependent colors
    final q = HeadlessWidgetStateQuery(states);
    final isDisabled = q.isDisabled;
    final isFocused = q.isFocused;
    final isError = q.isError;

    final variant = spec.variant;

    // Container colors
    final containerBackgroundColor = fieldOverrides?.containerBackgroundColor ??
        _resolveBackgroundColor(
          variant: variant,
          scheme: scheme,
        );
    final containerBorderColor = _resolveBorderColor(
      isError: isError,
      isFocused: isFocused,
      isDisabled: isDisabled,
      scheme: scheme,
      override: fieldOverrides?.containerBorderColor,
    );

    // Text colors
    final textColor = fieldOverrides?.textColor ??
        (isDisabled
            ? scheme.onSurface.withValues(alpha: 0.38)
            : scheme.onSurface);
    final placeholderColor = fieldOverrides?.placeholderColor ??
        scheme.onSurfaceVariant.withValues(alpha: 0.6);

    // Label colors
    final labelColor = fieldOverrides?.labelColor ??
        (isError
            ? scheme.error
            : isFocused
                ? scheme.primary
                : scheme.onSurfaceVariant);

    // Helper/error colors
    final helperColor = fieldOverrides?.helperColor ?? scheme.onSurfaceVariant;
    final errorColor = fieldOverrides?.errorColor ?? scheme.error;

    // Cursor/selection
    final cursorColor = fieldOverrides?.cursorColor ??
        (isError ? scheme.error : scheme.primary);
    final selectionColor =
        fieldOverrides?.selectionColor ?? scheme.primary.withValues(alpha: 0.4);

    // Icon color
    final iconColor = fieldOverrides?.iconColor ??
        (isDisabled
            ? scheme.onSurface.withValues(alpha: 0.38)
            : scheme.onSurfaceVariant);

    // Text styles
    final bodyStyle = text.bodyLarge ?? const TextStyle(fontSize: 16);
    final labelStyle = text.bodySmall ?? const TextStyle(fontSize: 12);
    final helperStyle = text.bodySmall ?? const TextStyle(fontSize: 12);

    return RTextFieldResolvedTokens(
      // Container
      containerPadding: fieldOverrides?.containerPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      containerBackgroundColor: containerBackgroundColor,
      containerBorderColor: containerBorderColor,
      containerBorderRadius: fieldOverrides?.containerBorderRadius ??
          _resolveBorderRadius(variant: variant),
      containerBorderWidth: fieldOverrides?.containerBorderWidth ?? 1.0,
      containerElevation: fieldOverrides?.containerElevation ?? 0.0,
      containerAnimationDuration:
          fieldOverrides?.containerAnimationDuration ??
              const Duration(milliseconds: 200),
      // Label / Helper / Error
      labelStyle: fieldOverrides?.labelStyle ?? labelStyle,
      labelColor: labelColor,
      helperStyle: fieldOverrides?.helperStyle ?? helperStyle,
      helperColor: helperColor,
      errorStyle: fieldOverrides?.errorStyle ?? helperStyle,
      errorColor: errorColor,
      messageSpacing: fieldOverrides?.messageSpacing ?? 4.0,
      // Input
      textStyle: fieldOverrides?.textStyle ?? bodyStyle,
      textColor: textColor,
      placeholderStyle: fieldOverrides?.placeholderStyle ?? bodyStyle,
      placeholderColor: placeholderColor,
      cursorColor: cursorColor,
      selectionColor: selectionColor,
      disabledOpacity: 0.38,
      // Icons / Slots
      iconColor: iconColor,
      iconSpacing: fieldOverrides?.iconSpacing ?? 12.0,
      // Sizing
      minSize: fieldOverrides?.minSize ?? Size.zero,
    );
  }

  Color _resolveBackgroundColor({
    required RTextFieldVariant variant,
    required ColorScheme scheme,
  }) {
    switch (variant) {
      case RTextFieldVariant.filled:
        return scheme.surfaceContainerHighest.withValues(alpha: 0.05);
      case RTextFieldVariant.outlined:
      case RTextFieldVariant.underlined:
        return scheme.surface.withValues(alpha: 0.0);
    }
  }

  BorderRadius _resolveBorderRadius({required RTextFieldVariant variant}) {
    switch (variant) {
      case RTextFieldVariant.underlined:
        return BorderRadius.zero;
      case RTextFieldVariant.filled:
      case RTextFieldVariant.outlined:
        return const BorderRadius.all(Radius.circular(4));
    }
  }

  Color _resolveBorderColor({
    required bool isError,
    required bool isFocused,
    required bool isDisabled,
    required ColorScheme scheme,
    Color? override,
  }) {
    if (override != null) return override;

    if (isDisabled) {
      return scheme.outline.withValues(alpha: 0.12);
    }
    if (isError) {
      return scheme.error;
    }
    if (isFocused) {
      return scheme.primary;
    }
    return scheme.outline;
  }
}
