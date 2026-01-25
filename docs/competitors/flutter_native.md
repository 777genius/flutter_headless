# Flutter Native Mechanisms

**Нативные механизмы Flutter для theming и состояний**

## WidgetState (Flutter 3.22+)

### Информация
- **Документация**: [api.flutter.dev/flutter/widgets/WidgetState.html](https://api.flutter.dev/flutter/widgets/WidgetState-class.html)
- **Ранее**: MaterialState (deprecated)
- **Версия**: Flutter 3.22+

### Enum значения

```dart
enum WidgetState {
  hovered,   // Курсор наведён
  focused,   // В фокусе (клавиатура)
  pressed,   // Нажат
  dragged,   // Перетаскивается
  selected,  // Выбран (checkbox, radio, tab)
  disabled,  // Отключён
  error,     // Ошибка валидации
}
```

### WidgetStateProperty

```dart
// Resolve значение по набору состояний
abstract class WidgetStateProperty<T> {
  T resolve(Set<WidgetState> states);
}

// Реализации
WidgetStateProperty.all<T>(T value)           // Одно значение для всех
WidgetStatePropertyAll<T>(T value)            // То же, но const
WidgetStateProperty.resolveWith<T>(callback)  // Функция
```

### Примеры

```dart
// Простой случай — одно значение
ElevatedButton(
  style: ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.blue),
  ),
)

// С условиями
ElevatedButton(
  style: ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) {
        return Colors.grey;
      }
      if (states.contains(WidgetState.pressed)) {
        return Colors.blue.shade900;
      }
      if (states.contains(WidgetState.hovered)) {
        return Colors.blue.shade700;
      }
      return Colors.blue;
    }),
  ),
)

// Несколько состояний одновременно
WidgetStateProperty.resolveWith<Color?>((states) {
  final isHovered = states.contains(WidgetState.hovered);
  final isPressed = states.contains(WidgetState.pressed);

  if (isHovered && isPressed) return Colors.blue.shade900;
  if (isHovered) return Colors.blue.shade700;
  if (isPressed) return Colors.blue.shade800;
  return Colors.blue;
})
```

### Создание кастомного WidgetStateProperty

```dart
class HoverColor extends WidgetStateProperty<Color> {
  final Color defaultColor;
  final Color hoverColor;

  HoverColor(this.defaultColor, this.hoverColor);

  @override
  Color resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered)) {
      return hoverColor;
    }
    return defaultColor;
  }
}

// Использование
backgroundColor: HoverColor(Colors.blue, Colors.blue.shade700)
```

---

## ThemeExtension

### Информация
- **Документация**: [api.flutter.dev/flutter/material/ThemeExtension-class.html](https://api.flutter.dev/flutter/material/ThemeExtension-class.html)
- **Версия**: Flutter 3.0+

### Базовая реализация

```dart
class AppColors extends ThemeExtension<AppColors> {
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color surface;

  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.surface,
  });

  @override
  AppColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? surface,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      surface: surface ?? this.surface,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
    );
  }
}
```

### Регистрация

```dart
MaterialApp(
  theme: ThemeData.light().copyWith(
    extensions: [
      AppColors(
        primary: Color(0xFF6366F1),
        onPrimary: Colors.white,
        secondary: Color(0xFF64748B),
        surface: Color(0xFFF8FAFC),
      ),
    ],
  ),
  darkTheme: ThemeData.dark().copyWith(
    extensions: [
      AppColors(
        primary: Color(0xFF818CF8),
        onPrimary: Colors.black,
        secondary: Color(0xFF94A3B8),
        surface: Color(0xFF1E293B),
      ),
    ],
  ),
)
```

### Доступ

```dart
// Стандартный способ
final colors = Theme.of(context).extension<AppColors>()!;
final primary = colors.primary;

// Extension на BuildContext
extension ThemeExtensions on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

// Использование
final primary = context.colors.primary;
```

### Анимация при смене темы

```dart
// lerp автоматически вызывается при AnimatedTheme
AnimatedTheme(
  data: isDark ? darkTheme : lightTheme,
  duration: Duration(milliseconds: 300),
  child: MyApp(),
)
```

---

## InheritedWidget / InheritedModel

### Для передачи данных вниз по дереву

```dart
class ThemeScope extends InheritedWidget {
  final AppTheme theme;

  const ThemeScope({
    required this.theme,
    required Widget child,
  }) : super(child: child);

  static AppTheme of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    return scope!.theme;
  }

  @override
  bool updateShouldNotify(ThemeScope oldWidget) {
    return theme != oldWidget.theme;
  }
}

// Использование
ThemeScope(
  theme: QaspaTheme(),
  child: MyApp(),
)

// Доступ
final theme = ThemeScope.of(context);
```

---

## Что можно использовать в Headless

### WidgetState — ДА
```dart
// Нативный enum для состояний виджетов
Set<WidgetState> get _states => {
  if (onPressed == null) WidgetState.disabled,
  if (_isHovered) WidgetState.hovered,
  if (_isPressed) WidgetState.pressed,
  if (_isFocused) WidgetState.focused,
};
```

### ThemeExtension — ЧАСТИЧНО
Можно комбинировать с нашими токенами, но:
- Требует boilerplate (или theme_tailor)
- Не даёт exhaustive checking вариантов

### InheritedWidget — ДА
Для передачи темы вниз по дереву.

---

## Сравнение

| Механизм | Для чего | Плюсы | Минусы |
|----------|----------|-------|--------|
| WidgetState | Состояния | Нативный, стандарт | Set-based, не exhaustive |
| ThemeExtension | Токены | Lerp анимации | Много boilerplate |
| InheritedWidget | Scope | Оптимизирован | Boilerplate |

## Оценка для headless

| Критерий | Оценка |
|----------|:------:|
| Headless | 5 |
| Type-safety | 7 |
| Theming | 7 |
| Документация | 9 |
| Готовность | 10 |
| **Итого** | **7.6** |
