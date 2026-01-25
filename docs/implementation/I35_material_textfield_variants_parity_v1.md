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

---

## 4) Архитектура в `headless_material` (SOLID/DRY)

Ключевая цель: renderer остаётся “координатором”, а сложные части — в отдельные классы/виджеты (без `_build*`).

### 4.1 Файловая структура (slice)

`packages/headless_material/lib/src/textfield/`

- `material_text_field_renderer.dart`
  - собирает `InputDecoration` и строит `InputDecorator`
  - НЕ содержит большой верстки
- `material_text_field_decoration_factory.dart`
  - чистый builder: `RTextFieldRenderRequest` → `InputDecoration`
  - маппинг `variant → (filled/border)` + перенос label/hint/helper/error
  - маппинг slots → `prefixIcon/suffixIcon/prefix/suffix`
- `material_text_field_state_adapter.dart`
  - адаптация `request.state/spec` → флаги `InputDecorator` (`isEmpty`, `isFocused`, `isHovering`, `isDense`, ...)

### 4.2 Принципы зависимостей

- Renderer зависит только от:
  - `headless_contracts` (request/spec/state/slots),
  - `flutter/material.dart` (InputDecorator/InputDecoration),
  - preset overrides (опционально) и ThemeData.
- Никаких material-параметров в `headless_contracts`.
- Любые дополнительные режимы (не покрываемые `variant`) — только через `MaterialTextFieldOverrides` (preset-specific).

---

## 5) Тесты (критично для “точно соответствует”)

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

### 5.2 Motion evidence

Минимально: тест, который фокусит поле и снимает фокус, фиксируя:

- наличие анимации (progress меняется)
- длительность/кривая соответствует `InputDecorator` (через использование самого `InputDecorator`, а не ручные анимации)

---

## 6) Acceptance criteria

- Визуально `RTextField` в `headless_material` совпадает с Flutter `TextField` по variant’ам (`filled/outlined/underlined`) на golden тестах.
- Padding/мин. высота/label/hint/border ведут себя так же (см. ссылки на source of truth).
- Код в preset’е остаётся читаемым и модульным (SOLID/DRY, без копипасты `InputDecorator` логики).

