## I24 — Autocomplete v1: composable “TextField + Menu” (Flutter-like API) без дублирования логики (part 2)

Back: [Index](./I24_autocomplete_v1.md)

## Options меняются пока меню открыто (тонкие моменты)

Autocomplete почти всегда пересчитывает options при каждом изменении текста, поэтому:

### 1) Стабильность highlight при обновлении options

MUST policy:
- если текущий `highlightedId` всё ещё присутствует в новом options списке → сохраняем его,
- иначе:
  - если есть `selectedId` и он присутствует и enabled → highlight selected,
  - иначе → highlight first enabled,
  - иначе → highlight null.

Почему так:
- предотвращает “скачки” highlight на каждую букву,
- делает ArrowUp/Down предсказуемыми.

### 2) Стабильность selection

Selection (`selectedId`) не должен “сам” прыгать из-за изменения options.
Он меняется только:
- при selectIndex,
- или при пользовательском вводе текста (см. правила выше).

---

## Close/open thrash (тонкие моменты)

Классическая проблема Autocomplete:
- пользователь кликает вне меню → overlay dismiss закрывает меню,
- input остаётся focused,
- на следующем build логика `openOnFocus`/`openOnInput` может снова открыть меню.

MUST policy v1:
- открытие по focus происходит **только на событие “focus gained”**, а не “потому что сейчас focused”.
- открытие по input происходит **только на событие изменения текста**, и подавляется во время `isApplyingSelectionText`.
- после dismiss (tap outside) можно поставить внутренний `wasDismissed` и сбросить его при следующем вводе/ArrowDown/explicit tap (чтобы не было мгновенного re-open).

---

## Foundation refactor (чтобы реально не дублировать логику)

### Проблема

Dropdown уже содержит glue‑логику overlay/menu state/close contract. Autocomplete потребует почти то же, но с другим focus model.

### Решение v1

Вынести общий “anchored menu overlay lifecycle” в `headless_foundation/src/menu/` как primitives, но **без dropdown‑специфики** (SRP):

- `headless_menu_overlay_controller.dart`
  - открытие/закрытие/completeClose для anchored overlay
  - владеет `OverlayHandle` (из `anchored_overlay_engine`)
  - слушает `OverlayHandle.phase` (`OverlayPhase` из `anchored_overlay_engine`)
  - **не хранит** highlight/selected (это listbox concern)
  - поддерживает опциональный “transfer focus to overlay”:
    - dropdown: да (menuFocusNode.requestFocus())
    - autocomplete: нет (focus stays in input)
- `headless_menu_state.dart`
- `headless_menu_anchor.dart` (value object, чтобы не протаскивать 10 параметров)
- (опционально) `headless_menu_keyboard_router.dart` — helper, но key events остаются в компоненте

#### Почему так SOLID/clean

- **SRP**: overlay controller отвечает только за overlay lifecycle/phase, а не за navigation/highlight.
- **DIP**: controller принимает зависимости через параметры (anchor + builder), не знает про renderer contracts.
- **Boundary**: внутри foundation используются `OverlayPhase`/`OverlayHandle`. Компоненты мапят это в свои contract state (`ROverlayPhase`) при сборке render request.

#### Как именно переиспользуем (без дублирования)

- `headless_dropdown_button` перестаёт держать собственный `DropdownOverlayController` с дублирующимися правилами.
  - В компоненте остаётся только тонкий адаптер: “как собрать anchorRect + какой focus policy + куда восстановить фокус”.
- `headless_autocomplete` использует тот же `headless_menu_overlay_controller.dart`, но:
  - с focus policy “не переводить фокус в overlay”
  - с открытием по input/tap rules (см. выше)

---

## Минимальный API `HeadlessMenuOverlayController` (псевдо‑Dart, MUST)

Цель: один reusable контроллер, который закрывает общий lifecycle anchored overlay меню.
Он **не знает** про dropdown/autocomplete, не знает про renderer contracts и не содержит listbox логики.

```dart
/// Политика фокуса для overlay меню.
enum HeadlessMenuFocusTransferPolicy {
  /// Не переводить фокус в overlay (Autocomplete v1 default).
  keepFocusOnAnchor,
  /// Перевести фокус на menu FocusNode после mount (Dropdown default).
  transferToMenu,
}

/// Value object для anchoring (не тащим 10 параметров).
final class HeadlessMenuAnchor {
  const HeadlessMenuAnchor({
    required this.anchorLink,
    required this.anchorSizeGetter,
    required this.anchorRectGetter,
    required this.restoreFocus,
  });

  final LayerLink anchorLink;
  final Size? Function() anchorSizeGetter;
  final Rect? Function() anchorRectGetter;
  final FocusNode restoreFocus;
}

/// Реюзабельный controller anchored overlay меню.
final class HeadlessMenuOverlayController {
  HeadlessMenuOverlayController({
    required this.contextGetter,
    required this.isDisposedGetter,
  });

  final BuildContext Function() contextGetter;
  final bool Function() isDisposedGetter;

  /// Текущая фаза overlay (foundation OverlayPhase).
  ValueListenable<OverlayPhase> get phase;

  bool get isOpen; // opening||open

  /// Открыть меню. Создаёт overlay и начинает opening→open.
  ///
  /// - [builder] строит widget overlay контента (menu-only).
  /// - [anchor] — параметры anchoring + restoreFocus.
  /// - [dismissPolicy]/[focusPolicy] — из anchored_overlay_engine.
  /// - [focusTransfer] — поведение фокуса.
  /// - [menuFocusNode] — обязателен при transferToMenu.
  void open({
    required Widget Function(BuildContext overlayContext) builder,
    required HeadlessMenuAnchor anchor,
    required DismissPolicy dismissPolicy,
    required FocusPolicy focusPolicy,
    required HeadlessMenuFocusTransferPolicy focusTransfer,
    FocusNode? menuFocusNode,
  });

  /// Начать закрытие (closing). Не удаляет overlay.
  void close();

  /// Завершить закрытие (closed) и удалить overlay.
  void completeClose();

  void toggle({
    required Widget Function(BuildContext overlayContext) builder,
    required HeadlessMenuAnchor anchor,
    required DismissPolicy dismissPolicy,
    required FocusPolicy focusPolicy,
    required HeadlessMenuFocusTransferPolicy focusTransfer,
    FocusNode? menuFocusNode,
  });

  /// Должен быть безопасен: close/completeClose idempotent.
  void dispose();
}
```

Инварианты этого controller’а (MUST):
- `open()` no-op если overlay уже открыт.
- `close()`/`completeClose()` idempotent.
- `completeClose()` можно вызывать даже если overlay уже disposed (не падать).
- перевод фокуса в overlay выполняется только если `focusTransfer == transferToMenu`.
- restoreFocus всегда делается через `AnchoredOverlayEngineHost` политику (`restoreFocus: anchor.restoreFocus`), а не вручную.

Почему это важно:
- dropdown и autocomplete перестают держать “свои” overlay controllers (дублирование исчезает),
- различия сведены к параметрам (policy), а не копипасте.

---

## Пакеты/файлы (feature-slice)

### 1) `headless_foundation`

`lib/src/menu/`:
- `headless_menu_state.dart`
- `headless_menu_overlay_controller.dart`
- `headless_menu_anchor.dart`
- (опционально) `headless_menu_focus_policy.dart`

Экспорт через публичный entrypoint (как принято в репо).

### 2) `components/headless_autocomplete` (новый пакет)

- `lib/headless_autocomplete.dart`
- `lib/src/presentation/r_autocomplete.dart` (orchestration)
- `lib/src/presentation/r_autocomplete_field.dart` (виджет input)
- `lib/src/presentation/r_autocomplete_menu_overlay.dart` (overlay presenter)
- `lib/src/logic/autocomplete_options_controller.dart` (кэш + пересчёт options)
- `lib/src/logic/autocomplete_selection_controller.dart` (selectedId + text sync правила)

Никаких `_build*` методов.

---

## Доказательство “реально не дублируем код” (чеклист ревью)

Это секция для code review: если любой пункт нарушен — итерация считается “не как надо”.

- **Overlay lifecycle**:
  - [ ] В `headless_dropdown_button` и `headless_autocomplete` нет двух разных реализаций open/close/completeClose.
  - [ ] Общая логика anchored overlay находится в `headless_foundation/src/menu/`.
  - [ ] Компоненты различаются только политиками (focus transfer yes/no, open triggers).

- **Listbox navigation**:
  - [ ] Оба компонента используют `ListboxController.setMetas` и `ListboxItemMeta` как единственный источник навигации/highlight.
  - [ ] Нет “второй” реализации wrap-around/skip-disabled на уровне компонентов.

- **Renderer contracts**:
  - [ ] Нет нового renderer контракта “только для Autocomplete menu”.
  - [ ] Меню рендерится через `RDropdownMenuRenderRequest` из `headless_contracts`.
  - [ ] Поле рендерится через `RTextFieldRenderer` из `headless_contracts`.

- **Text selection sync**:
  - [ ] Логика `selectedId ↔ text` живёт в одном узком месте (`autocomplete_selection_controller.dart`).
  - [ ] Есть явная защита от self-trigger (suppressNextTextChange).

---

## Guardrails (MUST)

- `HeadlessListItemModel.id` уникален среди текущих options (assert).
- `typeaheadLabel` нормализован (уже enforced).
- Никаких component→component deps.
- Renderer не вызывает app callbacks напрямую (только commands).
- Никаких `Widget/BuildContext` в foundation моделях.

---

## Тесты (MUST для v1)

Component tests `components/headless_autocomplete/test`:

- **Selection/text sync**
  - selecting option updates text + selectedId
  - user edit clears selectedId
- **Keyboard**
  - ArrowDown opens & navigates highlight
  - Enter selects highlighted when menu open
  - Escape closes without selection
- **Focus**
  - focus stays on input on open (default)
  - tab closes menu
- **Options**
  - optionsBuilder called only on text changes (cache)
  - empty options closes menu
- **Open triggers**
  - openOnTap открывает меню при focus=true (без изменения текста)
  - dismiss не приводит к мгновенному re-open (anti-thrash)
- **Guardrails**
  - duplicate id asserts in debug

После тестов:

```bash
melos run analyze
melos run test
```

---

