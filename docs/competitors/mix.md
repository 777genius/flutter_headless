# Mix + Remix

**Utility-first styling system + headless widgets**

## Информация

| | |
|---|---|
| **Mix** | [pub.dev/packages/mix](https://pub.dev/packages/mix) |
| **Remix** | [pub.dev/packages/remix](https://pub.dev/packages/remix) |
| **GitHub** | [github.com/conceptadev/mix](https://github.com/conceptadev/mix) |
| **Версия Mix** | 1.7.0 (stable), 2.0.0-rc.0 (prerelease) |
| **Версия Remix** | 0.0.4+1 (stable), 0.1.0-beta.2 (prerelease) |
| **Автор** | leoafarias.com |
| **Лицензия** | BSD-3-Clause |
| **Сайт** | [fluttermix.com](https://www.fluttermix.com/) |

## Концепция

> "An expressive way to effortlessly build design systems in Flutter."

Utility-first подход вдохновлённый Tailwind CSS. Разделяет стили от виджетов.

## Архитектура Mix

```
┌─────────────────────────────────────────┐
│              MixTheme                    │
│  (токены: colors, spaces, radii...)     │
└─────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│               Style                      │
│  ($box, $text, $icon, $on.disabled...)  │
└─────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│           StyledWidget                   │
│  (Box, PressableBox, StyledText...)     │
└─────────────────────────────────────────┘
```

## Токены

```dart
// Определение токенов
const $primary = ColorToken('primary');
const $secondary = ColorToken('secondary');
const $surface = ColorToken('surface');

const $sm = SpaceToken('sm');
const $md = SpaceToken('md');
const $lg = SpaceToken('lg');

const $radiusSm = RadiusToken('radius.sm');
const $radiusLg = RadiusToken('radius.lg');

// Тема с значениями
final theme = MixThemeData(
  colors: {
    $primary: Colors.blue,
    $secondary: Colors.grey,
    $surface: Colors.white,
  },
  spaces: {
    $sm: 8.0,
    $md: 16.0,
    $lg: 24.0,
  },
  radii: {
    $radiusSm: Radius.circular(4),
    $radiusLg: Radius.circular(12),
  },
);
```

## Style API (DSL)

```dart
final buttonStyle = Style(
  // Box (Container)
  $box.height(48),
  $box.padding.horizontal.ref($md),
  $box.borderRadius.all.ref($radiusLg),
  $box.color.ref($primary),

  // Text
  $text.style.fontSize(16),
  $text.style.fontWeight.bold(),
  $text.style.color(Colors.white),

  // Icon
  $icon.size(20),
  $icon.color(Colors.white),

  // Состояния
  $on.hover(
    $box.color.ref($primary).darken(10),
  ),

  $on.press(
    $box.color.ref($primary).darken(20),
    $box.scale(0.98),
  ),

  $on.disabled(
    $box.color(Colors.grey.shade300),
    $text.style.color(Colors.grey.shade500),
  ),

  // Анимация
  $box.animate(
    duration: Duration(milliseconds: 150),
    curve: Curves.easeOut,
  ),
);
```

## Варианты

```dart
// Определение вариантов
const $secondary = Variant('secondary');
const $danger = Variant('danger');
const $outline = Variant('outline');
const $small = Variant('small');
const $large = Variant('large');

final buttonStyle = Style(
  // Базовые стили
  $box.height(40),
  $box.color.ref($primary),

  // Вариант secondary
  $secondary(
    $box.color.ref($secondary),
  ),

  // Вариант danger
  $danger(
    $box.color(Colors.red),
  ),

  // Вариант outline
  $outline(
    $box.color(Colors.transparent),
    $box.border.all.color.ref($primary),
    $box.border.all.width(2),
  ),

  // Размеры
  $small(
    $box.height(32),
    $text.style.fontSize(14),
  ),

  $large(
    $box.height(56),
    $text.style.fontSize(18),
  ),
);

// Использование
PressableBox(
  style: buttonStyle.applyVariants([$danger, $large]),
  child: StyledText('Delete'),
)
```

## StyledWidgets

```dart
// Box — аналог Container
Box(
  style: Style(
    $box.color(Colors.blue),
    $box.padding.all(16),
  ),
  child: Text('Content'),
)

// PressableBox — кнопка
PressableBox(
  style: buttonStyle,
  onPress: () => print('tap'),
  child: StyledText('Click'),
)

// FlexBox — Row/Column
FlexBox(
  style: Style(
    $flex.direction.horizontal(),
    $flex.gap(8),
  ),
  children: [...],
)

// HBox / VBox — shortcuts
HBox(children: [...])  // horizontal
VBox(children: [...])  // vertical

// StyledText
StyledText(
  'Hello',
  style: Style($text.style.fontSize(24)),
)

// StyledIcon
StyledIcon(
  Icons.home,
  style: Style($icon.size(32), $icon.color(Colors.blue)),
)
```

## Remix (Headless)

```dart
// Remix предоставляет unstyled виджеты
// которые работают с Mix стилями

// Пока в beta, мало документации
```

## Mix 2.0 RC изменения

- `Style.of()` и `Style.maybeOf()` — доступ к стилям из контекста
- Widget state variant mixins вынесены в отдельные файлы
- Рефакторинг Stack и StackBox
- Улучшенный merge вариантов

## Плюсы

- ✅ **Utility-first** — как Tailwind, компактно
- ✅ **Варианты** — $secondary, $danger, $large
- ✅ **Состояния** — $on.hover, $on.press, $on.disabled
- ✅ **Токены** — ColorToken, SpaceToken, RadiusToken
- ✅ **Анимации** — встроенные
- ✅ **Хорошая документация**
- ✅ **Активная разработка**

## Минусы

- ❌ **Свой DSL** — $box, $text, $on — нужно учить
- ❌ **String токены** — ColorToken('name') = runtime ошибки
- ❌ **Варианты = строки** — Variant('name') не type-safe
- ❌ **Runtime overhead** — стили собираются в runtime
- ❌ **Не exhaustive** — забыл вариант? Узнаешь в runtime
- ❌ **Кривая обучения** — непривычный синтаксис

## Пример DSL проблемы

```dart
// Как понять что это значит?
$box.borderRadius.all.ref($radiusLg)

// vs чистый Dart
borderRadius: Radii.lg.circular
```

## Что можно взять

1. **Идея вариантов** — но через sealed class
2. **Состояния** — но использовать нативный WidgetState
3. **Структура токенов** — colors, spaces, radii

## Сравнение с нашим подходом

| Аспект | Mix | Headless |
|--------|-----|------------|
| Подход | DSL | Чистый Dart |
| Токены | String-based | Extension types |
| Варианты | Variant('name') | sealed class |
| Состояния | $on.disabled | WidgetState |
| Type-safety | Runtime | Compile-time |
| Learning curve | Высокая | Средняя |
| Headless | Через Remix | Встроено |

## Оценка

| Критерий | Оценка |
|----------|:------:|
| Headless (с Remix) | 9 |
| Type-safety | 5 |
| Theming | 7 |
| Документация | 7 |
| Готовность | 7 |
| **Итого** | **6.3** |
