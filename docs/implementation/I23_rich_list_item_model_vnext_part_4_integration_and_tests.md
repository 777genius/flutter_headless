## I23 (часть 4) — Интеграция: `headless_theme`/`headless_dropdown_button`/presets/tests/guardrails

## Изменения в `headless_theme` (dropdown contracts)

### 1) RenderRequest

В `packages/headless_theme/lib/src/renderers/dropdown/r_dropdown_request.dart`:

- заменить `final List<RDropdownItem> items;`
- на `final List<HeadlessListItemModel> items;`

`headless_theme` уже зависит от `headless_foundation`, это вписывается в текущий DAG.

### 2) Slot contexts

В `packages/headless_theme/lib/src/renderers/dropdown/r_dropdown_slots.dart`:

- `selectedItem` становится `HeadlessListItemModel?`
- `RDropdownItemContext.item` становится `HeadlessListItemModel`
- `RDropdownItemContentContext.item` становится `HeadlessListItemModel`
- семантика label: `item.semanticsLabel ?? item.primaryText`

### 3) Удаление `RDropdownItem`

В `packages/headless_theme/lib/src/renderers/dropdown/r_dropdown_spec.dart` удалить `RDropdownItem` (breaking OK, pre-release).

---

## Изменения в компоненте `headless_dropdown_button`

### Новый public API (breaking OK)

Golden path:

- `items: List<T>`
- `itemAdapter: HeadlessItemAdapter<T>`

Advanced:

- `options: List<RDropdownOption<T>>` где `RDropdownOption<T>` — публичный value object:

```dart
@immutable
final class RDropdownOption<T> {
  const RDropdownOption({
    required this.value,
    required this.item,
  });

  final T value;
  final HeadlessListItemModel item;
}
```

Файл (компонентный пакет, public API):
- `packages/components/headless_dropdown_button/lib/r_dropdown_option.dart` (и экспорт через entrypoint)

Это сохраняет “component owns generic T”, а theme/renderer видят только non-generic `HeadlessListItemModel`.

### Внутренний mapping и listbox/typeahead

Компонент должен:

- вычислять `selectedId` из `value` через `itemAdapter.id(value)`
- вычислять `selectedIndex` как индекс модели `item.id == selectedId`
- регистрировать listbox metas (через новый `ListboxController.setMetas`) на основе item‑модели:
  - `typeaheadLabel` берём из `item.typeaheadLabel` (а не из `primaryText`)

### Производительность (важно, чтобы не получить “rebuild storm”)

Тонкость: если на каждый build создавать новые модели items “с нуля”, это может:
- мешать сравнению списков,
- увеличивать GC,
- и создавать лишние rebuild в renderer subtree.

Рекомендованный подход vNext:

- хранить “последние вычисленные” модели в `State` и пересобирать только если:
  - изменилась ссылка на список `items` (или длина/ids), или
  - поменялся `itemAdapter` (reference change).

Требование к `itemAdapter`:
- желательно, чтобы он был `const`/immutable и передавался как стабильный объект.

---

## Presets: Material/Cupertino

### Renderer

Material/Cupertino dropdown renderers меняются минимально:

- дефолтный текст триггера/айтема = `item.primaryText` (POLA, без внезапного “богатого” визуала)
- богатую раскладку (флаг/подписи) пользователь делает через slots, т.к. данные теперь доступны в `ctx.item`.

### Token resolver

Token resolvers не зависят от item‑данных → почти без изменений.

---

## Альтернативы, которые сознательно НЕ выбираем

- **Hardcoded fields** (“добавим `dialCode`, `flag`, `subtitle` прямо в контракт”):
  - плохо масштабируется (контракт распухает), нарушает ISP на практике.
- **`Object? payload`**:
  - типы начинают жить “в голове” и в кастах, DX хуже, больше ошибок, сложнее conformance.
- **Сделать renderer generic по `T`**:
  - ломает capability discovery по типу (type identity становится нестабильной),
  - повышает связность и мешает subtree capability overrides.

---

## Тесты и conformance

### 1) `headless_test`

Обновить dropdown conformance suites:

- фикстуры item‑ов создаются как `HeadlessListItemModel`
- добавить проверку “features доступны в slot context” (например `dialCode`), без индексов

### 2) `headless_dropdown_button` tests

Добавить/обновить:

- keyboard/typeahead: matching использует `typeaheadLabel` (пример: `+7`, `ru`)
- semantics: label берётся из `item.semanticsLabel ?? item.primaryText`
- controlled/uncontrolled: selected value ↔ selectedId ↔ selectedIndex не дрейфует

После добавления/изменения тестов прогнать:

```bash
melos run analyze
melos run test
```

---

## Guardrails / запреты

- `HeadlessListItemModel` не содержит `Widget`, `BuildContext`, `TextStyle`, `Color`.
- `HeadlessItemFeatures` не использует строки как ключи в public API (только типизированные `HeadlessItemKey<T>`).
- Renderer не вызывает user callbacks (только commands).

