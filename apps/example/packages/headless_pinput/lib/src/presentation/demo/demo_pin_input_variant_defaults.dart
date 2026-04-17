import 'package:flutter/material.dart';

import '../../contracts/r_pin_input_types.dart';

final class DemoPinInputVariantDefaults {
  const DemoPinInputVariantDefaults._();

  static const fallbackColorScheme = ColorScheme.light(
    primary: Color(0xFF315EFB),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF171717),
    outline: Color(0xFFB6BDC8),
    error: Color(0xFFC62828),
    errorContainer: Color(0xFFFFE3E2),
    surfaceContainerHighest: Color(0xFFF1F4F8),
    primaryContainer: Color(0xFFDCE5FF),
  );

  static DemoPinInputVariantPalette paletteFor(
    ColorScheme scheme,
    RPinInputVariant variant,
  ) {
    switch (variant) {
      case RPinInputVariant.outlined:
        return DemoPinInputVariantPalette(
          background: scheme.surface,
          border: scheme.outline,
          borderWidth: 1,
          shadows: const [],
        );
      case RPinInputVariant.elevated:
        return DemoPinInputVariantPalette(
          background: scheme.surface,
          border: scheme.outline.withValues(alpha: 0.2),
          borderWidth: 1,
          shadows: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        );
      case RPinInputVariant.filled:
      case RPinInputVariant.filledRounded:
        return DemoPinInputVariantPalette(
          background: scheme.surfaceContainerHighest.withValues(alpha: 0.7),
          border: Colors.transparent,
          borderWidth: 0,
          shadows: const [],
        );
      case RPinInputVariant.underlined:
        return DemoPinInputVariantPalette(
          background: Colors.transparent,
          border: scheme.outline,
          borderWidth: 2,
          shadows: const [],
        );
    }
  }

  static Color focusedBackground(
    DemoPinInputVariantPalette palette,
    RPinInputVariant variant,
  ) {
    if (variant == RPinInputVariant.outlined ||
        variant == RPinInputVariant.underlined) {
      return palette.background;
    }
    return palette.background.withValues(alpha: 0.95);
  }

  static List<BoxShadow> focusedShadows(
    DemoPinInputVariantPalette palette,
    RPinInputVariant variant,
    ColorScheme scheme,
  ) {
    if (variant != RPinInputVariant.elevated) {
      return palette.shadows;
    }
    return [
      ...palette.shadows,
      BoxShadow(
        color: scheme.primary.withValues(alpha: 0.12),
        blurRadius: 12,
        spreadRadius: 1,
      ),
    ];
  }

  static Color submittedBackground(
    DemoPinInputVariantPalette palette,
    ColorScheme scheme,
  ) {
    if (palette.borderWidth == 0) {
      return scheme.primaryContainer.withValues(alpha: 0.65);
    }
    return palette.background;
  }

  static Color submittedBorder(ColorScheme scheme) {
    return scheme.primary.withValues(alpha: 0.55);
  }

  static double radiusFor(RPinInputVariant variant) {
    switch (variant) {
      case RPinInputVariant.filledRounded:
        return 20;
      case RPinInputVariant.underlined:
        return 0;
      case RPinInputVariant.outlined:
      case RPinInputVariant.elevated:
      case RPinInputVariant.filled:
        return 14;
    }
  }

  static double widthFor(RPinInputVariant variant) {
    switch (variant) {
      case RPinInputVariant.filledRounded:
        return 58;
      case RPinInputVariant.underlined:
        return 52;
      case RPinInputVariant.outlined:
      case RPinInputVariant.elevated:
      case RPinInputVariant.filled:
        return 56;
    }
  }
}

final class DemoPinInputVariantPalette {
  const DemoPinInputVariantPalette({
    required this.background,
    required this.border,
    required this.borderWidth,
    required this.shadows,
  });

  final Color background;
  final Color border;
  final double borderWidth;
  final List<BoxShadow> shadows;
}
