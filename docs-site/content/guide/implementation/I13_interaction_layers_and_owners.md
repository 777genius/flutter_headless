## Цель

Зафиксировать “как делать правильно” для масштабируемой архитектуры renderless компонентов:

- единые interaction layers (pressable / hover+focus)
- единые owners для lifecycle объектов (FocusNode, TextEditingController, …)
- SRP: UI-координация в компоненте, “провода” — в foundation, render request сборка — отдельно

Этот документ — рабочая инструкция, чтобы не забывать принципы при росте компонентной библиотеки.

## Базовые правила

- **Semantics живёт в компоненте**, а не в renderer’е.
  - Renderer может добавлять локальные semantics внутри, но не должен дублировать корневые.
- **Один источник истины для интеракций**:
  - кнопки/триггеры: `HeadlessPressableController` + `HeadlessPressableRegion`
  - hover/focus (без “нажатия”): `HeadlessFocusHoverController` + `HeadlessHoverRegion`
- **Lifecycle объектов не копируем**:
  - `FocusNode`: `HeadlessFocusNodeOwner`
  - `TextEditingController`: `HeadlessTextEditingControllerOwner` (см. ниже)

## Interaction layers

### Pressable (Button-like)

Используем для: `RTextButton`, dropdown trigger, любые кликабельные поверхности.

- **Состояние**: pressed/hovered/focused/disabled
- **Клавиатура**:
  - Space: pressed на keyDown, activate на keyUp
  - Enter: activate на первый keyDown (anti-repeat)
  - опционально ArrowDown (dropdown trigger)

Компонент обязан:

- держать Semantics
- решать что такое `onActivate` (например `onPressed`, `openMenu`, `toggleMenu`)
- мапить state контроллера в свой render request state

#### A11y activation policy (важно, чтобы не спорить снова)

Цель: **screen readers** должны уметь активировать компонент через `SemanticsAction.tap`, но при этом мы не должны получать “двойную активацию” и не должны переносить ответственность в renderer.

Правило v1:

- **Semantics принадлежит компоненту** и включает `onTap`, когда компонент интерактивен.
  - Пример: `Semantics(onTap: _activate)` у `RTextButton`, `Semantics(onTap: _toggleMenu)` у dropdown trigger.
- **`HeadlessPressableRegion` = pointer + keyboard plumbing**, но **не** owner Semantics.
  - Pointer activation: `GestureDetector.onTapDown/onTapUp/onTapCancel` → `HeadlessPressableController` (pressed state + вызов `onActivate`).
  - Keyboard activation: `Focus.onKeyEvent` через `handlePressableKeyEvent`.
- **Renderer не добавляет свой “tap путь”** (никаких `InkWell(onTap: ...)`, `GestureDetector(onTap: ...)` и т.п. на root surface).

Почему так:

- В Flutter `Semantics(onTap: ...)` — это прямой, явный контракт для `SemanticsAction.tap` (accessibility).
- `GestureDetector.onTapUp` — это про pointer-жесты и детали (`TapUpDetails`), но он сам по себе не гарантирует наличие `SemanticsAction.tap`.
- Если смешать pointer-активацию и Semantics-активацию в одном месте без явного правила, легко получить double-invoke или рассинхрон поведения между renderer’ами.

##### Ссылки на исходники Flutter (проверка “как оно устроено”)

- `packages/flutter/lib/src/semantics/semantics.dart`:
  - `SemanticsData.hasAction`: проверяет наличие действия как `(actions & action.index) != 0`.
- `packages/flutter/lib/src/widgets/gesture_detector.dart`:
  - `RawGestureDetectorState.initState`: при `semantics == null` используется `_DefaultSemanticsGestureDelegate`.
  - блок построения распознавателей: `TapGestureRecognizer` добавляется, если задан любой из tap-callback’ов (`onTapDown`, `onTapUp`, `onTap`, ...).
  - комментарий в документации: “During a semantic tap, it calls TapGestureRecognizer's onTapDown, onTapUp, and onTap.”

### Hover + Focus (без activation)

Используем для: `RTextField` и любых полей ввода.

- hover приходит из `HeadlessHoverRegion`
- focus приходит из `FocusNode` listener’а (источник фокуса — сам input)

Компонент обязан:

- держать Semantics
- на каждом build мапить focus/hover state в render request state

## Owners (lifecycle helpers)

### `HeadlessFocusNodeOwner`

Решает:

- создать внутренний `FocusNode`, если внешний не передан
- корректно переключиться при смене `widget.focusNode`
- dispose только “своего” node (внешний не трогаем)
- перед dispose делает `unfocus()` (устраняет edge-cases в focus tree)

Компонент обязан:

- сам вешать/снимать listeners на `owner.node` при обновлениях

### `HeadlessTextEditingControllerOwner`

Решает:

- создать внутренний `TextEditingController` если внешний не передан
- корректно переключиться при смене `widget.controller`
- dispose только “своего” controller

**Важно**: owner не знает про IME composing, controlled vs controller-driven режимы и т.п.
Компонент обязан:

- сам вешать/снимать listeners на `owner.controller`
- сам синхронизировать `value -> controller.text` в controlled режиме
- сам решать, что делать при “переключении” controller’а (например сброс pending состояния)

## Рекомендации по RTextField

- Controlled mode: `value + onChanged`, внутренний controller
  - синхронизация value → controller должна учитывать IME composing (defer)
- Controller-driven mode: внешний controller, value не задаётся
  - компонент не должен “перетираеть” текст, только подписывается на изменения

