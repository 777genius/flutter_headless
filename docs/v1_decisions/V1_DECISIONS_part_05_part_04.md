## V1 Decisions (зафиксировано перед реализацией) (part 5) (part 4)

Back: [Index](../V1_DECISIONS.md)


**Использование в OverlayShowRequest:**
```dart
class OverlayShowRequest {
  final OverlayAnchor anchor;
  final Placement placement;
  final DismissPolicy dismissPolicy;  // ← Новый контракт
  final FocusPolicy focusPolicy;
  final Widget Function(OverlayScope) builder;
  // ...
}

// Пример: dropdown menu
OverlayShowRequest(
  anchor: OverlayAnchor.fromKey(triggerKey),
  placement: Placement.bottomStart,
  dismissPolicy: DismissPolicy.nonModal,  // outsideTap + esc + focusLoss
  focusPolicy: NonModalFocusPolicy(),
  builder: (scope) => DropdownMenuRenderer(...),
)

// Пример: modal dialog
OverlayShowRequest(
  anchor: OverlayAnchor.center(),  // центрирование
  dismissPolicy: DismissPolicy.modal,  // outsideTap + esc
  focusPolicy: ModalFocusPolicy(trap: true, restoreOnClose: true),
  builder: (scope) => DialogRenderer(...),
)
```

**Почему sealed class с factory:**
- `DismissPolicy.none` — для overlays, которые закрываются только программно
- `DismissPolicy.modal` / `.nonModal` — удобные пресеты
- `DismissByTriggers` — полный контроль через `Set<DismissTrigger>`
- Exhaustive matching в Dart 3.x

**OverlayAnchor (зафиксировано):**

Решение: **sealed class + `getCurrentRect()` + convenience factories** (оценка 9.2/10)

```dart
sealed class OverlayAnchor {
  const OverlayAnchor();

  /// Получить текущий Rect anchor'а в глобальных координатах
  Rect? getCurrentRect();

  // Convenience factories
  factory OverlayAnchor.fromKey(GlobalKey key) = GlobalKeyAnchor;
  factory OverlayAnchor.fromRect(Rect rect) => RectAnchor.fixed(rect);
  factory OverlayAnchor.fromRectGetter(Rect Function() getRect) = RectAnchor;
}

final class GlobalKeyAnchor extends OverlayAnchor {
  final GlobalKey key;
  const GlobalKeyAnchor(this.key);

  @override
  Rect? getCurrentRect() {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }
}

final class RectAnchor extends OverlayAnchor {
  final Rect Function() _getRect;
  const RectAnchor(this._getRect);
  factory RectAnchor.fixed(Rect rect) => RectAnchor(() => rect);

  @override
  Rect? getCurrentRect() => _getRect();
}
```

**Почему этот выбор:**
- Exhaustive pattern matching (Dart 3.x)
- `RectAnchor.fixed()` идеален для тестов и виртуальных позиций (курсор, selection)
- `GlobalKeyAnchor` для production
- Расширяемо без breaking changes (новый подтип = minor)
- Единый `getCurrentRect()` для collision detection (flip/shift)

**Оценка:** 9.5/10  
**Почему:** мы заранее фиксируем “скелет” системы (theme + overlay), и дальше реализация/компоненты не будут спорить об API.

#### 0.3) `headless_foundation/listbox`: ItemRegistry + navigation/typeahead (минимум)

Цель: один общий механизм для menu‑паттернов (`DropdownButton`, `Select/Combobox`, `Autocomplete`) без component→component зависимостей.

**Инварианты (v1):**
- Listbox — это **механизм поведения**, а не UI: он не знает про `ListView`, `InkWell` и т.п.
- Listbox работает с **порядком элементов**, disabled, keyboard nav и typeahead.
- Listbox не требует “полного дерева” в памяти: renderer может быть lazy, а registry хранит только метаданные.
- Selection не обязана быть частью listbox: многие сценарии — “только highlight/active descendant” (selection controlled на уровне компонента).

**Минимальный набор (v1):**
- `ListboxItemId = Object` (любой value с корректным equality/hashCode).
- `ListboxItemMeta`:
  - `ListboxItemId id`
  - `bool isDisabled`
  - `String typeaheadLabel` (что матчим в typeahead)
- `ItemRegistry`:
  - `void register(ListboxItemMeta meta, {required int order})`
  - `void unregister(ListboxItemId id)`
  - `List<ListboxItemId> get orderedEnabledIds`
  - `ListboxItemMeta? getMeta(ListboxItemId id)`

**ListboxController (зафиксировано):**

Решение: **`ListboxController extends ChangeNotifier`** + internal registry + `state` getter (оценка 9.0/10)

```dart
/// Immutable state snapshot (on demand)
@immutable
class ListboxState {
  final ListboxItemId? highlightedId;
  final String typeaheadBuffer;

  const ListboxState({
    this.highlightedId,
    this.typeaheadBuffer = '',
  });
}

/// Configuration
class ListboxPolicy {
  final bool loopNavigation;
  final Duration typeaheadTimeout;
  final bool skipDisabled;

  const ListboxPolicy({
    this.loopNavigation = true,
    this.typeaheadTimeout = const Duration(milliseconds: 500),
    this.skipDisabled = true,
  });
}

/// Main controller
class ListboxController extends ChangeNotifier {
  ListboxController({
    ItemRegistry? registry,
    this.policy = const ListboxPolicy(),
  }) : _registry = registry ?? ItemRegistry();

  final ItemRegistry _registry;
  final ListboxPolicy policy;

  // Internal mutable state (performant)
  ListboxItemId? _highlightedId;
  final _TypeaheadHandler _typeahead = _TypeaheadHandler();

  // === Public getters ===

  /// Direct access for hot paths (UI rebuild)
  ListboxItemId? get highlightedId => _highlightedId;

  /// Immutable snapshot for tests/debugging
  ListboxState get state => ListboxState(
    highlightedId: _highlightedId,
    typeaheadBuffer: _typeahead.buffer,
  );

  // === Registration (delegated to internal registry) ===

  void register(ListboxItemMeta meta, {required int order}) =>
    _registry.register(meta, order: order);

  void unregister(ListboxItemId id) => _registry.unregister(id);

  // === Highlight API ===

  void setHighlighted(ListboxItemId? id) {...}
  void highlightNext() {...}
  void highlightPrevious() {...}
  void highlightFirst() {...}
  void highlightLast() {...}

  // === Navigation (abstract commands, no Flutter types) ===

  /// Выполняет навигационную команду.
  /// Foundation layer не знает про KeyEvent — это Presentation concern.
  void navigate(ListboxNavigation nav) {...}
}

/// Abstract navigation commands (Foundation layer)
/// KeyEvent → ListboxNavigation конвертация живёт в Presentation layer.
sealed class ListboxNavigation {
  const ListboxNavigation();
}

/// Переместить highlight вверх/вниз
final class MoveHighlight extends ListboxNavigation {
  final int delta; // +1 = вниз, -1 = вверх
  const MoveHighlight(this.delta);
}

/// Перейти к первому/последнему
final class JumpToFirst extends ListboxNavigation {
  const JumpToFirst();
}

final class JumpToLast extends ListboxNavigation {
  const JumpToLast();
}

/// Typeahead символ
final class TypeaheadChar extends ListboxNavigation {
  final String char;
  const TypeaheadChar(this.char);
}

/// Select текущий highlighted item
final class SelectHighlighted extends ListboxNavigation {
  const SelectHighlighted();
}

/// Widget tree access
class ListboxScope extends InheritedNotifier<ListboxController> {
  static ListboxController of(BuildContext context) {...}
  static ListboxController? maybeOf(BuildContext context) {...}
}
```

**Presentation layer helper (конвертация KeyEvent → ListboxNavigation):**

```dart
// В presentation layer (packages/components/*/lib/src/presentation/)
ListboxNavigation? keyEventToNavigation(KeyEvent event) {
  return switch (event.logicalKey) {
    LogicalKeyboardKey.arrowDown => const MoveHighlight(1),
    LogicalKeyboardKey.arrowUp => const MoveHighlight(-1),
    LogicalKeyboardKey.home => const JumpToFirst(),
    LogicalKeyboardKey.end => const JumpToLast(),
    LogicalKeyboardKey.enter || LogicalKeyboardKey.space =>
      const SelectHighlighted(),
    _ when event.character != null && event.character!.isNotEmpty =>
      TypeaheadChar(event.character!),
    _ => null,
  };
}

// Использование в компоненте:
KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
  final nav = keyEventToNavigation(event);
  if (nav != null) {
    _listboxController.navigate(nav);
    return KeyEventResult.handled;
  }
  return KeyEventResult.ignored;
}
```
