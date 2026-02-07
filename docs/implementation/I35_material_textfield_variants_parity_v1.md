## I35 — headless_material: Material TextField variants parity v1 (filled/outlined/underlined)

### Цель

Сделать в `packages/headless_material` визуал `RTextField` **максимально идентичным** Flutter Material `TextField` (Material 3), включая:

- геометрию (contentPadding, min height),
- поведение label (floating + outline gap),
- анимации (duration/curve, hint fade),
- отображение hint/helper/error,
- корректное поведение border’ов для состояний (enabled/focused/error/disabled),
- корректные пространства для prefix/suffix/prefixIcon/suffixIcon.

Варианты (intent):

- `RTextFieldVariant.filled`
- `RTextFieldVariant.outlined`
- `RTextFieldVariant.underlined`

---

## 0) Источник истины (Flutter stable, pinned)

В этой итерации **никаких “похожих” значений** — только exact parity по исходникам Flutter.

Используем последнюю stable версию в окружении:

- Flutter `3.38.6` stable, framework revision `8b87286849`

Ссылки на исходники (зафиксированы по revision):

- `InputDecorator` / `InputDecoration`:  
  `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart`
- `TextField` (effective decoration via theme):  
  `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/text_field.dart`
- `InputBorder` (gap для floating label):  
  `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_border.dart`

### 0.1 Material 3 only (policy)

Эта итерация — **только Material 3**. Поддержку “старого Material” мы не делаем.

Технически это означает:

- В preset’е `headless_material` мы считаем `Theme.of(context).useMaterial3 == true` обязательным.
- Golden parity тесты всегда прогоняем только с `ThemeData(useMaterial3: true)`.
- Если `useMaterial3 == false`, реализацию можно:
  - либо явно “фейлить” (лучше — чтобы не было тихого расхождения),
  - либо документированно маппить в ближайший M3‑эквивалент (но это уже не parity).

---

## 1) Ключевой дизайн‑выбор: не переписывать `InputDecorator`, а переиспользовать

### Почему

`InputDecorator` содержит **точные**:

- анимации (`167ms`, `fastOutSlowIn`, reverseCurve),
- геометрию (матрица contentPadding для **Material 3** + isDense + outline vs underline),
- min hit target (через `kMinInteractiveDimension`),
- outline gap (через `_InputBorderGap` и `border.isOutline`),
- логику hint fade (AnimatedOpacity/AnimatedSwitcher с `20ms` default).

Копирование этой логики руками почти гарантирует расхождения.

### Как

`RTextField` остаётся владельцем поведения и создаёт `EditableText`. Renderer получает готовый `request.input` и строит вокруг него **`InputDecorator`**.

Нам нужно добиться того, чтобы `InputDecorator` получил “такой же” `InputDecoration`, как Flutter `TextField`, и “правильные” флаги состояния:

- `isFocused`
- `isHovering`
- `isEmpty`
- `expands`
- `isDense`
- `isCollapsed` (мы его не используем в v1)

### 1.1 Как Flutter `TextField` использует `InputDecorator` (reference)

Flutter `TextField` оборачивает `EditableText` в `InputDecorator` и прокидывает:

- `decoration: _getEffectiveDecoration()` (уже нормализованная через `applyDefaults`)
- `baseStyle: widget.style`
- `isHovering/isFocused/isEmpty/expands`

Source:

- `text_field.dart` (InputDecorator wrapper)  
  `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/text_field.dart#L1753-L1770`

Важно для нас:

- `RTextField` уже сам перестраивается при изменениях focus/hover/text, поэтому нам не нужен отдельный `AnimatedBuilder` как в Flutter.
- Но мы должны **прокидывать те же флаги** (`isEmpty` именно из текста, `isFocused` из FocusNode, `isHovering` из hover state).

---

## 2) Точные значения и логика (ссылки на строки)

### 2.1 Анимации label/border (duration/curve)

В Flutter:

- `_kTransitionDuration = 167ms`  
  `input_decorator.dart#L37-L42`
- `_kTransitionCurve = Curves.fastOutSlowIn`  
  `input_decorator.dart#L39-L41`
- `_kFinalLabelScale = 0.75`  
  `input_decorator.dart#L39-L42`

Ссылки:

- `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L37-L42`

### 2.2 Border container animation (shape tween + hover)

В Flutter `_BorderContainerState`:

- hover duration: `15ms` (`_kHoverDuration`)  
- border animation: `AnimationController(duration: _kTransitionDuration)` + `CurvedAnimation(curve: _kTransitionCurve, reverseCurve: flipped)`
- hover animation: linear
- при изменении border: controller сбрасывается на `0.0` и `forward()`

Source:

- `input_decorator.dart` `_BorderContainerState.initState/didUpdateWidget`  
  `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L201-L283`

### 2.2.1 M3: как именно рисуется fill + hover (alphaBlend по outerPath border’а)

Чтобы совпасть визуально, важно понимать, что `InputDecorator` рисует контейнер **не виджетом**, а через `CustomPaint`:

- `_InputBorderPainter.blendedColor` = `alphaBlend(hoverColorTween.evaluate(hoverAnimation), fillColor)`
- fill рисуется **по `border.getOuterPath(...)`**, т.е. форма/радиусы fill берутся из `InputBorder` (Underline/Outline).

Source:

- `_InputBorderPainter.paint()` + `blendedColor`  
  `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L114-L160`

И следствие для наших variants:

- `filled` + `UnderlineInputBorder` → заливка с верхними радиусами (как Material filled), потому что `UnderlineInputBorder` по дефолту имеет topLeft/topRight radius `4.0`.
- `outlined` (filled=false) → fillColor прозрачный → заливки нет, остаётся только outline.

### 2.3 Floating label controller + решение “label should withdraw”

В Flutter `_InputDecoratorState`:

- `_floatingLabelController` / `_floatingLabelAnimation` с теми же `167ms` и `fastOutSlowIn` (reverse flipped)
- начальное положение label выставляется в `didChangeDependencies()`:
  - label “изначально floating”, если `floatingLabelBehavior != never` и `labelShouldWithdraw`
- `labelShouldWithdraw` true, если:
  - `widget._labelShouldWithdraw` **или**
  - `floatingLabelBehavior == always`

Source:

- initState/didChangeDependencies/labelShouldWithdraw  
  `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L2013-L2069`

### 2.3.1 M3: стили label/hint/helper/error (и почему это важно)

В M3 `InputDecorator` берёт стили не “из воздуха”, а через явные функции, которые мерджат:

- `themeData.textTheme` (база),
- `widget.baseStyle` (база EditableText),
- defaults из `_InputDecoratorDefaultsM3`,
- overrides из `InputDecorationTheme` / `InputDecoration`.

Source (точные мерджи):

- Inline label style: `_getInlineLabelStyle()`  
  `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L2176-L2186`
- Inline hint style (для M3 база = `bodyLarge`): `_getInlineHintStyle()`  
  `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L2190-L2201`
- Floating label style: `_getFloatingLabelStyle()`  
  `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L2203-L2225`
- Helper/Error style: `_getHelperStyle()` / `_getErrorStyle()`  
  `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L2227-L2239`

### 2.3.2 Точная логика “label vs hint” (inline label вытесняет hint)

В Flutter есть жёсткое правило:

- label может быть “inline” (в месте hint), если:
  - label есть,
  - `labelShouldWithdraw == false`
- hint показывается только если `isEmpty && !_hasInlineLabel`

Source:

- `_hasInlineLabel` / `_shouldShowLabel`  
  `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L2163-L2172`
- hint show condition (`showHint = isEmpty && !_hasInlineLabel`)  
  `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L2337-L2351`

### 2.4 Hint fade (точное поведение)

В Flutter:

- default hint fade duration: `20ms` (`_kHintFadeTransitionDuration`)
- hint показывается, когда `isEmpty && !_hasInlineLabel`
- если `maintainHintSize`:
  - `AnimatedOpacity(duration: hintFadeDuration ?? 20ms, curve: _kTransitionCurve)`
  иначе:
  - `AnimatedSwitcher(duration: hintFadeDuration ?? 20ms, transitionBuilder: _buildTransition)`

Source:

- `input_decorator.dart` hint block  
  `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L2320-L2351`

### 2.5 Content padding (Material 3 only) + floatingLabelHeight

В Flutter padding вычисляется в build (после resolve direction), с ветвлениями:

- `isCollapsed -> EdgeInsetsDirectional.zero`
- `!border.isOutline`:
  - `floatingLabelHeight = scale(4.0 + 0.75 * labelFontSize)`
  - если `filled == true`:
    - M3 dense: `fromSTEB(12, 4, 12, 4)`
    - M3 normal: `fromSTEB(12, 8, 12, 8)`
  - если `filled == false` (underline и НЕ filled):
    - M3 dense: `fromSTEB(0, 4, 0, 4)`
    - M3 normal: `fromSTEB(0, 8, 0, 8)`
- `border.isOutline == true`:
  - `floatingLabelHeight = 0.0`
  - M3 dense: `fromSTEB(12, 16, 12, 8)`
  - M3 normal: `fromSTEB(12, 20, 12, 12)`

Source (код, который реально задаёт значения):

- `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L2550-L2628`

Source (док-комментарий в `InputDecoration.contentPadding`, полезен как “таблица”):

- `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L3296-L3309`

### 2.6 inputGap (M3)

В Flutter (Material3):

- если `border is OutlineInputBorder`: `inputGap = border.gapPadding`
- иначе: `inputGap = border.isOutline || filled ? _kInputExtraPadding(=4.0) : 0.0`

Source:

- `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L2630-L2637`

### 2.7 Min height / kMinInteractiveDimension

В Flutter при layout высоты контейнера:

- `contentHeight` включает `contentPadding`, topHeight/bottomHeight, baseline поправки и `visualDensity`.
- `minContainerHeight`:
  - если `isDense || isCollapsed || expands` → `inputHeight`
  - иначе → `kMinInteractiveDimension`
- если контент меньше min, добавляется `interactiveAdjustment` для вертикального центрирования

Source:

- `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L1105-L1130`

### 2.8 M3 defaults: activeIndicatorBorder / outlineBorder / fillColor (точные state rules)

Для parity важно не “угадывать” цвета/толщины, а опираться на M3 defaults, которые в Flutter генерируются из Material token DB.

Source:

- `_InputDecoratorDefaultsM3` (generated token properties):  
  `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L5897`

Ключевые правила (точные, в коде):

- `fillColor`:
  - disabled: `onSurface opacity 0.04`
  - enabled: `surfaceContainerHighest`
  - `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L5924-L5930`
- `activeIndicatorBorder` (underline‑ветка):
  - focused: width **2.0**, color primary/error
  - hovered: использует `onSurface` (или `onErrorContainer` в error)
  - default: `onSurfaceVariant`
  - `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L5932-L5953`
- `outlineBorder` (outline‑ветка):
  - disabled: `onSurface opacity 0.12`
  - focused: width **2.0**, color primary/error
  - hovered: `onSurface` (или `onErrorContainer` в error)
  - default: `outline`
  - `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L5955-L5976`

### 2.9 InputDecorationThemeData defaults (M3 behavior defaults)

В M3 важно учитывать дефолты темы, иначе parity сломается “тихо”:

- `floatingLabelBehavior` default = `auto`
- `floatingLabelAlignment` default = `start`
- `isDense` default = `false`
- `filled` default = `false`

Source:

- `InputDecorationTheme` ctor defaults  
  `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L4352-L4377`

### 2.10 M3: default border selection (states + filled vs not filled)

В Flutter `InputDecorator` делает два важных шага:

1) Выбирает **какой border использовать по состояниям**:
- disabled → `disabledBorder` или `errorBorder`
- focused → `focusedBorder` или `focusedErrorBorder`
- иначе → `enabledBorder` или `errorBorder`
- если ничего не задано → `_getDefaultBorder(...)`

Source:

- `input_decorator.dart` (border selection + fallback)  
  `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L2353-L2362`

2) В M3 `_getDefaultBorder` подставляет `borderSide` так:

- если `decoration.filled == true` → `activeIndicatorBorder` (2.0 в focused)
- иначе → `outlineBorder` (2.0 в focused)

Source:

- `input_decorator.dart` `_getDefaultBorder` (M3 branch)  
  `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L2248-L2274`

### 2.11 Дефолтная геометрия `UnderlineInputBorder` / `OutlineInputBorder` (важно для parity)

Мы не должны “придумывать” радиусы/зазоры — берём дефолты Flutter:

- `UnderlineInputBorder`:
  - top-left/top-right radius = **4.0**
  - Source: `input_border.dart` ctor docs/values  
    `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_border.dart#L143-L170`
- `OutlineInputBorder`:
  - radius = **4.0** (все углы)
  - `gapPadding = 4.0`
  - Source: `input_border.dart` ctor docs/values  
    `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_border.dart#L307-L333`

### 2.12 TextField M3: input style + cursor/selection defaults (EditableText parity)

Чтобы поле выглядело “как Flutter”, важно совпадать не только декорацией, но и тем, как Flutter задаёт стиль ввода и курсор/selection:

- M3 input style: `Theme.of(context).textTheme.bodyLarge`
  - Source: `_m3InputStyle`  
    `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/text_field.dart#L1875-L1883`
- Cursor color / selection color (Android/Fuchsia/Linux/Windows):
  - `cursorColor`: error → errorColor, иначе `widget.cursorColor ?? DefaultSelectionStyle.cursorColor ?? theme.colorScheme.primary`
  - `selectionColor`: `DefaultSelectionStyle.selectionColor ?? theme.colorScheme.primary.withOpacity(0.40)`
  - Source: `text_field.dart` build (platform switch)  
    `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/text_field.dart#L1531-L1662`

---

## 3) Mapping: `RTextFieldVariant` → `InputDecoration` (как добиться parity)

В Flutter “variant” — это комбинация параметров `InputDecoration`:

### 3.1 `underlined`

- border: `UnderlineInputBorder` (default), затем `InputDecorator` сам выбирает `enabled/focused/error/disabled` и подставляет default border через `_getDefaultBorder()`.
- `filled == false` по умолчанию
- ключевой эффект: contentPadding по ветке “underline + not filled” (M3: `0,4/8,0,4/8`)

### 3.2 `outlined`

- border: `OutlineInputBorder` (важно для outline gap)
- contentPadding по ветке `isOutline` (M3: `12,16/20,12,8/12`)
- outline gap и floating label transform остаются внутри `InputDecorator`

### 3.3 `filled`

- `filled: true`
- `fillColor`: из `InputDecorationTheme` (через applyDefaults) и/или material defaults (`_InputDecoratorDefaultsM3`)
- border остаётся тем, который получается как “effective decoration” после `applyDefaults(...)`

Важно: чтобы совпадать с Flutter, мы должны использовать **тот же шаг нормализации**, что `TextField`:

- `(decoration ?? const InputDecoration()).applyDefaults(themeData.inputDecorationTheme)`
  - Source: `text_field.dart` `_getEffectiveDecoration()`  
    `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/text_field.dart#L1193-L1204`

И аналогично внутри `InputDecorator`:

- `widget.decoration.applyDefaults(InputDecorationTheme.of(context))`
  - Source: `input_decorator.dart` getter `decoration`  
    `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L2054-L2057`

### 3.4 Маппинг `RTextFieldSpec` → `InputDecoration` (parity‑режим)

Чтобы визуал/анимации совпали с Flutter, мы должны “кормить” `InputDecorator` теми же смыслами:

- `spec.placeholder` → `InputDecoration.hintText`
  - В Flutter hint показывается при `isEmpty && !_hasInlineLabel`  
    (см. `input_decorator.dart` hint block: `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L2320-L2351`)
- `spec.label` → `InputDecoration.labelText`
  - Тогда label будет inline/floating ровно по логике `InputDecorator` (withdraw + scale/transform)
- `spec.helperText` → `InputDecoration.helperText`
- `spec.errorText` → `InputDecoration.errorText`
- `enabled` (из `RTextField.enabled`) → `InputDecoration.enabled`
  - важно, потому что `InputDecorator` использует `decoration.enabled` для widgetState и label withdraw
- `spec.maxLines` → `InputDecoration.hintMaxLines`
  - по аналогии с Flutter `TextField`, который в `_getEffectiveDecoration()` подставляет `widget.maxLines` как fallback  
    `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/text_field.dart#L1193-L1204`

Важно: в parity‑режиме **не задаём руками** `contentPadding`, `constraints`, `labelStyle`, `floatingLabelStyle`, `fillColor`, `outlineBorder` и т.п. — это источник расхождений. Всё это приходит из `InputDecorationThemeData` (M3) и defaults `_InputDecoratorDefaultsM3`.

### 3.5 Маппинг `RTextFieldSlots` → `InputDecoration` (parity‑режим)

В Flutter структура “иконки vs inline affixes” задаётся через поля `InputDecoration`, поэтому маппим так:

- `slots.leading` → `InputDecoration.prefixIcon`
- `slots.trailing` → `InputDecoration.suffixIcon`
- `slots.prefix` → `InputDecoration.prefix`
- `slots.suffix` → `InputDecoration.suffix`

Notes:

- `InputDecorator` сам выставляет `IconTheme`/цвета для `prefixIcon/suffixIcon` через M3 defaults (`prefixIconColor/suffixIconColor`) — мы не должны “перекрашивать” заранее, иначе легко уехать от Flutter.
  - Source: `_getPrefixIconColor/_getSuffixIconColor`  
    `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/input_decorator.dart#L2140-L2161`
- В v1 parity **не используем** `InputDecoration.icon` (иконка вне контейнера), потому что в contracts нет отдельного слота под “вне контейнера слева”, а также потому что это меняет внешнюю геометрию (и усложняет parity).

### 3.6 Headless‑фичи, которые НЕ входят в Flutter Material parity (и как с ними жить)

Есть свойства `RTextField`, которые сознательно добавлены ради кросс‑платформенности, но у Flutter Material `TextField` нет их аналога:

- `clearButtonMode`
  - В Material parity режиме: **не реализуем** как built‑in визуал (по дефолту `never`)
  - Если нужен clear button — его нужно дать как `slots.trailing` (тогда это уже кастом, не parity).
- `prefixMode/suffixMode`
  - В parity режиме по умолчанию они `always`, поэтому на визуал не влияют.
  - Если включены другие режимы — это intentional deviation от Flutter (документируем как “headless extension”).

---

## 4) Архитектура в `headless_material` (SOLID/DRY)

Ключевая цель: renderer остаётся “координатором”, а сложные части — в отдельные классы/виджеты (без `_build*`).

### 4.0 Один источник правды (важно для DRY и parity)

Чтобы parity реально держалась, нам нельзя иметь два конкурирующих источника “дизайна”:

- **Source of truth для декорации**: `InputDecorator` + `InputDecoration` + `InputDecorationThemeData` (M3).
- **Source of truth для поведения**: `RTextField` (EditableText/focus/IME/a11y/commands).
- `RTextFieldResolvedTokens` в M3 parity режиме:
  - не должны “перерисовывать” рамки/паддинги поверх `InputDecorator`,
  - могут использоваться только там, где это нужно для `EditableText` (text/cursor/selection), и только если они 1‑в‑1 совпадают с Flutter.

### 4.0.1 Политика overrides/tokens в parity‑режиме (что разрешено, а что запрещено)

Чтобы parity была стабильной и повторяемой, фиксируем:

**Запрещено влиять через `RTextFieldOverrides`/`RTextFieldStyle` на декорацию** (потому что это ломает `InputDecorator` parity):

- container: `containerPadding/containerBackgroundColor/containerBorder* / containerElevation / containerAnimationDuration`
- label/helper/error: `labelStyle/labelColor/helperStyle/helperColor/errorStyle/errorColor/messageSpacing`
- slots/icons: `iconColor/iconSpacing`

Всё перечисленное должно приходить только из:

- `ThemeData(useMaterial3: true)` + `InputDecorationThemeData`
- M3 defaults (`_InputDecoratorDefaultsM3`)

**Разрешено** (и применимо только к `EditableText`, не к `InputDecorator`):

- `textStyle/textColor` — но в parity baseline ожидаем совпадение с M3 (`TextField` использует `bodyLarge`)
- `cursorColor/selectionColor` — только если совпадает с логикой `TextField` (иначе это deviation)
- `minSize` — для parity baseline ставим `Size.zero`, чтобы не навязывать minWidth (Flutter его не навязывает)

Если нужен кастомный дизайн поверх M3 (не parity):

- делаем это через `ThemeData.inputDecorationTheme` (как Flutter),
- либо через `MaterialTextFieldOverrides` (preset-specific), понимая что это уже intentional deviation.

### 4.1 Файловая структура (slice)

`packages/headless_material/lib/src/textfield/`

- `material_text_field_renderer.dart`
  - собирает `InputDecoration` и строит `InputDecorator`
  - НЕ содержит большой верстки
- `material_text_field_input_decorator.dart`
  - тонкая обёртка над `InputDecorator` (только прокидывает флаги/child/decoration)
- `material_text_field_decoration_factory.dart`
  - чистый builder: `RTextFieldRenderRequest` → `InputDecoration`
  - маппинг `variant → (filled/border)` + перенос label/hint/helper/error
  - маппинг slots → `prefixIcon/suffixIcon/prefix/suffix`
- `material_text_field_state_adapter.dart`
  - адаптация `request.state/spec` → флаги `InputDecorator` (`isEmpty`, `isFocused`, `isHovering`, `isDense`, ...)
- `material_text_field_affix_visibility_resolver.dart`
  - чистая логика видимости prefix/suffix по `RTextFieldOverlayVisibilityMode`

### 4.2 Принципы зависимостей

- Renderer зависит только от:
  - `headless_contracts` (request/spec/state/slots),
  - `flutter/material.dart` (InputDecorator/InputDecoration),
  - preset overrides (опционально) и ThemeData.
- Никаких material-параметров в `headless_contracts`.
- Любые дополнительные режимы (не покрываемые `variant`) — только через `MaterialTextFieldOverrides` (preset-specific).

### 4.3 Migration note (из текущего renderer’а)

Сейчас `MaterialTextFieldRenderer` рисует поле вручную (container/placeholder/label) и использует `MaterialTextFieldTokenResolver`. Для parity‑итерации это нужно заменить на `InputDecorator`‑подход, иначе мы будем постоянно “догонять” Flutter.

Подход миграции (без полумер):

- Вынести новую реализацию в отдельные файлы (см. 4.1).
- Переключить capability `RTextFieldRenderer` в `headless_material` на новую реализацию.
- Добавить golden parity tests, чтобы зафиксировать визуал.

### 4.4 Решения, которые фиксируем перед началом кода (чтобы не было “развилок”)

1) **`variant` всегда сильнее theme border**

- Иначе variant может “случайно” поменяться через `ThemeData.inputDecorationTheme.border`, и parity станет непредсказуемой.
- Поэтому `MaterialTextFieldDecorationFactory` всегда выставляет:
  - `underlined` → `border: const UnderlineInputBorder()`, `filled: false`
  - `outlined` → `border: const OutlineInputBorder()`, `filled: false`
  - `filled` → `border: const UnderlineInputBorder()`, `filled: true`

2) **В parity режиме декорацию определяет `InputDecorator` (M3), а не tokens**

- `RTextFieldResolvedTokens` не должны влиять на `InputDecoration` (padding/border/fill/label styles).
- Tokens могут использоваться только для `EditableText` (text/cursor/selection) и только если совпадают с Flutter M3.

3) **В parity режиме исключаем non‑Flutter affordances**

- `clearButtonMode` игнорируем (по дефолту `never`).
- `prefixMode/suffixMode` по дефолту `always` (в тестах и baseline). Другие режимы — это расширение, отдельно от parity.

4) **Material 3 только**

- Если `Theme.of(context).useMaterial3 == false`, renderer должен выбрасывать понятную ошибку (чтобы не было тихого “почти как”).

---

## 5) Тесты (критично для “точно соответствует”)

### 5.0 Parity harness (как сравниваем с Flutter без “на глаз”)

Так как golden‑инфраструктуры в репозитории нет, в рамках итерации добавляем минимальный набор golden тестов на `flutter_test`:

- строим виджет‑хост с `ThemeData(useMaterial3: true)` и фиксированными параметрами (textScaleFactor/devicePixelRatio);
- рендерим **пару** рядом (или в разных golden’ах):
  - слева: `RTextField` через `HeadlessMaterialApp`/material theme provider,
  - справа: эталонный Flutter `TextField` с соответствующим `InputDecoration`.

Цель harness’а: любое расхождение в padding/label animation/border сразу видно как diff.

### 5.1 Golden parity tests

Golden сравнения `RTextField` (в `HeadlessMaterialApp`) против Flutter `TextField` с тем же `ThemeData`:

- `underlined`: `TextField()` (дефолт)
- `outlined`: `TextField(decoration: InputDecoration(border: OutlineInputBorder()))`
- `filled`: `TextField(decoration: InputDecoration(filled: true))`

Кейсы:

- empty vs hasText
- focused/unfocused
- errorText
- disabled
- prefix/suffix/prefixIcon/suffixIcon
- multiline

Важно для “чистого parity”:

- В baseline golden’ах не используем `clearButtonMode` и нестандартные `prefixMode/suffixMode` (оставляем дефолты).
- Не добавляем кастомные `RTextFieldStyle`/`RenderOverrides`, которые влияют на декорацию.

### 5.2 Motion evidence

Минимально: тест, который фокусит поле и снимает фокус, фиксируя:

- наличие анимации (progress меняется)
- длительность/кривая соответствует `InputDecorator` (через использование самого `InputDecorator`, а не ручные анимации)

---

## 6) Acceptance criteria

- Визуально `RTextField` в `headless_material` совпадает с Flutter `TextField` по variant'ам (`filled/outlined/underlined`) на golden тестах.
- Padding/мин. высота/label/hint/border ведут себя так же (см. ссылки на source of truth).
- Код в preset'е остаётся читаемым и модульным (SOLID/DRY, без копипасты `InputDecorator` логики).

---

## 7) Что реализовано в коде

### Архитектура
- 5 source-файлов: renderer, input_decorator, decoration_factory, state_adapter, affix_visibility_resolver
- Renderer делегирует визуал `InputDecorator` — не рисует контейнер/границы руками

### Ключевые решения (зафиксированы в коде)
- `baseStyle`: всегда null — `InputDecorator` сам берёт `bodyLarge` из M3 defaults
- `HeadlessRendererPolicy`: renderer не проверяет strict tokens policy — ему tokens не нужны
- Parity harness использует `EditableText` (не Text/SizedBox.shrink) для реалистичного baseline/height

### Тестовое покрытие
- Parity golden тесты (side-by-side renderer vs native TextField)
- Motion evidence goldens (filled/outlined/underlined/helper→error, 3 snapshot per transition)
- Unit-тесты: DecorationFactory, StateAdapter, AffixVisibilityResolver, Renderer pipeline
- Parity invariant guards: factory НЕ задаёт contentPadding/constraints/labelStyle/fillColor/etc.
- E2E guard: renderer → InputDecorator property propagation (variant/error/slots/affix visibility)
- E2E parity test: RTextField via HeadlessMaterialApp (3 variants × 4 states + slots)
- E2E golden parity: RTextField (via HeadlessThemeProvider) vs native TextField side-by-side (3 variants × 3 states = 9 goldens)

### Parity levels
- **Renderer-only** (51 goldens): renderer + InputDecorator side-by-side, без headless stack
- **E2E** (9 goldens): полный headless stack (HeadlessThemeProvider → RTextField → renderer) vs native TextField

---

## 8) Golden file inventory

| Golden file | Variant | State | Test file | Type |
|---|---|---|---|---|
| `filled_empty_unfocused.png` | filled | empty, unfocused | parity_test | side-by-side |
| `filled_empty_focused.png` | filled | empty, focused | parity_test | side-by-side |
| `filled_hastext_unfocused.png` | filled | hasText, unfocused | parity_test | side-by-side |
| `filled_helper.png` | filled | helper | parity_test | side-by-side |
| `filled_error.png` | filled | error | parity_test | side-by-side |
| `filled_error_focused.png` | filled | error, focused | parity_test | side-by-side |
| `filled_disabled.png` | filled | disabled | parity_test | side-by-side |
| `filled_hovered_unfocused.png` | filled | hovered, unfocused | parity_extras | side-by-side |
| `filled_hovered_focused.png` | filled | hovered, focused | parity_extras | side-by-side |
| `outlined_empty_unfocused.png` | outlined | empty, unfocused | parity_test | side-by-side |
| `outlined_empty_focused.png` | outlined | empty, focused | parity_test | side-by-side |
| `outlined_hastext_unfocused.png` | outlined | hasText, unfocused | parity_test | side-by-side |
| `outlined_hastext_focused.png` | outlined | hasText, focused | parity_test | side-by-side |
| `outlined_helper.png` | outlined | helper | parity_test | side-by-side |
| `outlined_error.png` | outlined | error | parity_test | side-by-side |
| `outlined_error_focused.png` | outlined | error, focused | parity_test | side-by-side |
| `outlined_disabled.png` | outlined | disabled | parity_test | side-by-side |
| `underlined_empty_unfocused.png` | underlined | empty, unfocused | parity_test | side-by-side |
| `underlined_empty_focused.png` | underlined | empty, focused | parity_test | side-by-side |
| `underlined_hastext_unfocused.png` | underlined | hasText, unfocused | parity_test | side-by-side |
| `underlined_helper.png` | underlined | helper | parity_test | side-by-side |
| `underlined_error.png` | underlined | error | parity_test | side-by-side |
| `underlined_error_focused.png` | underlined | error, focused | parity_test | side-by-side |
| `underlined_disabled.png` | underlined | disabled | parity_test | side-by-side |
| `multiline_filled_maxlines3.png` | filled | multiline | parity_test | side-by-side |
| `multiline_outlined_maxlines3.png` | outlined | multiline | parity_test | side-by-side |
| `multiline_underlined_maxlines3.png` | underlined | multiline | parity_test | side-by-side |
| `slots_prefix_suffix_icon.png` | filled | prefixIcon+suffixIcon | parity_test | side-by-side |
| `slots_prefix_suffix_widget.png` | filled | prefix+suffix | parity_test | side-by-side |
| `prefix_whileediting_focused.png` | filled | prefix, whileEditing, focused | parity_extras | renderer-only |
| `prefix_whileediting_unfocused.png` | filled | prefix, whileEditing, unfocused | parity_extras | renderer-only |
| `prefix_notediting_focused.png` | filled | prefix, notEditing, focused | parity_extras | renderer-only |
| `prefix_notediting_unfocused.png` | filled | prefix, notEditing, unfocused | parity_extras | renderer-only |
| `suffix_whileediting_focused.png` | filled | suffix, whileEditing, focused | parity_extras | renderer-only |
| `suffix_whileediting_unfocused.png` | filled | suffix, whileEditing, unfocused | parity_extras | renderer-only |
| `suffix_notediting_focused.png` | filled | suffix, notEditing, focused | parity_extras | renderer-only |
| `suffix_notediting_unfocused.png` | filled | suffix, notEditing, unfocused | parity_extras | renderer-only |
| `motion_t0_unfocused.png` | filled | motion t=0 | motion_test | motion |
| `motion_t83_mid.png` | filled | motion t=83ms | motion_test | motion |
| `motion_t167_focused.png` | filled | motion t=167ms | motion_test | motion |
| `motion_outlined_t0_unfocused.png` | outlined | motion t=0 | motion_test | motion |
| `motion_outlined_t83_mid.png` | outlined | motion t=83ms | motion_test | motion |
| `motion_outlined_t167_focused.png` | outlined | motion t=167ms | motion_test | motion |
| `motion_underlined_t0_unfocused.png` | underlined | motion t=0 | motion_test | motion |
| `motion_underlined_t83_mid.png` | underlined | motion t=83ms | motion_test | motion |
| `motion_underlined_t167_focused.png` | underlined | motion t=167ms | motion_test | motion |
| `motion_helper_t0.png` | filled | helper→error t=0 | motion_test | motion |
| `motion_helper_error_t83_mid.png` | filled | helper→error t=83ms | motion_test | motion |
| `motion_error_t167.png` | filled | helper→error t=167ms | motion_test | motion |
| `motion_outlined_placeholder_t0.png` | outlined | placeholder t=0 | motion_test | motion |
| `motion_outlined_placeholder_t83_mid.png` | outlined | placeholder t=83ms | motion_test | motion |
| `motion_outlined_placeholder_t167_focused.png` | outlined | placeholder t=167ms | motion_test | motion |

Total: **51 renderer/motion golden files**

### E2E golden parity (RTextField via HeadlessThemeProvider vs native TextField)

| Golden file | Variant | State | Test file | Type |
|---|---|---|---|---|
| `e2e_filled_empty.png` | filled | empty, unfocused | e2e_golden_parity_test | e2e side-by-side |
| `e2e_filled_error.png` | filled | error | e2e_golden_parity_test | e2e side-by-side |
| `e2e_filled_disabled.png` | filled | disabled | e2e_golden_parity_test | e2e side-by-side |
| `e2e_outlined_empty.png` | outlined | empty, unfocused | e2e_golden_parity_test | e2e side-by-side |
| `e2e_outlined_error.png` | outlined | error | e2e_golden_parity_test | e2e side-by-side |
| `e2e_outlined_disabled.png` | outlined | disabled | e2e_golden_parity_test | e2e side-by-side |
| `e2e_underlined_empty.png` | underlined | empty, unfocused | e2e_golden_parity_test | e2e side-by-side |
| `e2e_underlined_error.png` | underlined | error | e2e_golden_parity_test | e2e side-by-side |
| `e2e_underlined_disabled.png` | underlined | disabled | e2e_golden_parity_test | e2e side-by-side |

Total: **9 E2E golden files**

### Grand total: **60 golden files** (51 renderer/motion + 9 E2E)

---

## 9) Golden hygiene rules

- Каждый PNG в `goldens/` обязан иметь ровно один `matchesGoldenFile()` вызов в тестах.
- Сирот (golden без теста) быть не должно.
- Команда обновления: `melos run update-goldens`
- После обновления goldens обязательно визуально проверить diff.

---

## 10) v1 known limitations

- `expands`: всегда `false` (требует `RTextFieldSpec.expands` — не в contracts).
- `GestureDetector`: только tap-to-focus, без selection gestures.
- Token resolver: container/label/icon токены resolved, но не читаются renderer'ом в parity mode — `InputDecorator` предоставляет M3 defaults напрямую.
- `backgroundCursorColor`: headless fallback (`cursorColor × 0.2`), не платформенный (Flutter использует `colorScheme.onSurface` на non-iOS).

