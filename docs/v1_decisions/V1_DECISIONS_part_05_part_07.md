## V1 Decisions (зафиксировано перед реализацией) (part 5) (part 7)

Back: [Index](../V1_DECISIONS.md)


**Interactable widget (convenience API):**

```dart
/// Widget для удобного использования InteractionController
class Interactable extends StatefulWidget {
  final InteractionController? controller;
  final bool isDisabled;
  final Widget Function(BuildContext, WidgetStateSet) builder;
  final VoidCallback? onPressed;

  const Interactable({
    super.key,
    this.controller,
    this.isDisabled = false,
    required this.builder,
    this.onPressed,
  });
}
```

**Интеграция с 0.4 StateResolution:**

```dart
// Полный pipeline от input до tokens:
// 1. InteractionController.states → raw WidgetStateSet
// 2. StateResolutionPolicy.normalize() → disabled подавляет pressed/hovered
// 3. HeadlessWidgetStateMap.resolve() → token value

final rawStates = interactionController.states;
final normalized = policy.normalize(rawStates);
final tokenValue = tokenMap.resolve(normalized, policy);
```

**Инварианты:**
- `notifyListeners()` вызывается после КАЖДОГО изменения state
- Комбинированные состояния (hovered + focused + pressed) работают корректно
- `activePointerType` даёт контекст для visual feedback без нарушения модели

**PointerType → Visual Feedback Mapping (зафиксировано):**

Разные типы устройств ввода требуют разного visual feedback:

| PointerType | Pressed Feedback | Hover Feedback | Focus Ring | Примеры использования |
|-------------|-----------------|----------------|------------|----------------------|
| **mouse** | Ripple/scale + immediate | ✅ Показывать | ✅ При keyboard nav | Desktop, laptop |
| **touch** | Ripple/scale + delayed (100ms) | ❌ Не показывать | ❌ Не показывать | Mobile, tablet |
| **stylus** | Как mouse | ✅ Показывать | ✅ При keyboard nav | Tablet с пером |
| **keyboard** | Без ripple, highlight bg | ❌ N/A | ✅ Всегда | Space/Enter activation |
| **assistiveTech** | Без visual (semantic announce) | ❌ N/A | ❌ Скрыт | Screen reader tap |

**Реализация в renderer:**

```dart
class ButtonRenderer {
  Widget build(ButtonRenderRequest request) {
    final pointerType = request.activePointerType;

    return AnimatedContainer(
      duration: _getDuration(pointerType),
      decoration: BoxDecoration(
        color: request.tokens.backgroundColor,
        // Ripple только для mouse/stylus
        boxShadow: pointerType == PointerType.mouse ||
                   pointerType == PointerType.stylus
            ? _rippleShadow
            : null,
      ),
      child: Stack(
        children: [
          // Focus ring только для keyboard nav
          if (request.states.contains(WidgetState.focused) &&
              pointerType != PointerType.touch)
            _focusRing(request.tokens.focusRingColor),

          _content(request),
        ],
      ),
    );
  }

  Duration _getDuration(PointerType? type) {
    return switch (type) {
      PointerType.touch => const Duration(milliseconds: 100), // delayed
      PointerType.mouse || PointerType.stylus => Duration.zero, // immediate
      _ => Duration.zero,
    };
  }
}
```

**Почему разный feedback:**
- **Touch:** Delayed feedback предотвращает "мерцание" при scroll (iOS/Android behavior)
- **Mouse:** Immediate feedback ожидается на desktop (POLA)
- **Keyboard:** Focus ring критичен для accessibility
- **AssistiveTech:** Visual feedback не нужен — screen reader announce достаточно

**Полный пример использования (RTextButton):**

```dart
class RTextButton extends StatefulWidget {
  final TextButtonSpec spec;
  final String label;
  final VoidCallback? onPressed;
  final bool isDisabled;

  const RTextButton({
    super.key,
    this.spec = const TextButtonSpec(),
    required this.label,
    this.onPressed,
    this.isDisabled = false,
  });

  @override
  State<RTextButton> createState() => _RTextButtonState();
}

class _RTextButtonState extends State<RTextButton> {
  late final InteractionController _interaction;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _interaction = InteractionController()
      ..isDisabled = widget.isDisabled
      ..addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void didUpdateWidget(RTextButton old) {
    super.didUpdateWidget(old);
    _interaction.isDisabled = widget.isDisabled;
  }

  void _handlePress() {
    if (!widget.isDisabled) {
      widget.onPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = RenderlessTheme.of(context);
    final states = _interaction.states;
    final normalized = theme.statePolicy.normalize(states);

    return Semantics(
      button: true,
      enabled: !widget.isDisabled,
      label: widget.label,
      child: Listener(
        onPointerDown: _interaction.handlePointerDown,
        onPointerUp: (e) {
          _interaction.handlePointerUp(e);
          if (states.contains(WidgetState.pressed)) {
            _handlePress();
          }
        },
        onPointerCancel: _interaction.handlePointerCancel,
        child: MouseRegion(
          cursor: widget.isDisabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          onEnter: (_) => _interaction.handleHoverEnter(),
          onExit: (_) => _interaction.handleHoverExit(),
          child: Focus(
            focusNode: _focusNode,
            onFocusChange: (hasFocus) => hasFocus
                ? _interaction.handleFocus()
                : _interaction.handleBlur(),
            onKeyEvent: (node, event) {
              if (_interaction.handleKeyDown(event as KeyEvent)) {
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: theme.buttons.getTextButtonRenderer(widget.spec).build(
              TextButtonRenderRequest(
                spec: widget.spec,
                states: normalized,
                semantics: TextButtonSemantics(label: widget.label),
                callbacks: TextButtonCallbacks(onPressed: _handlePress),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _interaction.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
```

**Оценка:** 9.5/10
**Почему:** без единого механизма поведение pressed/hover расходится между компонентами.

#### 0.7) Effects Executor contract (зафиксировано)

**Цель:** детальный контракт lifecycle для выполнения эффектов. Дополняет E1 Effects конкретикой.

**Где живёт executor:**
- Создаётся внутри R* компонента как часть `State`
- Не нужен отдельный scope — это internal implementation detail
- Каждый R* компонент имеет свой executor instance

**Lifecycle (строгий порядок):**

```dart
// 1. Event приходит в компонент
void _dispatch(ComponentEvent event) {
  // 2. Reducer возвращает новое состояние + список effects
  final (nextState, effects) = _reducer(_state, event);

  // 3. Обновляем состояние
  _state = nextState;

  // 4. Выполняем effects через executor
  _executor.execute(effects, onResultEvent: _dispatch);

  // 5. notifyListeners() после всех sync effects
  notifyListeners();
}
```

**Порядок выполнения эффектов (фиксирован):**
1. **Overlay effects** (ShowOverlay, UpdateOverlay, CloseOverlay)
2. **Focus effects** (RequestFocus, RestoreFocus, TrapFocus, ReleaseFocus)
3. **Semantics effects** (Announce)
4. **Scheduling effects** (PostFrame, CoalesceNextFrame)
