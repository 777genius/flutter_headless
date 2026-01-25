## V1 Decisions (зафиксировано перед реализацией) (part 4)

Back: [Index](../V1_DECISIONS.md)

## Единый стандарт поведения v1: E1 (Events + pure reducer + Effects)

**Решение (зафиксировано):**
- Для сложных компонентов (`Dialog`, `Select/Combobox`, menu‑паттерны) мы стандартизируем ядро поведения как:
  - `sealed` **events**
  - immutable **state**
  - чистая функция `reduce(state, event) -> (nextState, effects)`
  - **effects** — отдельный слой для побочных действий (focus/overlay/announce/schedule update), чтобы reducer оставался pure.

**FSM поверх E1 (разрешено и рекомендуется по необходимости):**
- FSM не заменяет E1, а реализуется **поверх** него:
  - либо как часть state (явные режимы `closed/open/closing/...`)
  - либо как строгие правила переходов внутри reducer
- Цель: предсказуемые transition‑инварианты без усложнения публичного API.

**Оценка:** 9.5/10  
**Почему:** максимальная тестируемость/предсказуемость и самый безопасный путь к будущему D2b (engine = thin adapter над тем же reduce).

### Примечание: FSM как optional pattern (не часть core contracts)

**Важное уточнение:**
- FSM **НЕ** является частью core contracts (0.1–0.7)
- FSM — это **optional pattern** поверх E1, рекомендуемый для сложных компонентов
- Компоненты могут работать без FSM, используя только E1 events + pure reducer
- Решение использовать FSM принимается per-component, не глобально

**Когда использовать FSM:**
- `Select/Combobox` — сложная логика open/close/typeahead
- `Dialog` — modal lifecycle (opening/open/closing/closed)
- `Menu` — nested overlays, focus management

**Когда НЕ использовать FSM:**
- `Button` — простой pressed/released, E1 достаточно
- `Checkbox/Switch` — два состояния, FSM overkill

**Решение (зафиксировано):**
- Мы берём дисциплину "маленьких машин" (минимум состояний, простые переходы), но **не копируем** Zag архитектуру 1:1 и не подстраиваем API под конкретную библиотеку.
- В Headless:
  - состояние/переходы остаются **immutable + pure** (E1),
  - side-effects выполняются **только** через effects executor,
  - "computed" = чистые селекторы от state (без watch/reactive мутаций).

**Почему:** мутабельный context/watch часто приводит к скрытым сайд‑эффектам и perf проблемам; для библиотеки уровня DS это слишком рискованно.

**FSM в дереве пакетов:**
- `headless_foundation/fsm/` — optional helper для тех, кто хочет FSM
- Компоненты **не обязаны** использовать этот модуль
- Можно реализовать FSM вручную как sealed class в state

### E1 Code Example: Button

**Полный пример E1 pattern для простого компонента (Button):**

```dart
// === 1. Events (domain) ===
sealed class ButtonEvent {
  const ButtonEvent();
}

final class ButtonPressed extends ButtonEvent {
  final PointerType pointerType;
  const ButtonPressed(this.pointerType);
}

final class ButtonReleased extends ButtonEvent {
  const ButtonReleased();
}

final class ButtonHovered extends ButtonEvent {
  const ButtonHovered();
}

final class ButtonUnhovered extends ButtonEvent {
  const ButtonUnhovered();
}

final class ButtonFocused extends ButtonEvent {
  const ButtonFocused();
}

final class ButtonBlurred extends ButtonEvent {
  const ButtonBlurred();
}

// === 2. State (immutable) ===
class ButtonState {
  final bool isPressed;
  final bool isHovered;
  final bool isFocused;
  final bool isDisabled;
  final PointerType? activePointerType;

  const ButtonState({
    this.isPressed = false,
    this.isHovered = false,
    this.isFocused = false,
    this.isDisabled = false,
    this.activePointerType,
  });

  ButtonState copyWith({
    bool? isPressed,
    bool? isHovered,
    bool? isFocused,
    bool? isDisabled,
    PointerType? activePointerType,
  }) => ButtonState(
    isPressed: isPressed ?? this.isPressed,
    isHovered: isHovered ?? this.isHovered,
    isFocused: isFocused ?? this.isFocused,
    isDisabled: isDisabled ?? this.isDisabled,
    activePointerType: activePointerType ?? this.activePointerType,
  );

  /// Convert to WidgetStateSet for token resolution
  WidgetStateSet toWidgetStates() => {
    if (isDisabled) WidgetState.disabled,
    if (isPressed) WidgetState.pressed,
    if (isHovered) WidgetState.hovered,
    if (isFocused) WidgetState.focused,
  };
}

// === 3. Effects (side effects) ===
sealed class ButtonEffect {
  const ButtonEffect();
}

final class InvokeCallback extends ButtonEffect {
  final VoidCallback callback;
  const InvokeCallback(this.callback);
}

final class AnnounceSemantics extends ButtonEffect {
  final String message;
  const AnnounceSemantics(this.message);
}

// === 4. Reducer (pure function) ===
(ButtonState, List<ButtonEffect>) reduceButton(
  ButtonState state,
  ButtonEvent event,
  VoidCallback? onPressed,
) {
  // Disabled state blocks all events
  if (state.isDisabled) {
    return (state, const []);
  }

  return switch (event) {
    ButtonPressed(:final pointerType) => (
      state.copyWith(isPressed: true, activePointerType: pointerType),
      const [],
    ),
    ButtonReleased() => (
      state.copyWith(isPressed: false, activePointerType: null),
      [
        if (state.isPressed && onPressed != null)
          InvokeCallback(onPressed),
      ],
    ),
    ButtonHovered() => (
      state.copyWith(isHovered: true),
      const [],
    ),
    ButtonUnhovered() => (
      state.copyWith(isHovered: false),
      const [],
    ),
    ButtonFocused() => (
      state.copyWith(isFocused: true),
      const [],
    ),
    ButtonBlurred() => (
      state.copyWith(isFocused: false),
      const [],
    ),
  };
}

// === 5. Effects Executor (in component) ===
void executeEffects(List<ButtonEffect> effects) {
  for (final effect in effects) {
    switch (effect) {
      case InvokeCallback(:final callback):
        callback();
      case AnnounceSemantics(:final message):
        SemanticsService.announce(message, TextDirection.ltr);
    }
  }
}
```

**Ключевые принципы E1:**
1. **Events** — sealed class, все возможные входы
2. **State** — immutable, только данные
3. **Reducer** — pure function `(state, event) -> (newState, effects)`
4. **Effects** — sealed class, все side effects вынесены из reducer
5. **Executor** — выполняет effects после reducer

---

## Решено для v1 (после анализа конкурентов): i18n / parts / async

### 1) i18n: I1 — core контракт + дефолты через Flutter локализации

**Решение (зафиксировано):**
- В core добавляем **минимальный контракт** `RenderlessStrings`/`RenderlessI18n` (строки/лейблы/подсказки, которые нужны компонентам).
- По умолчанию (если пользователь ничего не передал) используем нативные Flutter локализации:
  - `MaterialLocalizations` / `CupertinoLocalizations` там, где это уместно.
- Это **не** означает “Material визуал в core”: используем только локализационные строки, без UI-дефолтов/виджетов.
- Пользователь может переопределить строки через `RenderlessI18nScope` (scope объект в дереве).

**Почему:** получаем правильную архитектуру без “React Aria тяжёлый”, и не раздуваем core переводами/зависимостями.

**Оценка:** 9/10

### 2) Parts: P1 — только typed slots/parts (без string-id / data-part)

**Решение (зафиксировано):**
- Точки расширения в рендере — только **typed**:
  - renderer contracts `render(request)`
  - slots `Replace/Decorate` с typed contexts
- Не вводим string-based part identifiers (аналог `data-part`), чтобы не терять type-safety и exhaustive подход.

**Оценка:** 9/10

### 3) Async: A1 — async только через effects executor → result events

**Решение (зафиксировано):**
- Reducer остаётся **pure** и не выполняет async.
- Async операции реализуются как:
  - `effects` запускают операцию через executor (с `opId`/key для дедупа/отмены),
  - по завершении executor диспатчит **result events** обратно в reducer (`Succeeded/Failed/...`).
- Политики дедупа/отмены — ответственность executor/контракта effects, а не “watch/побочный код”.

**Оценка:** 9/10

---

