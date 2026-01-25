## V1 Decisions (зафиксировано перед реализацией) (part 3)

Back: [Index](../V1_DECISIONS.md)

## Guardrails v1 (чтобы не наступать на грабли экосистемы)

Эти правила — "красные линии". Они защищают нас от типовых проблем headless библиотек при росте.

### 0) DAG — никаких циклических зависимостей

- Граф зависимостей пакетов должен быть **DAG (Directed Acyclic Graph)**.
- Циклические зависимости = blocker PR.
- Проверка: `dart pub deps --no-dev` + CI валидация.
- Если компонент A требует foundation механизм из B, а B требует что-то из A — это архитектурная ошибка, требующая рефакторинга.

### 1) Не делаем `as` / "полиморфизм компонента"

- Не вводим API вида `as: ...` / `asChild` на уровне компонентов.
- Композиция и переопределение структуры делаются через renderer contracts + slots (`Replace/Decorate`).

### 2) Не раздуваем поведение через boolean-флаги

- Для сложных компонентов поведение выражается через **события + состояние** (и при необходимости FSM), а не набором `isX`.
- Для интеракций используем `Set<WidgetState>` и централизованную нормализацию/приоритеты (см. `headless_foundation/state_resolution`).

### 3) Не тащим Material как дефолт в core

- Core = headless/unstyled.
- Любые “material-like” default renderers живут в отдельном пакете.

### 4) Не откладываем a11y “на потом”

- Для `Dialog/Menu/Select/Dropdown` обязательны тесты: keyboard, focus trap/restore, dismiss, semantics.

### 5) Overlay — только как foundation механизм

- Не делаем “каждый компонент сам себе overlay”.
- Оверлейный стек/позиционирование/диссмис/фокус — общий механизм через `AnchoredOverlayEngineHost` + `OverlayController` + `OverlayHandle`.

### 6) Performance guardrails (не повторяем forced reflow/measure loops)

- Не делаем паттерны, где open/close требует “синхронно измерить дерево” повторно и в цикле.
- В overlay‑позиционировании:
  - обновления позиции **коалесим/троттлим** (особенно на scroll),
  - избегаем “measure → setState → measure” в tight loop,
  - предпочитаем детерминированные расчёты и обновления по событиям (scroll/resize/layout), а не постоянный polling.

### 7) Async как часть стандарта E1 (не как Zag “watch”)

- Async операции делаем через **effects**, которые по завершении диспатчат **result events** (`Succeeded/Failed`) обратно в reducer.
- Никаких “наблюдателей”, где внешний код обязан вручную синхронизировать машину без явного контракта результата.

### 8) Built-in state sharing (не тащим отдельные DI/сторонние либы)

- Шэринг состояния между частями одного компонента/оверлея делаем через **Scope/InheritedWidget** + listenables/controllers.
- Не вводим обязательные зависимости уровня Bunshi/DI framework для доступа к state.

### 9) Error Handling Policy — 4 уровня ошибок

**Проблема:** Без явной стратегии обработки ошибок разные части системы будут обрабатывать ошибки по-разному, что приведёт к непредсказуемому поведению.

**Решение (зафиксировано):**

Определяем 4 уровня ошибок с разной стратегией обработки:

| Уровень | Тип ошибки | Стратегия | Пример |
|---------|-----------|-----------|--------|
| **L1** | Configuration errors | throw at startup | Missing capability в теме |
| **L2** | Runtime errors | OperationFailed event | Network timeout, async failure |
| **L3** | Logic errors | assert in debug, ignore in release | Invalid state transition |
| **L4** | Render errors | ErrorWidget fallback | Exception в renderer.build() |

**Инварианты:**

1. **Reducers НИКОГДА не throw** — возвращают error state:
```dart
// ✅ Правильно:
(State, List<Effect>) reduce(State state, Event event) {
  if (event is OperationFailed) {
    return (state.copyWith(error: event.error), []);
  }
  // ...
}

// ❌ Неправильно:
(State, List<Effect>) reduce(State state, Event event) {
  throw Exception('Invalid event'); // НИКОГДА
}
```

2. **Effects могут throw** — executor оборачивает в OperationFailed:
```dart
class EffectsExecutor {
  void execute(List<Effect> effects, void Function(Event) dispatch) {
    for (final effect in effects) {
      try {
        _executeOne(effect, dispatch);
      } catch (e, stack) {
        // L2: Оборачиваем в event
        dispatch(OperationFailed(effect.key, e, stack));
      }
    }
  }
}
```

3. **Configuration errors = fail fast:**
```dart
// L1: При старте приложения
final theme = RenderlessTheme.of(context);
final buttons = theme.requireCapability<ButtonCapability>(); // throws MissingCapabilityError
```

4. **Render errors = graceful degradation:**
```dart
// L4: Flutter ErrorWidget как fallback
Widget build(BuildContext context) {
  try {
    return renderer.build(request);
  } catch (e, stack) {
    // В debug — показываем ошибку
    // В release — ErrorWidget.builder или placeholder
    return ErrorWidget.withDetails(message: 'Render error', error: e);
  }
}
```

**Error types (sealed class):**
```dart
sealed class RenderlessError implements Exception {
  const RenderlessError();
}

// L1: Configuration
final class MissingCapabilityError extends RenderlessError {
  final Type capabilityType;
  final String message;
  const MissingCapabilityError(this.capabilityType, this.message);
}

// L2: Runtime (через events, не exceptions)
sealed class OperationResult {
  const OperationResult();
}
final class OperationSucceeded<T> extends OperationResult {
  final T data;
  const OperationSucceeded(this.data);
}
final class OperationFailed extends OperationResult {
  final Object error;
  final StackTrace? stackTrace;
  const OperationFailed(this.error, [this.stackTrace]);
}
final class OperationTimeout extends OperationResult {
  final Duration timeout;
  const OperationTimeout(this.timeout);
}
final class OperationCancelled extends OperationResult {
  const OperationCancelled();
}

// L3: Logic (только в debug)
final class InvalidStateTransitionError extends RenderlessError {
  final String from;
  final String to;
  final String event;
  const InvalidStateTransitionError(this.from, this.to, this.event);
}
```

**Оценка:** 9/10

---

## Dual API (D2a сейчас, путь к D2b потом) — зафиксировано

**Сравнительная таблица D2a vs D2b:**

| Аспект | D2a (v1) | D2b (future) |
|--------|----------|--------------|
| **Power-user API** | Foundation primitives | Per-component engines |
| **Overlay/Focus/Listbox** | `headless_foundation/*` | Остаётся в foundation |
| **Кастомизация** | Через foundation + renderer | + `useDialog()`, `useSelect()` |
| **API surface** | Минимальный | Расширенный (engines) |
| **Breaking risk** | Низкий | Средний (больше контрактов) |
| **Совместимость** | Flutter-like `R*` | React Aria-like hooks |
| **Примеры** | `OverlayController.show()` | `DialogEngine.dispatch(event)` |

**Почему D2a в v1:**
- Меньше API surface = меньше breaking changes
- Foundation primitives покрывают 90% power-user сценариев
- Легче поддерживать стабильность
- Путь к D2b остаётся открытым

**Путь к D2b (критерии для добавления):**
1. Явный demand от пользователей (3+ issues)
2. Foundation primitives недостаточны для use case
3. Engine добавляется **аддитивно** (minor version)
4. Engine = thin wrapper над тем же state/events

См. также: `ARCHITECTURE.md` → "Dual API policy"

### Выбор для v1: D2a (9/10)

**Решение (зафиксировано):**
- В v1 мы **НЕ вводим** публичные per-component engines/хуки типа `useDialog()`/`useSelect()` (React-style).
- Вместо этого мы делаем “power user” уровень через **публичные foundation primitives**:
  - `anchored_overlay_engine/*` (O1: `AnchoredOverlayEngineHost` + `OverlayController` + `OverlayHandle`)
  - `headless_foundation/listbox/*` (L1: `ItemRegistry` + keyboard nav + typeahead)
- Компоненты (`RDialog`, `RDropdownButton`, …) остаются **удобными wrappers** с Flutter-like API (D1), которые внутри используют foundation механизмы.

**Почему это правильно:** максимальная кастомизация достигается без раздувания публичного API на каждую фичу, и это лучше защищает “без миграций”.

### Как обеспечиваем путь к D2b “без ломаний” (архитектурные рельсы)

Чтобы позже добавить per-component engines **аддитивно**, соблюдаем правила:

1) **Event-first модель**
   - Внутреннее поведение сложных компонентов выражаем через **events** (например `OpenRequested`, `ItemHighlighted`, `ItemSelected`, `DismissRequested`), а не через россыпь boolean-флагов.
   - Состояние — immutable (`copyWith`/pattern matching) и имеет стабильные инварианты.

2) **Единые механизмы остаются в foundation**
   - Overlay/positioning/focus/dismiss остаются в `headless_foundation`.
   - Listbox/navigation/typeahead остаются в `headless_foundation`.
   - Per-component engine (если появится) не должен дублировать эти механизмы, только “оркестрировать” их.

3) **Публичные engines (если появятся) = тонкая оболочка над теми же событиями**
   - Любой будущий `DialogEngine`/`SelectEngine` должен быть **thin adapter** над тем же event/state, который уже используется внутри `R*`.
   - Это снижает риск расхождения поведения между “виджетом” и “engine”.

4) **Аддитивность как обязательное требование**
   - Добавление engine API не должно менять поведение `R*` по умолчанию (POLA).
   - Новые события/поля — только с дефолтами и без breaking (minor).

**Оценка:** 9/10  
**Почему:** D2a даёт кастомизацию через foundation уже сейчас, а D2b становится “мягким расширением”, а не переписыванием архитектуры.

---

