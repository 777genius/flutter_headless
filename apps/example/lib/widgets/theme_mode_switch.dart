import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:headless/headless.dart';

import '../theme_mode_scope.dart';

/// Переключатели темы для AppBar.
///
/// Содержит два RSwitch:
/// 1. Material/Cupertino — автоматически меняет стиль при переключении
/// 2. Light/Dark — использует thumbIcon для отображения иконок солнца/луны
class ThemeModeSwitch extends StatelessWidget {
  const ThemeModeSwitch({super.key});

  static void _closeActiveTextInputSession() {
    // Web stability: a DOM-backed text input can intermittently block pointer
    // events in other parts of the UI after rebuild/theme changes.
    //
    // Be aggressive: blur Flutter focus + ask engine to hide the text input.
    FocusManager.instance.primaryFocus?.unfocus();
    // `TextInput.hide` is safe to call even when no client is active.
    SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
  }

  static void _schedule(VoidCallback cb) {
    SchedulerBinding.instance.addPostFrameCallback((_) => cb());
  }

  @override
  Widget build(BuildContext context) {
    final scope = ThemeModeScope.of(context);

    // TextFieldTapRegion: keep AppBar actions tappable while any text field
    // is focused (prevents "tap outside" focus management from interfering).
    return TextFieldTapRegion(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Material/Cupertino switch
          Text(
            'Material',
            style: TextStyle(
              fontWeight:
                  scope.isCupertino ? FontWeight.normal : FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => _closeActiveTextInputSession(),
            child: RSwitch(
              value: scope.isCupertino,
              onChanged: (_) {
                _closeActiveTextInputSession();
                // Give the engine a frame to fully close the editing session
                // before rebuilding the app with a different preset.
                _schedule(scope.toggleMode);
              },
              semanticLabel: 'Switch between Material and Cupertino theme',
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'Cupertino',
            style: TextStyle(
              fontWeight:
                  scope.isCupertino ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 24),
          // Light/Dark switch with thumbIcon
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => _closeActiveTextInputSession(),
            child: RSwitch(
              value: scope.isDark,
              onChanged: (_) {
                _closeActiveTextInputSession();
                _schedule(scope.toggleBrightness);
              },
              semanticLabel: 'Switch between light and dark theme',
              thumbIcon: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const Icon(Icons.dark_mode, size: 16);
                }
                return const Icon(Icons.light_mode, size: 16);
              }),
            ),
          ),
        ],
      ),
    );
  }
}
