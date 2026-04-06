## I06 — Reference component: Button (первый end-to-end вертикальный срез)

### Цель

Сделать первый компонент так, чтобы он доказал:
- headless separation (поведение отдельно от визуала),
- capability discovery,
- controlled/uncontrolled (POLA),
- базовые состояния/а11y,
- conformance mindset (минимальные тесты поведения).

### Ссылки на требования

- Spec-first + DoD: `docs/ARCHITECTURE.md` → “Definition of Done: Headless‑совместимый package”
- Controlled/uncontrolled: `docs/ARCHITECTURE.md` → “Controlled / Uncontrolled модель”
- Renderer contracts: `docs/V1_DECISIONS.md` → “0.1 Renderer contracts”
- Conformance: `docs/CONFORMANCE.md`

### Что делаем

#### 1) Domain (чистый)

Минимальный домен должен быть полезным, но без UI типов (см. `docs/ARCHITECTURE.md` → “Где нельзя хранить состояние”).

- `ButtonVariant` (sealed): `filled`, `tonal`, `outlined`, `text` (appearance-based, see I37).
- `ButtonSize` (sealed): например `md` (минимум, расширяем аддитивно).
- `ButtonSpec` (value object): variant/size/disabled.
- `ButtonState` (immutable): минимум `isPressed`, `isFocused`, `isHovered` (если hover вообще включаем в v1 — можно начать с pressed+focused).

Тонкие моменты:
- инвариант: `disabled` доминирует над `pressed` (POLA). В состоянии не должно быть “нажатой disabled кнопки”.
- equality/dedupe: state/spec должны иметь стабильное сравнение, чтобы не эмитить лишние события.

#### 2) Presentation

API (минимум v1):
- `RTextButton` принимает:
  - `onPressed` (nullable)
  - `disabled` (или вычисляется: `onPressed == null`)
  - `variant`, `size`
  - `child` (Widget)

Поведение:
- pointer/keyboard input переводится в `pressed` state (через foundation interactions позже; на старте можно MVP, но без дублирования логики в каждом компоненте).
- семантика:
  - role = button
  - disabled состояние
  - активация по Enter/Space

Headless separation:
- `RTextButton` **не** строит Container/Row/Ink и т.п. как “визуал по умолчанию”.
- Он формирует `spec/state`, берёт renderer capability и вызывает renderer.

Тонкие моменты:
- если `disabled == true` или `onPressed == null` → никаких действий и `pressed` не должен “залипать”.
- фокус/клавиатура: Space должен вести себя как “press-start → press-end”, Enter как “activate” (минимально — единый путь, но без двойного вызова).
- не делать “магический” focus request на тап, если Flutter уже это делает.

#### 3) Theme contract (renderer)

Минимум:
- интерфейс `RButtonRenderer`
- `RenderRequest` включает:
  - `spec`
  - `state`
  - `child`
  - optional `slots` (если нужно)

Required capability failure:
- если capability отсутствует, бросаем ошибку/assert с текстом:
  - какая capability нужна,
  - что подключить (facade или свой theme composition),
  - ссылки на `docs/SPEC_V1.md` и `docs/CONFORMANCE.md` (как “правильный путь”).

Тонкие моменты:
- request не должен тащить большие объекты, пересоздаваемые на каждый build (см. `docs/ARCHITECTURE.md` → context splitting policy).

#### 4) Тесты (conformance для первого компонента)

Минимум (см. `docs/CONFORMANCE.md`):
- Semantics/a11y: кнопка объявлена как button, disabled отображается.
- Keyboard-only:
  - Space/Enter вызывают `onPressed` ровно 1 раз на активацию.
  - disabled не вызывает `onPressed`.
- Controlled/uncontrolled:
  - если `disabled`/`onPressed` меняются между билдами — компонент ведёт себя предсказуемо (без “залипания” состояний).

Тонкие моменты:
- тестируем поведение, не пиксели (no golden-first).
- отдельно проверяем “missing renderer capability” (ошибка понятная).

#### 5) Facade

- экспортируем `headless_button` через `packages/headless/lib/headless.dart`.
- правило: компоненты не импортят facade обратно.

### Артефакты итерации (что должно появиться в git)

- `packages/headless_contracts/lib/src/renderers/button/*` (renderer contract + domain types: RButtonSpec, RButtonState, RButtonVariant, RButtonSize, RButtonSlots)
- `packages/components/headless_button/lib/src/presentation/*` (`RTextButton`)
- тесты в `packages/components/headless_button/test/*`
- обновление `apps/example` (минимальный "test renderer" для ручной проверки)

**Примечание v1**: Domain types (RButtonSpec, RButtonState, etc.) живут в `headless_contracts` вместе с renderer contract, т.к. они являются shared contract между компонентом и renderer'ом. Отдельной `domain/` папки в component package нет.

### Что НЕ делаем

- Не делаем “идеальную” кнопку сразу (loading/progress, long-press, haptics) — только фундамент.
- Не делаем default renderers (можно временно сделать “test renderer” внутри example app для ручной проверки).

### Диагностика (тонкие баги)

- `onPressed` вызывается дважды на Enter/Space:
  - значит обработка клавиатуры дублируется (Semantics + key handler) — оставляем один источник истины.
- `pressed` “залипает”:
  - значит cancel путь не обработан (pointer cancel / focus loss / key up).
- компонент начинает строить визуальную структуру “на всякий случай”:
  - это нарушение headless separation; визуал только в renderer.

### Критерии готовности (DoD)

- Компонент компилируется и работает в `apps/example`.
- Если renderer capability не подключена — понятная ошибка.
- Есть тесты поведения (минимум по conformance).

### Чеклист

- [x] Domain чистый (без Flutter) — types in headless_contracts (shared with renderer contract)
- [x] Renderer capability обязательна и discovery работает
- [x] Controlled/uncontrolled соблюдён
- [x] Есть semantics + keyboard тесты
- [x] Есть тест на missing renderer capability (понятная ошибка)
- [x] Экспорт через facade

