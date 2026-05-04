import 'package:flutter/material.dart';

import '../../contracts/r_phone_field_country_selector_navigator.dart';

final class RPhoneFieldCountryMenuTheme {
  const RPhoneFieldCountryMenuTheme({
    required this.surfaceColor,
    required this.outlineColor,
    required this.shadowColor,
    required this.accentColor,
    required this.primaryTextStyle,
    required this.secondaryTextStyle,
    required this.sectionLabelStyle,
    required this.searchTextStyle,
    required this.searchIconColor,
    required this.searchBackgroundColor,
    required this.searchBorderColor,
    required this.selectedTileColor,
  });

  final Color surfaceColor;
  final Color outlineColor;
  final Color shadowColor;
  final Color accentColor;
  final TextStyle primaryTextStyle;
  final TextStyle secondaryTextStyle;
  final TextStyle sectionLabelStyle;
  final TextStyle searchTextStyle;
  final Color searchIconColor;
  final Color searchBackgroundColor;
  final Color searchBorderColor;
  final Color selectedTileColor;
}

RPhoneFieldCountryMenuTheme resolvePhoneFieldCountryMenuTheme(
  BuildContext context,
  RPhoneFieldCountrySelectorRequest request,
) {
  final theme = Theme.of(context);
  final scheme = theme.colorScheme;
  final surface = request.backgroundColor ?? scheme.surface;
  final isDark =
      ThemeData.estimateBrightnessForColor(surface) == Brightness.dark;
  final accent = request.searchBoxIconColor ??
      request.titleStyle?.color ??
      (isDark ? const Color(0xFF9BE66E) : scheme.primary);
  final primaryBase = request.titleStyle?.color ??
      (isDark ? Colors.white.withValues(alpha: 0.92) : scheme.onSurface);
  final secondaryBase = request.subtitleStyle?.color ??
      (isDark ? Colors.white.withValues(alpha: 0.68) : scheme.onSurfaceVariant);

  return RPhoneFieldCountryMenuTheme(
    surfaceColor: surface,
    outlineColor: _blend(
      color: isDark ? Colors.white : Colors.black,
      background: surface,
      alpha: isDark ? 0.18 : 0.12,
    ),
    shadowColor: isDark ? Colors.black : scheme.shadow,
    accentColor: accent,
    primaryTextStyle: (theme.textTheme.bodyLarge ?? const TextStyle())
        .copyWith(
          color: primaryBase,
          fontWeight: FontWeight.w600,
        )
        .merge(request.titleStyle),
    secondaryTextStyle: (theme.textTheme.bodySmall ?? const TextStyle())
        .copyWith(
          color: secondaryBase,
        )
        .merge(request.subtitleStyle),
    sectionLabelStyle:
        (theme.textTheme.labelMedium ?? const TextStyle()).copyWith(
      color: secondaryBase,
      fontWeight: FontWeight.w700,
    ),
    searchTextStyle: (theme.textTheme.bodyMedium ?? const TextStyle())
        .copyWith(
          color: request.searchBoxTextStyle?.color ?? primaryBase,
          fontWeight: FontWeight.w500,
        )
        .merge(request.searchBoxTextStyle),
    searchIconColor: accent,
    searchBackgroundColor: _blend(
      color: isDark ? Colors.white : scheme.surfaceTint,
      background: surface,
      alpha: isDark ? 0.06 : 0.05,
    ),
    searchBorderColor: _blend(
      color: accent,
      background: surface,
      alpha: isDark ? 0.38 : 0.22,
    ),
    selectedTileColor: _blend(
      color: accent,
      background: surface,
      alpha: isDark ? 0.18 : 0.12,
    ),
  );
}

Color _blend({
  required Color color,
  required Color background,
  required double alpha,
}) {
  return Color.alphaBlend(color.withValues(alpha: alpha), background);
}
