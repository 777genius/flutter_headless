# I34 (part 2) — Реализация UI в `headless_cupertino`: renderer + token resolver + primitives

Оригинальная дока Flutter: [`CupertinoTextField`](https://api.flutter.dev/flutter/cupertino/CupertinoTextField-class.html).

## 0) Инварианты (их нельзя нарушать)

- renderer **НЕ создаёт** `EditableText` и НЕ меняет текст напрямую.
- renderer работает только с:
  - `request.input` (готовый `EditableText` от компонента),
  - `request.resolvedTokens`,
  - `request.spec/state/slots/commands`.
- любые действия UI (focus, clear) идут **через** `request.commands.*`.

---

## 1) Структура файлов (без `_build*`, всё отдельными виджетами)

### 1.1 TextField slice в preset’е

`packages/headless_cupertino/lib/src/textfield/`

- `cupertino_text_field_renderer.dart`
- `cupertino_text_field_token_resolver.dart`
- `r_cupertino_text_field.dart` (wrapper, из part 1)

### 1.2 Primitives

`packages/headless_cupertino/lib/src/primitives/textfield/`

- `cupertino_text_field_surface.dart`
  - только decoration/layout: фон/бордер/радиус/clip/анимация (без поведения)
- `cupertino_text_field_affix.dart`
  - layout-only для prefix/suffix, с уважением `OverlayVisibilityMode`
- `cupertino_text_field_clear_button.dart`
  - iOS‑стиль “clear” (иконка + hitbox), вызывает `commands.clearText`

### 1.3 Overrides

`packages/headless_cupertino/lib/src/overrides/`

- `cupertino_text_field_overrides.dart`
- обновить `cupertino_override_types.dart` (если там централизованный список типов)

#### 1.3.1 `CupertinoTextFieldOverrides` (P0): минимальный контракт и приоритеты

Цель overrides: дать “Cupertino-like” визуальные ручки **без** раздувания `RTextField` props.

Минимальный P0 набор полей:

- `EdgeInsetsGeometry? padding` (override `containerPadding`)
- `bool? isBorderless` (важно: влияет на decoration/clip/анимации, см. ниже)
- (опционально) `BoxDecoration? decorationOverride`
  - использовать осторожно: если его добавить, нужно явно решить, как оно маппится в tokens.

Приоритеты (строго):

1) `CupertinoTextFieldOverrides` (preset-specific)
2) `RTextFieldOverrides` (contract-level)
3) дефолты `CupertinoTextFieldTokenResolver`

Как трактуем `isBorderless`:

- `isBorderless == true` = семантика `CupertinoTextField.borderless` / `decoration: null`:
  - background/border → transparent/0,
  - **clip выключен**,
  - анимации рамки **выключены**.

---

## 2) Визуальные требования (P0) — “похоже на оригинал”, но через tokens

Оригинальный `CupertinoTextField` важен нам как ориентир по дефолтам:

- **rounded border decoration** по умолчанию;
- `borderless` конструктор;
- **padding** по умолчанию `EdgeInsets.all(7.0)`.

Источник: [`CupertinoTextField`](https://api.flutter.dev/flutter/cupertino/CupertinoTextField-class.html).

### 2.1 Как это маппится на наши токены

Мы НЕ добавляем новые contracts ради этого: `RTextFieldResolvedTokens` уже содержит всё нужное:

- контейнер: `containerPadding/background/borderColor/borderRadius/borderWidth/animationDuration`
- ввод: `textStyle/textColor/placeholderStyle/placeholderColor/cursorColor/selectionColor`
- slots: `iconColor/iconSpacing`
- размер: `minSize`

**Следствие:** “пиксель‑подкрутка” делается в `CupertinoTextFieldTokenResolver`, а renderer остаётся простым.

---

## 3) `CupertinoTextFieldTokenResolver` (P0): правила вычисления

Файл: `packages/headless_cupertino/lib/src/textfield/cupertino_text_field_token_resolver.dart`

### 3.1 Inputs

- `CupertinoTheme.of(context)` / `CupertinoTheme.brightnessOf(context)`
- `WidgetState` (focused/disabled/error/hovered)
- overrides (приоритет):
  1) `CupertinoTextFieldOverrides` (preset-specific)
  2) `RTextFieldOverrides` (contract-level)
  3) дефолты cupertino preset

### 3.2 Outputs (P0 defaults — фиксируем явно)

Вместо “примерно” фиксируем конкретные базовые правила:

- `containerPadding`: **по умолчанию** `EdgeInsets.all(7)`
  - для `.borderless` → `EdgeInsets.all(7)` остаётся, но border/фон регулируются
- `containerBorderRadius`: rounded (параметр preset overrides, чтобы можно было менять централизованно)
- `containerBorderColor`:
  - focused: `CupertinoTheme.primaryColor`
  - normal: `resolve(CupertinoColors.separator)`
  - disabled: `resolve(CupertinoColors.separator).withValues(alpha: ...)` (коэффициент — через overrides/константу)
- `containerBackgroundColor`:
  - light/dark: `resolve(CupertinoColors.systemBackground)` (dynamic)
  - borderless: `CupertinoColors.transparent`
- `textStyle`: cupertino body (ориентир: size 17; шрифт не форсим)
  - базу берём из `CupertinoTheme.of(context).textTheme.textStyle` или `DefaultTextStyle.of(context).style`,
  - затем аккуратно дополняем (например, размер) через `copyWith(...)`.
- `placeholderColor`: `resolve(CupertinoColors.placeholderText)`
- `cursorColor`: `CupertinoTheme.primaryColor`
- `selectionColor`: `CupertinoTheme.primaryColor.withValues(alpha: 0.3)`
- `minSize`: минимум 44x44 (POLA для iOS hit targets), но уважать constraints/overrides

Важно: “не форсим SF Pro” жёстко. Дефолтный шрифт на iOS и так будет системным; на других платформах мы не хотим ломать user‑theme.

### 3.3 Таблица P0-дефолтов токенов (light / dark / borderless)

Принцип: по умолчанию используем **dynamic** cupertino цвета и резолвим их через `CupertinoDynamicColor.resolve(..., context)`, чтобы значения корректно менялись от brightness и чтобы в `RTextFieldResolvedTokens` попадал финальный `Color`.

| Token | Light (P0) | Dark (P0) | Borderless (P0) |
|---|---|---|---|
| `containerPadding` | `EdgeInsets.all(7)` | `EdgeInsets.all(7)` | `EdgeInsets.all(7)` |
| `containerBackgroundColor` | `resolve(CupertinoColors.systemBackground)` | `resolve(CupertinoColors.systemBackground)` | `CupertinoColors.transparent` |
| `containerBorderColor` | `resolve(CupertinoColors.separator)` | `resolve(CupertinoColors.separator)` | `CupertinoColors.transparent` |
| `containerBorderWidth` | `1.0` | `1.0` | `0.0` |
| `containerBorderRadius` | rounded (preset default) | rounded (preset default) | (игнорируется, т.к. нет decoration) |
| `textStyle` | `DefaultTextStyle`/`CupertinoTheme` baseline + size≈17 | то же | то же |
| `textColor` | `resolve(CupertinoColors.label)` | `resolve(CupertinoColors.label)` | `resolve(CupertinoColors.label)` |
| `placeholderColor` | `resolve(CupertinoColors.placeholderText)` | `resolve(CupertinoColors.placeholderText)` | `resolve(CupertinoColors.placeholderText)` |
| `cursorColor` | `CupertinoTheme.of(context).primaryColor` | `CupertinoTheme.of(context).primaryColor` | `CupertinoTheme.of(context).primaryColor` |
| `selectionColor` | `primaryColor.withValues(alpha: 0.3)` | `primaryColor.withValues(alpha: 0.3)` | `primaryColor.withValues(alpha: 0.3)` |
| `minSize` | `Size(44, 44)` (с учётом constraints) | `Size(44, 44)` (с учётом constraints) | `Size(44, 44)` (с учётом constraints) |

Где `resolve(x)` = `CupertinoDynamicColor.resolve(x, context)`.

Примечание про `borderless`:

- В Flutter `CupertinoTextField.borderless` по смыслу равен “`decoration: null`” (нет рамки/фона/клипа).
- Поэтому в нашем preset’е `borderless` должен не только выставлять `borderWidth = 0` и `background = transparent`,
  но и **не включать clip** на контейнере (например, `Clip.none`), чтобы не появлялось неожиданного обрезания.

Ещё один важный нюанс:

- `borderless` не должен запускать “анимации рамки” (если у surface есть анимация borderColor/borderWidth).
  Иначе получится визуальная “пульсация невидимой рамки” при фокусе.

---

## 4) `CupertinoTextFieldRenderer` (P0): дерево и ответственность

Файл: `packages/headless_cupertino/lib/src/textfield/cupertino_text_field_renderer.dart`

### 4.1 Дерево (без скрытой логики)

Структура должна быть максимально похожа на Material renderer по читаемости:

- `CupertinoTextFieldSurface` (decor + padding + border animation)
  - `GestureDetector(onTap: commands.tapContainer)` (только focus)
  - `Row`
    - `prefix` (slots.prefix) — видимость по `spec.prefixMode`
    - `Expanded`
      - `Stack`
        - placeholder (если `!state.hasText` и placeholder != null)
        - `request.input`
    - `suffix` (slots.suffix) — видимость по `spec.suffixMode`
    - `CupertinoTextFieldClearButton` — по `spec.clearButtonMode` и состояниям:
      - показывать только если `state.hasText && !state.isDisabled && !state.isReadOnly`
      - дополнительно уважать `OverlayVisibilityMode` (editing/notEditing/always/never)

### 4.2 Clear button: инварианты

- кликабельная зона не меньше 44x44 (или через padding вокруг иконки)
- действие: только `commands.clearText?.call()`
- никаких прямых обращений к controller

### 4.3 Иконка и hit target (как сделать “по‑iOS”, не ломая платформы)

Рекомендуемая иконка (Flutter‑стандарт):

- `CupertinoIcons.clear_thick_circled` / `CupertinoIcons.clear_circled_solid`

Важно:

- иконка — это визуал preset’а (ок),
- но размер tappable области должен быть стабильным (44x44), независимо от размера иконки.

### 4.4 Явная логика `OverlayVisibilityMode` (чтобы не ошибиться в реализации)

Для `prefixMode/suffixMode/clearButtonMode` используем одну и ту же модель “editing state”:

- `isEditing = state.isFocused && !state.isDisabled && !state.isReadOnly`

Тогда:

- `OverlayVisibilityMode.always` → показываем (если слот не null)
- `OverlayVisibilityMode.never` → не показываем
- `OverlayVisibilityMode.editing` → показываем, когда `isEditing == true`
- `OverlayVisibilityMode.notEditing` → показываем, когда `isEditing == false`

Важно:

- `prefixMode/suffixMode` **не зависят от** `state.hasText` (они зависят от состояния редактирования).
- `clearButtonMode` дополнительно требует `state.hasText == true`.

---

## 5) Интеграция в `CupertinoHeadlessTheme` (P0)

Файл: `packages/headless_cupertino/lib/src/cupertino_headless_theme.dart`

Добавляем private поля и capability mapping:

- `RTextFieldRenderer` → `CupertinoTextFieldRenderer`
- `RTextFieldTokenResolver` → `CupertinoTextFieldTokenResolver`

Acceptance:

- пример/демо в Cupertino режиме больше не падает из‑за отсутствия `RTextFieldRenderer` (и, как следствие, `RAutocomplete` тоже).

---

## 6) Acceptance criteria (part 2)

- [ ] В `headless_cupertino` есть renderer+resolver для textfield и они зарегистрированы в теме.
- [ ] `.borderless` реально убирает border/фон без костылей в компоненте.
- [ ] Clear button работает через `commands.clearText` и obeys `OverlayVisibilityMode`.
- [ ] Вся крупная UI‑ветка разнесена по primitives (без `_build*`).

---

## 7) PR checklist для part 2 (чтобы было как у больших команд)

- [ ] Renderer использует только `request.*` и не держит скрытых зависимостей на `RTextField` (никаких импортов компонента).
- [ ] Все дефолты — в token resolver, renderer читает tokens и не содержит “магических констант” (кроме минимальных layout‑инвариантов).
- [ ] Примитивы не содержат поведения, только layout/paint; поведение идёт через commands.

