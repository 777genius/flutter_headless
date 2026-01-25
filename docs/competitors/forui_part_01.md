## Forui (part 1)

Back: [Index](./forui.md)

# Forui

**Минималистичная UI библиотека с CLI**

## Информация

| | |
|---|---|
| **Пакет** | [pub.dev/packages/forui](https://pub.dev/packages/forui) |
| **GitHub** | [github.com/forus-labs/forui](https://github.com/forus-labs/forui) |
| **Сайт** | [forui.dev](https://forui.dev/) |
| **Версия** | 0.17.0 |
| **Автор** | duobase.io |
| **Лицензия** | MIT |
| **Обновление** | 10 дней назад (очень активно!) |
| **Flutter** | Требует 3.35.0+ |

## Концепция

> "A Flutter UI library that provides a set of beautifully designed, minimalistic widgets."

Готовые минималистичные виджеты с мощной системой тем и CLI.

## Компоненты (40+)

### Layout
- FScaffold, FHeader, FDivider

### Form
- FButton, FTextField, FCheckbox, FRadio
- FSwitch, FSlider, FSelect, FSelectGroup
- FDateField, FTimeField, FCalendar

### Navigation
- FTabs, FTabController
- FBreadcrumb, FPagination
- FSidebar, FBottomNavigationBar

### Data Presentation
- FCard, FAvatar, FBadge
- FAccordion, FCalendar
- FProgress, FLineCalendar

### Feedback
- FAlert, FToast (Sonner)
- FDialog, FSheet

### Overlay
- FPopover, FTooltip

## Архитектура тем (6 компонентов)

```
┌─────────────────────────────────────────┐
│            FAnimatedTheme               │
│     (root widget, provides theme)       │
└─────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│              FThemeData                 │
│  (colors, typography, style, widgets)   │
└─────────────────────────────────────────┘
        │           │           │
        ▼           ▼           ▼
┌───────────┐ ┌───────────┐ ┌───────────┐
│  FColors  │ │FTypography│ │  FStyle   │
└───────────┘ └───────────┘ └───────────┘
```

### FColors
```dart
// Парные цвета (background + foreground)
class FColors {
  final Color background;
  final Color foreground;
  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color secondaryForeground;
  final Color muted;
  final Color mutedForeground;
  final Color destructive;
  final Color destructiveForeground;
  final Color border;
  // ...
}
```

### FTypography
```dart
// Основано на размерах Tailwind
class FTypography {
  final String defaultFontFamily;
  final TextStyle xs;   // 12px
  final TextStyle sm;   // 14px
  final TextStyle base; // 16px
  final TextStyle lg;   // 18px
  final TextStyle xl;   // 20px
  final TextStyle xl2;  // 24px
  // ...
}
```

## CLI для генерации

```bash
# Создать тему
dart run forui theme create zinc-light

# Создать стиль виджета
dart run forui style create button
dart run forui style create accordion

# Структура сгенерированных файлов
lib/
├── theme/
│   └── zinc_light_theme.dart
└── styles/
    ├── button_style.dart
    └── accordion_style.dart
```

## Предустановленные темы

```dart
// Готовые темы
FThemes.zinc.light
FThemes.zinc.dark
FThemes.slate.light
FThemes.slate.dark
FThemes.red.light
// ... и другие
```

## Кастомизация стилей

### Вариант 1: copyWith() — быстрые изменения
```dart
FButton(
  style: (style) => style.copyWith(
    enabledStyle: style.enabledStyle.copyWith(
      backgroundColor: Colors.red,
      padding: EdgeInsets.all(20),
    ),
    hoveredStyle: style.hoveredStyle.copyWith(
      backgroundColor: Colors.red.shade700,
    ),
  ),
  onPress: () {},
  child: Text('Custom Button'),
)
```

### Вариант 2: CLI — полная кастомизация
```bash
dart run forui style create button
```

Генерирует файл который можно полностью переписать.

## FWidgetStateMap

```dart
// Состояния через constraints
final stateMap = FWidgetStateMap({
  // Более специфичные сначала!
  WidgetState.hovered | WidgetState.pressed: pressedHoveredStyle,
  WidgetState.hovered: hoveredStyle,
  WidgetState.focused: focusedStyle,
  WidgetState.disabled: disabledStyle,
  WidgetState.values: defaultStyle, // fallback
});

// Использование
final currentStyle = stateMap.resolve(currentStates);
```

## Использование

```dart
// Инициализация
void main() {
  runApp(
    MaterialApp(
      builder: (context, child) => FAnimatedTheme(
        data: FThemes.zinc.light,
        child: FToaster(child: child!),
      ),
      home: MyApp(),
    ),
  );
}

// Виджеты
FButton(
  onPress: () => print('tap'),
  child: Text('Click me'),
)

FTextField(
  controller: _controller,
  label: Text('Email'),
  hint: 'Enter your email',
)

FCheckbox(
  value: _checked,
  onChanged: (value) => setState(() => _checked = value),
  label: Text('Accept terms'),
)

FTabs(
  tabs: [
    FTabEntry(label: Text('Tab 1'), content: Content1()),
    FTabEntry(label: Text('Tab 2'), content: Content2()),
  ],
)
```

## Material Interop

```dart
// Конвертация в Material тему
final materialTheme = forumTheme.toApproximateMaterialTheme();

MaterialApp(
  theme: materialTheme,
  // ...
)
```

## ThemeExtension для кастомных токенов

```dart
class BrandColors extends ThemeExtension<BrandColors> {
  final Color accent;
  final Color highlight;

  const BrandColors({required this.accent, required this.highlight});

  @override
  BrandColors copyWith({Color? accent, Color? highlight}) {
    return BrandColors(
      accent: accent ?? this.accent,
      highlight: highlight ?? this.highlight,
    );
  }

  @override
  BrandColors lerp(BrandColors? other, double t) {
    return BrandColors(
      accent: Color.lerp(accent, other?.accent, t)!,
      highlight: Color.lerp(highlight, other?.highlight, t)!,
    );
  }
}

// Доступ
context.theme.extension<BrandColors>()!.accent
```

## Плюсы

- ✅ **40+ виджетов** — всё что нужно
- ✅ **CLI генерация** — темы и стили
- ✅ **FWidgetStateMap** — декларативные состояния
- ✅ **Хорошая документация**
- ✅ **Активная разработка** (обновление 10 дней назад)
- ✅ **Material interop**
- ✅ **Hooks интеграция** (forui_hooks)
- ✅ **Минималистичный дизайн**

## Минусы

- ❌ **НЕ headless** — готовый визуал, нельзя полностью переопределить
- ❌ **Привязан к Forui стилю** — выглядит как Forui
- ❌ **Не для multi-brand** — один визуальный язык
- ❌ **copyWith hell** — глубокая вложенность для кастомизации

