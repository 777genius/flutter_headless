## V1 Decisions (зафиксировано перед реализацией) (part 5) (part 9)

Back: [Index](../V1_DECISIONS.md)


**Оценка:** 9/10
**Почему:** без явного lifecycle effects будут выполняться в разном порядке, создавая edge-case баги.

### 1) E1 Effects contract (строго) + Executor (A1) — зафиксировано

**Цель:** reducer остаётся pure и тестируемым; все side-effects предсказуемы; async не превращается в “watch/внешний костыль”.

**Решение (зафиксировано):**
- Reducer возвращает **список типизированных effects**, а не “callback’и”.
- Effects делятся на категории (примерная модель, но требование — именно типизированные категории):
  - **Overlay effects**: `ShowOverlay`, `UpdateOverlay`, `CloseOverlay`
  - **Focus effects**: `RequestFocus`, `RestoreFocus`, `TrapFocus`, `ReleaseFocus`
  - **Semantics effects**: `Announce` (экранный диктор/semantics live-region аналоги)
  - **Scheduling effects**: `PostFrame`, `CoalesceNextFrame(key)`
  - **Async operation effects (A1)**: `RunOperation(opKey, payload)` → result events обратно в reducer
- Executor принимает `(effects)` и:
  - выполняет их **вне** reducer,
  - коалесит эффекты с одинаковым `key` (минимум: `CoalesceNextFrame` и overlay update),
  - поддерживает **отмену/дедуп** операций по `opKey`,
  - диспатчит **result events** обратно в reducer: `OperationSucceeded(opKey, data)`, `OperationFailed(opKey, error)`, `OperationCancelled(opKey)`

**Инварианты:**
- Reducer **никогда** не создаёт `Future` и не читает "мир" (контекст/лейаут/фокус) напрямую.
- Все async результаты **всегда** возвращаются как events (никаких "watch").
- Executor обязан быть безопасным к повторным вызовам и не создавать циклы "effect → event → effect" без изменения state.

**Async fail-safe (зафиксировано):**

Если executor не диспатчит result event в течение timeout:
1. Автоматически диспатчит `OperationTimeout(opKey)`
2. Логирует warning: "Operation X did not complete within 30s"
3. Reducer обрабатывает `OperationTimeout` как Failed

```dart
/// Политика async операций
class AsyncPolicy {
  final Duration operationTimeout;

  const AsyncPolicy({
    this.operationTimeout = const Duration(seconds: 30),
  });
}

/// Результаты async операций
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
  const OperationTimeout();
}

final class OperationCancelled extends OperationResult {
  const OperationCancelled();
}
```

**Timeout по умолчанию:** 30 секунд (конфигурируемо через `AsyncPolicy`)

**Оценка:** 9.5/10
**Почему:** это гарантирует стабильную основу для D2a (power users) и мягкое расширение к D2b.

### 2) Overlay SLA v1 (positioning/updates/stacking) — зафиксировано

**Цель:** чтобы пользователи не писали костыли вокруг dropdown/dialog/tooltip.

**Требования v1:**
- **Anchoring**: overlay должен оставаться привязанным к anchor при:
  - scroll (включая nested scroll containers),
  - resize/orientation change,
  - появлении/скрытии клавиатуры (mobile) — насколько позволяет Flutter layout.
- **Collision pipeline** (floating-ui идеи):
  - базовый placement (например `bottomStart`)
  - затем **flip** (если не влезает)
  - затем **shift** (поджать в viewport/safe area)
- **Update policy**:
  - reposition не чаще **1 раза на frame** (коалесинг/троттлинг обязательны),
  - никаких tight loops “measure → setState → measure”.
- **Stacking**:
  - поддержка стека (dialog поверх menu и т.п.)
  - корректный dismiss по “наружному клику” с учётом вложенности (верхний закрывается первым).
- **Focus**:
  - focus trap/restore для modal‑оверлеев,
  - предсказуемые правила фокуса для non-modal (menu/tooltip).

**Оценка:** 9/10  
**Почему:** overlay — общая зависимость почти всех сложных компонентов; если он слабый, всё остальное “сыпется”.

### 3) Listbox keyboard + typeahead spec v1 — зафиксировано

**Цель:** единое предсказуемое поведение для menu‑паттернов (Dropdown/Select/Autocomplete) и хороший a11y/DX.

**Требования v1 (по умолчанию):**
- **Navigation keys**:
  - `ArrowDown/ArrowUp`: move highlight к следующему/предыдущему **enabled** item
  - `Home/End`: к первому/последнему enabled item
  - `Enter/Space`: select highlighted item (если применимо)
  - `Escape`: dismiss/close (через overlay)
- **Looping**: wrap-around **включён** по умолчанию (может быть опцией политики).
- **Disabled items**: пропускаются в навигации и selection.
- **Typeahead**:
  - ввод букв собирается в буфер,
  - timeout по умолчанию **~500ms** (может быть политикой),
  - матч по “label” item (строка, которую отдаёт registry; не UI),
  - поиск идёт от текущей позиции вперёд, затем wrap.

**Оценка:** 9/10  
**Почему:** это предотвращает расхождения поведения между компонентами и снижает стоимость поддержки.

### 4) Performance baseline v1 (минимум) — зафиксировано

**Требования v1:**
- Все “горячие” операции в foundation должны быть:
  - **O(1)** или **амортизированно O(1)** на event (scroll/key/pointer), где это возможно,
  - без проходов по “всему дереву” на каждое событие.
- Overlay reposition/update: коалесинг до **1/frame** обязателен.
- Listbox registry: операции highlight/select не должны триггерить rebuild всего списка; UI обязан оставаться lazy (например, через `ListView.builder` в renderer).

**Минимальные проверки (на уровне тестов/benchmarks):**
- “Open/close overlay” не должен давать серии кадров с jank в типовом сценарии (dropdown/menu на странице с большим деревом).
- Keyboard navigation по 1000 items не должна деградировать нелинейно.

**Оценка:** 8.5/10  
**Почему:** это то, что отличает “игрушку” от библиотеки уровня DS.

### 5) Focus management v1 (anti-trap) — зафиксировано

**Цель:** не ловить пользователей в keyboard trap и не ломать screen readers (особенно на touch, где нет Esc).

**Требования v1:**
- Для modal-оверлеев (Dialog) обязателен **focus trap** + **restoreFocus** по умолчанию (может быть отключаемо).
- **initialFocus policy**: при открытии modal-оверлея можно задать, куда поставить фокус (иначе используем предсказуемый дефолт).
- **Escapable boundaries**: должны быть чёткие правила выхода из trap (например, закрытие по Esc, явная Close-кнопка, и корректное поведение “наружного клика” через overlay dismiss stack).
- Должна существовать **явная Close-кнопка**, доступная для assistive tech:
  - допускается `visuallyHidden`, но **focusable** и с `semanticLabel`.
- Tab-order должен соответствовать **визуальному порядку** (не вмешиваемся в порядок без необходимости).
- Не ставим фокус на “невидимые/скрытые” элементы (hidden-but-focusable только по сознательной политике, например close button).

**Оценка:** 9/10  
**Почему:** это одна из самых частых “больных точек” headless UI и главный источник багов/репутационных провалов.

### 6) Interactions v1: Unified press events — зафиксировано

**Цель:** одинаковое поведение “нажатия” для mouse/touch/keyboard/assistive tech, без залипания `pressed` и без странных краёв.

**Решение (зафиксировано):**
- В `headless_foundation/interactions` вводим единый press‑механизм (аналог идеи `usePress`):
  - типизированные события `pressStart/pressEnd/press/pressCancel`,
  - `pointerType` (mouse/touch/stylus/keyboard/screenReader),
  - корректная обработка cancel/drag-off.
- `R*` компоненты получают `pressed/hovered/focused` через этот механизм, а не пишут свою “жестовую логику” каждый раз.

**Оценка:** 8.5/10

### 6.1) Visual effects hooks (v1)

**Goal:** allow renderer-specific visual feedback (ripple/pressed highlight)
without creating a second activation path.

**Decision:**
- `HeadlessPressableRegion` can emit **visual-only** events:
  - pointer down/up/cancel,
  - hover/focus changes.
- A `HeadlessPressableVisualEffectsController` carries these events to renderers.
- Renderers may subscribe to the controller and animate, while activation remains
  owned by the component.

**Invariants:**
- No user callbacks are invoked by the renderer.
- Visual effects are optional (components work without them).

### 6) WCAG 2.2 baseline v1 — зафиксировано

**Требования v1 (минимум):**
- **Target Size (AA)**: интерактивные цели по умолчанию обеспечивают минимум **24×24px** (даже для “small” размеров).
- **Focus Not Obscured**: политика **ensureVisible** для фокуса:
  - если элемент получает фокус внутри scroll view, обеспечиваем прокрутку так, чтобы фокус не был перекрыт sticky/header/overlay.
  - реализация — через foundation focus/overlay policies (не в каждом компоненте отдельно).

**Оценка:** 8.5/10
**Почему:** WCAG 2.2 — реальный комплаенс драйвер; лучше встроить базовые гарантии в v1.

### 7) Порог выноса в foundation — Hard requirement

**Правило "2-3 фичи":**
- **Уровень A (1 компонент):** механизм остаётся в компоненте
- **Уровень B (2 фичи):** кандидат на вынос — выносим если есть чёткий контракт
- **Уровень C (3+ фичи):** обязателен вынос в `headless_foundation`

**Примеры:**
| Механизм | Где используется | Уровень | Решение |
|----------|------------------|---------|---------|
| Press handling | Button, MenuItem, Link, ListItem | C (4+) | `foundation/interactions` |
| Overlay positioning | Dropdown, Dialog, Tooltip, Popover | C (4+) | `anchored_overlay_engine` |
| Listbox navigation | Dropdown, Select, Autocomplete | C (3) | `foundation/listbox` |
| Focus trap | Dialog, FullscreenMenu | B (2) | `anchored_overlay_engine` (часть overlay) |
| Drag-and-drop | DraggableList | A (1) | остаётся в компоненте |

**Инвариант:** переиспользуемость → минимизация дублирования → меньше багов на краях.

**Оценка:** 8/10
**Почему:** без явного правила механизмы дублируются, и поведение расходится между компонентами.

---

