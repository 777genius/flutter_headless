import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';

final class PhoneFieldShowcaseTextFieldTokenResolver
    implements RTextFieldTokenResolver {
  const PhoneFieldShowcaseTextFieldTokenResolver();

  @override
  RTextFieldResolvedTokens resolve({
    required BuildContext context,
    required RTextFieldSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final contractOverrides = overrides?.get<RTextFieldOverrides>();
    final isFocused = states.contains(WidgetState.focused);
    final isDisabled = states.contains(WidgetState.disabled);
    final isError = states.contains(WidgetState.error);
    final isUnderlined = spec.variant == RTextFieldVariant.underlined;
    final defaultCursorColor = contractOverrides?.cursorColor ?? scheme.primary;
    final defaultTextColor = contractOverrides?.textColor ?? scheme.onSurface;
    final defaultPlaceholderColor = contractOverrides?.placeholderColor ??
        scheme.onSurfaceVariant.withValues(alpha: 0.72);
    final defaultBorderColor = _defaultBorderColor(
      contractOverrides: contractOverrides,
      scheme: scheme,
      isFocused: isFocused,
      isError: isError,
      cursorColor: defaultCursorColor,
    );
    final defaultTextStyle = _defaultTextStyle(
      textTheme: text,
      variant: spec.variant,
      color: defaultTextColor,
    );
    final defaultPlaceholderStyle = _defaultPlaceholderStyle(
      textTheme: text,
      variant: spec.variant,
      color: defaultPlaceholderColor,
    );

    return RTextFieldResolvedTokens(
      containerPadding:
          contractOverrides?.containerPadding ?? _defaultPadding(spec.variant),
      containerBackgroundColor: contractOverrides?.containerBackgroundColor ??
          _defaultBackgroundColor(
            scheme: scheme,
            variant: spec.variant,
          ),
      containerBorderColor: defaultBorderColor,
      containerBorderRadius: contractOverrides?.containerBorderRadius ??
          _defaultBorderRadius(spec.variant),
      containerBorderWidth: contractOverrides?.containerBorderWidth ?? 1,
      containerElevation: contractOverrides?.containerElevation ?? 0,
      containerAnimationDuration:
          contractOverrides?.containerAnimationDuration ??
              const Duration(milliseconds: 180),
      labelStyle: contractOverrides?.labelStyle ??
          (text.labelLarge ?? const TextStyle()).copyWith(
            color: contractOverrides?.labelColor ?? scheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
      labelColor: contractOverrides?.labelColor ?? scheme.onSurfaceVariant,
      helperStyle: contractOverrides?.helperStyle ??
          (text.bodySmall ?? const TextStyle()).copyWith(
            color: contractOverrides?.helperColor ?? scheme.onSurfaceVariant,
          ),
      helperColor: contractOverrides?.helperColor ?? scheme.onSurfaceVariant,
      errorStyle: contractOverrides?.errorStyle ??
          (text.bodySmall ?? const TextStyle()).copyWith(
            color: contractOverrides?.errorColor ?? scheme.error,
            fontWeight: FontWeight.w600,
          ),
      errorColor: contractOverrides?.errorColor ?? scheme.error,
      messageSpacing: contractOverrides?.messageSpacing ?? 10,
      textStyle: contractOverrides?.textStyle ?? defaultTextStyle,
      textColor: defaultTextColor,
      placeholderStyle: defaultPlaceholderStyle,
      placeholderColor: defaultPlaceholderColor,
      cursorColor: defaultCursorColor,
      selectionColor: contractOverrides?.selectionColor ??
          defaultCursorColor.withValues(alpha: 0.18),
      disabledOpacity: isDisabled ? 0.52 : 1,
      iconColor: contractOverrides?.iconColor ?? scheme.onSurfaceVariant,
      iconSpacing: contractOverrides?.iconSpacing ?? (isUnderlined ? 10 : 12),
      minSize: contractOverrides?.minSize ??
          Size(
            constraints?.minWidth ?? 0,
            isUnderlined ? 54 : 52,
          ),
    );
  }
}

Color _defaultBorderColor({
  required RTextFieldOverrides? contractOverrides,
  required ColorScheme scheme,
  required bool isFocused,
  required bool isError,
  required Color cursorColor,
}) {
  if (isError) {
    return contractOverrides?.errorColor ?? scheme.error;
  }
  if (isFocused) {
    return cursorColor;
  }
  return contractOverrides?.containerBorderColor ??
      scheme.outlineVariant.withValues(alpha: 0.68);
}

TextStyle _defaultTextStyle({
  required TextTheme textTheme,
  required RTextFieldVariant variant,
  required Color color,
}) {
  final base = switch (variant) {
    RTextFieldVariant.underlined => textTheme.headlineSmall ??
        const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
    _ => textTheme.titleLarge ??
        const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  };

  return base.copyWith(
    color: color,
    height: 1.04,
    letterSpacing: variant == RTextFieldVariant.underlined ? 0.4 : 0.2,
  );
}

TextStyle _defaultPlaceholderStyle({
  required TextTheme textTheme,
  required RTextFieldVariant variant,
  required Color color,
}) {
  final base = switch (variant) {
    RTextFieldVariant.underlined => textTheme.headlineSmall ??
        const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    _ => textTheme.titleLarge ??
        const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  };

  return base.copyWith(
    color: color,
    height: 1.04,
    letterSpacing: variant == RTextFieldVariant.underlined ? 0.4 : 0.2,
  );
}

Color _defaultBackgroundColor({
  required ColorScheme scheme,
  required RTextFieldVariant variant,
}) {
  return switch (variant) {
    RTextFieldVariant.filled => scheme.surface.withValues(alpha: 0.84),
    RTextFieldVariant.outlined => Colors.white.withValues(alpha: 0.82),
    RTextFieldVariant.underlined => Colors.transparent,
  };
}

EdgeInsets _defaultPadding(RTextFieldVariant variant) {
  return switch (variant) {
    RTextFieldVariant.underlined =>
      const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
    _ => const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  };
}

BorderRadius _defaultBorderRadius(RTextFieldVariant variant) {
  return switch (variant) {
    RTextFieldVariant.underlined => BorderRadius.zero,
    RTextFieldVariant.outlined => BorderRadius.circular(24),
    RTextFieldVariant.filled => BorderRadius.circular(24),
  };
}
