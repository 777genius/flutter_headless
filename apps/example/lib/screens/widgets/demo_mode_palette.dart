import 'package:flutter/material.dart';

import '../../theme_mode_scope.dart';

final class DemoModePalette {
  const DemoModePalette({
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.divider,
    required this.primaryText,
    required this.secondaryText,
    required this.accent,
    required this.accentSurface,
    required this.accentForeground,
  });

  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color divider;
  final Color primaryText;
  final Color secondaryText;
  final Color accent;
  final Color accentSurface;
  final Color accentForeground;

  factory DemoModePalette.of(BuildContext context) {
    final scope = ThemeModeScope.of(context);
    if (!scope.isCupertino) {
      final scheme = Theme.of(context).colorScheme;
      return DemoModePalette(
        surface: scheme.surface,
        surfaceAlt: scheme.surfaceContainerHighest,
        border: scheme.outlineVariant,
        divider: scheme.outlineVariant,
        primaryText: scheme.onSurface,
        secondaryText: scheme.onSurfaceVariant,
        accent: scheme.primary,
        accentSurface: scheme.primaryContainer.withValues(alpha: 0.55),
        accentForeground: scheme.onPrimaryContainer,
      );
    }

    if (scope.isDark) {
      return const DemoModePalette(
        surface: Color(0xFF1C1C1E),
        surfaceAlt: Color(0xFF2C2C2E),
        border: Color(0xFF3A3A3C),
        divider: Color(0xFF3A3A3C),
        primaryText: Color(0xFFF2F2F7),
        secondaryText: Color(0xFFAEAEB2),
        accent: Color(0xFF0A84FF),
        accentSurface: Color(0x260A84FF),
        accentForeground: Color(0xFF8FC2FF),
      );
    }

    return const DemoModePalette(
      surface: Color(0xFFFFFFFF),
      surfaceAlt: Color(0xFFF2F2F7),
      border: Color(0xFFD1D1D6),
      divider: Color(0xFFD1D1D6),
      primaryText: Color(0xFF1C1C1E),
      secondaryText: Color(0xFF636366),
      accent: Color(0xFF007AFF),
      accentSurface: Color(0x14007AFF),
      accentForeground: Color(0xFF005BBB),
    );
  }
}
