## I33 — Switch Interaction Parity v1 (Material Ink ripple + Drag thumb like Flutter) (part 1)

### Цель

После I32 довести **interaction parity** до уровня оригинальных Flutter `Switch`/`SwitchListTile`:

- **Material**: `RSwitchListTile` получает **реальный Ink ripple** на весь tile (как `SwitchListTile`/`ListTile`).
- **Material + Cupertino**: `RSwitch` / `RCupertinoSwitch` поддерживают **drag thumb**, где thumb следует пальцу/курсору, а track/цвета/outline **интерполируются по прогрессу**, как во Flutter.

Цель достигается **без нарушения single activation source**, и без переноса input‑логики в renderer.

---

### Источники (Flutter reference)

- Material `Switch`: `https://api.flutter.dev/flutter/material/Switch-class.html`
- Material `SwitchListTile`: `https://api.flutter.dev/flutter/material/SwitchListTile-class.html`
- Cupertino `CupertinoSwitch`: `https://api.flutter.dev/flutter/cupertino/CupertinoSwitch-class.html`

Дополнительно (для точного матча поведения):
- Исходники Flutter `switch.dart`, `cupertino/switch.dart`, `switch_list_tile.dart` (порог/velocity/RTL/dragStartBehavior).

---

### Инварианты (обязательные)

1) **Single activation source (I19)**
- Renderer **никогда** не вызывает `onChanged`.
- Renderer **не** ставит `onTap`/`onChanged` на “внутренние” Flutter‑виджеты (`ListTile`, `InkWell`, `GestureDetector`), если это создаёт второй путь активации.
- Единственный источник “toggle” — компонент (`RSwitch`/`RSwitchListTile`).

2) **Spec-first**
- В `Spec` остаётся только то, что описывает поведение/конфигурацию “что это за компонент”.
- Все transient вещи взаимодействия (drag progress) — это `State` компонента.
- Визуальные настройки (shape/splash/overlayColor) **не в spec**: они должны идти через **overrides/tokens** (или через theme defaults + overrides).

3) **Foundation не содержит Material**
- `headless_foundation` остаётся дизайн‑агностичным.
- Всё, что использует `InkResponse/InkWell/Material`, живёт в `headless_material`.

4) **Error policy (I27)**
- Missing theme/capability **не должен ронять release**.
- Компоненты используют `HeadlessThemeProvider.maybeCapabilityOf(...)` и рендерят fallback.

---

## Что делаем

### A) Material ripple на `RSwitchListTile` (как у Flutter `SwitchListTile`)

#### Проблема

Сейчас `MaterialSwitchListTileRenderer` использует `MaterialPressableOverlay` (оверлей), что:
- визуально **не** равно Ink ripple (`InkRipple`/`InkSplash`);
- не повторяет поведение `ListTile` (shape clipping, splashFactory, hover/focus overlay и т.д.).

При этом мы не можем просто поставить `ListTile(onTap: ...)` в renderer — это нарушит single activation source.

#### Решение (каноничное для нашей архитектуры)

1) Добавить в `headless_material` primitive, который **использует Flutter Ink**, но отдаёт “активацию” наружу (мы не пишем ripple сами):

- `MaterialInkPressableSurface` (название примерное; важно: это в `packages/headless_material/lib/src/primitives/`).
- Внутри использует:
  - `Material` (чтобы гарантировать ink слой),
  - `InkResponse` (или `InkWell`) для ripple,
  - `Focus`/`MouseRegion` для hover/focus (по необходимости).
- По input:
  - ловит pointer events (`onTap`, `onTapDown`, `onTapCancel`, hover),
  - вызывает **только** `onActivate` (который даёт компонент).

2) Компонент `RSwitchListTile` становится владельцем pressable surface (а renderer остаётся “тупым”):
- Внутри `build` оборачивает результат renderer’а в pressable surface из theme capability.

3) Как компонент поймёт “мы в Material”?
- Вводим theme capability **в `headless_theme`** (это именно capability, а не renderer‑contract):

`HeadlessPressableSurfaceFactory`:
- метод `Widget wrap({required BuildContext context, required HeadlessPressableController controller, required bool enabled, required VoidCallback onActivate, required Widget child, RenderOverrides? overrides, HeadlessPressableVisualEffectsController? visualEffects, FocusNode? focusNode, bool autofocus = false, MouseCursor? cursorWhenEnabled, MouseCursor? cursorWhenDisabled})`

Material preset регистрирует реализацию (Ink).
Cupertino preset регистрирует реализацию (opacity / без ripple).

**Важно:** capability может использовать `ListTileTheme.of(context)` + `Theme.of(context).splashFactory` для поведения “как Flutter”, без проброса визуальных параметров через spec.

4) Как не нарушить single activation source и не получить двойной tap
- `MaterialSwitchListTileRenderer` оставляет `ListTile(onTap: null)`.
- Интерактивность всего tile даёт **только** capability‑wrapper, который:
  - вызывает `controller.handleTapDown/handleTapUp/handleTapCancel` (как `HeadlessPressableRegion`),
  - и зовёт `onActivate` **ровно один раз**.

5) Per-instance кастомизация ripple не через spec:
- Добавляем контракт overrides (например `RSwitchListTileInteractionOverrides`) с полями:
  - `ShapeBorder? shape` (граница ripple),
  - `double? splashRadius`,
  - `WidgetStateProperty<Color?>? overlayColor` (pressed/hover/focus).
- Capability читает эти overrides и/или дефолты из `ListTileTheme/ThemeData`.

#### Артефакты (A) — конкретно по пакетам
- `packages/headless_theme/lib/src/interaction/headless_pressable_surface_factory.dart` (новый): интерфейс capability.
- `packages/headless_material/lib/src/primitives/material_ink_pressable_surface.dart` (новый): InkResponse wrapper.
- `packages/headless_material/lib/primitives.dart`: export нового primitive.
- `packages/headless_material/lib/src/material_headless_theme.dart`: регистрация capability.
- `packages/headless_cupertino/lib/src/primitives/cupertino_pressable_surface.dart` (новый/или reuse `CupertinoPressableOpacity`): реализация capability.
- `packages/headless_cupertino/lib/src/cupertino_headless_theme.dart`: регистрация capability.
- `packages/headless_contracts/lib/src/renderers/switch_list_tile/r_switch_list_tile_overrides.dart`: добавить `RSwitchListTileInteractionOverrides` (или рядом с list tile overrides).
- `packages/components/headless_switch/lib/src/presentation/r_switch_list_tile.dart`: оборачивать renderer‑результат через capability; fallback по I27.

#### Fallback (I27)
Если capability отсутствует (custom theme, пользователь не подключил preset):
- **Debug/Profile**: assert‑ошибка “Missing capability” через `maybeCapabilityOf`.
- **Release**: `RSwitchListTile` должен:
  - работать без падения,
  - обернуть tile через `HeadlessPressableRegion` + существующий `MaterialPressableOverlay` (не Ink‑ripple, но интеракция не ломается).

---

### B) Drag‑thumb + interpolation трека/цветов (как Flutter `Switch`/`CupertinoSwitch`)

#### Проблема

Текущее поведение построено вокруг:
- `spec.value` (bool),
- `AnimatedAlign` для thumb (0/1).

Это не позволяет:
- непрерывно двигать thumb “за пальцем”,
- интерполировать цвета/outline во время drag.

#### Решение: вводим “позицию” как interaction state + “visual value” preview

1) Расширяем `RSwitchState` (в `headless_contracts`) новыми полями:
- `double? dragT` — позиция thumb \(0..1\) во время drag.
  - `null` означает “не в drag”, thumb определяется `spec.value`.
- `bool? dragVisualValue` — “preview” значения во время drag (чтобы `WidgetStateProperty` и `thumbIcon` могли меняться как в Flutter, когда thumb пересекает середину).
  - `null` означает “preview не активен” (обычный режим).
  - `true/false` означает “визуально считаем switch ON/OFF” во время drag (при этом controlled `spec.value` не меняется, пока не вызван `onChanged`).

Если хотим минимальный контракт — допускается вывести `dragVisualValue` из `dragT` в renderers, но тогда `WidgetStateProperty.resolve(...)` (thumbIcon/colors) не сможет опираться на “selected” во время drag. Для 1:1 лучше добавить поле.

2) Добавляем в компонент `RSwitch` drag‑обработку:
- Критичный момент: **tap и drag находятся в одной gesture arena**. Чтобы не получить “tap toggled + drag toggled”, делаем владение жестами в одном месте:
  - либо расширяем `HeadlessPressableRegion` в `headless_foundation` добавлением `onHorizontalDragStart/Update/End` (предпочтительно: 1 owner для pointer state),
  - либо используем `RawGestureDetector` с явными recognizer’ами и вручную синхронизируем `HeadlessPressableController`.
- Требование: за один pointer gesture `onChanged` вызывается **не более 1 раза**.

- Обработчики:
  - `onHorizontalDragStart / Update / End`,
  - `dragStartBehavior` как во Flutter.
- В drag‑режиме обновляем `dragT` на каждом update:
  - `dragT = clamp01(dragT + deltaX / travelPx)`
  - и обновляем `dragVisualValue` (например `dragT >= 0.5`), с учётом RTL.
- На `dragEnd`:
  - вычисляем `nextValue` по:
    - порогу (`dragT > 0.5`), и
    - velocity (fling) как в Flutter (точные числа берём из исходников).
  - вызываем `onChanged(nextValue)` **ровно один раз**, если значение меняется.
  - сбрасываем `dragT = null` и `dragVisualValue = null`, чтобы визуал снова перешёл в “анимацию до bool”.

3) Renderer становится “умнее” только в смысле визуализации:
- Если `state.dragT != null`:
  - thumb alignment = `lerp(left,right,state.dragT)`
  - цвета/outline/overlay = интерполяция по `dragT`
  - `thumbIcon` и `WidgetStateProperty`‑цвета резолвим через “visual value”:
    - если `dragVisualValue != null` — считаем selected = `dragVisualValue`,
    - иначе selected = `spec.value`.
- Если `state.dragT == null`:
  - поведение остаётся как сейчас: `AnimatedAlign` по `spec.value` и stateChangeDuration.

4) RTL
- Для RTL направление должно быть зеркально:
  - effectiveT = `isRtl ? 1 - t : t`
  - и/или менять “left/right” местами.

5) Параметр `dragStartBehavior` (Flutter parity)
- Чтобы “как Flutter”, добавляем в публичный API `RSwitch.dragStartBehavior`:
  - тип `DragStartBehavior`,
  - default = `DragStartBehavior.start` (как в Flutter `Switch`/`CupertinoSwitch`).

**Важно:** это поведенческий параметр. Рекомендация: добавить в `RSwitchSpec`, чтобы он был частью “static config” и попадал в render request/slots (без зависимости на State).

6) **Как вычислить travelPx без зависимости компонента от tokens**
Это критично для “1:1”: travelPx должен соответствовать реальной геометрии визуала.

Рекомендуемый способ (без доступа к resolver/tokens из component):
- использовать **внутренние “измерительные” wrappers** через typed slots, которыми уже обладает `RSwitchRenderer`:
  - компонент добавляет internal slot wrapper вокруг `track` и `thumb`, который считывает `Size` через `SizeChangedLayoutNotifier`/`LayoutBuilder` и сохраняет в state.
  - далее `travelPx = trackSize.width - thumbSize.width - (внутренние padding’и)`.
  - если padding у renderer фиксированный (как сейчас: Material left/right = 4, Cupertino = 2), фиксируем это в “geometry adapter” рядом с renderer (в `headless_material`/`headless_cupertino`), а компонент использует только измеренные размеры.

Альтернатива (хуже): брать `travelPx` из размеров root. Это будет “похоже”, но не 1:1.

---

## Decision table (чтобы не спорить в коде)

### 1) Gesture owner для tap+drag
- **Вариант A (рекомендую)**: расширить `HeadlessPressableRegion` в `headless_foundation` для горизонтального drag.
  - **Плюсы**: один owner для pointer state; меньше расхождений между компонентами; проще обеспечить “onChanged ≤ 1/gesture”.
  - **Минусы**: изменение foundation API (нужно аккуратно и с тестами).
- **Вариант B**: `RawGestureDetector` внутри `RSwitch` + ручная синхронизация `HeadlessPressableController`.
  - **Плюсы**: не трогаем foundation.
  - **Минусы**: больше edge-cases; выше риск регресса; сложнее поддерживать единый policy.

### 2) Preview-selected во время drag (для thumbIcon/цветов)
- **Вариант A (рекомендую)**: добавить `RSwitchState.dragVisualValue` (как в этом плане).
  - **Плюсы**: `WidgetStateProperty` резолвится предсказуемо “как Flutter”; slots могут реагировать на preview.
  - **Минусы**: расширение contracts.
- **Вариант B**: вычислять “visual selected” в renderer из `dragT >= 0.5`.
  - **Плюсы**: не расширяем contracts.
  - **Минусы**: slots/внешние резолверы не видят preview; сложнее повторить Flutter‑поведение для `WidgetStateProperty`.

#### Артефакты (B) — конкретно по пакетам
- `packages/headless_contracts/lib/src/renderers/switch/r_switch_state.dart`: добавить `dragT` и `dragVisualValue`.
- `packages/components/headless_switch/lib/src/presentation/logic/` (новое): чистые функции “decision”:
  - `switch_drag_decider.dart` (velocity/threshold/RTL).
- `packages/components/headless_switch/lib/src/presentation/r_switch.dart`:
  - raw gesture detector + обновление `dragT/dragVisualValue`,
  - измерение `track/thumb` через internal slot wrappers,
  - соблюдение single activation source.
- `packages/headless_material/lib/src/switch/material_switch_renderer.dart`:
  - ветка `dragT != null`,
  - lerp цветов/outline/overlay по `dragT`,
  - резолв `thumbIcon` по “visual selected”.
- `packages/headless_cupertino/lib/src/switch/cupertino_switch_renderer.dart`: аналогично.

---
