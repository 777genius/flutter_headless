## I24 — Autocomplete v1: composable “TextField + Menu” (Flutter-like API) без дублирования логики (part 3)

Back: [Index](./I24_autocomplete_v1.md)

## Порядок реализации (2–3 PR)

### PR1 — Foundation menu primitives + миграция dropdown
- добавить `headless_foundation/src/menu/*`
- мигрировать dropdown overlay lifecycle на primitives (без изменения public API)
- удалить/сжать старый `DropdownOverlayController` до thin wrapper (или полностью заменить)
- regression tests на close contract/keyboard/focus для dropdown

### PR2 — `headless_autocomplete` minimal v1
- новый пакет `components/headless_autocomplete`
- `RAutocomplete<T>`: optionsBuilder + itemAdapter + onSelected
- menu-only request через dropdown renderer contracts + input через textfield renderer contracts
- тесты selection/text sync + keyboard + options

### PR3 — DX polish + example
- `maxOptions`, `openOnFocus/openOnInput`, `readOnly`
- пример в `apps/example` (страны/телефоны) с двумя дизайнами

---

## DoD

- [ ] Есть `RAutocomplete<T>` с Flutter-like API (`optionsBuilder`, `onSelected`, `controller/focusNode`, `initialValue`).
- [ ] Меню рендерится через dropdown contracts (menu-only), без нового меню renderer.
- [ ] Text sync правила фиксированы и протестированы.
- [ ] Open triggers покрыты: focus/input/tap/keyboard; нет re-open thrash после dismiss.
- [ ] Highlight стабилен при изменении options (не “прыгает” без причины).
- [ ] Close contract соблюдён, menu overlay корректно закрывается (closing → completeClose).
- [ ] Реального дублирования overlay/menu lifecycle нет: общие куски в `headless_foundation/menu`.
- [ ] `melos run analyze` и `melos run test` зелёные.

---

## Таблица ответственности (чтобы не расползлось)

| Класс/файл | Ответственность (SRP) | Пакет |
|---|---|---|
| `HeadlessMenuOverlayController` | anchored overlay lifecycle: open/close/completeClose, focus transfer policy, phase | `headless_foundation` |
| `HeadlessMenuAnchor` | value object для anchoring/restoreFocus | `headless_foundation` |
| `ListboxController` + `ListboxItemMeta` | highlight/navigation/typeahead mechanics | `headless_foundation` |
| `HeadlessListItemModel` + `HeadlessItemAdapter<T>` | item anatomy + mapping `T -> model` | `headless_foundation` |
| `RTextFieldRenderer` + `RTextFieldRenderRequest` | contracts для визуала поля (renderer не создаёт EditableText) | `headless_contracts` |
| `RDropdownButtonRenderer` + `RDropdownMenuRenderRequest` | contracts для визуала меню (menu-only usage) | `headless_contracts` |
| `HeadlessThemeProvider` / requireCapability helpers | discovery/guard runtime (доставка capabilities) | `headless_theme` |
| `RAutocomplete<T>` (widget) | orchestration: wiring input+menu, open triggers, keyboard routing, selection↔text sync | `components/headless_autocomplete` |
| `AutocompleteSelectionController` | выбранный id + правила синхронизации с текстом + suppressNextTextChange | `components/headless_autocomplete` |
| `AutocompleteOptionsController` | кеширование optionsBuilder, лимиты, пересбор моделей/метаданных | `components/headless_autocomplete` |
| `RDropdownButton<T>` | orchestration dropdown (pressable trigger + menu) поверх foundation/menu primitives | `components/headless_dropdown_button` |

