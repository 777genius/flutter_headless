# shadcn_ui

**Порт shadcn/ui для Flutter (by nank1ro)**

## Информация

| | |
|---|---|
| **Пакет** | [pub.dev/packages/shadcn_ui](https://pub.dev/packages/shadcn_ui) |
| **GitHub** | [github.com/nank1ro/flutter-shadcn-ui](https://github.com/nank1ro/flutter-shadcn-ui) |
| **Docs** | [flutter-shadcn-ui.mariuti.com](https://flutter-shadcn-ui.mariuti.com/) |
| **Версия** | 0.43.0 |
| **Автор** | mariuti.com |
| **Лицензия** | MIT |
| **Обновление** | 12 дней назад |
| **Загрузки** | 20.4k |
| **Лайки** | 828 |

## Концепция

> "shadcn/ui ported in Flutter. Awesome UI components for Flutter, fully customizable."

Порт популярного веб-дизайна shadcn/ui. Первая Flutter библиотека позволяющая использовать shadcn и Material компоненты вместе.

## Компоненты (30+)

### Готовые
- Accordion, Alert, Avatar, Badge
- Button, Calendar, Card, Checkbox
- Combobox, Context Menu, Date Picker
- Form, Input, Menubar, Popover
- Progress, RadioGroup, Select, Sheet
- Slider, Switch, Table, Tabs
- Toast, Tooltip

### В разработке
- Carousel, Collapsible, Command
- Data Table, Drawer, Navigation Menu
- Pagination, Skeleton, Toggle, ToggleGroup

## Три режима интеграции

### 1. Pure Shadcn (без Material/Cupertino)
```dart
void main() {
  runApp(
    ShadApp(
      home: MyHomePage(),
    ),
  );
}

// Или с роутером
ShadApp.router(
  routerConfig: _router,
)
```

### 2. Shadcn + Material
```dart
void main() {
  runApp(
    ShadApp.custom(
      materialThemeBuilder: (context, theme) {
        return MaterialApp(
          theme: theme,
          builder: (context, child) {
            return ShadAppBuilder(child: child!);
          },
          home: MyHomePage(),
        );
      },
    ),
  );
}
```

### 3. Shadcn + Cupertino
```dart
void main() {
  runApp(
    ShadApp.custom(
      cupertinoThemeBuilder: (context, theme) {
        return CupertinoApp(
          theme: theme,
          builder: (context, child) {
            return ShadAppBuilder(child: child!);
          },
          home: MyHomePage(),
        );
      },
    ),
  );
}
```

## Theming

### Цветовые схемы (12 штук)
```dart
// Доступные схемы
ShadColorScheme.fromName('blue', Brightness.light)
ShadColorScheme.fromName('gray', Brightness.dark)
ShadColorScheme.fromName('green', Brightness.light)
ShadColorScheme.fromName('neutral', Brightness.dark)
ShadColorScheme.fromName('orange', Brightness.light)
ShadColorScheme.fromName('red', Brightness.dark)
ShadColorScheme.fromName('rose', Brightness.light)
ShadColorScheme.fromName('slate', Brightness.dark)
ShadColorScheme.fromName('stone', Brightness.light)
ShadColorScheme.fromName('violet', Brightness.dark)
ShadColorScheme.fromName('yellow', Brightness.light)
ShadColorScheme.fromName('zinc', Brightness.dark)
```

### Кастомная тема
```dart
ShadApp(
  themeMode: ThemeMode.light,
  theme: ShadThemeData(
    colorScheme: ShadColorScheme.fromName('zinc', Brightness.light),
    brightness: Brightness.light,
  ),
  darkTheme: ShadThemeData(
    colorScheme: ShadColorScheme.fromName('zinc', Brightness.dark),
    brightness: Brightness.dark,
  ),
  home: MyApp(),
)
```

### Кастомизация отдельных компонентов
```dart
ShadThemeData(
  colorScheme: myColorScheme,
  primaryButtonTheme: ShadButtonTheme(
    backgroundColor: Colors.purple,
    hoverBackgroundColor: Colors.purple.shade700,
  ),
)
```

### Custom Colors
```dart
// Добавление кастомных цветов
ShadThemeData(
  colorScheme: ShadColorScheme.fromName('zinc', Brightness.light),
  custom: {
    'brand': Colors.orange,
    'accent': Colors.teal,
  },
)

// Доступ
ShadTheme.of(context).colorScheme.custom['brand']

// Или через extension
extension CustomColors on ShadColorScheme {
  Color get brand => custom['brand']!;
  Color get accent => custom['accent']!;
}

// Использование
ShadTheme.of(context).colorScheme.brand
```

## Использование компонентов

```dart
// Button
ShadButton(
  child: Text('Click me'),
  onPressed: () {},
)

ShadButton.outline(
  child: Text('Outline'),
  onPressed: () {},
)

ShadButton.destructive(
  child: Text('Delete'),
  onPressed: () {},
)

// Input
ShadInput(
  placeholder: Text('Email'),
  controller: _controller,
)

// Checkbox
ShadCheckbox(
  value: _checked,
  onChanged: (value) => setState(() => _checked = value),
  label: Text('Accept'),
)

// Select
ShadSelect<String>(
  placeholder: Text('Select framework'),
  options: [
    ShadOption(value: 'flutter', child: Text('Flutter')),
    ShadOption(value: 'react', child: Text('React')),
  ],
  onChanged: (value) {},
)

// Dialog
ShadDialog(
  title: Text('Are you sure?'),
  description: Text('This action cannot be undone.'),
  actions: [
    ShadButton.outline(child: Text('Cancel')),
    ShadButton(child: Text('Continue')),
  ],
)

// Toast
ShadToaster.of(context).show(
  ShadToast(
    title: Text('Success'),
    description: Text('Your changes have been saved.'),
  ),
)
```

## Зависимости

```yaml
dependencies:
  boxy
  collection
  flutter_animate
  flutter_svg
  lucide_icons_flutter
  theme_extensions_builder_annotation
  two_dimensional_scrollables
  universal_image
  vector_graphics
```

## Плюсы

- ✅ **Популярный дизайн** — shadcn узнаваем
- ✅ **30+ компонентов**
- ✅ **Material/Cupertino interop** — уникальная фича
- ✅ **12 цветовых схем**
- ✅ **Активная разработка**
- ✅ **Хорошая документация**
- ✅ **Custom colors**

## Минусы

- ❌ **НЕ headless** — привязан к shadcn визуалу
- ❌ **Много зависимостей** — 8 пакетов
- ❌ **Специфичный стиль** — не для любого бренда
- ❌ **Не type-safe варианты**

## Что можно взять

1. **Material interop** — полезно для миграции
2. **Color scheme naming** — 12 готовых палитр
3. **Custom colors через Map** — расширяемость

## Сравнение с нашим подходом

| Аспект | shadcn_ui | Headless |
|--------|-----------|------------|
| Headless | ❌ | ✅ |
| Компоненты | 30+ | Примеры |
| Визуал | Фиксированный | Любой |
| Multi-brand | ❌ | ✅ |
| Material interop | ✅ | Можно |

## Оценка

| Критерий | Оценка |
|----------|:------:|
| Headless | 3 |
| Type-safety | 6 |
| Theming | 7 |
| Документация | 7 |
| Готовность | 8 |
| **Итого** | **6.2** |
