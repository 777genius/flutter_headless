## I23 (часть 3) — Foundation: `HeadlessItemAdapter<T>`, typeahead, `ListboxController.setMetas`

### 4) `HeadlessItemAdapter<T>` (без forced-null)

Цель: DRY mapping домена → item‑модель без API вида `trailing: (_) => null`.

API (vNext):

- `HeadlessItemAdapter<T>({...})`:
  - обязательные: `ListboxItemId Function(T) id`, `String Function(T) primaryText`
  - optional:
    - `bool Function(T)? isDisabled`
    - `String Function(T)? semanticsLabel`
    - `String Function(T)? searchText` (если нужно богаче для typeahead)
    - `HeadlessContent Function(T)? leading`
    - `HeadlessContent Function(T)? title`
    - `HeadlessContent Function(T)? subtitle`
    - `HeadlessContent Function(T)? trailing`
    - `HeadlessItemFeatures Function(T)? features`

- `HeadlessItemAdapter.simple<T>(...)` (для 90% кейсов):
  - `id`
  - `titleText`
  - optional `subtitleText`, `leadingEmoji`, `semanticsLabel`, `searchText`, `features`, `isDisabled`

Правило typeahead:

- `typeaheadLabel = HeadlessTypeaheadLabel.normalize(searchText ?? primaryText)`

Чтобы не размазывать “как мы нормализуем строку” по компонентам, вводим маленький helper в foundation:

```dart
final class HeadlessTypeaheadLabel {
  static String normalize(String raw) {
    // vNext minimum:
    // - trim
    // - collapse whitespace
    // - toLowerCase
    // (опционально: убрать дефисы/пробелы в телефонных кодах — только если нужно и единообразно)
  }
}
```

Файлы:
- `packages/headless_foundation/lib/src/listbox/typeahead_label.dart`
- `packages/headless_foundation/lib/src/listbox/headless_item_adapter.dart`

---

### 5) Интеграция с текущим `ListboxController`

Сейчас удобный путь `ListboxController.setItems(List<ListboxItem>)` строит `typeaheadLabel` из `item.label.toLowerCase()`, а `ListboxItem` содержит только `label`.
Для `HeadlessListItemModel` нужен `typeaheadLabel` (и он уже computed/known).

Решение (рекомендуемое, аддитивно):

- добавить в `ListboxController` новый convenience‑метод:

```dart
void setMetas(List<ListboxItemMeta> metas)
```

который:
- очищает registry,
- регистрирует metas в исходном порядке,
- нормализует `highlightedId/selectedId` как сейчас.

Компоненты (`DropdownButton`, будущий `Select`) будут передавать metas напрямую:

- `ListboxItemMeta(id: item.id, isDisabled: item.isDisabled, typeaheadLabel: item.typeaheadLabel)`

Это сохраняет SRP: listbox отвечает за механику, компонент — за mapping.

