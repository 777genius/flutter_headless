# shadcn_flutter

**Полная экосистема shadcn/ui для Flutter (by sunarya-thito)**

## Информация

| | |
|---|---|
| **Пакет** | [pub.dev/packages/shadcn_flutter](https://pub.dev/packages/shadcn_flutter) |
| **GitHub** | [github.com/sunarya-thito/shadcn_flutter](https://github.com/sunarya-thito/shadcn_flutter) |
| **Версия** | 0.0.47 |
| **Автор** | Thito Yalasatria Sunarya |
| **Лицензия** | MIT |
| **Обновление** | 52 дня назад |
| **Загрузки** | 3.92k |
| **Лайки** | 392 |

## Концепция

> "A cohesive shadcn/ui ecosystem for Flutter — components, theming, and tooling."

Standalone экосистема, не зависящая от Material/Cupertino (опциональный interop).

## Отличие от shadcn_ui

| | shadcn_ui (nank1ro) | shadcn_flutter (sunarya-thito) |
|---|---|---|
| Стиль | Default shadcn | New York style |
| Компоненты | 30+ | 84+ |
| Standalone | Нет | Да |
| Material interop | Основной | Опциональный |

## Компоненты (84+)

### Forms
- Button, IconButton, ButtonGroup
- Input, Textarea, NumberInput
- Checkbox, Radio, Switch
- Select, MultiSelect, Combobox
- Slider, DatePicker, TimePicker
- ColorPicker, FilePicker
- Form, FormField

### Surfaces
- Dialog, AlertDialog
- Drawer, Sheet
- Popover, Tooltip
- ContextMenu, DropdownMenu

### Navigation
- Tabs, TabList
- Breadcrumb, Pagination
- NavigationMenu, Menubar
- Stepper, Steps

### Layout
- Card, Accordion
- Carousel, Collapsible
- Timeline, ResizablePanel
- Scaffold, AppBar

### Data Display
- Avatar, Badge
- Table, DataTable
- CodeSnippet, Tracker
- Calendar, Chart

### Feedback
- Alert, Toast
- Progress, Skeleton
- Spinner, Loader

### Utilities
- Command (cmd+k palette)
- Keyboard shortcuts
- Scroll area

### Animation
- AnimationBuilder
- Transitions

## Инкрементальное внедрение

```dart
// Можно использовать внутри существующего MaterialApp
MaterialApp(
  home: Scaffold(
    body: ShadcnUI(
      // shadcn компоненты здесь
      child: Column(
        children: [
          Button(child: Text('Shadcn Button')),
          ElevatedButton(child: Text('Material Button')),
        ],
      ),
    ),
  ),
)
```

## Standalone режим

```dart
void main() {
  runApp(
    ShadcnApp(
      title: 'My App',
      theme: ShadcnThemeData.dark(),
      home: MyHomePage(),
    ),
  );
}
```

## Theming

```dart
// Тёмная/светлая тема
ShadcnThemeData.light()
ShadcnThemeData.dark()

// Кастомная тема
ShadcnThemeData(
  colorScheme: ColorScheme(
    background: Color(0xFF0A0A0A),
    foreground: Color(0xFFFAFAFA),
    primary: Color(0xFFF4F4F5),
    primaryForeground: Color(0xFF18181B),
    // ...
  ),
  radius: 8.0,
  // ...
)
```

## Использование

```dart
// Buttons
Button(
  child: Text('Primary'),
  onPressed: () {},
)

Button.secondary(
  child: Text('Secondary'),
  onPressed: () {},
)

Button.destructive(
  child: Text('Delete'),
  onPressed: () {},
)

Button.outline(
  child: Text('Outline'),
  onPressed: () {},
)

Button.ghost(
  child: Text('Ghost'),
  onPressed: () {},
)

Button.link(
  child: Text('Link'),
  onPressed: () {},
)

// Inputs
Input(
  placeholder: 'Email',
  controller: _controller,
)

Textarea(
  placeholder: 'Message',
  maxLines: 5,
)

// Select
Select<String>(
  value: _selected,
  onChanged: (value) => setState(() => _selected = value),
  children: [
    SelectItem(value: 'opt1', child: Text('Option 1')),
    SelectItem(value: 'opt2', child: Text('Option 2')),
  ],
)

// Dialog
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Confirm'),
    content: Text('Are you sure?'),
    actions: [
      Button.outline(child: Text('Cancel')),
      Button(child: Text('Continue')),
    ],
  ),
)

// Toast
showToast(
  context: context,
  builder: (context) => Toast(
    title: Text('Success'),
    description: Text('Saved!'),
  ),
)

// Command Palette (cmd+k)
showCommandDialog(
  context: context,
  commands: [
    Command(
      label: 'Settings',
      icon: Icons.settings,
      onSelect: () {},
    ),
    Command(
      label: 'Profile',
      icon: Icons.person,
      onSelect: () {},
    ),
  ],
)
```

## Платформы

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Windows
- ✅ Linux

## Плюсы

- ✅ **84+ компонентов** — больше всех
- ✅ **Standalone** — не зависит от Material
- ✅ **New York style** — современный вид
- ✅ **Command palette** — cmd+k из коробки
- ✅ **Инкрементальное внедрение**
- ✅ **Кроссплатформенность**

## Минусы

- ❌ **НЕ headless** — фиксированный shadcn визуал
- ❌ **New York only** — нет default стиля
- ❌ **Менее активен** чем shadcn_ui
- ❌ **Меньше документации**

## Что можно взять

1. **Количество компонентов** — 84 покрывает всё
2. **Command palette** — полезная фича
3. **Standalone архитектура** — независимость от Material

## Сравнение с нашим подходом

| Аспект | shadcn_flutter | Headless |
|--------|----------------|------------|
| Headless | ❌ | ✅ |
| Компоненты | 84+ | Примеры |
| Визуал | New York | Любой |
| Multi-brand | ❌ | ✅ |

## Оценка

| Критерий | Оценка |
|----------|:------:|
| Headless | 3 |
| Type-safety | 6 |
| Theming | 6 |
| Документация | 6 |
| Готовность | 7 |
| **Итого** | **5.6** |
