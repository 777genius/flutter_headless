## V1 Decisions (зафиксировано перед реализацией) (part 5) (part 6)

Back: [Index](../V1_DECISIONS.md)

**Приоритет состояний (по умолчанию):**
```
error > disabled > focused > selected > pressed > hovered > dragged > {}
```

**Custom Priority Rules (расширение):**

Для специфических UI паттернов можно кастомизировать приоритеты:

```dart
/// Кастомная policy для компонента где pressed важнее focused
class ButtonResolutionPolicy extends StateResolutionPolicy {
  const ButtonResolutionPolicy();

  @override
  List<WidgetStateSet> precedence(WidgetStateSet normalized) {
    // Кастомный порядок: pressed имеет приоритет над focused
    final priorityOrder = [
      WidgetState.error,
      WidgetState.disabled,
      WidgetState.pressed,   // ← pressed выше focused для кнопок
      WidgetState.focused,
      WidgetState.selected,
      WidgetState.hovered,
      WidgetState.dragged,
    ];

    return _generatePrecedenceFromOrder(normalized, priorityOrder);
  }
}

/// Использование кастомной policy в теме
class BrandTheme extends RenderlessTheme {
  @override
  StateResolutionPolicy get statePolicy => const ButtonResolutionPolicy();
}
```

**Инвариант:** Кастомные policy должны сохранять контракт: `error` и `disabled` всегда в начале (они подавляют интерактивные состояния).

**Оценка:** 9/10
**Почему:** это ключ к предсказуемости renderers/tokens и снижает риск "странных" визуальных багов.

#### 0.5) `headless_test`: a11y/overlay/focus/keyboard helpers (минимум)

Цель: сделать тестирование поведения/a11y **дешёвым и регулярным**, а не “героическим усилием раз в полгода”.  
Важно: `headless_test` — это **не** отдельный тестовый фреймворк и не “генератор тестов”. Это набор маленьких helpers, которые закрывают самые частые сценарии headless UI.

**Инварианты (v1):**
- Пакет зависит только от `flutter_test` и core‑пакетов (`headless_foundation`, `headless_contracts`, `headless_theme`, `headless_tokens`).
- Никаких зависимостей на компоненты (`packages/components/*`) и на facade `headless`.
- Helpers проверяют **поведение/семантику/фокус**, а не пиксели (golden — не дефолт).
- Все API должны быть стабильными и читабельными (тесты пишутся людьми).

**Минимальный набор (v1):**
- **Semantics helpers**:
  - `expectHasSemanticsLabel(finder, label)`
  - `expectHasSemanticsRole(finder, /* role hint */)`
  - `expectIsFocusable(finder)` / `expectIsNotFocusable(finder)`
- **Keyboard helpers**:
  - `sendKey(LogicalKeyboardKey key)` / `sendTab()` / `sendShiftTab()` (обёртки над `WidgetTester.sendKeyEvent`)
  - `expectFocusOn(finder)`
- **Overlay helpers** (для overlay SLA и A1 close contract):
  - `pumpUntilOverlayPhase(handle, phase)` (или аналогичная утилита ожидания)
  - `expectOverlayPhase(handle, phase)`
  - `expectOverlayNotStuckInClosing(handle)` (проверка fail-safe таймаута/политики)
- **Listbox helpers**:
  - `expectHighlightedId(controller, id)`
  - `typeahead(controller, "abc")` (или через keyboard helper)

Примечание: конкретные имена функций могут уточняться в коде, но **категории и назначение** фиксируются заранее.

**Полные примеры использования:**

```dart
// === Semantics helpers ===
testWidgets('Button has correct semantics', (WidgetTester tester) async {
  await tester.pumpWidget(
    RenderlessTestApp(
      child: RTextButton(
        onPressed: () {},
        semanticsLabel: 'Submit form',
        child: Text('Submit'),
      ),
    ),
  );

  // Проверяем label
  expectHasSemanticsLabel(find.byType(RTextButton), 'Submit form');

  // Проверяем роль (button)
  expectHasSemanticsRole(find.byType(RTextButton), SemanticsRole.button);

  // Проверяем focusability
  expectIsFocusable(find.byType(RTextButton));
});

testWidgets('Disabled button is not focusable', (WidgetTester tester) async {
  await tester.pumpWidget(
    RenderlessTestApp(
      child: RTextButton(
        onPressed: null, // disabled
        child: Text('Submit'),
      ),
    ),
  );

  expectIsNotFocusable(find.byType(RTextButton));
});

// === Keyboard helpers ===
testWidgets('Tab moves focus through buttons', (WidgetTester tester) async {
  await tester.pumpWidget(
    RenderlessTestApp(
      child: Column(children: [
        RTextButton(key: Key('btn1'), onPressed: () {}, child: Text('First')),
        RTextButton(key: Key('btn2'), onPressed: () {}, child: Text('Second')),
      ]),
    ),
  );

  // Focus на первую кнопку
  await sendTab(tester);
  expectFocusOn(find.byKey(Key('btn1')));

  // Tab переводит на вторую
  await sendTab(tester);
  expectFocusOn(find.byKey(Key('btn2')));

  // Shift+Tab возвращает на первую
  await sendShiftTab(tester);
  expectFocusOn(find.byKey(Key('btn1')));
});

// === Overlay helpers ===
testWidgets('Dropdown closes with exit animation', (WidgetTester tester) async {
  final controller = OverlayController();

  await tester.pumpWidget(
    RenderlessTestApp(
      child: AnchoredOverlayEngineHost(
        controller: controller,
        child: RDropdownButton<String>(
          items: ['A', 'B', 'C'],
          onChanged: (_) {},
        ),
      ),
    ),
  );

  // Открываем dropdown
  await tester.tap(find.byType(RDropdownButton<String>));
  await tester.pump();

  final handle = controller.activeHandles.first;

  // Ждём фазу open
  await pumpUntilOverlayPhase(tester, handle, OverlayPhase.open);
  expectOverlayPhase(handle, OverlayPhase.open);

  // Закрываем
  handle.close(reason: CloseReason.userDismiss);
  await tester.pump();

  // Проверяем что не застряли в closing
  await expectOverlayNotStuckInClosing(tester, handle, timeout: Duration(seconds: 2));
});

// === Listbox helpers ===
testWidgets('Arrow keys navigate listbox', (WidgetTester tester) async {
  final controller = ListboxController();

  await tester.pumpWidget(
    RenderlessTestApp(
      child: ListboxScope(
        controller: controller,
        child: Column(children: [
          ListboxItem(id: ListboxItemId('a'), child: Text('Item A')),
          ListboxItem(id: ListboxItemId('b'), child: Text('Item B')),
          ListboxItem(id: ListboxItemId('c'), child: Text('Item C')),
        ]),
      ),
    ),
  );

  // Изначально ничего не highlighted
  expectHighlightedId(controller, null);

  // Arrow down → первый item
  await sendKey(tester, LogicalKeyboardKey.arrowDown);
  expectHighlightedId(controller, ListboxItemId('a'));

  // Arrow down → второй item
  await sendKey(tester, LogicalKeyboardKey.arrowDown);
  expectHighlightedId(controller, ListboxItemId('b'));

  // Typeahead: "c" → третий item
  await typeahead(tester, controller, 'c');
  expectHighlightedId(controller, ListboxItemId('c'));
});
```

**Оценка:** 9/10
**Почему:** без этого качество и a11y быстро становятся "везением", а не гарантией библиотеки.

#### 0.6) `headless_foundation/interactions`: InteractionController (зафиксировано)

**Цель:** унифицировать обработку press/hover/focus для всех интерактивных компонентов. Аналог React Aria `usePress`, но по-Flutter.

**Проблема Flutter primitives:**
- `GestureDetector` + `MouseRegion` + `Focus` не объединены
- Нет единого "pressed state" — каждый компонент делает по-своему
- Разная обработка cancel/drag-off

**Решение (зафиксировано):**

```dart
/// Тип устройства ввода (для разного visual feedback)
enum PointerType { mouse, touch, stylus, keyboard, assistiveTech }

/// Alias для Set<WidgetState>
typedef WidgetStateSet = Set<WidgetState>;

/// Контроллер интерактивных состояний.
/// Выход — Set<WidgetState>, совместимый с state_resolution (0.4).
class InteractionController extends ChangeNotifier {
  /// Raw user-driven states (pressed, hovered, focused)
  /// НЕ включает disabled — это external control
  WidgetStateSet get interactionStates;

  /// External control: disabled status (controlled by parent)
  bool get isDisabled;
  set isDisabled(bool value);

  /// Combined states для renderer.
  /// Включает disabled если isDisabled=true.
  WidgetStateSet get states => isDisabled
      ? {...interactionStates, WidgetState.disabled}
      : interactionStates;

  /// Тип устройства для активного press.
  /// null если не в состоянии pressed.
  PointerType? get activePointerType;

  // === Pointer events ===
  void handlePointerDown(PointerDownEvent event);
  void handlePointerUp(PointerUpEvent event);
  void handlePointerCancel(PointerCancelEvent event);

  // === Hover events ===
  void handleHoverEnter();
  void handleHoverExit();

  // === Focus events (delegated from FocusNode) ===
  void handleFocus();
  void handleBlur();

  // === Keyboard activation ===
  /// Returns true если Space/Enter был обработан как "press"
  bool handleKeyDown(KeyEvent event);
  void handleKeyUp(KeyEvent event);

  // === Semantics (screen reader activation) ===
  void handleSemanticTap();
}
```
