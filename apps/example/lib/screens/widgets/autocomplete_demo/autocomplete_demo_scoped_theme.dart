import 'package:flutter/material.dart';

ThemeData autocompleteDemoScopedTheme(
  BuildContext context,
  ColorScheme colorScheme,
) {
  final baseTheme = Theme.of(context);
  final scopedTextTheme = baseTheme.textTheme.apply(
    bodyColor: colorScheme.onSurface,
    displayColor: colorScheme.onSurface,
  );

  return ThemeData.from(
    colorScheme: colorScheme,
    textTheme: scopedTextTheme,
    useMaterial3: true,
  ).copyWith(
    scaffoldBackgroundColor: Colors.transparent,
    cardColor: Colors.transparent,
    textTheme: scopedTextTheme,
    chipTheme: baseTheme.chipTheme.copyWith(
      backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.9),
      deleteIconColor: colorScheme.onPrimaryContainer,
      labelStyle: scopedTextTheme.labelLarge?.copyWith(
        color: colorScheme.onPrimaryContainer,
        fontWeight: FontWeight.w700,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.outline;
      }),
      checkColor: WidgetStatePropertyAll(colorScheme.onPrimary),
    ),
  );
}
