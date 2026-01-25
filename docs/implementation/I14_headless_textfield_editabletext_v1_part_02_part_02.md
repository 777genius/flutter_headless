## I14 — Component v1: Headless TextField на базе `EditableText` (contracts + renderer split) (part 2) (part 2)

Back: [Index](./I14_headless_textfield_editabletext_v1_part_02.md)

## Дизайн v1 (минимальный, но прод‑полезный)

### 0) Принципы (что делает архитектуру “топ”)

- **Поведение в компоненте, визуал в renderer**: компонент владеет контролем ввода, focus/keyboard/IME и “истиной”; renderer строит только дерево/декорацию.
- **Non-leaky abstractions**: contracts не должны протекать Material/Cupertino типами. Все “мощные” настройки доступны через:
  - slots (структура),
  - contract overrides (token-level),
  - scoped theme (локально меняем preset).
- **Детерминизм**: token resolver — чистая функция вход→выход, без зависимости от build order.
- **Политика “одна истина”** (source-of-truth) и строгие переходы режимов — MUST, иначе TextField будет “глючить”.

### 0.1) Variant как intent (v1) + политика маппинга

Нам нужны визуальные варианты TextField (в стиле Material / других дизайн‑систем), но **без протекания** Material/Cupertino деталей в контракты.

Решение: добавить `variant` в `RTextFieldSpec` как **intent**, а пресеты интерпретируют его как “ближайший нативный вид”.

`RTextFieldVariant` (v1):

- `filled` — контейнер “залит” (фон отличим от окружения)
- `outlined` — контейнер с рамкой (обводка)
- `underlined` — акцент на нижней границе (bottom border)

Политика:

- Variant — **intent**, а не обещание пиксель‑в‑пиксель идентичности.
- Если preset не поддерживает variant 1‑в‑1, он **маппит в ближайший** (и документирует это у себя), а не падает.
- Behavior (EditableText/focus/IME/a11y) от variant **не зависит** и остаётся в компоненте.

Пример маппинга (минимум, без претензии на “единственно верное”):

- Material: `filled → filled`, `outlined → outlined`, `underlined → underlined`
- Cupertino: `filled/outlined → ближайший стандартный iOS‑вид`, `underlined → plain/borderless`

Расширения:

- `RTextFieldVariant` **не расширяем** в пресетах.
- Если пресету нужны дополнительные режимы, он вводит **preset-specific overrides** (через `RenderOverrides`) и даёт им приоритет над базовым intent’ом.

### 1) Пакеты/контракты

#### 1.1 `headless_contracts`: контракты для textfield

Добавить:
- `RTextFieldRenderer`
- `RTextFieldTokenResolver`
- `RTextFieldResolvedTokens`
- `RTextFieldOverrides` (contract overrides, preset-agnostic)
- `RTextFieldSpec` (static)
- `RTextFieldState` (derived)
- slots (v1 минимум): `leading`, `trailing`, `label`, `helper`, `error`, `container`, `input` (всё опционально)

Тонкий момент:
- НЕ тащить Material/Cupertino типы в контракты.
- Overrides — только contract уровень.

#### 1.1.1 Renderer contract (v1)

**Важно**: renderer **не создаёт** `EditableText`. Он получает “input child” от компонента и оборачивает/раскладывает его по слотам.

Причина: если renderer создаёт `EditableText`, он начинает владеть IME/focus/selection — это ломает headless separation.

Форма RenderRequest (Variant B, аналог I08):
- `spec/state/semantics/commands/slots/resolvedTokens/constraints/overrides`
- плюс обязательное поле `input` (Widget), которое представляет “ядро ввода”.

##### 1.1.1.1 Точная форма `RTextFieldRenderRequest` (v1)

Минимальная “полная форма” RenderRequest (как контракт):
- `context`
- `spec`
- `state`
- `semantics`
- `commands`
- `slots`
- `resolvedTokens` (nullable, если token resolver отсутствует)
- `constraints`
- `overrides`
- `input` (**обязателен**, Widget)

Где “input” — это `EditableText` (или узкий wrapper вокруг него), созданный компонентом.

#### 1.1.4 Точная спецификация `RTextFieldState` (v1)

Цель `RTextFieldState` — дать renderer’у **только** то, что нужно для визуального состояния, без доступа к внутренностям.

Предлагаемый v1 минимум:
- `isFocused: bool`
- `isHovered: bool`
- `isDisabled: bool`
- `isReadOnly: bool`
- `hasText: bool`
- `isError: bool` (например `errorText != null`)
- `isObscured: bool` (password)
- `isMultiline: bool`

Тонкий момент:
- `hasText` нужен для UX (placeholder floating/clear icon) и для token resolution.
- `isError` — это derived state, а не "токен".
- `isHovered` meaningful только на desktop/web; на mobile всегда false (no hover events).

##### State → WidgetState (v1 policy)

Для token resolution удобно нормализовать часть состояния в `Set<WidgetState>`:
- `focused` ← `isFocused`
- `hovered` ← `isHovered`
- `disabled` ← `isDisabled`

Важно:
- error/readOnly/obscured/multiline **не** выражаются `WidgetState` и идут отдельными полями в `spec/state`.

#### 1.1.5 Точная спецификация `RTextFieldSemantics` (v1)

Semantics передаётся в request, чтобы renderer мог корректно построить доступность в своём дереве (если нужно).
Но базовый `Semantics(textField: true, ...)` остаётся на стороне компонента.

**Правило no-duplicate semantics:**
- Компонент задаёт `Semantics(textField: true, label, hint, enabled, ...)`
- Renderer **НЕ должен** повторно задавать role `textField` — только дополнять/оборачивать
- Иначе screen reader получит двойное чтение

Предлагаемый v1 минимум:
- `label: String?`
- `hint: String?` (placeholder)
- `isEnabled: bool`
- `isReadOnly: bool`
- `isObscured: bool`
- `errorText: String?` (для озвучивания)

Политика:
- `isObscured=true` → **не** передавать реальное содержимое текста как “value” в semantics.

#### 1.1.6 Точная спецификация `RTextFieldCommands` (v1)

Callbacks в request — это "инструменты renderer'а" для **визуальных взаимодействий**, но не источник истины текста.

Предлагаемый v1 минимум:
- `tapContainer: VoidCallback?` (чтобы renderer мог фокусировать input при тапе по контейнеру/padding)
- `tapLeading: VoidCallback?` / `tapTrailing: VoidCallback?` (опционально, клики по icon slots)

**Что renderer МОЖЕТ делать через commands:**
- Фокусировать input при тапе на decoration area (`tapContainer`)
- Уведомлять о тапах на leading/trailing slots

**Что renderer НЕ ДОЛЖЕН делать:**
- Менять текст напрямую (нет доступа к controller)
- Вызывать submit/onChanged (это идёт через EditableText)
- **Держать** `FocusNode` — ownership остаётся у компонента

**Про focus ownership:**
- Renderer **не держит** FocusNode, но **может запрашивать фокус** через `tapContainer`
- Компонент получает callback и решает, фокусировать ли (проверяет enabled/readOnly)

**v1.1+ рассмотреть:**
- `onClearRequested: VoidCallback?` (если trailing icon = clear button)
- `onToggleObscure: VoidCallback?` (если trailing icon = show/hide password)
- Но это расширения, не core v1

Важно:
- `onChanged` не передаётся renderer'у как "главный callback". Изменения текста идут из `EditableText` внутри компонента.

#### 1.1.2 TokenResolver contract (v1)

Resolver должен учитывать:
- states: focused/hovered/disabled/error/readOnly
- multiline (minLines/maxLines) — влияет на padding/lineHeight policy
- density/constraints (min hit target)
- overrides (contract-level)

Приоритеты:
1) `RTextFieldOverrides` (contract)
2) preset-specific overrides (advanced, optional)
3) defaults

#### 1.1.3 Slots contract (v1)

Слоты должны быть:
- **опциональные**
- Replace/Decorate/Enhance (явная семантика, как в `headless_contracts`)
- получать контекст: `spec/state/resolvedTokens/constraints/handlers` (без доступа к "внутренним" контроллерам напрямую)

Важный слот `input`:
- позволяет обернуть input child (например, добавить padding/clip/transform) **без** переписывания поведения.

##### 1.1.3.1 Контексты слотов (чтобы слоты были реально полезны)

Каждый слот получает контекст, который позволяет сделать кастомизацию без доступа к внутренностям компонента:
- `spec` (static)
- `state` (derived: focused/hovered/disabled/error/readOnly/hasText)
- `resolvedTokens` (если есть)
- `constraints`
- `semantics` (label/hint/error summary)
- `input` (только для container/input слотов)

Запрещено: отдавать наружу `TextEditingController`/`FocusNode` в slot context (это ломает инварианты ownership).

#### 1.2 Компонентный пакет

Создать `packages/components/headless_textfield` (аналогично `headless_dropdown_button` — без underscore в "textfield").

---

### 2) API компонента (v1)

Минимальный public API, ориентированный на реальные кейсы:

- `value` (String?) + `onChanged` (controlled)
- `controller` (TextEditingController?) (advanced)
- `focusNode` (FocusNode?) (advanced)
- `enabled`, `readOnly`
- `placeholder`, `label`, `helperText`, `errorText`
- `textInputAction`, `keyboardType`, `textCapitalization`
- `obscureText`
- `autocorrect`, `enableSuggestions` (P0 для прод-использования)
- `autofillHints` (P0 для прод-форм)
- `maxLines`, `minLines`
- `autofocus`
- `inputFormatters` (List<TextInputFormatter>?)
- `overrides` (RenderOverrides?)
- `slots` (для структуры)

#### 2.1 Источник истины (критично, иначе будут баги)

В v1 фиксируем однозначную политику source-of-truth:

**Режим A (controlled)**:
- если переданы `value` и `onChanged`, то источником истины считается `value`.
- внутренний controller синхронизируется с `value` (без потери selection, насколько возможно).

**Режим B (controller-driven)**:
- если передан `controller`, то источником истины считается `controller.text`.
- `onChanged` (если есть) вызывается на изменения текста, но не “ведёт” состояние.

**Запрещённая комбинация (MUST fail fast ВСЕГДА)**:
- одновременно переданы `controller` и `value` (две истины).
  - **Всегда** бросаем `ArgumentError` (не assert!) — поведение одинаково в debug и release.
  - Это контрактная ошибка, не runtime edge case.

**Переходы между режимами**:
- переход `controller: null → non-null` и обратно должен быть поддержан:
  - ownership: если controller пришёл извне — компонент его не dispose'ит.
  - если controller внутренний (uncontrolled/controlled) — dispose делает компонент.

#### 2.2 Каноничный алгоритм синхронизации (controlled режим)

**Единый алгоритм** (учитывает composing, selection, pending value):

```dart
String? _pendingValue;  // Для отложенной синхронизации при IME composing
String? _lastNotifiedValue;  // Для предотвращения двойных onChanged

@override
void didUpdateWidget(RTextField oldWidget) {
  super.didUpdateWidget(oldWidget);

  // Fail-fast: запрещённая комбинация
  if (widget.controller != null && widget.value != null) {
    throw ArgumentError(
      'Cannot provide both controller and value. '
      'Use either controlled mode (value + onChanged) or '
      'controller-driven mode (controller only).',
    );
  }

  // Sync value → controller (только в controlled режиме)
  if (_ownsController && widget.value != null) {
    _syncValueToController();
  }
}

void _syncValueToController() {
  // 1. Idempotent: ничего не делаем если значения равны
  if (widget.value == _controller.text) {
    _pendingValue = null;
    return;
  }

  // 2. IME composing: откладываем sync
  if (_controller.value.composing.isValid) {
    _pendingValue = widget.value;
    return;
  }

  // 3. Применяем pending или текущий value
  final targetValue = _pendingValue ?? widget.value;
  _pendingValue = null;

  if (targetValue == null || targetValue == _controller.text) {
    return;
  }

  // 4. Обновляем с сохранением selection
  _updateControllerText(targetValue);
}

void _updateControllerText(String newText) {
  final oldSelection = _controller.selection;
  _controller.text = newText;

  // Clamp selection в диапазон нового текста
  final newLength = newText.length;
  if (oldSelection.isValid) {
    _controller.selection = TextSelection(
      baseOffset: oldSelection.baseOffset.clamp(0, newLength),
      extentOffset: oldSelection.extentOffset.clamp(0, newLength),
    );
  }
}
```
