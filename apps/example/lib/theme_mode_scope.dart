import 'package:flutter/widgets.dart';

/// Режим темы приложения.
enum AppThemeMode { material, cupertino }

/// InheritedWidget для глобального состояния темы.
///
/// Позволяет переключать тему между Material и Cupertino,
/// а также между светлой и тёмной темой.
class ThemeModeScope extends InheritedWidget {
  const ThemeModeScope({
    required this.mode,
    required this.toggleMode,
    required this.isDark,
    required this.toggleBrightness,
    required super.child,
    super.key,
  });

  /// Текущий режим темы (Material/Cupertino).
  final AppThemeMode mode;

  /// Переключает режим темы.
  final VoidCallback toggleMode;

  /// Тёмная тема активна.
  final bool isDark;

  /// Переключает яркость темы (светлая/тёмная).
  final VoidCallback toggleBrightness;

  /// Возвращает true если текущая тема — Cupertino.
  bool get isCupertino => mode == AppThemeMode.cupertino;

  /// Получает ThemeModeScope из контекста.
  static ThemeModeScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeModeScope>();
    assert(scope != null, 'ThemeModeScope not found in widget tree');
    return scope!;
  }

  @override
  bool updateShouldNotify(ThemeModeScope oldWidget) =>
      mode != oldWidget.mode || isDark != oldWidget.isDark;
}
