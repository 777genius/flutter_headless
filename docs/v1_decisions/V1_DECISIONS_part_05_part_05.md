## V1 Decisions (зафиксировано перед реализацией) (part 5) (part 5)

Back: [Index](../V1_DECISIONS.md)


**Почему abstract commands:**
- Foundation layer не зависит от Flutter (`KeyEvent`)
- Легко тестировать navigation logic без виджетов
- Presentation layer отвечает за маппинг платформенных событий

**Почему этот выбор:**
- **ChangeNotifier** — Flutter-idiomatic (как TextEditingController, ScrollController)
- **Mutable internal + immutable getter** — zero allocations на hot path, snapshot для тестов
- **Registry internal** — простой API (один объект), но injectable для тестов
- **`_TypeaheadHandler` isolated** — SRP, typeahead logic отдельно
- **ListboxScope** — стандартный Flutter pattern для widget tree access

**E1 Pattern Exception (зафиксировано):**

ListboxController использует **imperative API** вместо event-driven (E1 pattern). Это **intentional exception**.

**Обоснование:**
- ListboxController — **Foundation mechanism**, не Component state
- Аналогично Flutter controllers: `TextEditingController`, `ScrollController`, `TabController`
- Flutter controllers традиционно imperative — это Flutter-idiomatic
- E1 pattern (events + pure reducer + effects) применяется к **Component state** (ButtonState, DialogState, SelectState)
- Foundation mechanisms обеспечивают **building blocks**, которые Components используют

**Scope применения E1 vs Imperative:**

| Layer | Pattern | Примеры |
|-------|---------|---------|
| **Component State** | E1 (events + reducer) | ButtonState, DialogState, SelectState |
| **Foundation Mechanisms** | Imperative (Flutter-like) | ListboxController, InteractionController, OverlayController |

**Как это работает вместе:**
```dart
// Component (R* widget) использует E1 для своего state
class _RComponentState extends State<StatefulWidget> {
  // Foundation mechanism (imperative)
  late final ListboxController _listbox;

  // Component state (E1 pattern)
  Object _state = Object();

  void _reduce(Object event) {
  final (nextState, effects) = reducer(_state, event);
    _state = nextState;
    _executeEffects(effects);
    setState(() {});
  }

  void _onHighlightChanged() {
    // Foundation mechanism notifies → Component dispatches E1 event
    _reduce(HighlightChanged(_listbox.highlightedId));
  }
}
```

**Инварианты:**
- Component state следует E1 (testable reducer, explicit effects)
- Foundation mechanisms следуют Flutter conventions (ChangeNotifier + imperative)
- Component orchestrates both — listens to Foundation, updates via E1

Примечание: правила клавиатуры/typeahead уже зафиксированы выше в `3) Listbox keyboard + typeahead spec v1` — здесь мы фиксируем именно **публичный API "скелет"**.

**Оценка:** 9/10
**Почему:** Flutter-idiomatic, performant, testable; общий механизм без UI и без component deps.

#### 0.4) `headless_foundation/state_resolution`: нормализация и приоритеты `WidgetState` (минимум)

Цель: чтобы `Set<WidgetState>` не превращался в “хаос if’ов” и давал предсказуемый resolve для tokens/renderers (POLA).

**Инварианты (v1):**
- Компоненты собирают “сырые” состояния (`pressed/hovered/focused/disabled/...`) через `interactions` механизм.
- `state_resolution` отвечает за:
  - нормализацию конфликтов (например, disabled подавляет pressed),
  - приоритеты/специфичность,
  - удобный lookup для token maps (без callback‑магии на каждом билде).

**Минимальный набор (v1):**
- `WidgetStateSet = Set<WidgetState>` (используем Flutter‑совместимую модель, без собственного DSL).
- `StateResolutionPolicy`:
  - `WidgetStateSet normalize(WidgetStateSet raw)`
  - `List<WidgetStateSet> precedence(WidgetStateSet normalized)`

**Контракт precedence (v1):**
- Возвращает список наборов состояний **от наиболее специфичного к наименее**, заканчивая “base” (пустым набором).
- Пример: `{hovered, focused}` → `[{hovered, focused}, {hovered}, {focused}, {}]`.

**StateMap (v1):**
- `HeadlessWidgetStateMap<T>`:
  - хранит значения для конкретных `WidgetStateSet`,
  - умеет `resolve(states, policy)` выбирая первое совпадение по `precedence`.

**Dart контракт (зафиксировано):**

```dart
/// Alias для Set<WidgetState> для консистентности API
typedef WidgetStateSet = Set<WidgetState>;

/// Политика нормализации и приоритетов состояний
class StateResolutionPolicy {
  const StateResolutionPolicy();

  /// Нормализация конфликтующих состояний.
  /// Пример: disabled подавляет pressed/hovered
  WidgetStateSet normalize(WidgetStateSet raw) {
    if (raw.contains(WidgetState.disabled)) {
      return raw.difference({
        WidgetState.pressed,
        WidgetState.hovered,
        WidgetState.dragged,
      });
    }
    return raw;
  }

  /// Возвращает список наборов от наиболее специфичного к наименее.
  /// Используется для token lookup: первое совпадение побеждает.
  List<WidgetStateSet> precedence(WidgetStateSet normalized) {
    final states = normalized.toList();
    final result = <WidgetStateSet>[];

    // Все комбинации от самой специфичной (все состояния) до пустой
    for (var size = states.length; size >= 0; size--) {
      result.addAll(_combinations(states, size));
    }
    return result;
  }

  List<WidgetStateSet> _combinations(List<WidgetState> states, int size) {
    if (size == 0) return [<WidgetState>{}];
    if (size == states.length) return [{...states}];

    final result = <WidgetStateSet>[];
    void combine(int start, List<WidgetState> current) {
      if (current.length == size) {
        result.add({...current});
        return;
      }
      for (var i = start; i < states.length; i++) {
        current.add(states[i]);
        combine(i + 1, current);
        current.removeLast();
      }
    }
    combine(0, []);
    return result;
  }
}

/// Map от WidgetStateSet к значениям с precedence-based lookup.
///
/// Важно: в Dart `Set` не имеет value-equality по содержимому, поэтому
/// реализация должна использовать стабильный ключ (например, по индексам enum).
class HeadlessWidgetStateMap<T> {
  HeadlessWidgetStateMap(
    Map<WidgetStateSet, T> entries, {
    T? defaultValue,
  });

  T? resolve(WidgetStateSet states, StateResolutionPolicy policy);

  T resolveOrThrow(
    WidgetStateSet states,
    StateResolutionPolicy policy, {
    String? context,
  });
}

/// Ошибка при невозможности resolve state map
class StateResolutionError extends Error {
  final String message;
  StateResolutionError(this.message);

  @override
  String toString() => 'StateResolutionError: $message';
}
```

**Error Handling Policy для StateMap (зафиксировано):**

| Метод | Поведение при отсутствии значения | Когда использовать |
|-------|-----------------------------------|-------------------|
| `resolve()` | Возвращает `null` | Опциональные токены (borderColor) |
| `resolveOrThrow()` | Бросает `StateResolutionError` | Обязательные токены (backgroundColor) |

**Рекомендации:**
- **Обязательные токены** (bg, fg, textStyle) → `resolveOrThrow()` + всегда иметь base entry `<WidgetState>{}`
- **Опциональные токены** (border, shadow, outline) → `resolve()` + проверка на null
- **defaultValue** — fallback для debug, production должен иметь все entries

**Пример правильного использования:**

```dart
// ✅ Обязательный токен — с resolveOrThrow
final bgColor = bgColors.resolveOrThrow(
  states,
  policy,
  context: 'Button.backgroundColor',
);

// ✅ Опциональный токен — с resolve + null check
final borderColor = borderColors.resolve(states, policy);
final border = borderColor != null
    ? Border.all(color: borderColor)
    : null;

// ❌ НЕ ДЕЛАЙ ТАК — resolve может вернуть null
final bgColor = bgColors.resolve(states, policy)!; // может упасть
```

**Пример использования:**

```dart
// Шаг 1: Определяем token map для цветов фона кнопки
final bgColors = HeadlessWidgetStateMap<Color>(
  {
    {WidgetState.disabled}: Colors.grey,
    {WidgetState.pressed}: Colors.blue.shade700,
    {WidgetState.hovered, WidgetState.focused}: Colors.blue.shade300,
    {WidgetState.hovered}: Colors.blue.shade400,
    {WidgetState.focused}: Colors.blue.shade200,
    <WidgetState>{}: Colors.blue, // base
  },
  defaultValue: Colors.blue,
);

// Шаг 2: Получаем raw states от InteractionController
final rawStates = {WidgetState.pressed, WidgetState.hovered, WidgetState.disabled};

// Шаг 3: Нормализуем (disabled подавляет pressed)
final policy = StateResolutionPolicy();
final normalized = policy.normalize(rawStates);
// Результат: {hovered, disabled} — pressed удалён

// Шаг 4: Resolve по precedence
final bgColor = bgColors.resolve(normalized, policy);
// Поиск: {hovered, disabled} → нет
//        {hovered} → нет (потому что есть disabled)
//        {disabled} → Colors.grey ✓
```

