## I31 — Autocomplete vNext: Local/Remote/Hybrid sources + RequestFeatures (part 2 — Contracts/Foundation изменения)

Back: [Index](./I31_autocomplete_sources_vnext.md)

### Цель этой части

Зафиксировать изменения в слоях `foundation` и `contracts`, чтобы:

- статусы данных (loading/error/…​) передавались renderer’ам **типобезопасно**;
- это не смешивалось с `RenderOverrides`;
- можно было явно маркировать item’ы как `local/remote` и (опционально) “секция”.

---

## 1) HeadlessRequestFeatures: typed features на уровне render request

### Почему нельзя через `RenderOverrides`

`RenderOverrides` по смыслу — “per-instance preset customization”.  
`loading/error/query/source` — это **данные/состояние**, а не “визуальная настройка”.

Плюс, у вас есть guardrail на “unconsumed overrides”: статусные типы в overrides будут создавать шум и заставлять пресеты “потреблять” их искусственно.

### Новая модель (foundation)

Добавляем в `headless_foundation`:

- `HeadlessRequestFeatures` — аналог `HeadlessItemFeatures`, но для запросов рендера.

### Ключи features: НЕ `HeadlessItemKey` (слишком item-специфично)

Чтобы термины были очевидны, вводим общий ключ:

- `HeadlessFeatureKey<T>`

И используем его и для item, и для request features.

Политика:

- `HeadlessItemKey<T>` становится `typedef HeadlessItemKey<T> = HeadlessFeatureKey<T>;`
  - (или deprecated wrapper) чтобы не ломать существующие места сразу
- в новых местах (request features и новые ключи autocomplete) используем **только** `HeadlessFeatureKey`.

Расположение:

- `packages/headless_foundation/lib/src/features/`
  - `headless_feature_key.dart`
  - `headless_item_features.dart` (переэкспорт/alias ключа)
  - `headless_request_features.dart`

API:

```dart
@immutable
final class HeadlessRequestFeatures {
  const HeadlessRequestFeatures._(this._values);
  static const empty = HeadlessRequestFeatures._(<Symbol, Object>{});
  final Map<Symbol, Object> _values;

  bool get isEmpty => _values.isEmpty;
  T? get<T>(HeadlessFeatureKey<T> key) => ...

  static HeadlessRequestFeatures build(
    void Function(HeadlessRequestFeaturesBuilder b) build,
  ) => ...
}
```

---

## 2) Contracts: добавить `features` в `RDropdownRenderRequest`

### Изменение контракта

В `headless_contracts`:

- `RDropdownRenderRequest` получает новое поле:
  - `final HeadlessRequestFeatures features;`

Политика:

- поле **не nullable**, дефолт: `HeadlessRequestFeatures.empty`
- это позволит пресетам не делать лишних null-checks

Причина: `RDropdownMenuRenderRequest` используется `RAutocomplete` для меню, и нам нужно туда доставлять remote state.

Файл:

- `packages/headless_contracts/lib/src/renderers/dropdown/r_dropdown_request.dart`

Замечание: формально это breaking для всех мест, где создаётся `RDropdown*RenderRequest`. Это ожидаемо и приемлемо для vNext.

---

## 3) Item-level признаки: local/remote/section через `HeadlessItemFeatures`

### 3.1) Ключи features (autocomplete layer)

В `components/headless_autocomplete` вводим ключи:

- `RAutocompleteItemSource` (enum: local/remote)
- `RAutocompleteSectionId` (value object / enum / string wrapper)

Ключи:

```dart
const rAutocompleteItemSourceKey =
    HeadlessFeatureKey<RAutocompleteItemSource>(#rAutocompleteItemSource);

const rAutocompleteSectionIdKey =
    HeadlessFeatureKey<RAutocompleteSectionId>(#rAutocompleteSectionId);
```

Эти ключи живут в пакете autocomplete, а не в contracts: это не “универсальная” вещь для всех компонентов.

### 3.2) Нужно уметь добавлять features к уже существующим features адаптера

`HeadlessListItemModel` уже содержит `features`, которые может дать `HeadlessItemAdapter.features`.
Нам нужно поверх этого добавить `source/section`, не ломая SRP адаптера и не теряя пользовательские features.

Поэтому в `headless_foundation` добавляем **операцию merge** для features:

```dart
extension HeadlessItemFeaturesX on HeadlessItemFeatures {
  HeadlessItemFeatures merge(HeadlessItemFeatures other);
}
```

Политика merge:

- если ключи не пересекаются → объединяем
- если пересекаются и тип совпадает → `other` перезаписывает `this`
- если тип не совпадает → assert в debug (чтобы не было скрытых багов)

Это минимальное расширение, которое делает features реально пригодными для композиции компонентов.

---

## 4) Request-level признаки для remote состояния (в autocomplete)

### Ключ request features

В `components/headless_autocomplete`:

- `RAutocompleteRemoteStateFeature` — value object, который описывает состояние remote части на момент рендера меню.

```dart
const rAutocompleteRemoteStateKey =
    HeadlessFeatureKey<RAutocompleteRemoteState>(#rAutocompleteRemoteState);
```

`RAutocompleteRemoteState` (пример состава):

- `status: idle/loading/ready/error`
- `queryText`
- `errorKind` (если нужно типизировать) или `message` (без StackTrace в UI)
- `canRetry`
- `isStale` (показываем ли stale результаты)

Почему request-level, а не item-level:

- loading/error относится к “списку как целому”, а не к конкретному item’у.

---

## 5) Slots/preset поведение (как это использовать в UI)

Канонический UI hook — уже существующий:

- `RDropdownButtonSlots.emptyState`

В preset’ах (Material/Cupertino):

1) Если `request.items.isNotEmpty` — рендерим список как обычно.
2) Если `request.items.isEmpty` — вызываем `emptyState` slot, но slot может смотреть на:
   - `request.features.get(rAutocompleteRemoteStateKey)`
   - и понимать: это “loading” / “error” / “no results” / “type to search”.

Важно: это не требует новых renderer контрактов.

### Критическая правка: slot contexts должны видеть `features`

Сейчас `RDropdownMenuContext` (и другие slot contexts) не содержат `overrides/tokens/features`.
Значит “slot читает request.features” невозможно без изменения контракта слотов.

Поэтому в этой итерации фиксируем изменение contracts:

- добавить `HeadlessRequestFeatures features` в:
  - `RDropdownMenuContext`
  - `RDropdownMenuSurfaceContext`
  - (опционально) `RDropdownAnchorContext` и item contexts — чтобы декорировать и trigger, если нужно

Минимум MUST для Autocomplete:

- `emptyState` slot получает `RDropdownMenuContext.features`
- `menuSurface` slot получает `RDropdownMenuSurfaceContext.features`

Тогда:

- emptyState может показать “loading/error/…” в пустом списке
- menuSurface может показать индикатор remote loading даже когда список не пустой (hybrid UX)

### Важно про секции (без “header items”)

Мы НЕ добавляем “разделители” как отдельные `HeadlessListItemModel`, иначе:

- listbox/typeahead ломаются (это не реальные опции),
- появляются сложности с highlight/selection.

Секции делаются полностью на стороне renderer’а:

- item’ы помечены `sectionId`
- renderer группирует и рисует заголовки как decoration.

---

## 6) Backward compatibility (не делаем)

Итерация намеренно breaking:

- `RAutocomplete.optionsBuilder` удаляется/заменяется на `source:`.
- `RDropdownRenderRequest` меняется (добавляется features).

Зато итоговая архитектура становится очевидной и расширяемой.

