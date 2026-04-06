## V1 Decisions (зафиксировано перед реализацией) (part 6)

Back: [Index](../V1_DECISIONS.md)

## Bounded Contexts (DDD) — v1

Headless использует принципы Domain-Driven Design для чёткого разделения ответственности.

### Button Context

| Тип | Элементы |
|-----|----------|
| **Entities** | `ButtonState` (pressed, hovered, focused, disabled) |
| **Domain Events** | `Pressed`, `Released` |
| **Value Objects** | `ButtonSpec` (variant, size) |
| **Invariants** | Button не может быть pressed и disabled одновременно |

### Menu/Listbox Context

| Тип | Элементы |
|-----|----------|
| **Entities** | `MenuState` (open, closed, closing), `ListboxState` |
| **Domain Events** | `MenuOpened`, `ItemHighlighted`, `ItemSelected`, `MenuClosed` |
| **Value Objects** | `ListboxItemMeta` (id, label, disabled) |
| **Invariants** | Только один item может быть highlighted в любой момент |

### Overlay Context

| Тип | Элементы |
|-----|----------|
| **Entities** | `OverlayEntry` (phase, anchor, placement) |
| **Domain Events** | `OverlayOpened`, `OverlayClosing`, `OverlayClosed` |
| **Value Objects** | `OverlayAnchor`, `FocusPolicy`, `DismissPolicy` |
| **Invariants** | Overlay должен завершить close в пределах fail-safe timeout |

### Interaction Context

| Тип | Элементы |
|-----|----------|
| **Entities** | `InteractionController` |
| **Domain Events** | `PressStart`, `PressEnd`, `PressCancel`, `HoverEnter`, `HoverExit` |
| **Value Objects** | `PointerType`, `WidgetStateSet` |
| **Invariants** | pointer type определяет поведение feedback |

### Ubiquitous Language (единый словарь)

| Термин | Значение | Где используется |
|--------|----------|------------------|
| **highlighted** | Визуально подсвечен (keyboard nav) | Listbox, Menu |
| **selected** | Выбран (controlled state) | Select, Dropdown |
| **pressed** | Нажат (pointer down, Space/Enter) | Button, MenuItem |
| **focused** | Имеет keyboard focus | Все интерактивные |
| **closing** | Exit-анимация идёт | Overlay |
| **disabled** | Неактивен (не реагирует на input) | Все |

**Инвариант:** `highlighted` ≠ `selected`. Highlight — временное визуальное состояние при навигации, selection — выбранное значение.

### Domain Layer Invariants (Clean Architecture)

**Что входит в domain слой компонента:**
- `specs/` — value objects (`ButtonSpec`, `DropdownButtonSpec`)
- `variants/` — sealed classes для полиморфизма (`ButtonVariant`, `ButtonSize`)
- `events/` — sealed domain events (`ButtonPressed`, `ItemSelected`)

**Что входит в application слой:**
- `state/` — immutable application state (`ButtonState`, `DropdownButtonState`)
- `reducers/` — pure functions `reduce(state, event) -> (state, effects)`

**Почему state не в domain:**
- State — это Application concern, не Domain
- Domain содержит только "что произошло" (events) и "что это" (value objects)
- State содержит "текущее положение дел" для UI

**Что НЕ входит в domain/application:**
- Flutter widgets (`Widget`, `BuildContext`)
- Flutter rendering types (`Color`, `TextStyle`) — используем semantic tokens
- Rendering logic

**Compile-time check:**
```bash
# Domain и Application файлы НЕ импортят package:flutter/*
# Только dart:* и package:meta
grep -r "package:flutter" packages/*/lib/src/domain/
grep -r "package:flutter" packages/*/lib/src/application/
# Должны вернуть пустой результат
```

**Пример структуры пакета (обновлено):**
```
packages/components/headless_button/lib/src/
├── domain/
│   ├── button_spec.dart       # ButtonSpec, ButtonVariant, ButtonSize (value objects)
│   └── button_events.dart     # sealed ButtonEvent (domain events)
├── application/
│   ├── button_state.dart      # ButtonState (immutable application state)
│   └── button_reducer.dart    # reduce(state, event) -> (state, effects)
├── presentation/
│   └── r_text_button.dart     # RTextButton widget
└── infra/
    └── button_theme_adapter.dart  # Glue to theme
```

**Инварианты:**
- Domain layer — portable, testable без Flutter, содержит только events и value objects
- Application layer — testable без Flutter, содержит state и business logic
- Presentation layer — зависит от Flutter, содержит widgets

---

## Resolved questions (зафиксировано)

### A) “headless_menu” как отдельный пакет (для переиспользования в Dropdown/Autocomplete)

**Вариант A1 (строго, по текущим правилам):** Menu как механизмы в `foundation` + renderer contracts в `theme`.  
Компоненты не зависят от компонента Menu.
- **Оценка:** 9/10 (самая чистая архитектура)
- **Риск:** чуть сложнее “собрать” в голове, где лежит Menu.

**Вариант A2 (компромисс):** `headless_menu` как *primitive component package* и **единственное исключение**, от которого могут зависеть другие компоненты.  
Тогда правило “нет component->component” становится “нет component->component, кроме packages/components/headless_menu”.
- **Оценка:** 8/10
- **Риск:** исключения любят разрастаться — нужно жёстко закрепить, что “primitive packages” ограничены списком.

**Вариант A3 (плохо):** разрешить любые component->component зависимости.
- **Оценка:** 4/10

#### Зафиксировано для v1 (выбрано)

**Выбор:** A1 + L1  
`headless_menu` как отдельный компонент‑пакет **не вводим**. Всё menu‑подобное строится через:
- `headless_foundation`: overlay + dismiss/focus + listbox/navigation механизмы
- `headless_contracts`: renderer contracts и slots/parts
- `headless_theme`: capability discovery + overrides + motion/widgets state
- `components/*`: конкретная сборка UX (Dropdown/Autocomplete/Select), но без `component -> component`

**Оценка:** 9/10  
**Почему:** это сохраняет DAG, предсказуемость границ и даёт фундамент без будущих миграций.

### B) Semantic tokens: как именно устроить v1

**Статус:** решено.  
Выбран **W3C-first + Hybrid (S3)**. См. `8.2`.

