## V1 Decisions (зафиксировано перед реализацией) (part 5) (part 2) (part 2) (part 2)

Back: [Index](../V1_DECISIONS.md)

## Hard requirements v1 (чтобы “без костылей” было правдой)

Ниже — требования, которые закрывают самые дорогие грабли конкурентов (perf/overlay/a11y/async) и не должны “размываться” при реализации.

### 0) Minimal public contract surface v1 (чтобы начать реализацию без “дыр”)

Цель: перед тем как писать код, зафиксировать **минимальный набор публичных типов/интерфейсов**, которые обязаны существовать в v1.  
Это снижает риск “переделок API”, потому что компоненты/рендереры/тесты начинают от одного источника правды.

Ниже — **контракты**, а не конкретные реализации.

#### 0.1) `headless_contracts`: renderer contracts + capability discovery (минимум)

**Инварианты:**
- `R*` не импортят реализации визуала. Они зависят только от контрактов в `headless_contracts` (capability discovery — через `headless_theme`).
- Capabilities подключаются композицией (ISP), а не через монолитный “Theme с 50 resolve методов”.
- Отсутствие нужного renderer capability должно давать понятную диагностику (assert/throw с инструкцией, как подключить facade/дефолтный рендерер).

**Минимальный набор (v1):**
- `RenderlessTheme` (scope/entrypoint) — предоставляет доступ к capability composition.
- Renderer capabilities:
  - `TextButtonRenderer` (для `RTextButton`)
  - `DropdownButtonRenderer` (для `RDropdownButton<T>`) — **renderer non-generic**, компонент maps value↔index
  - `DialogRenderer` (для `RDialog`)

**Форма renderer API (v1):**
- У каждого renderer есть один entrypoint `build(context, request) -> Widget`.
- `*RenderRequest` включает:
  - `spec` (domain-объект, typed variants/specs)
  - `state` (read-only snapshot: например `Set<WidgetState>` + доменные флаги вроде `isOpen/isLoading`)
  - `semantics` (минимальные данные для a11y: label/role hints)
  - `callbacks` (типизированные действия, которые renderer должен повесить на свою структуру: например `onPressed`, `onDismissRequested`)
  - `slots/parts` (если компонент сложный) — только typed (P1)
  - **`resolvedTokens`** (уже вычисленные token values: bg, fg, border, textStyle — renderer не должен делать resolution)
  - **`constraints`** (опциональные ограничения: minWidth, minHeight для WCAG compliance)

**ResolvedTokens контракт (зафиксировано):**

Renderer получает уже разрешённые tokens, а не делает resolution самостоятельно:

```dart
/// Resolved tokens для Button (пример)
@immutable
class ResolvedButtonTokens {
  const ResolvedButtonTokens({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.textStyle,
    required this.borderRadius,
    required this.padding,
    required this.animationDuration,
    this.borderColor,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final TextStyle textStyle;
  final double borderRadius;
  final EdgeInsets padding;
  final Duration animationDuration;
  final Color? borderColor;
}

class TextButtonRenderRequest {
  const TextButtonRenderRequest({
    required this.spec,
    required this.states,
    required this.semantics,
    required this.callbacks,
    required this.tokens,
    this.constraints,
  });

  final TextButtonSpec spec;
  final WidgetStateSet states;
  final TextButtonSemantics semantics;
  final TextButtonCallbacks callbacks;
  final ResolvedButtonTokens tokens; // уже resolved
  final BoxConstraints? constraints; // например: min 24x24 для WCAG
}
```

**Почему resolved tokens в request:**
- DRY — resolution logic в одном месте (компонент или capability)
- Renderer остаётся простым — только строит UI
- Тестируемость — легко проверить что tokens разрешены правильно
- Performance — resolution один раз, не на каждый rebuild

**Strict режим (опционально):**
- `HeadlessRendererPolicy(requireResolvedTokens: true)` — валится в debug/test,
  если renderer получил `resolvedTokens == null`.

Пример:

```dart
HeadlessThemeOverridesScope.only<HeadlessRendererPolicy>(
  capability: const HeadlessRendererPolicy(requireResolvedTokens: true),
  child: const HeadlessMaterialApp(home: Placeholder()),
)
```

**Пример для Dropdown (menu):**
- `backgroundOpacity` — отдельное поле, чтобы не терять dynamic colors в токенах.
- `backdropBlurSigma`, `shadowColor`, `shadowBlurRadius`, `shadowOffset` — все визуальные эффекты поповера приходят из tokens, без hardcode в примитивах.

**Token Resolution Layer — ownership (зафиксировано):**

Кто вычисляет resolved tokens? Это **application layer**, не renderer.

Коротко: `raw states → normalize(policy) → resolve(capability) → RenderRequest(tokens) → renderer.build(...)`.

**Ответственности слоёв:**

| Слой | Ответственность | Примеры |
|------|-----------------|---------|
| **InteractionController** | Сбор raw states | `{pressed, hovered, focused}` |
| **StateResolutionPolicy** | Нормализация (disabled → suppress pressed) | `normalize(states)` |
| **Capability** | Resolution tokens по states + spec | `backgroundColors.resolve(states, policy)` |
| **Component (R*)** | Оркестрация resolution flow, сборка RenderRequest | Вызывает capability, передаёт в renderer |
| **Renderer** | Визуальное построение из готовых tokens | Строит виджеты, анимации |

**Код resolution (в компоненте):**

```dart
class _RTextButtonState extends State<RTextButton> {
  late final InteractionController _interaction;

  @override
  Widget build(BuildContext context) {
    final theme = RenderlessTheme.of(context);
    final buttons = theme.requireCapability<ButtonCapability>();
    final policy = theme.statePolicy;

    // 1. Получаем raw states от InteractionController
    final rawStates = _interaction.states;

    // 2. Нормализуем (disabled подавляет pressed/hovered)
    final normalized = policy.normalize(rawStates);

    // 3. Резолвим tokens через capability
    final tokens = ResolvedButtonTokens(
      backgroundColor: buttons.backgroundColors.resolve(normalized, policy)!,
      foregroundColor: buttons.foregroundColors.resolve(normalized, policy)!,
      textStyle: buttons.textStyles.resolve(normalized, policy)!,
      borderRadius: buttons.borderRadii.resolve(normalized, policy)!,
      padding: buttons.paddings.resolve(normalized, policy)!,
      animationDuration: theme.durations.fast,
    );

    // 4. Передаём готовые tokens в renderer
    return buttons.getTextButtonRenderer(widget.spec).build(
      TextButtonRenderRequest(
        spec: widget.spec,
        states: normalized,  // normalized, не raw!
        tokens: tokens,      // уже resolved
        semantics: TextButtonSemantics(label: widget.label),
        callbacks: TextButtonCallbacks(onPressed: widget.onPressed),
      ),
    );
  }
}
```

**Инварианты Token Resolution:**
- Renderer **НИКОГДА** не делает resolution — получает готовые `ResolvedTokens`
- Component отвечает за orchestration (calls policy + capability)
- Capability владеет `HeadlessWidgetStateMap<T>` для каждого token type
- Policy определяет приоритеты и нормализацию states

**Почему в application layer (не в renderer):**
- Single Responsibility — renderer только рендерит
- Testability — можно тестировать resolution отдельно от рендеринга
- Reusability — один resolution flow для всех renderers одного типа
- Performance — resolution один раз на build, не на каждый widget

Примечание: "какие поля точно входят в request" — это уже уровень конкретного компонента (будет описано в `packages/components/*` в их `LLM.txt`), но форма **`spec/state/semantics/callbacks/slots/tokens/constraints`** фиксируется заранее.

**ISP Composition (зафиксировано) — Capability Discovery Pattern:**

Не рекомендуется:
```dart
// ❌ Раздутый интерфейс — нарушает ISP
abstract class RenderlessTheme {
  ButtonRenderer resolveButton(...);
  DropdownRenderer resolveDropdown(...);
  DialogRenderer resolveDialog(...);
  SelectRenderer resolveSelect(...);
  // ... 50+ методов → breaking changes при каждом новом компоненте
}

// ❌ Field-based composition — тоже нарушает OCP
class RenderlessTheme {
  final ButtonCapability buttons;     // Добавление нового поля = breaking change
  final DropdownCapability dropdowns;
  final DialogCapability dialogs;
  // ... каждый новый компонент требует нового поля
}
```

Рекомендуется:
```dart
// ✅ Capability Discovery Pattern — соблюдает ISP + OCP
abstract class RenderlessTheme {
  /// Получить capability по типу. Возвращает null если не зарегистрирована.
  T? capability<T>();

  /// Получить capability или выбросить понятную ошибку.
  T requireCapability<T>() {
    final cap = capability<T>();
    if (cap == null) {
      throw MissingCapabilityError(
        'Capability $T not found in theme. '
        'Did you forget to register it?',
      );
    }
    return cap;
  }

  /// State resolution policy (всегда доступна)
  StateResolutionPolicy get statePolicy;

  static RenderlessTheme of(BuildContext context) =>
      InheritedRenderlessTheme.of(context);
}

/// Реализация темы через Map capabilities
class MapRenderlessTheme extends RenderlessTheme {
  final Map<Type, Object> _capabilities;
  @override
  final StateResolutionPolicy statePolicy;

  MapRenderlessTheme({
    required Map<Type, Object> capabilities,
    this.statePolicy = const StateResolutionPolicy(),
  }) : _capabilities = capabilities;

  @override
  T? capability<T>() => _capabilities[T] as T?;
}

/// Capability interface для Button (ISP-compliant)
///
/// Используем TokenResolver<T> pattern вместо field-based tokens:
/// - Добавление нового типа токена НЕ требует изменения интерфейса
/// - Каждый тип токена может иметь optional getter с default = null
/// - Расширение через наследование, не модификацию
abstract class ButtonCapability {
  /// Получить renderer для TextButton
  TextButtonRenderer getTextButtonRenderer(TextButtonSpec spec);

  /// Core token resolvers (required)
  TokenResolver<Color> get backgroundColor;
  TokenResolver<Color> get foregroundColor;
  TokenResolver<TextStyle> get textStyle;

  /// Optional token resolvers (extensions) — добавляются аддитивно
  TokenResolver<EdgeInsets>? get padding => null;
  TokenResolver<double>? get borderRadius => null;
  TokenResolver<double>? get elevation => null;
}

/// TokenResolver — ISP-compliant pattern для token resolution
/// Изолирует state resolution от capability interface
abstract class TokenResolver<T> {
  const TokenResolver();

  /// Resolve token value for given widget states
  T resolve(WidgetStateSet states, StateResolutionPolicy policy);

  /// Factory for HeadlessWidgetStateMap-based resolution
  factory TokenResolver.fromMap(
    HeadlessWidgetStateMap<T> map,
    T defaultValue,
  ) = _MapTokenResolver<T>;
}

class _MapTokenResolver<T> implements TokenResolver<T> {
  final HeadlessWidgetStateMap<T> _map;
  final T _default;

  const _MapTokenResolver(this._map, this._default);

  @override
  T resolve(WidgetStateSet states, StateResolutionPolicy policy) {
    return _map.resolve(states, policy) ?? _default;
  }
}

/// Capability interface для Dropdown
abstract class DropdownCapability {
  DropdownButtonRenderer getDropdownRenderer(DropdownButtonSpec spec);
  DropdownMenuRenderer getMenuRenderer();
}
```
