## I08 — Token Resolution Layer v1: state→tokens + расширенные RenderRequest (Variant B)

### Цель

Убрать несостыковки между реализацией и `docs/V1_DECISIONS.md (0.1 + 0.4 + Token Resolution Layer)` за счёт **реального token-resolution flow**:

- компонент остаётся headless (поведение/состояние/a11y),
- renderer получает **уже-resolved tokens** (не делает resolution),
- `RenderRequest` расширяется до зафиксированной формы (Variant B),
- `constraints` становятся частью контракта (WCAG/min hit target), но остаются опциональными по данным.

### Ссылки

- `docs/V1_DECISIONS.md`:
  - `0.1 Renderer contracts` (форма RenderRequest: `spec/state/semantics/callbacks/slots/tokens/constraints`)
  - `0.4 State Resolution` (`HeadlessWidgetStateMap<T>`, нормализация состояний для token resolution)
  - `Token Resolution Layer` (ownership)
- `docs/ARCHITECTURE.md` → headless separation + context splitting policy
- `docs/CONFORMANCE.md` → раздел 1.4 и 2 (overlay/listbox/tokens при наличии)
- Per-instance кастомизация без раздувания core: `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`

---

## Что делаем

### 1) Ввести типы “resolved tokens” для компонентов (v1 минимум)

Принцип v1:
- `ResolvedTokens` — **маленький** и стабильный набор значений, который renderer реально использует.
- Никаких `Color`/`TextStyle` в `headless_tokens` (это чистые tokens), но `resolved tokens` уже могут быть Flutter-типами — **они принадлежат `headless_contracts`/renderer layer**.

Минимум v1:

#### 1.1 Button
- `RButtonResolvedTokens`:
  - `textStyle` (например `TextStyle`)
  - `foregroundColor`, `backgroundColor`, `borderColor` (например `Color`)
  - `padding`/`minSize` (например `EdgeInsetsGeometry`/`Size`)
  - `cornerRadius` (например `BorderRadius`)

#### 1.2 DropdownButton
- `RDropdownResolvedTokens`:
  - trigger tokens (bg/fg/border/textStyle/minSize/padding/shape)
  - menu surface tokens (bg/border/radius/elevation/constraints)
  - item tokens (highlight bg, selected marker, disabled fg, padding)

Тонкие моменты:
- tokens должны быть разделены на “trigger” vs “menu/item/surface”, чтобы request не разрастался.
- токены должны быть **детерминированны** по `(spec + resolved widget states + platform density)` и не зависеть от build order.

---

### 2) Ввести token resolver capability (в `headless_contracts`)

Renderer не делает resolution. Значит, компоненту нужно получить resolved tokens через capability.

Вариант v1 (рекомендуемый):
- `RButtonTokenResolver` capability:
  - вход: `spec`, `Set<WidgetState>`, `BuildContext`, `constraints?`, `overrides?`
  - выход: `RButtonResolvedTokens`
- `RDropdownTokenResolver` capability (**non-generic by design**):
  - вход: `spec`, `triggerStates`, `overlayPhase`, `BuildContext`, `constraints?`, `overrides?`
  - выход: `RDropdownResolvedTokens`

**v1 policy: resolver capability опциональна.**
- Если resolver отсутствует — `resolvedTokens` в request будет `null`.
- Renderer ДОЛЖЕН иметь дефолты и работать без падения при `resolvedTokens == null`.

Где брать `WidgetState`:
- Для Button уже есть `RButtonState.toWidgetStates()` в `headless_contracts`.
- Для Dropdown: `RDropdownButtonState.toTriggerWidgetStates()` (pressed/hovered/focused/disabled).
- `overlayPhase` передаётся отдельно (влияет на trigger tokens, например borderColor "opened").

Тонкие моменты:
- dropdown overlayPhase не равен WidgetState, но может влиять на token resolution (например, показывать “opened” border).
- token resolver capability должен быть ISP-friendly: отдельный интерфейс на компонент.
- `overrides` (per-instance override bag) передаётся в resolver, чтобы “style на конкретной кнопке/дропдауне” влиял на resolved tokens **детерминированно** (см. `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`).
  - рекомендация v1: `overrides` ключуются **контрактными типами** из `headless_contracts` (например `RButtonOverrides`, `RDropdownOverrides`), а preset‑специфичные объекты (Material/Cupertino) — это advanced‑слой поверх контрактов.

---

### 3) Расширить RenderRequest (Variant B) до “полной формы”

Для каждого компонента:

#### 3.1 Button: `RButtonRenderRequest`
MUST fields (v1):
- `context`
- `spec`
- `state`
- `semantics` (минимум: `label?`, `isEnabled`, `isButton=true`, возможно `onTapHint?`)
- `callbacks` (минимум: `onPressed` — renderer должен знать, делать ли hit testing/ink, но **активация** остаётся в компоненте)
- `slots`
- `resolvedTokens` (`RButtonResolvedTokens`)
- `constraints` (например `BoxConstraints?` или `RConstraints` value object)
- `overrides` (optional): per-instance override bag для preset’ов (Material/Cupertino/DS)

#### 3.2 Dropdown: `RDropdownButtonRenderRequest` (non-generic)

**Dropdown renderer/resolver contracts v1 — non-generic by design.**
`RDropdownButton<T>` хранит `T` и делает mapping `value ↔ index`. Renderer работает только с UI item‑моделью (без `T`).

MUST fields (v1):
- `context`
- `spec`
- `state` (uses `selectedIndex`/`highlightedIndex`, NOT `selectedValue`)
- `items` (`List<HeadlessListItemModel>` — UI-only: item anatomy, NO value)
- `semantics` (минимум: `label?`, `expanded`, `enabled`)
- `commands` (`RDropdownCommands` — uses `selectIndex(int)`, NOT `onSelect(T)`)
- `slots`
- `resolvedTokens` (`RDropdownResolvedTokens?` — nullable, resolver optional)
- `constraints`
- `overrides` (optional): per-instance override bag

Тонкие моменты:
- `callbacks` в request не должны приводить к double-invoke. Компонент остаётся единственным источником активации, callbacks — “инструменты renderer’а”.
- `constraints` — это не `LayoutBuilder` внутри renderer. Это “политика минимального hit target”, которую компонент рассчитывает и передаёт.
- `overrides` не интерпретируются компонентом. Компонент только прокидывает их в request и token resolver.

---

### 4) Обновить `V1_DECISIONS.md` только если нужно уточнение типов

Если в 0.1 сейчас слишком абстрактно/примерно:
- добавить конкретные типы `*ResolvedTokens` как часть contracts,
- зафиксировать, что token resolver — capability, а не “магия внутри renderer”.

Важно: менять не смысл, а “чтобы читателю было очевидно, что Variant B реализован”.

---

## Тесты (минимум, MUST для I08)

### T1 — Token resolver вызывается и влияет на UI через request
Для Button/Dropdown:
- создать test theme с:
  - renderer capability (пишет в лог полученные tokens),
  - token resolver capability (возвращает детерминированные значения).
- ожидать, что renderer получил `resolvedTokens`, а не null.

### T1.1 — overrides протекают по проводу (resolver → request → renderer)
- передать `overrides` в компонент (per-instance),
- ожидать, что resolver получил overrides и это отразилось в `resolvedTokens` (например, изменился borderColor/padding).

### T2 — Нормализация состояний → токены
Button:
- pressed/disabled/focused → меняется token output (например backgroundColor).

Dropdown:
- isOpen/expanded и focused/hovered → меняется trigger tokens (например borderColor).

Тонкие моменты:
- тесты должны проверять “провода” (flow), а не пиксели.

---

## Артефакты итерации (что должно появиться в git)

- `headless_contracts`:
  - `RButtonResolvedTokens`, `RDropdownResolvedTokens`
  - `RButtonTokenResolver`, `RDropdownTokenResolver` (capabilities, **non-generic**)
  - расширенные `RButtonRenderRequest` / `RDropdownButtonRenderRequest` (новые поля, **non-generic**)
- `HeadlessListItemModel` (UI-only, no value), `RDropdownCommands` (uses `selectIndex`)
- компоненты могут пока компилироваться с временным "test resolver" в `apps/example` (до I09)
- тесты на flow: `headless_contracts/test/*` или в component tests (где проще)

---

## Критерии готовности (DoD)

- RenderRequest расширен и используется (не просто типы "для вида").
- Если token resolver capability подключен — `resolvedTokens` передаются в request.
- Если token resolver capability отсутствует — `resolvedTokens == null`, renderer использует свои defaults (без падения).
- Dropdown contracts non-generic: `RDropdownButtonRenderer`, `RDropdownTokenResolver`, `HeadlessListItemModel`, `RDropdownCommands`.

---

## Чеклист

- [ ] Зафиксированы `*ResolvedTokens` типы для Button/Dropdown (v1 минимум).
- [ ] Добавлены token resolver capabilities для Button/Dropdown.
- [ ] RenderRequest расширен: `semantics/callbacks/slots/resolvedTokens/constraints`.
- [ ] Есть тесты на flow (resolver → request → renderer).
- [ ] Обновления задокументированы (при необходимости) в `docs/V1_DECISIONS.md`.

