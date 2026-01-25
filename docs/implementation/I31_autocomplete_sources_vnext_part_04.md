## I31 — Autocomplete vNext: Local/Remote/Hybrid sources + RequestFeatures (part 4 — Тесты/миграция/DoD)

Back: [Index](./I31_autocomplete_sources_vnext.md)

### Цель этой части

Сделать план готовым к “топ уровню реализации”:

- перечислить breaking changes,
- описать тестовую матрицу (unit/widget/conformance),
- дать Definition of Done.

---

## 1) Breaking changes (публичные)

### 1.1) `RAutocomplete` API

Было:

- `optionsBuilder: Iterable<T> Function(TextEditingValue)`

Станет:

- `source: RAutocompleteSource<T>`

Причина: source-first API делает local/remote/hybrid очевидным и расширяемым.

### 1.2) Contracts: `RDropdownRenderRequest`

Добавляется:

- `features: HeadlessRequestFeatures` (non-null, default empty)

Это breaking для всех мест, где создаётся render request (presets, тесты).

---

## 2) Изменения по пакетам (чтобы реализация не расползлась)

### `headless_foundation`

- добавить `HeadlessRequestFeatures`
- добавить `HeadlessFeatureKey<T>` (+ alias/deprecate для старого `HeadlessItemKey<T>`)
- добавить `HeadlessItemFeatures.merge(...)` (для композиции source/section поверх adapter features)
- экспортировать через публичный entrypoint (MUST)

### `headless_contracts`

- протянуть `features` в `RDropdownRenderRequest` и оба сабкласса (trigger/menu)
- обновить slot contexts (MUST минимум):
  - `RDropdownMenuContext.features`
  - `RDropdownMenuSurfaceContext.features`

### `headless_material` / `headless_cupertino`

- обновить создание `RDropdown*RenderRequest` (передать `features`)
- обновить `emptyState` slot поведение (опционально) — научиться читать request features и показывать:
  - loading
  - error + retry
  - “type to search”
  - “no results”
- hybrid UX: при `remote.status == loading` и `items.isNotEmpty` показывать индикатор через `menuSurface` (если preset хочет)

### `components/headless_autocomplete`

- внедрить `RAutocompleteSource` и remote state machine
- маркировать item’ы `source/section` через merged features
- заполнять request features (remote state) при сборке `RDropdownMenuRenderRequest`

---

## 3) Тестовая стратегия (MUST)

### 3.1) Unit tests (logic)

Фокус на “тонких” местах:

- remote request гонки:
  - два запроса подряд, второй быстрее → принимаем только второй
- debounce:
  - быстрый ввод “a”→“ab”→“abc” → один реальный load
- minQueryLength:
  - до порога remote не стартует
- backspace/clear ниже minQueryLength:
  - remote становится idle, stale remote результаты не показываем
- keepPreviousResultsWhileLoading:
  - во время loading itemsRemote остаются последними успешными (если policy=true)
- combine/dedupe:
  - collision id: preferLocal/preferRemote
- IME:
  - composing не стартует remote load

### 3.2) Widget tests (`components/headless_autocomplete/test`)

Добавить сценарии:

#### Remote-only

- open menu, ввод текста → remote loading state попадает в request.features
- success: items появляются
- error: emptyState показывает error (через slot) + retry вызывает новый load

#### Hybrid

- local items видны сразу (без ожидания)
- remote section появляется позже
- dedupe работает детерминированно
- remote minQueryLength влияет только на remote
- порядок: local секция всегда выше remote (если showSections=true)

#### Регрессии поведения v1.6

Все существующие тесты (selection sync, dismissed policy, IME guards) должны остаться зелёными.

### 3.3) Conformance (SLA)

Минимум:

- a11y SLA на root textField + expanded state как в `I29`
- overlay close contract не ломаем

Важно: conformance tests не должны зависеть от реального backend.

---

## 4) Миграция в коде (порядок PR’ов)

### PR1 — Foundation + Contracts

- `HeadlessRequestFeatures`
- `HeadlessItemFeatures.merge`
- `RDropdownRenderRequest.features`
- обновление пресетов и их тестов

Критерий: `melos run analyze` и `melos run test` зелёные.

### PR2 — Autocomplete vNext API (source-first)

- заменить `optionsBuilder` на `source`
- поддержать `local` через адаптацию старого поведения
- добавить remote skeleton (state machine + requestId + minQueryLength semantics)

### PR3 — Hybrid + UX polish

- combine policy + sections + dedupe
- emptyState UI в preset’ах (loading/error/empty)
- тесты remote/hybrid

---

## 5) Definition of Done (DoD)

- [ ] `RAutocomplete` использует `source:` и имеет три режима: local/remote/hybrid.
- [ ] Remote корректно обрабатывает гонки (requestId) и debounce.
- [ ] Hybrid маркирует item’ы как local/remote + sectionId через merged features.
- [ ] `RDropdownRenderRequest` имеет `features` и пресеты не ломаются.
- [ ] `emptyState` slot в пресетах может отрисовать loading/error/empty на базе request features.
- [ ] В примерах/доках нет “кастов” и скрытых трюков: hybrid создаётся через `RAutocompleteLocalSource/RAutocompleteRemoteSource` напрямую.
- [ ] Все существующие тесты для `headless_autocomplete` проходят.
- [ ] Добавлены новые тесты на remote/hybrid (см. выше).
- [ ] После изменений выполнено:

```bash
melos run analyze
melos run test
```

