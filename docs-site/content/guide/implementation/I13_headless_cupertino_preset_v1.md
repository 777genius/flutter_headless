## I13 — Preset v1: `headless_cupertino` (parity + platform POLA)

### Цель

Дать пользователям второй “быстрый прод‑старт”:
- `headless_cupertino` preset, который реализует те же capability contracts,
- и при этом ведёт себя “как ожидает iOS” (POLA), не ломая headless‑контракты.

### Ссылки

- Архитектура: `docs/ARCHITECTURE.md`
- Контракты: `docs/V1_DECISIONS.md`
- Per-instance гибкость: `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`
- I11 Material preset: `docs/implementation/I11_headless_material_preset_v1.md`
- Spec/Conformance: `docs/SPEC_V1.md`, `docs/CONFORMANCE.md`

---

## Что делаем

### 1) Пакет `packages/headless_cupertino`

Публичный API:
- `CupertinoHeadlessTheme` (implements `HeadlessTheme`)
- capabilities: button + dropdown (v1 минимум)

Тонкий момент:
- parity по контрактам ≠ визуальная идентичность.
  - Контракты должны совпадать, а визуал/платформенные детали могут отличаться.

---

### 2) Button (Cupertino)

- resolver: `RButtonTokenResolver` (cupertino typography, colors, paddings)
- renderer: строит кнопку в стиле iOS

Кастомизация:
- contract overrides (`RButtonOverrides`) — must support
- preset overrides (advanced) — optional

---

### 3) Dropdown (Cupertino)

В iOS есть разные паттерны выбора:
- action sheet / picker style / context menu

В v1 фиксируем минимальный путь:
- `RDropdownButton<T>` остаётся тем же компонентом,
- `headless_cupertino` renderer может визуально реализовать “cupertino menu” стилем,
- но должен соблюдать:
  - highlighted≠selected,
  - keyboard сценарии (для iPad/desktop),
  - close contract (closing→completeClose).

Тонкие моменты:
- не надо пытаться сделать `CupertinoPicker` как замену dropdown v1 — это отдельный компонент.

#### Cupertino Dropdown — UX решение для v1

**Выбор**: Popover-style menu (overlay рядом с trigger)

**Обоснование**:
- Parity с Material dropdown behaviour
- Работает на iPad/desktop (keyboard навигация)
- ActionSheet — это другой паттерн (bottom sheet), можно добавить как отдельный компонент в v1.1+

**Исключено из v1**:
- CupertinoPicker (это другой компонент, не dropdown)
- ActionSheet mode для dropdown

#### Non-generic Contracts (как в Material)

Renderer и resolver работают с индексами, не с `T`:
- `CupertinoDropdownRenderer implements RDropdownButtonRenderer` (non-generic)
- `CupertinoDropdownTokenResolver implements RDropdownTokenResolver` (non-generic)

Capability lookup:
```dart
theme.capability<RDropdownButtonRenderer>()  // ✅ правильно
theme.capability<RDropdownButtonRenderer<String>>()  // ❌ запрещено
```

#### Keyboard сценарии

**Обязательные тесты**:
- iPad/desktop: Tab focus, Arrow keys, Enter/Space, Escape
- iPhone: touch-only (keyboard тесты не применимы)

**Platform-aware поведение**:
- Focus ring: показывать только при keyboard navigation (не touch)
- Это может быть через `FocusHighlightMode` detection

#### Overlay Safe Areas

**Требования**:
- Popover не должен выходить за safe area (notch, home indicator)
- ClipRRect + blur для "Cupertino feel" — optional, но рекомендуется

**Dismiss**:
- Tap вне — закрывает
- Escape (desktop) — закрывает
- Swipe gesture — не для v1 (YAGNI)

#### Popover Positioning (v1 минимум)

**Стратегия позиционирования**:
- Привязка к trigger (ниже или выше, в зависимости от места)
- Clamp по safe area (не выходить за экран)
- Без Floating-UI / fancy repositioning в v1

**Реализация (простая)**:
```dart
// Получаем позицию trigger
final triggerBox = context.findRenderObject() as RenderBox;
final triggerPosition = triggerBox.localToGlobal(Offset.zero);

// Определяем направление (вниз если есть место, иначе вверх)
final screenHeight = MediaQuery.of(context).size.height;
final safeArea = MediaQuery.of(context).padding;
final spaceBelow = screenHeight - triggerPosition.dy - triggerBox.size.height - safeArea.bottom;

final showBelow = spaceBelow >= menuHeight;
```

**Отложено на v1.1+**:
- Автоматическое repositioning при скролле
- Flip/shift стратегии (как в Floating-UI)

---

### 4) Тесты

#### Тест-матрица I13 (минимум)

| ID | Сценарий | Описание |
|----|----------|----------|
| T1 | Tokens flow | resolvedTokens попадают в renderer |
| T2 | Keyboard | Open/navigate/select/escape (desktop) |
| T3 | Close contract | exit animation → onCompleteClose |
| T4 | A11y | expanded/label/enabled в semantics |
| T5 | Overrides | RDropdownOverrides применяются |

Минимум:
- tokens flow
- per-instance overrides
- close contract

#### Close Contract — уточнение

Exit animation живёт в renderer. Renderer **обязан** вызвать `onCompleteClose()` после завершения анимации.

```dart
// В CupertinoDropdownRenderer (пример)
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    if (_controller.isDismissed &&
        request.state.overlayPhase == ROverlayPhase.closing) {
      // Вызываем в postFrameCallback чтобы не ломать build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        request.callbacks.onCompleteClose();
      });
    }
    return ...;
  },
)
```

**Гарантии**:
- Renderer должен вызвать `onCompleteClose()` даже если анимация была прервана
- Timeout policy (если нужно) — на стороне компонента, не renderer'а

---

## Артефакты итерации (конкретные пути)

**Theme** (`packages/headless_cupertino/lib/`):
- `src/cupertino_headless_theme.dart`
- `headless_cupertino.dart` (barrel)

**Button** (`packages/headless_cupertino/lib/src/button/`):
- `cupertino_flutter_parity_button_renderer.dart`
- `cupertino_button_token_resolver.dart`

**Dropdown** (`packages/headless_cupertino/lib/src/dropdown/`):
- `cupertino_dropdown_renderer.dart`
- `cupertino_dropdown_token_resolver.dart`

**Tests** (`packages/headless_cupertino/test/`):
- `button_tokens_test.dart`
- `dropdown_tokens_test.dart`
- `dropdown_keyboard_test.dart`
- `dropdown_close_contract_test.dart`
- `overrides_test.dart`

---

## Критерии готовности (DoD)

- `headless_cupertino` компилируется, тесты проходят.
- Example app можно переключить между Material/Cupertino preset (можно через флаг/переключатель).

---

## Чеклист

- [ ] Создан пакет `headless_cupertino`.
- [ ] Реализован `CupertinoHeadlessTheme`.
- [ ] Реализованы button/dropdown renderers + token resolvers (non-generic).
- [ ] Поддержаны contract overrides.
- [ ] Dropdown: Popover-style (не ActionSheet — это v1.1+).
- [ ] Close contract: `onCompleteClose()` вызывается после exit animation.
- [ ] Тесты по матрице T1–T5.
- [ ] Интеграция в example app (переключатель Material/Cupertino).

