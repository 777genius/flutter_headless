## naked_ui (part 2)

Back: [Index](./naked_ui.md)

## Глубокое архитектурное сравнение

### Подход к разделению behavior/presentation

| Аспект | naked_ui | Headless |
|--------|----------|------------|
| **Pattern** | Builder callback | Renderer capability (ISP) |
| **Styling location** | Inline в builder | Отдельный пакет (preset) |
| **State exposure** | `state.when()` в callback | `RenderRequest` объект |
| **Reusability** | Copy-paste builder | Переиспользуемый renderer |

### Builder vs Renderer

**naked_ui — Builder Pattern:**
```dart
NakedButton(
  onPressed: save,
  builder: (context, state, child) {
    // Styling тут, inline
    return Container(
      color: state.when(pressed: red, orElse: blue),
      child: child,
    );
  },
)
```
- ✅ Простой API
- ✅ Полный контроль
- ❌ Дублирование styling при переиспользовании
- ❌ Нет multi-brand theming
- ❌ `orElse` не exhaustive

**Headless — Capability Pattern:**
```dart
RTextButton(
  onPressed: save,
  variant: RButtonVariant.primary,
  // Styling в отдельном RButtonRenderer
  child: Text('Save'),
)

// Renderer (в preset пакете):
class MaterialButtonRenderer implements RButtonRenderer {
  Widget render(RButtonRenderRequest request) {
    // request.spec, request.state, request.resolvedTokens
  }
}
```
- ✅ Renderer переиспользуется
- ✅ Multi-brand через preset пакеты
- ✅ Token resolution отдельно
- ✅ Per-instance overrides
- ❌ Сложнее начать

### Пакетная архитектура

| Аспект | naked_ui | Headless |
|--------|----------|------------|
| **Структура** | Один пакет | Multi-package monorepo |
| **Core** | `naked_ui` | `headless_contracts`, `headless_theme`, `headless_foundation` |
| **Компоненты** | В core | Отдельные пакеты (`headless_button`, ...) |
| **Presets** | Нет | `headless_material`, `headless_cupertino` |
| **Зависимости** | flutter only | flutter only (core) |

### State Management

**naked_ui:**
```dart
// State через builder callback
builder: (context, state, child) {
  state.isPressed  // bool
  state.isHovered  // bool
  state.isFocused  // bool
  state.when(pressed: a, hovered: b, orElse: c)  // helper
}
```

**Headless:**
```dart
// State через RenderRequest
final class RButtonState {
  final bool isPressed;
  final bool isHovered;
  final bool isFocused;
  final bool isDisabled;

  Set<WidgetState> toWidgetStates() => {...};
  factory RButtonState.fromWidgetStates(Set<WidgetState> states);
}
```

### Overlay / Popover

| Аспект | naked_ui | Headless |
|--------|----------|------------|
| **Lifecycle** | Не документирован | opening → open → closing → closed |
| **Focus trap** | Встроен | Контракт |
| **Close contract** | Implicit | `close()` → `completeClose()` |
| **Positioning** | Anchored (details unclear) | Renderer responsibility |

### Accessibility

| Аспект | naked_ui | Headless |
|--------|----------|------------|
| **Semantics** | Built-in | Component contract |
| **Keyboard nav** | Tab, Enter, Arrows | Full spec (Space/Enter/Arrows/Home/End) |
| **ARIA roles** | Yes | Via Semantics widget |
| **Focus management** | focusNode, autofocus | focusNode, autofocus, focus restore |

### Кастомизация

| Механизм | naked_ui | Headless |
|----------|----------|------------|
| **Per-instance style** | Inline в builder | `overrides: RenderOverrides({...})` |
| **Slots** | child в builder | `RButtonSlots`, `RDropdownButtonSlots` |
| **Theming** | Нет | `RenderlessThemeProvider` |
| **Token resolution** | Нет | `RButtonTokenResolver` capability |
| **Variants** | Нет | `RButtonVariant.primary/secondary` |

---

## Таблица сравнения (полная)

| Критерий | naked_ui | Headless | Winner |
|----------|:--------:|:----------:|:------:|
| **Philosophy** | | | |
| Headless | ✅ | ✅ | Tie |
| Behavior separation | ✅ | ✅ | Tie |
| Zero styling in core | ✅ | ✅ | Tie |
| **Architecture** | | | |
| Pattern | Builder | Capability | Context |
| Package structure | Mono | Multi-repo | Headless |
| Preset system | ❌ | ✅ | Headless |
| Token resolution | ❌ | ✅ | Headless |
| **Type Safety** | | | |
| State types | Runtime | Compile-time | Headless |
| Variant types | ❌ | Sealed class | Headless |
| Exhaustive matching | orElse | switch | Headless |
| **Customization** | | | |
| Per-instance | ✅ inline | ✅ overrides | Tie |
| Slots | ✅ child | ✅ Replace/Decorate | Headless |
| Multi-brand | ❌ | ✅ | Headless |
| **Accessibility** | | | |
| Keyboard | ✅ | ✅ | Tie |
| Semantics | ✅ | ✅ | Tie |
| Focus management | ✅ | ✅ | Tie |
| **DX** | | | |
| Learning curve | Low | Medium | naked_ui |
| Boilerplate | Low | Medium | naked_ui |
| Documentation | 6/10 | 8/10 | Headless |
| **Maturity** | | | |
| Stability | Beta | Pre-release | Tie |
| Components | 12 | 2+ (growing) | naked_ui |
| Production ready | ❌ | ❌ | Tie |

---

## Когда выбрать naked_ui

- Быстрый прототип с headless
- Один проект, один бренд
- Простой визуал без preset системы
- Уже используете Mix

## Когда выбрать Headless

- Multi-brand / white-label продукт
- Design system с preset'ами
- Type-safe exhaustive patterns
- Token-based theming
- Enterprise-grade accessibility

---

## Оценка

| Критерий | Оценка |
|----------|:------:|
| Headless | 10 |
| Type-safety | 7 |
| Theming | 2 |
| Документация | 6 |
| Готовность | 6 |
| **Итого** | **6.3** |

---

## Вывод

naked_ui — **отличный headless конкурент** с простым API. Главное отличие Headless:

1. **Capability pattern** vs Builder — лучшее переиспользование
2. **Preset system** — multi-brand из коробки
3. **Token resolution** — отделение visual tokens от rendering
4. **Per-instance overrides** — type-safe кастомизация
5. **Overlay lifecycle contract** — предсказуемые анимации

naked_ui проще начать, Headless масштабируется лучше.
