# I34 (part 1.2) — Изменения `RTextField` + алгоритмы + `RCupertinoTextField` API

Оригинальная дока Flutter: [`CupertinoTextField`](https://api.flutter.dev/flutter/cupertino/CupertinoTextField-class.html).

## 1) `RTextField` (P0): новые props, которые реально конфигурируют `EditableText`

Файлы:

- `packages/components/headless_textfield/lib/src/presentation/r_text_field.dart`
- `packages/components/headless_textfield/lib/src/presentation/r_text_field_editable_text_factory.dart`

P0 набор:

- `textCapitalization`
- `autocorrect`
- `enableSuggestions`
- `smartDashesType`
- `smartQuotesType`
- `maxLength`
- `maxLengthEnforcement`
- `showCursor`
- `keyboardAppearance`
- `scrollPadding`
- `dragStartBehavior`
- `enableInteractiveSelection`
- `onEditingComplete`
- `onTapOutside`

Точная сигнатура (P0, без полного списка existing props):

```dart
class RTextField extends StatefulWidget {
  RTextField({
    // ...existing...
    this.clearButtonMode = OverlayVisibilityMode.never,
    this.prefixMode = OverlayVisibilityMode.always,
    this.suffixMode = OverlayVisibilityMode.always,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.maxLength,
    this.maxLengthEnforcement,
    this.showCursor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection,
    this.onEditingComplete,
    this.onTapOutside,
  });

  final OverlayVisibilityMode clearButtonMode;
  final OverlayVisibilityMode prefixMode;
  final OverlayVisibilityMode suffixMode;
  final TextCapitalization textCapitalization;
  /// Совместимость с `CupertinoTextField`: может быть nullable.
  ///
  /// В реализации важно не прокидывать null в `EditableText`, если там ожидается
  /// non-nullable bool. Делать `effectiveAutocorrect = autocorrect ?? true`.
  final bool? autocorrect;
  final bool enableSuggestions;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final bool? showCursor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final DragStartBehavior dragStartBehavior;
  final bool? enableInteractiveSelection;
  final VoidCallback? onEditingComplete;
  final TapRegionCallback? onTapOutside;
}
```

Примечание:

- `clearButtonMode/prefixMode/suffixMode` — policy для renderer’а (они уходят в `spec`, а не в `EditableText`).

---

## 2) Алгоритмы (component-side) — однозначная реализация

### 2.1 `commands.clearText` (критично для controlled режима)

Почему так: programmatic изменение controller может не вызвать `EditableText.onChanged`, поэтому компонент обязан сам дернуть user callback.

Псевдокод:

```text
if !enabled -> return
controller.value = TextEditingValue(text: '', selection: collapsed(0), composing: empty)
valueSync.notifyIfChanged('', onChanged)  // ровно один раз
```

#### 2.1.1 Нюансы `clearText`, которые важно зафиксировать (P0)

- `clearText` **не должен** снимать фокус (Cupertino поведение: очистка не = blur).
- `selection` после очистки:
  - `TextSelection.collapsed(offset: 0)`
- `composing` после очистки:
  - `TextRange.empty`

Если этого не сделать, на некоторых клавиатурах/IME можно получить “залипшую” composing подсветку или странные cursor позиции.

### 2.2 `maxLength` как в Flutter TextField/CupertinoTextField

Реализация через formatter:

```text
effectiveFormatters = userFormatters
if maxLength != null:
  if userFormatters already contains LengthLimitingTextInputFormatter:
    do not add a second limiter (avoid double-limiting surprises)
  else:
    effectiveFormatters += LengthLimitingTextInputFormatter(maxLength, maxLengthEnforcement)
pass effectiveFormatters into EditableText
```

Фиксируем и тестируем порядок применения форматтеров.

Важно (явный инвариант):

- Не допускаем “двойного лимитера” из-за одновременного `maxLength` и пользовательского `LengthLimitingTextInputFormatter`.
- В тестах фиксируем ожидаемый приоритет, чтобы поведение не менялось незаметно.

#### 2.2.1 Приоритет, если лимитеры разные (P0)

Если пользователь передал `LengthLimitingTextInputFormatter` сам, то **он выигрывает**.

- `maxLength` в этом случае рассматриваем как “sugar”, который не должен неожиданно переопределять пользовательскую политику.
- В тестах фиксируем: задан `maxLength = 10`, но пользовательский limiter = 3 → ввод ограничивается 3.

### 2.3 Прокидывание nullable-полей в `EditableText` (важно)

Некоторые параметры в `CupertinoTextField` nullable, но в `EditableText` могут быть non-nullable.
Политика: в factory вычисляем “effective” значения с дефолтами:

```text
effectiveAutocorrect = autocorrect ?? true
effectiveEnableInteractiveSelection = enableInteractiveSelection ?? true
```

#### 2.3.1 Полный список nullable → effective (P0)

Чтобы при реализации ничего не забыть, фиксируем:

- `autocorrect` → `autocorrect ?? true`
- `enableInteractiveSelection` → `enableInteractiveSelection ?? true`
- `showCursor`:
  - если `showCursor == null` → отдаём `null` в `EditableText` (пусть решает платформа),
  - если `true/false` → прокидываем как есть.

Важно: это часть “похожести на Flutter API”, но без жёсткой переопределяющей логики.

---

## 3) `RCupertinoTextField` (P0): public API “как Cupertino”, но на наших слоях

Где живёт:

- `packages/headless_cupertino/lib/src/textfield/r_cupertino_text_field.dart`
- экспорт: `packages/headless_cupertino/lib/headless_cupertino.dart`

### 3.1 Что поддерживаем в P0

- `controller`, `focusNode`, `placeholder`, `readOnly`, `enabled`, `autofocus`
- keyboard: `keyboardType`, `textInputAction`, `textCapitalization`
- input behavior: `autocorrect`, `enableSuggestions`, `smartDashesType`, `smartQuotesType`
- length: `maxLength`, `maxLengthEnforcement`
- layout: `maxLines`, `minLines`, `scrollPadding`
- callbacks: `onChanged`, `onSubmitted`, `onEditingComplete`, `onTapOutside`
- affordances: `prefix`, `suffix`, `prefixMode`, `suffixMode`, `clearButtonMode`

### 3.2 Маппинг в `RTextField`

- `prefix/suffix` → `RTextFieldSlots(prefix: ..., suffix: ...)`
- `clearButtonMode/prefixMode/suffixMode` → `RTextField` props → `RTextFieldSpec`
- визуал (padding/decoration/borderless) → `RenderOverrides({ CupertinoTextFieldOverrides: ... })`

Примечание по `*Mode`:

- `prefixMode/suffixMode` должны управлять видимостью по “editing state”
  (в стиле `CupertinoTextField`), а не по `hasText`.
- `clearButtonMode` зависит от “editing state” и дополнительно от `hasText`.

### 3.3 Таблица соответствия (P0)

| Свойство `CupertinoTextField` | Где у нас |
|---|---|
| `controller/focusNode` | `RTextField` |
| `placeholder` | `RTextField.placeholder` |
| `textCapitalization/autocorrect/enableSuggestions` | `RTextField` (P0) |
| `smartDashesType/smartQuotesType` | `RTextField` (P0) |
| `maxLength/maxLengthEnforcement` | `RTextField` (P0) |
| `onEditingComplete/onTapOutside` | `RTextField` (P0) |
| `prefix/suffix + *Mode` | `RCupertinoTextField` → slots + spec policy |
| `borderless/decoration/padding` | `CupertinoTextFieldOverrides` (preset) |

---

## 4) Acceptance criteria (part 1.x)

- [ ] Contracts: `RTextFieldSpec` содержит `clearButtonMode/prefixMode/suffixMode`, commands содержит `clearText`.
- [ ] `RTextField` прокидывает P0 поведенческие параметры в `EditableText`.
- [ ] `clearText` очищает текст и вызывает `onChanged('')` корректно (controlled + controller-driven).
- [ ] `RCupertinoTextField` покрывает базовые кейсы `CupertinoTextField` без архитектурных компромиссов.

