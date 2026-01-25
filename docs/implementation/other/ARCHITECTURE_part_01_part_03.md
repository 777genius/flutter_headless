## Monorepo архитектура (feature-first + DDD + SOLID) (part 1) (part 3)

Back: [Index](./ARCHITECTURE_part_01.md)


- **Domain**:
  - `variants/` (sealed классы)
  - `specs/` (value objects)
  - `resolved/` (resolved output)
  - Никакой “структуры UI” и “рендера”.
- **Presentation**:
  - `R*` управляет **поведением/состояниями/а11y** и собирает spec.
  - Визуал делегируется в renderer (контракты в `headless_contracts`, discovery в `headless_theme`).
- **Infra**:
  - Адаптеры и инфраструктура компонента (например, glue-код для theme contracts), но renderer implementations живут в preset-пакетах (`headless_material`, `headless_cupertino`) или в приложении.

#### Общие пакеты

- `headless_contracts`:
  - Контракты renderer/token resolver + slots + per-instance overrides.
  - Общий язык между компонентами и preset-реализациями.
- `headless_theme`:
  - Capability discovery + overrides scopes + HeadlessApp.
  - Motion/widget state helpers для пресетов и компонентов.
- `anchored_overlay_engine`:
  - Один раз решаем сложное (overlay lifecycle/policies/positioning/insertion) → переиспользуем во всех фичах.
  - Overlay positioning (зафиксировано):
    - `anchored_overlay_engine/src/positioning/anchored_overlay_layout.dart` — базовый collision pipeline v1: flip + horizontal shift + maxHeight с учётом safe area/keyboard.
  - Overlay reposition policy (зафиксировано):
    - reposition триггерится scroll/metrics (keyboard/resize) и коалесится до ≤ 1 раза на frame (`OverlayController.requestReposition()`).
  - Overlay update triggers v1.1 (зафиксировано):
    - optional ticker в `AnchoredOverlayEngineHost(enableAutoRepositionTicker: true)` — для редких кейсов, когда anchor движется без scroll/metrics.
    - SLA conformance tests обязаны покрывать flip/shift/maxHeight updates на scroll/metrics/ticker.
  - Overlay lifecycle v1: фаза `opening/open/closing/closed` экспонируется как `ValueListenable` (чтобы renderer мог делать enter/exit без костылей; см. `docs/V1_DECISIONS.md`).
  - Close contract v1: `close()` переводит в `closing`, а завершение закрытия — через `OverlayHandle.completeClose()` (есть fail-safe таймаут, чтобы не зависнуть в `closing`; см. `docs/V1_DECISIONS.md`).
  - Overlay API фиксирован как `AnchoredOverlayEngineHost` + `OverlayController` + `OverlayHandle` (без Navigator).
  - Compat: `headless_foundation/overlay.dart` ре‑экспортирует API для переходного периода.
- `headless_foundation`:
  - Один раз решаем сложное (focus/fsm/listbox/state resolution) → переиспользуем во всех фичах.
  - Interaction layers (зафиксировано):
    - `HeadlessPressableController/Region` — button-like поведение (pressed/hover/focus + anti-repeat)
    - `HeadlessFocusHoverController/HoverRegion` — hover+focus для input-like (без activation)
  - Ownership helpers (зафиксировано):
    - `HeadlessFocusNodeOwner` — владение/замена/безопасный dispose `FocusNode`
    - `HeadlessTextEditingControllerOwner` — владение/замена/безопасный dispose `TextEditingController`
  - Menu‑подобные паттерны строим через `listbox/*` механизмы, а не через компонент‑пакет.
- `headless_tokens`:
  - Raw + semantic tokens (готовит почву для multi-brand и стабильного API).
  - **Политика v1:** semantic tokens = **W3C-first + hybrid**:
    - небольшой whitelist **global semantic primitives**
    - всё специфичное — через `components.*` semantic tokens (не раздуваем global слой)
    - brand overrides через W3C `$extends` / group inheritance (см. `docs/V1_DECISIONS.md`)

#### Foundation ↔ Theme Contract (гарантии, не зависимости)

Foundation предоставляет механизмы; Theme обязана их использовать корректно:

| Механизм Foundation | Контракт Theme |
|---------------------|----------------|
| `OverlayHandle.phase` | Renderer слушает phase, отрисовывает enter/exit анимации |
| `OverlayHandle.completeClose()` | Renderer вызывает после exit-анимации |
| `StateResolutionPolicy` | Theme использует precedence для token resolution |
| `ListboxController.highlightedId` | Renderer отмечает highlighted item визуально |
| `InteractionController.states` | Renderer применяет states к token lookup |

**Это НЕ зависимость** (foundation не импортит theme), а **гарантия контракта**. Theme полагается на стабильность этих механизмов.

**Foundation types exposed to Theme/Renderers:**

| Type | Package | Used in | Stability |
|------|---------|---------|-----------|
| `OverlayHandle` | anchored_overlay_engine | Renderer receives via OverlayScope | `@stable` |
| `OverlayPhase` | anchored_overlay_engine | Renderer listens to phase changes | `@stable` |
| `WidgetStateSet` | headless_foundation | Renderer receives for token resolution | `@stable` |
| `ListboxItemId` | headless_foundation | Renderer highlights items by ID | `@stable` |
| `StateResolutionPolicy` | headless_foundation | Theme uses for token precedence | `@stable` |
| `TokenResolver<T>` | headless_contracts | Capability exposes for token resolution | `@stable` |
| `CloseReason` | anchored_overlay_engine | Renderer may inspect close reason | `@stable` |

Подробные контракты: `docs/V1_DECISIONS.md` → секции 0.1–0.7.

---

### Dual API policy (D2a сейчас, путь к D2b потом)

В v1 мы считаем “advanced / power user” уровень частью **foundation**, а не частью каждого компонента:

- **D2a (v1)**: публичные `anchored_overlay_engine` (overlay) + `headless_foundation` (listbox/focus/fsm) + обычные `R*` виджеты.
- **D2b (позже, если понадобится)**: per-component engines допускаются только если они:
  - **тонкая оболочка** над теми же event/state, которые использует `R*`,
  - не дублируют механизмы overlay/listbox (overlay остаётся в `anchored_overlay_engine`, listbox/focus/fsm — в `headless_foundation`),
  - добавляются **аддитивно** (без изменения дефолтного поведения и без breaking).

Цель: дать максимум кастомизации, не превращая систему в набор несогласованных “двух разных API”.

---

### Как это напрямую покрывает `docs/MUST.md`

- **Renderer contract (9/10)**: контракты в `headless_contracts/src/renderers/*`, реализации — в preset‑пакетах (`headless_material`, `headless_cupertino`) или в приложении/брендах (не в `components/*`).
- **Parts/Slots API (8/10)**: живёт в `components/*/presentation` (анатомия компонентов), но без протечки в tokens/foundation.
- **Theme runtime (9/10)**: `headless_theme/src/theme/*` + scopes/overrides.
- **State resolution (8/10)**: `headless_foundation/src/state_resolution/*`.
- **FSM (8/10)**: `headless_foundation/src/fsm/*` — **optional pattern** поверх E1, не часть core contracts. Используется в сложных компонентах (Select, Dialog), но не обязателен (см. V1_DECISIONS.md → "FSM как optional pattern").
- **Overlay infra (7/10)**: `anchored_overlay_engine/src/*` и dialog‑компоненты.
- **Semantic tokens (7/10)**: `headless_tokens/src/semantic/*`.
- **API stability (8/10)**: достигается через capability discovery/optional wiring в `headless_theme`.
- **Behavior + a11y tests (7/10)**: тесты живут рядом с фичами и foundation (без golden по умолчанию).

---

### Renderer contracts: capability discovery + политика стабильности API (v1)

Цель: чтобы мы могли **добавлять возможности аддитивно** (minor), не ломая пользователей и не раздувая “монолитную тему”.

#### Принципы

- **ISP**: вместо “одной большой темы” делаем маленькие capabilities (`ButtonRenderer`, `DialogRenderer`, …).
- **Discovery**: наличие capability определяется через `RenderlessTheme`/composition слой (не через `if (theme is FooTheme)`).
- **Компоненты не знают реализаций**: `R*` импортят только contracts (из `headless_contracts`), а не default renderers.

#### Правила эволюции (чтобы не было миграций)

- **Additive-only в minor**:
  - новые capabilities — только как **опциональные** поля/композиция с дефолтами,
  - новые parts/slots — только аддитивно (старые не исчезают),
  - новые токены — только аддитивно и по правилам semantic tokens v1.
- **Breaking = только major**:
  - переименования/удаления renderer API,
  - изменение поведения по умолчанию,
  - изменение обязательности capability.
- **Отсутствие renderer’а = явная ошибка**:
  - если пользователь подключил компонент, но не предоставил соответствующий renderer capability, это должно приводить к понятной диагностике (assert/throw с инструкцией, как подключить `headless` facade или свой theme composition).

Ссылки: `docs/V1_DECISIONS.md` (renderer/parts/overlay).

---

### Interaction layers + Owners (зафиксировано, как делать правильно)

Цель: чтобы при росте компонентов не копировались и не дрейфовали “провода” интеракций и lifecycle объектов.

#### Semantics policy (must)

- **Корневые Semantics принадлежат компоненту (`R*`)**.
- Renderer может добавлять локальные semantics внутри, но **не должен дублировать корневые** (иначе a11y становится непредсказуемым).

#### Interaction layers (must)

- **Pressable surfaces** (кнопки, dropdown trigger):
  - Используем `HeadlessPressableController` + `HeadlessPressableRegion`.
  - Стандартизирует: pressed/hover/focus/disabled + клавиатурную активацию Space/Enter (anti-repeat).
- **Hover+Focus surfaces** (textfield-like):
  - Используем `HeadlessFocusHoverController` + `HeadlessHoverRegion`.
  - Hover даёт region, focus приходит от `FocusNode` (источник фокуса — input).

#### Owners (must)

Правило ownership: если объект передан снаружи — мы его **не dispose**.

- `HeadlessFocusNodeOwner`:
  - создаёт внутренний `FocusNode`, если внешний не задан
  - корректно переключается при смене `widget.focusNode`
  - dispose только внутреннего node (+ безопасный `unfocus()` перед dispose)
- `HeadlessTextEditingControllerOwner`:
  - создаёт внутренний `TextEditingController`, если внешний не задан
  - корректно переключается при смене `widget.controller`
  - dispose только внутреннего controller

Детали и примеры: `docs/implementation/I13_interaction_layers_and_owners.md`.

---

### Tokens pipeline v1: W3C → `headless_tokens` (без runtime parsing)

Цель: один source of truth для multi-brand, без “магии в рантайме”.

- **Source of truth**: W3C Design Tokens JSON (с `$extends`, `$type`, aliases).
- **Import**: `tools/headless_cli` (optional tooling) читает W3C JSON и генерирует Dart-код токенов в `headless_tokens`.
- **Runtime**: никаких JSON парсеров и резолва `$extends` в рантайме; в приложении используются типизированные токены.
- **Color spaces**: P3/OKLCH можно принимать на вход, но в v1 конвертируем в **sRGB на импорте** (см. `docs/V1_DECISIONS.md`).

---

### Governance v1: как мы принимаем архитектурные решения

Цель: не получить “дрейф” архитектуры и скрытые несовместимости при росте пакетов.

- **Единый источник решений v1**: любые изменения, затрагивающие контракты `headless_tokens` / `headless_foundation` / `headless_contracts` должны сопровождаться обновлением `docs/V1_DECISIONS.md` (или явной записью “почему не нужно”).
- **Spec-first инвариант**: любые изменения, влияющие на совместимость сторонних component packages, должны сопровождаться обновлением `docs/SPEC_V1.md` и `docs/CONFORMANCE.md`.
- **Запрет “тихих” изменений поведения**: любое изменение дефолтов/инвариантов — это либо minor с явным описанием в changelog, либо major.
- **PR дисциплина**: PR checklist из этого документа обязателен; если чеклист “не проходим” — значит решение не готово.

### Политика “не монолит” (границы модулей)

- Любой новый компонент начинается как **новый пакет компонента** в `packages/components/`.
- Общий код “вытаскиваем” вверх только если он:
  - используется **минимум в 2–3 фичах**, и
  - формулируется как **общий механизм** (overlay/focus/fsm/state), а не как “кусок конкретного компонента”.

---

### Чеклист PR‑ревью (быстро проверяем архитектуру)

- **Spec-first**:
  - Если меняли публичные контракты/инварианты или “что значит совместимость” — обновлены `docs/V1_DECISIONS.md` и/или `docs/SPEC_V1.md`, и при необходимости `docs/CONFORMANCE.md`.

- **Границы пакета**:
  - Изменения затрагивают только “свою” фичу/пакет и общие пакеты по делу.
  - Нет импорта других компонентов из `packages/components/*`.

- **Зависимости**:
  - Не добавили циклические зависимости (DAG).
  - `domain/` не импортит Flutter UI/renderer реализации (только спецификации/контракты).

- **SOLID**:
  - Новый функционал добавлен через capability/контракт, а не через расширение “большого” интерфейса без необходимости (ISP).
  - `R*` зависит от абстракций (capabilities/renderers), а не от конкретной темы/рендера (DIP).

- **POLA**:
  - Дефолтное поведение компонента предсказуемо (disabled/loading/focus).
  - Нет “магических” сайд‑эффектов (например, неожиданные изменения фокуса/закрытия) без явной опции/контракта.

- **AI metadata (LLM.txt)**:
  - Если менялся публичный API/инварианты пакета — обновлён `LLM.txt` (или `docs/LLM.md`) в этом пакете.

- **A11y (manual слой)**:
  - Для новых/изменённых overlay/сложных компонентов выполнена минимальная ручная проверка: **keyboard-only** + **screen reader** (VoiceOver/NVDA/JAWS).

---

### AI/MCP metadata policy (LLM.txt) — v1

Цель: чтобы AI/агенты и codegen инструменты использовали Headless **правильно** и не нарушали инварианты.

**Правило:**
- Для каждого publishable package добавляем файл **`LLM.txt`** в корне пакета (рядом с `pubspec.yaml`).
- Если нужен markdown/ссылки — допускаем `docs/LLM.md`, но “короткая выжимка” всё равно должна быть в `LLM.txt`.

**Минимальное содержимое `LLM.txt`:**
- **Purpose**: что делает пакет (1–3 предложения).
- **Non-goals**: что пакет *не делает* (чтобы агент не добавлял “магии”).
- **Invariants**: 5–10 пунктов (overlay closing phase, focus restore, state resolution, no component->component deps, etc.).
- **Correct usage**: 2–3 коротких примера.
