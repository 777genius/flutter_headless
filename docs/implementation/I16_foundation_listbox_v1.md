## I16 — Foundation v1: Listbox (registry + navigation + typeahead) as a shared mechanism

### Цель

Сделать второй критический “кирпич” фундамента после overlay: **Listbox** — общую механику для menu‑паттернов:

- Dropdown
- Select / Combobox
- Autocomplete меню
- Context menu / Menu

Так мы предотвращаем дрейф поведения (особенно keyboard/typeahead), уменьшаем копипасту и повышаем conformance.

Ссылка на требования: `docs/V1_DECISIONS.md` → “Listbox keyboard + typeahead spec v1”.

### Почему это must для масштаба

Если listbox‑логика живёт внутри каждого компонента, то при росте получаем:

- разные правила loop/skip disabled,
- разные таймауты typeahead,
- разные инварианты selection/highlight,
- сложные баги “в одном компоненте работает, в другом нет”.

Listbox — это “domain mechanism” (поведение), поэтому он должен жить в `headless_foundation`.

### Решение (DDD / Clean Architecture / SOLID)

#### Bounded Context: Listbox

Сущности/термины:

- **Item**: `id`, `label`, `disabled`
- **Highlighted**: текущий item под навигацией (keyboard)
- **Selected**: выбранный item (может отличаться от highlighted)
- **Typeahead**: буфер ввода символов + поиск следующего совпадения по `label`

Инварианты v1:

- highlighted всегда указывает на **enabled** item (если есть enabled items)
- disabled items пропускаются при навигации/selection
- looping (wrap-around) включён по умолчанию (policy)
- typeahead:
  - собирает буфер
  - timeout ~500ms (policy)
  - поиск идёт от текущей позиции вперёд, затем wrap

#### Пакет/слой

`packages/headless_foundation/lib/src/listbox/*`

SRP разбиение:

- `ListboxItem` (value object)
- `ListboxState` (immutable state)
- `ListboxNavigationPolicy` + чистые функции “next/prev/first/last enabled”
- `ListboxTypeahead` (буфер + timeout)
- `ListboxController` (координация state + API для компонентов)

Важно: foundation не знает про конкретный UI, overlay, или renderer.

### Public API (v1 минимум)

`ListboxController`:

- `setItems(List<ListboxItem> items)` — обновить список items
- `ValueListenable<ListboxState> state` — наблюдение (без forcing rebuild всего дерева)
- `highlightFirst/Last/Next/Previous()`
- `selectHighlighted()` / `selectById(ListboxItemId)`
- `resetTypeahead()` / `handleTypeahead(String char)`

Policies:

- `looping` (default true)
- `typeaheadTimeout` (default 500ms)

### Интеграция в Dropdown (миграция без регрессий)

В `headless_dropdown_button`:

- `DropdownSelectionController` становится thin wrapper над `ListboxController`
  - хранит маппинг index ↔ id (id можно строить из index)
  - сохраняет текущие public hooks, чтобы не ломать компонентный API

### Тесты

`packages/headless_foundation/test/listbox_*_test.dart`:

- next/prev skips disabled + looping
- home/end to first/last enabled
- typeahead: buffer, timeout, wrap search
- selectHighlighted не выбирает disabled

Dropdown tests должны остаться зелёными (проверка отсутствия регрессий).

### Команды

```bash
melos run analyze
melos run test
```

