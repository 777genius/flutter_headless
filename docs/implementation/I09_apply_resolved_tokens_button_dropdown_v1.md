## I09 — Протянуть расширенные RenderRequest в Button/Dropdown + закрыть conformance gaps (Variant B)

### Цель

Сделать так, чтобы `headless_button` и `headless_dropdown_button`:
- реально формировали “полный” RenderRequest (как в `V1_DECISIONS 0.1`),
- брали `resolvedTokens` через token resolver capabilities,
- не ломали headless separation,
- и были готовы к будущим default renderers (отдельная итерация будет согласована позже).

Параллельно закрываем “дырки” conformance, которые блокируют external adoption.

### Ссылки

- `docs/implementation/I08_token_resolution_and_render_requests_v1.md`
- `docs/V1_DECISIONS.md`:
  - `0.1 Renderer contracts`
  - `0.3 Listbox` (looping/wrap-around policy)
  - `0.4 State Resolution` (HeadlessWidgetStateMap как механизм tokens)
- `docs/CONFORMANCE.md`:
  - 1.4 overlay/listbox invariants (если применимо)
  - 4) `CONFORMANCE_REPORT.md` MUST (если пакет заявляет “passes conformance”)

---

## Что делаем

### 1) Button: обновить `RTextButton` → полный request (и без double-invoke)

#### 1.1 Semantics
Сейчас semantics живёт как wrapper в компоненте. В Variant B:
- в request добавляем `RButtonSemantics` (value object), чтобы renderer мог корректно выставить label/hints в своём дереве.
- но правило остаётся: **мы не добавляем Semantics(onTap)**, чтобы не получать double invoke.

Решение v1:
- `RTextButton` оставляет `Semantics(button: true, enabled: ...)` как внешний слой,
- в request даём `semanticLabel` и `isEnabled` чтобы renderer мог использовать (например, tooltip/aria label).

#### 1.2 Callbacks
В request добавить:
- `RButtonCallbacks(onPressed: VoidCallback?)` или аналог, но использовать только для визуальных частей (Ink/hover).

Правило:
- компонент остаётся источником `_activate()`.
- renderer **не должен** сам вызывать `onPressed` на pointer/key (иначе двойной вызов).

#### 1.3 ResolvedTokens
В build:
- получить `RButtonTokenResolver` capability
- собрать `Set<WidgetState>` из состояния
- вычислить `resolvedTokens`
- положить в request

#### 1.4 Constraints
В request добавить constraints минимум hit target (например 44x44 или политика из docs). В v1 можно захардкодить политику на стороне компонента как value object (без визуала).

#### 1.5 Тесты
Добавить в `headless_button/test/*`:
- что renderer получил non-null `resolvedTokens`
- что разные состояния дают разные tokens (через test resolver)

---

### 2) Dropdown: расширить request + привести навигацию к listbox invariants

**Dropdown renderer/resolver contracts v1 — non-generic by design.**
`RDropdownButton<T>` хранит `T` и делает mapping `value ↔ index`. Renderer работает только с UI item‑моделью (без `T`).

#### 2.1 Value↔Index Mapping (компонент)
- Компонент maps `items + HeadlessItemAdapter<T>` → `HeadlessListItemModel`
- Компонент maps `selectedValue` → `selectedId` → `selectedIndex` для renderer
- Компонент maps `onSelectIndex(index)` → `onChanged(value)` callback

#### 2.2 ResolvedTokens
Dropdown получает токены отдельно для trigger/menu/item (из I08).
- Token resolver capability опциональна
- Если resolver отсутствует — `resolvedTokens == null`, renderer uses defaults

#### 2.3 Constraints
Передать constraints для trigger и menu (минимальные размеры/макс высота меню).

#### 2.4 Wrap-around (looping)
Если dropdown не использует foundation listbox primitives напрямую, он всё равно MUST соблюдать их инварианты.

Сделать:
- ArrowDown на последнем enabled → first enabled
- ArrowUp на первом enabled → last enabled

Тонкие моменты:
- wrap-around должен пропускать disabled
- если enabled items нет вообще — навигация no-op

#### 2.5 State Resolution (уточнение)
Компонент может хранить bool/индексы; HeadlessWidgetStateMap обязателен для token resolution, не для внутренней модели.

#### 2.6 Conformance gaps
- добавить `CONFORMANCE_REPORT.md` в `headless_dropdown_button` (или README секцию)
- расширить `LLM.txt` (Purpose/Non-goals/Invariants/Correct usage/Anti-patterns) с обязательными инвариантами:
  - highlighted ≠ selected
  - disabled items не выбираются/пропускаются
  - looping включён (wrap-around)
  - focus restore на trigger после close
  - close contract: `close()`→`closing`, `completeClose()`→`closed`
  - **renderer contract non-generic**: selection/index mapping lives in component

#### 2.7 Тесты
Добавить/обновить:
- wrap-around tests (Down на последнем / Up на первом)
- tests что wrap-around пропускает disabled
- tests что request содержит `resolvedTokens` и `constraints`
- **resolver отсутствует → `resolvedTokens == null` → renderer defaults** (не ошибка)

---

## Артефакты итерации

- `headless_button`:
  - обновлённый `RTextButton` (полный request)
  - тесты на tokens flow
- `headless_dropdown_button`:
  - wrap-around
  - полный request + tokens flow
  - `CONFORMANCE_REPORT.md`
  - расширенный `LLM.txt`

---

## Критерии готовности (DoD)

- Button и Dropdown компилируются и тесты проходят.
- RenderRequest в обоих компонентах содержит `resolvedTokens` и `constraints`.
- Dropdown navigation соответствует listbox spec (looping default on).
- Conformance report добавлен (dropdown).

---

## Чеклист

- [ ] Button: request расширен (semantics/callbacks/resolvedTokens/constraints).
- [ ] Button: token resolver используется, есть тесты.
- [ ] Dropdown: request расширен (semantics/resolvedTokens/constraints).
- [ ] Dropdown: wrap-around реализован + тесты.
- [ ] Dropdown: `CONFORMANCE_REPORT.md` добавлен (или README секция).
- [ ] Dropdown: `LLM.txt` расширен инвариантами.

