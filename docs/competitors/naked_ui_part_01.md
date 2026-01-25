## naked_ui (part 1)

Back: [Index](./naked_ui.md)

# naked_ui

**Главный headless конкурент — ближайший по философии**

## Информация

| | |
|---|---|
| **Пакет** | [pub.dev/packages/naked_ui](https://pub.dev/packages/naked_ui) |
| **GitHub** | [github.com/btwld/naked_ui](https://github.com/btwld/naked_ui) |
| **Docs** | [docs.page/btwld/naked_ui](https://docs.page/btwld/naked_ui) |
| **Версия** | 0.2.0-beta.7 |
| **Автор** | leoafarias.com (тот же что Mix) |
| **Лицензия** | BSD-3-Clause |
| **Обновление** | Активная разработка |
| **Платформы** | Android, iOS, Linux, macOS, Web, Windows |
| **Downloads** | ~720/week |
| **Dart SDK** | >=3.8.0 |
| **Flutter SDK** | >=3.27.0 |

## Концепция

> "A Flutter UI library for headless widgets. No styling, just behavior."

Behavior-first подход — компоненты предоставляют только логику и состояния, визуал полностью на разработчике.

**Ключевая идея**: Разделение behavior и presentation через builder pattern.

## Компоненты (12 штук)

### Input Controls
- `NakedButton` — кнопка
- `NakedCheckbox` — чекбокс
- `NakedRadio` — радио-кнопка
- `NakedSelect` — выпадающий список
- `NakedSlider` — слайдер
- `NakedToggle` — переключатель

### Layout / Overlay
- `NakedTabs` — табы
- `NakedAccordion` — аккордеон
- `NakedMenu` — меню
- `NakedDialog` — диалог
- `NakedTooltip` — тултип
- `NakedPopover` — поповер

## API Pattern

### Builder с state.when()
```dart
NakedButton(
  onPressed: () => print('tap'),
  builder: (context, state, child) {
    final color = state.when(
      pressed: Colors.blue.shade900,
      hovered: Colors.blue.shade700,
      focused: Colors.blue.shade600,
      orElse: Colors.blue,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('Click me', style: TextStyle(color: Colors.white)),
    );
  },
)
```

### Прямой доступ к состояниям
```dart
builder: (context, state, child) {
  if (state.isPressed) return pressedWidget;
  if (state.isHovered) return hoveredWidget;
  if (state.isFocused) return focusedWidget;
  return defaultWidget;
}
```

### NakedCheckbox
```dart
NakedCheckbox(
  checked: _isChecked,
  onChanged: (value) => setState(() => _isChecked = value),
  builder: (context, state, child) {
    final borderColor = state.when(
      hovered: Colors.blue,
      focused: Colors.blue.shade700,
      orElse: Colors.grey,
    );

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(4),
        color: state.isChecked ? Colors.blue : Colors.transparent,
      ),
      child: state.isChecked
        ? Icon(Icons.check, size: 16, color: Colors.white)
        : null,
    );
  },
)
```

### NakedMenu
```dart
NakedMenu<String>(
  items: ['Edit', 'Delete', 'Share'],
  onSelected: (item) => print('Selected: $item'),
  builder: (context, state, child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  },
  itemBuilder: (context, item, state) {
    return Container(
      padding: EdgeInsets.all(12),
      color: state.isHovered ? Colors.grey.shade100 : Colors.transparent,
      child: Text(item),
    );
  },
)
```

## Состояния

| Состояние | Описание |
|-----------|----------|
| `isPressed` | Нажат |
| `isHovered` | Наведён курсор |
| `isFocused` | В фокусе |
| `isDisabled` | Отключён |
| `isChecked` | Отмечен (для checkbox/radio) |
| `isOpen` | Открыт (для menu/dialog) |

## Архитектура

```
NakedWidget
    │
    ├── Управляет состояниями (hover, press, focus)
    ├── Обрабатывает accessibility (Semantics)
    ├── Вызывает callbacks (onPressed, onChanged)
    │
    └── builder(context, state, child)
            │
            └── Разработчик рендерит что хочет
```

## Плюсы

- ✅ **100% headless** — полная свобода визуала
- ✅ **Builder pattern** — удобный API
- ✅ **state.when()** — декларативные состояния
- ✅ **Accessibility** — семантика встроена
- ✅ **12 компонентов** — основные кейсы покрыты
- ✅ **Тот же автор что Mix** — можно комбинировать

## Минусы

- ❌ **Нет вариантов** — primary/secondary/danger делай сам
- ❌ **Нет тем** — multi-brand руками
- ❌ **Нет токенов** — spacing/colors отдельно
- ❌ **Не exhaustive** — state.when() не проверяет все кейсы
- ❌ **Beta** — ещё не стабильный
- ❌ **Мало документации**

## Что можно взять

1. **Builder pattern** — удобно, понятно
2. **state.when()** — но сделать exhaustive через sealed class
3. **Структура компонентов** — 12 базовых покрывают 90% кейсов

---

