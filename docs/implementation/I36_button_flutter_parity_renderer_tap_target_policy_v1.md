## I36 — Button: Flutter parity renderer (visual-only) + разделение tap target и visual size v1

### Цель

Сделать `RTextButton` в `headless_material` и `headless_cupertino` **визуально максимально идентичным Flutter** (pinned stable), сохранив архитектурные инварианты:

- **Single activation source**: активация (`onPressed`) живёт только в компоненте.
- **Renderer = visual-only**: renderer может рисовать “как угодно”, но не должен владеть семантикой/интеракцией.
- **Tap target ≠ visual size**: минимальная зона интеракции и минимальный визуальный размер — разные политики, и они не должны “раздувать” визуал.

Scope этой итерации — **только кнопки**. Parity-by-reuse для других компонентов обсуждаем отдельно (у них другие контракты, эффекты, ограничения).

---

## 0) Source of truth (Flutter stable, pinned)

Мы не подбираем “похожие” значения. Для parity опираемся на исходники Flutter в текущей stable версии проекта (см. `I35`):

- Flutter `3.38.6` stable, framework revision `8b87286849`

Ссылки на исходники (зафиксированы по revision):

- Material 3:
  - FilledButton:  
    `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/filled_button.dart`
  - OutlinedButton:  
    `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/outlined_button.dart`
  - База (layout + states + tap target padding):  
    `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/button_style_button.dart`
- Cupertino:
  - CupertinoButton (размеры/паддинги/анимации pressed/focus):  
    `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/cupertino/button.dart`

---

## 1) Определения (чтобы убрать двусмысленности)

- **Visual size**: минимальные размеры **видимого** контейнера кнопки (например, Material 3 `minimumSize = Size(64, 40)`).
- **Tap target**: минимальные размеры **зоны интеракции** (hit test area). Для Material это обычно 48×48 (с учётом `VisualDensity` и `MaterialTapTargetSize`), для iOS — 44×44.
- **Visual-only renderer**: renderer-subtree может содержать любые Flutter widgets, но итоговый subtree:
  - не получает pointer events (интеракция заблокирована),
  - не поставляет button-semantics (semantics у компонента),
  - не добавляет фокус-остановок (focus остаётся у компонента).
- **Parity (v1)**: совпадение геометрии/типографики/цветов/shape/disabled/pressed/hover/focus визуала с Flutter **в рамках указанного mapping** (см. раздел 4). Ripple/ink splash в v1 — **не цель** (см. 1.1 Non-goals).

---

### 1.1 Non-goals (явно не делаем в этой итерации)

- **Ripple/ink splash parity**: в v1 не добиваемся 1:1 ripple, т.к. он gesture-driven внутри Flutter кнопок.
- **Material size variants parity** для `RButtonSize.small/large`: у Flutter нет прямых аналогов “small/large” для Filled/Outlined.
- **Иконки/спиннер**: parity гарантируем для “label only” (и отдельно можно добавить `.icon` как follow-up).
- **Автоматический перенос решения на другие компоненты**: parity-by-reuse для checkbox/switch/listTile/etc. обсуждается отдельно.

---

## 1.2 Жёсткие инварианты (MUST / MUST NOT)

Это не “рекомендации”, а правила, которые должны подтверждаться тестами/conformance.

- **MUST**: `onPressed` вызывается **только** компонентом (`RTextButton`), никакой callback не должен “утечь” внутрь renderer-subtree.
- **MUST**: renderer-subtree **инертный** (см. 4.1).
- **MUST**: tap target формируется **снаружи** visual дерева (см. 3.2) и не изменяет геометрию visual части.
- **MUST NOT**: renderer-subtree добавляет semantics “button”. Semantics принадлежит компоненту.
- **MUST NOT**: renderer-subtree добавляет focus stop (tab traversal). Focus принадлежит компоненту.

---

## 2) Контекст (почему сейчас не parity)

- **Hand-rolled renderers**: текущие кнопочные renderer’ы рисуют “свои” деревья → дрейф относительно Flutter.
- **Tap target смешан с visual**: min hit target попадает в layout constraints и раздувает визуал (в Flutter Material это отдельный `_InputPadding`).
- **Conformance brittle**: проверки “нет InkWell” не выражают инвариант “renderer inert”.

---

## 3) Решение A: развести tap target и visual size на уровне компонента

### 3.1 Вводим capability `HeadlessTapTargetPolicy` (без вариантов “или”)

**Где**: `packages/headless_theme/lib/src/accessibility/headless_tap_target_policy.dart` (и экспорт из `headless_theme`).

**Зачем**: компоненту нужен единый, тестируемый способ получать min tap target (как policy), не смешивая его с визуальными токенами.

**API (v1, минимально достаточный и расширяемый):**

- `enum HeadlessTapTargetComponent { button /* v1 */, /* follow-ups */ }`
- `abstract interface class HeadlessTapTargetPolicy {`
  - `Size minTapTargetSize({required BuildContext context, required HeadlessTapTargetComponent component});`
  - `}`

**Дефолтные реализации (в пресетах, не в компоненте):**

- Material preset (`headless_material`) возвращает policy, эквивалентный Flutter `ButtonStyleButton` (Material API находится в `headless_material`, не в `headless_theme`):
  - если `Theme.of(context).materialTapTargetSize == MaterialTapTargetSize.padded`:
    - `density = Theme.of(context).visualDensity.baseSizeAdjustment`
    - `min = Size(48 + density.dx, 48 + density.dy)` (clamp \(>= 0\))
  - если `shrinkWrap`: `Size.zero`
  - clamp: значения не должны стать отрицательными.
- Cupertino preset (`headless_cupertino`):
  - `Size(44, 44)` (HIG minimum) как минимум для `button`.

> Важно: это не “наши числа”, это повторяемая политика Flutter.
> На Material стороне формула берётся напрямую из `button_style_button.dart`.

### 3.2 Компонент применяет tap target, renderer — visual size

Меняем `RTextButton` так, чтобы:

- `renderer.render(request)` возвращал **визуальный** виджет (высота 40/44 и т.п.),
- интерактивная зона гарантировала **min tap target** вокруг визуала, не раздувая визуальный контейнер.

Implementation note (v1):

- `visual = renderer.render(request)`
- `tapTarget = policy.minTapTargetSize(...)` (fallback: `WcagConstants.kMinTouchTargetSize`)
- `pressableChild = ConstrainedBox(min: tapTarget) → Center(visual)`

**Точное правило layout (MUST):**

- padding/hit-area увеличивается **вокруг** visual, но visual min size определяется только renderer’ом / Flutter default style.
- visual центрируется внутри hit-area (как в Flutter Material `_InputPadding`).

### 3.2.1 Где именно применяется tap target в дереве

Чтобы не появилось “вроде работает, но где-то раздувает”, фиксируем порядок:

- `Semantics(button: true, onTap: componentActivate, ...)`
  - `HeadlessPressableRegion(behavior: opaque)`
    - `ConstrainedBox(min tapTarget)`
      - `Center(child: rendererOutput)`

Так мы гарантируем, что:

- hit test area соответствует policy,
- визуал не меняется,
- pressed/hover/focus состояние всё равно вычисляется компонентом и прокидывается в renderer.

### 3.3 Уточняем семантику `RButtonResolvedTokens.minSize` (чтобы не путать слои)

В этой итерации фиксируем правило (и обновляем комментарий в контракте):

- `RButtonResolvedTokens.minSize` = **min visual size** (аналог Flutter `ButtonStyle.minimumSize`).
- tap target **не** хранится в `RButtonResolvedTokens` и **не** приходит в renderer через `constraints`.

Это минимальное изменение смысла, которое убирает архитектурную ловушку “hit target раздувает визуал”.

Файлы контрактов, которые нужно обновить вместе с реализацией (чтобы документация совпадала с поведением):

- `packages/headless_contracts/lib/src/renderers/button/r_button_resolved_tokens.dart` (комментарий `minSize`)
- `packages/headless_contracts/lib/src/renderers/button/r_button_token_resolver.dart` (описание `constraints`)
- `packages/headless_contracts/lib/src/renderers/button/r_button_renderer.dart` (описание `RButtonRenderRequest.constraints`)

---

### 3.4 Взаимодействие со `HeadlessRendererPolicy.requireResolvedTokens`

В репозитории уже есть policy “strict tokens” (см. `HeadlessRendererPolicy(requireResolvedTokens: true)` и тест `strict_tokens_policy_test.dart`).

Для parity кнопок источник истины — **Flutter Theme + Flutter reference widgets**, а не `resolvedTokens`.
Поэтому фиксируем поведение:

- **Parity renderer MUST**: корректно работать при `resolvedTokens == null`.
- **Parity renderer MUST NOT**: падать из-за `requireResolvedTokens == true`.

Следствие: “strict tokens” остаётся валиден для token-driven renderers, но **не является глобальным правилом для parity-by-reuse**.
Это аналогично тому, как `MaterialTextFieldRenderer` (parity-by-reuse через `InputDecorator`) не участвует в strict tokens.

Deliverable: обновить `packages/headless_material/test/strict_tokens_policy_test.dart`:

- тест должен продолжать проверять **legacy token-driven** renderer (если он остаётся в коде),
- parity renderer не должен быть покрыт этим тестом.

---

## 4) Решение B: Flutter parity renderers (visual-only)

### 4.1 Общий инвариант (inert subtree)

Renderer output должен быть **инертным**:

- `ExcludeSemantics` + `AbsorbPointer(absorbing: true)`
- внутри subtree нет focus stop (внутренний `FocusNode` выключен)

**Проверяемая форма (MUST):**

- самый внешний wrapper: `ExcludeSemantics`
- следующий: `AbsorbPointer(absorbing: true)`

Причина: если `AbsorbPointer` снаружи, semantics всё равно может “протечь” в дереве доступности.

### 4.2 Material parity renderer (Material 3 only)

- **Guard**: `Theme.of(context).useMaterial3 == true`, иначе `StateError`.
- **Mapping (I36 v1)**: `primary → FilledButton`, `secondary → OutlinedButton`.
  > **Обновлено в I37**: `RButtonVariant` мигрировал на appearance-variants: `filled → FilledButton`, `tonal → FilledButton.tonal`, `outlined → OutlinedButton`, `text → TextButton`.
- **Parity scope v1**: только `RButtonSize.medium` (small/large = custom extension).
- **Implementation checklist**:
  - `child = request.content`
  - `onPressed = state.isDisabled ? null : () {}`
  - `style = ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap)` (tap target добавляет компонент)
  - `statesController = MaterialStatesController()` (updates в `initState` + `didUpdateWidget`: pressed/hovered/focused/disabled)
  - внутренний `focusNode`: `canRequestFocus: false`, `skipTraversal: true` (dispose обязателен)
  - outer wrappers: `ExcludeSemantics → AbsorbPointer`

### 4.2.1 Таблица соответствия state → WidgetState (Material)

| `RButtonState` | `WidgetState` |
|---|---|
| `isDisabled` | `WidgetState.disabled` |
| `isPressed` | `WidgetState.pressed` |
| `isHovered` | `WidgetState.hovered` |
| `isFocused` | `WidgetState.focused` |

Правило (MUST): parity renderer обновляет `statesController` так, чтобы его `value` соответствовало этой таблице.

### 4.2.2 Как применяем `RButtonOverrides` в Material parity renderer

Renderer строит `ButtonStyle`-delta и передаёт её в `FilledButton/OutlinedButton(style: ...)`.

Маппинг (v1):

- `textStyle` → `ButtonStyle.textStyle`
- `foregroundColor` → `ButtonStyle.foregroundColor`
- `backgroundColor` → `ButtonStyle.backgroundColor`
- `padding` → `ButtonStyle.padding`
- `minSize` → `ButtonStyle.minimumSize`
- `borderRadius` → `ButtonStyle.shape` (RoundedRectangleBorder). Это intentional deviation от StadiumBorder.
- `borderColor`:
  - для `OutlinedButton` → `ButtonStyle.side = BorderSide(color: borderColor, width: 1)`
  - для `FilledButton` игнорируем (border не рисуется по дефолту)

Важно: overrides применяются **как delta**, дефолтный стиль остаётся Flutter’овским.

### 4.3 Cupertino parity renderer (порт визуала из `CupertinoButton`)

- `CupertinoButton` gesture-driven, поэтому для visual-only делаем порт визуальной части из `cupertino/button.dart` (без gestures/semantics).
- **Mapping (I36 v1)**: `primary → filled-like`, `secondary → plain-like` (без outline).
  > **Обновлено в I37**: `filled → CupertinoButton.filled`, `tonal → CupertinoButton.tinted`, `text → CupertinoButton` (plain), `outlined → design-system extension (не native)`.
- **Size mapping**: `small/medium/large → CupertinoButtonSize.small/medium/large`.
- **Implementation checklist**:
  - константы/анимации pressed/focus берём из pinned исходников
  - состояние берём из `request.state`
  - outer wrappers: `ExcludeSemantics → AbsorbPointer` + focus disabled

### 4.3.1 Таблица соответствия state (Cupertino)

CupertinoButton в исходниках использует:

- pressed: fade animation (120ms out / 180ms in) + `pressedOpacity`
- focused: focus outline (зависит от enabled + isFocused)
- disabled: отдельные цвета/disabledColor

В parity renderer:

- pressed визуал driven **только** `request.state.isPressed`
- focused driven **только** `request.state.isFocused`
- disabled driven **только** `request.state.isDisabled`

Никаких “внутренних” pointer событий быть не должно (pointer заблокирован).

---

## 5) Кастомизация (правила v1)

- В parity renderer v1 поддерживаем `RButtonOverrides`: `textStyle`, `foregroundColor`, `backgroundColor`, `borderColor` (Material secondary), `padding`, `minSize` (visual), `borderRadius`.
- `disabledOpacity`, `pressOverlayColor`, `pressOpacity` считаем legacy/custom-only (иначе придётся писать state overlay руками).
- Escape hatch (preset-specific): raw style hooks (Material `ButtonStyle` и аналоги на iOS). Parity не гарантируется.

---

## 6) Тесты

### 6.1 Conformance: single activation source (v2)

Renderer passes if:

- **A**: нет интерактивных handlers в subtree, **или**
- **B**: есть inert guard (`AbsorbPointer(absorbing: true)` + `ExcludeSemantics`).

### 6.2 Golden parity

- **E2E**: `RTextButton` vs native Flutter button side-by-side (фиксируем `MediaQuery` как в TextField goldens).
- **Renderer-only**: `renderer.render(state: pressed/hovered/focused/disabled)` vs native button в эквивалентном состоянии.

### 6.3 Layout tests

- visual не раздувается: min height 40 (Material M3) / 44 (iOS)
- hit-area \(>=\) `HeadlessTapTargetPolicy`

---

## 7) План работ (конкретно по файлам)

### P1) `HeadlessTapTargetPolicy` (contract + export)

- **Add**: `packages/headless_theme/lib/src/accessibility/headless_tap_target_policy.dart`
- **Update**: `packages/headless_theme/lib/headless_theme.dart` (export)

### P2) Preset policies

- **Add**: `packages/headless_material/lib/src/accessibility/material_tap_target_policy.dart`
  - реализует формулу из Flutter `ButtonStyleButton` (padded/shrinkWrap + VisualDensity)
- **Update**: `packages/headless_material/lib/src/material_headless_theme.dart`
  - `capability<HeadlessTapTargetPolicy>() → MaterialTapTargetPolicy()`

- **Add**: `packages/headless_cupertino/lib/src/accessibility/cupertino_tap_target_policy.dart`
  - возвращает `Size(44, 44)` для button
- **Update**: `packages/headless_cupertino/lib/src/cupertino_headless_theme.dart`
  - `capability<HeadlessTapTargetPolicy>() → CupertinoTapTargetPolicy()`

### P3) Компонент `RTextButton`: tap target wrapper

- **Update**: `packages/components/headless_button/lib/src/presentation/r_text_button.dart`
  - убрать WCAG base constraints как механизм layout/visual,
  - получить `HeadlessTapTargetPolicy` capability,
  - обернуть renderer output в min tap target + центрирование,
  - обновить смысл `constraints` в `RButtonRenderRequest` (tap target туда не прокидывать).

- **Update**: docs/comments в контрактах (см. 3.3) — иначе это останется источником путаницы.

### P4) Parity renderers

- **Add**: `packages/headless_material/lib/src/button/material_flutter_parity_button_renderer.dart`
  - Material 3 only (`useMaterial3` guard)
  - FilledButton/OutlinedButton mapping
  - inert guard + lifecycle-driven statesController
  - `tapTargetSize: MaterialTapTargetSize.shrinkWrap`
- **Update**: `packages/headless_material/lib/src/material_headless_theme.dart`
  - подключить parity renderer как дефолтный `RButtonRenderer`
  - legacy renderer (если оставляем) переименовать/оставить как internal

- **Add**: `packages/headless_cupertino/lib/src/button/cupertino_flutter_parity_button_renderer.dart`
  - визуальный порт из `CupertinoButton` (без gestures/semantics)
  - mapping variant + sizeStyle
  - inert guard (semantics/pointer/focus)
- **Update**: `packages/headless_cupertino/lib/src/cupertino_headless_theme.dart`
  - подключить parity renderer как дефолтный `RButtonRenderer`

### P5) Conformance + tests + goldens

- **Update**: `packages/headless_test/lib/src/button/button_renderer_conformance.dart` (v2 правила A/B)
- **Update**: preset tests под новые правила
- **Add**: golden harness + goldens для Material/Cupertino кнопок (по аналогии с TextField)
- Прогон: `melos run analyze`, `melos run test`

---

## 8) DoD (acceptance criteria)

- **Parity**:
  - Material (M3): `RTextButton` совпадает с `FilledButton/OutlinedButton` в golden parity (minimum: enabled/disabled + renderer-only pressed/hover/focus).
  - Cupertino: `RTextButton` совпадает с визуалом `CupertinoButton` (по mapping variant/size) в golden parity.
- **Architecture**:
  - single activation source соблюдён (conformance v2),
  - tap target отделён от visual size (unit tests + отсутствие регрессов в golden layout).
- **Tooling**: `melos run analyze` и `melos run test` зелёные.

---

## 9) Follow-ups (явно out of scope)

- Ripple strategy для parity (если нужно) — отдельная итерация: либо внешний pressable surface, либо controlled "ink" эффекты от component gestures.
- Расширение `HeadlessTapTargetPolicy` на другие pressable компоненты (checkbox/switch/listTile).
- Parity-by-reuse для не-кнопочных компонентов — отдельные ADR/итерации (не переносим решение автоматически).
- **I37**: appearance-variants (`filled/tonal/outlined/text`), deterministic focus highlight, token-mode, demo/tests.

