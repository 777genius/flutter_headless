import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import '../theme_mode_scope.dart';

/// Переключатели темы для AppBar.
///
/// Содержит два RSwitch:
/// 1. Material/Cupertino — автоматически меняет стиль при переключении
/// 2. Light/Dark — использует thumbIcon для отображения иконок солнца/луны
class ThemeModeSwitch extends StatelessWidget {
  const ThemeModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ThemeModeScope.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Material/Cupertino switch
        Text(
          'Material',
          style: TextStyle(
            fontWeight: scope.isCupertino ? FontWeight.normal : FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 4),
        RSwitch(
          value: scope.isCupertino,
          onChanged: (_) => scope.toggleMode(),
          semanticLabel: 'Switch between Material and Cupertino theme',
        ),
        const SizedBox(width: 4),
        Text(
          'Cupertino',
          style: TextStyle(
            fontWeight: scope.isCupertino ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 24),
        // Light/Dark switch with thumbIcon
        RSwitch(
          value: scope.isDark,
          onChanged: (_) => scope.toggleBrightness(),
          semanticLabel: 'Switch between light and dark theme',
          thumbIcon: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const Icon(Icons.dark_mode, size: 16);
            }
            return const Icon(Icons.light_mode, size: 16);
          }),
        ),
      ],
    );
  }
}
