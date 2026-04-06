## I07 — Reference component: DropdownButton (overlay + listbox + keyboard)

### Цель

Проверить, что фундаментальные механизмы реально работают в бою:
- overlay lifecycle (closing + completeClose + fail-safe),
- listbox navigation/typeahead,
- focus policies,
- parts/slots для кастомизации структуры,
- тестируемость поведения.

### Ссылки на требования

- Dropdown state model: `docs/V1_DECISIONS.md` → “Dropdown state model v1”
- Overlay: `docs/V1_DECISIONS.md` → “0.2 Overlay”
- Listbox: `docs/V1_DECISIONS.md` → “0.3 Listbox”
- State resolution: `docs/V1_DECISIONS.md` → “0.4 State Resolution”
- Conformance: `docs/CONFORMANCE.md`
- “DropdownButton не зависит от Dialog”: `docs/ARCHITECTURE.md` → “Кейс 2: DropdownButton хочет Dialog/Overlay”

### Что делаем

#### 1) Domain

Минимум:
- `ListboxItemId` / `DropdownItemId` (типизированный id)
- `ItemMeta` (label, disabled, etc.)
- `DropdownState<T>`:
  - `isOpen`
  - `selectedId/selectedValue` (selection)
  - `highlightedId` (highlighted ≠ selected, см. `docs/ARCHITECTURE.md` glossary)

Тонкие моменты:
- `highlighted` и `selected` не смешиваем (иначе keyboard UX ломается).
- disabled item не может быть выбран и не должен “залипать” как highlighted.

#### 2) Presentation

API v1 (минимум):
- `RDropdownButton<T>`:
  - `value` / `onChanged`
  - `items` (list of metas + values)
  - optional `controller` (open/highlight)
  - `disabled` (или `onChanged == null`)

Keyboard-only сценарии (минимум, MUST для conformance):
- **Открытие**:
  - `Enter` / `Space` на trigger → open
  - `ArrowDown` на trigger → open (опционально, но желательно)
- **Навигация внутри меню**:
  - `ArrowDown/ArrowUp` → изменяет `highlightedId` (пропуская disabled)
  - `Home/End` (опционально v1) → прыгнуть в начало/конец
  - **Typeahead**: ввод букв → highlight следующий item с совпадением (MVP)
    - v1 ограничения: только `[a-zA-Z0-9]`, только `startsWith`, нет циклического перебора одной буквой
- **Выбор**:
  - `Enter` / `Space` → select highlighted и закрыть
- **Закрытие**:
  - `Escape` → close без изменения selection
  - Tab/Shift+Tab поведение: не “ломаем” фокус (точная политика зависит от focus policy v1)

A11y/Semantics:
- trigger имеет role/button и объявляет “expanded” (если применимо).
- меню объявлено как listbox/menu (конкретный mapping в v1 фиксируем в renderer contracts).
- items объявлены как option/menuitem (с disabled/selected/active(descendant)/highlighted).

Тонкие моменты:
- события не должны “протекать” (например, Enter не должен одновременно закрыть и повторно открыть).
- focus restore: после закрытия фокус возвращается на trigger (POLA), если не задано иначе.

#### 3) Overlay integration (foundation)

Открытие:
- `OverlayController.show(...)` возвращает handle
- фаза lifecycle: `opening -> open`

Закрытие:
- `close()` переводит в `closing`
- renderer меню обязан вызвать `completeClose()` после exit (или немедленно, если анимаций нет)
- fail-safe таймаут должен предотвратить вечный `closing`

Dismiss:
- outside tap (по policy) закрывает меню
- `Escape` закрывает меню

Тонкие моменты:
- outside tap не должен кликать underlying UI (нужна “absorb” политика).
- если trigger повторно нажали во время `closing` — поведение должно быть предсказуемым (обычно: игнор или re-open после closed).

#### 4) Renderer + slots

Минимум слотов (типизированно):
- `anchor` (trigger)
- `menu`
- `item`
- `menuSurface`

Слоты: Replace/Decorate (см. `docs/V1_DECISIONS.md`).

Тонкие моменты:
- slots должны быть **опциональными** (POLA).
- Replace может игнорировать default — это ожидаемая семантика, но контекст должен быть достаточным (callbacks/state).

#### 5) Тесты (обязательные)

Минимум для conformance (см. `docs/CONFORMANCE.md`):
- keyboard-only end-to-end:
  - open → navigate → select → close
- focus restore:
  - после close фокус на trigger
- semantics:
  - trigger expanded state + disabled state
- overlay lifecycle:
  - `close()` → `closing`
  - `completeClose()` → `closed`
  - fail-safe работает

Тонкие моменты:
- отдельный тест: `Escape` закрывает без изменения selection.
- отдельный тест: disabled item пропускается навигацией и не выбирается.

### Артефакты итерации (что должно появиться в git)

- foundation listbox primitives (минимум для highlightedId/typeahead), если их ещё нет
- overlay MVP (если не сделан в I03)
- renderer contracts для dropdown + slots
- тесты в `packages/components/headless_dropdown_button/test/*`
- пример в `apps/example`

### Что НЕ делаем

- Не делаем combobox/search/query (это отдельный компонент/итерация).
- Не пытаемся сразу “идеальный positioning” (только достаточный для примера).

### Критерии готовности (DoD)

- Dropdown работает в `apps/example` с простым renderer’ом.
- Overlay lifecycle соблюдён и тестами подтверждён.
- Есть conformance-тесты на keyboard/focus/semantics.

### Диагностика (тонкие баги)

- “highlight == selected”:
  - значит мы перепутали навигацию и выбор; исправлять модель, а не костылить в UI.
- меню закрывается, но subtree исчезает мгновенно:
  - значит close contract нарушен (нет closing phase / completeClose).
- после закрытия фокус уходит “в никуда”:
  - значит focus restore policy не сработала; исправлять в foundation overlay/focus.

### Чеклист

- [x] controlled selection работает (value/onChanged)
- [x] overlay lifecycle базовый (open/close, fail-safe в foundation)
- [x] listbox navigation/typeahead — keyboard nav работает (24/24 tests passing)
- [x] slots typed + Replace/Decorate/Enhance
- [x] тесты: все 24 теста проходят

### I07.1 — Решённые проблемы (keyboard navigation)

Выявленные и исправленные проблемы:

1. **Focus transfer trigger→menu в overlay**:
   - Проблема: autofocus/requestFocus работал непредсказуемо между разными частями widget tree
   - Решение: Dropdown создаёт и владеет FocusNode для меню, вызывает requestFocus() через post-frame callback после mount overlay

2. **ValueNotifier lifecycle**:
   - Проблема: menu в overlay держал reference на notifier, который мог быть disposed раньше
   - Решение: Notifier создаётся per-session (при открытии), dispose откладывается на post-frame после закрытия overlay

3. **AnchoredOverlayEngineHost widget tree stability** (корневая проблема):
   - Проблема: AnchoredOverlayEngineHost.build() условно оборачивал в Shortcuts/Actions/Focus только когда hasActiveOverlays=true, что меняло структуру дерева и пересоздавало dropdown state
   - Решение: AnchoredOverlayEngineHost теперь всегда оборачивает в одинаковую структуру (Shortcuts→Actions→Focus→Stack), только shortcuts/actions пустые когда нет overlay'ев

4. **didUpdateWidget setState during build**:
   - Проблема: _closeMenu() вызывался из didUpdateWidget, что вызывало notification во время build phase
   - Решение: Закрытие откладывается на post-frame callback

