## I29 — Autocomplete v1.6: conformance + a11y SLA + keyboard/overlay polish + план multi-select

### Зачем эта итерация

`RDropdownButton` и `RTextField` уже близки к “production confidence” за счёт conformance‑отчётов и SLA‑тестов.  
`RAutocomplete` архитектурно выглядит правильно, но сейчас **проседает по доказательной базе** (conformance report = `TBD`) и по широте кейсов.

Цель итерации — довести `headless_autocomplete` до уровня “можно публиковать и защищать”:

- есть **conformance report** с evidence;
- есть **минимальный a11y/semantics SLA** (чтобы пресеты/рендереры не ломали доступность);
- есть **keyboard-only** матрица не хуже, чем у dropdown (в рамках Autocomplete UX);
- overlay/focus поведение сформулировано и зафиксировано тестами.

Отдельно: подготовить дизайн/контракт для **multi-select режима** (без поспешного API, который потом не выдержит).

---

### Scope (что делаем сейчас)

#### 1) Conformance report для `headless_autocomplete`

- Заполнить `packages/components/headless_autocomplete/CONFORMANCE_REPORT.md`
- Добавить ссылки на тесты как evidence.
- Зафиксировать Scope таблицу (Overlay/Listbox/Effects) согласно реальному поведению v1.6.

#### 2) Conformance / A11y SLA тесты для `RAutocomplete`

Минимальный SLA (как “страховка”):

- `SemanticsFlag.isTextField` присутствует на корне компонента.
- `enabled/disabled` корректно отражается.
- `readOnly` корректно отражается.
- `expanded state` корректно отражается при открытом меню.

Критерий готовности: тесты не зависят от конкретного пресета, используют тестовые renderer’ы.

#### 3) Keyboard-only матрица (RAutocomplete)

Минимально необходимое для desktop и a11y:

- `ArrowDown/ArrowUp`: открыть меню (если есть options) и навигация highlight.
- `Enter`: выбрать highlighted (когда меню открыто).
- `Escape`: закрыть меню без изменения selection.
- `Tab`: закрыть меню и отдать фокус дальше (не перехватываем Tab).

Опционально (если не сломает IME/инпут):

- `Home/End`: jump к первому/последнему option (когда меню открыто).

#### 4) Overlay + Focus policy (RAutocomplete)

Зафиксировать контракт:

- **Focus stays on input** при открытом меню (важно для IME/курсор/ввода).
- При programmatic close флаг “dismissed” не должен блокировать openOnFocus.
- При non-programmatic dismissal (клик мимо overlay) меню считается “dismissed”, и openOnFocus не переоткрывает меню мгновенно.

Минимальный набор тестов:

- Focus остаётся на input при открытии меню.
- `Escape` закрывает меню, focus остаётся на input.

---

### Non-goals (не делаем в этой итерации)

- Async options / debounce / cancel.
- Виртуализация списка (renderer concern).
- Free-solo режим (ввод “своего” значения как валидного).
- Новые пресеты/дизайн (только поведение/контракты/доказательная база).

---

## Multi-select: что хотим и как лучше назвать

### Пользовательский кейс

- Можно выбрать **несколько значений**.
- Выбранные значения показываются **внутри поля слева от текста** (токены/чипы/inline).
- В меню элементы по умолчанию (Material preset) показываются **с чекбоксом слева**.

Это в индустрии часто называют:

- **Multi-select autocomplete**
- **Tokenized autocomplete**
- **Tag picker / tag input**
- (в web/ARIA) часто говорят “**multi-select combobox**”, но это может путать.

### Рекомендация по неймингу в нашем проекте

Чтобы пользователям Flutter было максимально понятно и без конфликтов с `DropdownButton`:

- Оставить базовый виджет как `RAutocomplete<T>` (single-select, как сейчас).
- Добавить named constructor **`RAutocomplete.multiple<T>(...)`** для multi-select.
  - Это типобезопаснее, чем “один виджет с универсальным коллбеком”.
  - И визуально читается как отдельный режим, не смешивая API.

Термин **Combobox** можно упоминать в документации как “синоним/паттерн”, но не делать его главным именем API.

---

## Предлагаемая архитектура multi-select (vNext)

### Принципы

- Не ломать существующий single-select API.
- Не делать “два разных компонента” с дубляжом — должно быть одно ядро поведения.
- Renderer остаётся **не-generic**; данные уходят в UI как list items + индексы + lightweight state.

### Минимальные изменения в контрактах/requests (идея)

- Menu request должен уметь отражать “checked” состояние для items (для чекбоксов).
  - Вариант A (минимальный): расширить `HeadlessListItemModel` флагом `isSelected` (или отдельным `selectionState`).
  - Вариант B (контрактный): добавить в `RDropdownButtonState` поле `selectedItemsIndices: Set<int>`.
- Field request должен уметь отрендерить “prefix tokens”.
  - В `RTextFieldSlots` уже есть slots — можно завести slot под prefix/tokens (если его нет).

### Поведение multi-select (черновик инвариантов)

- Выбор в меню **toggle**:
  - если item не выбран — добавляем
  - если выбран — убираем
- По умолчанию меню **не закрывается** при выборе (closeOnSelected=false).
- Ввод текста служит для **фильтра**, а не как “значение поля”.
- После выбора пунктов **очищаем query** (как дефолт).
- Backspace при пустом query **удаляет последний выбранный**.

---

## Open questions (закрыто в v1.6)

### Зафиксированные решения (на основании обсуждения)

- **Отображение выбранных**: выбор между “chips” и “csv” контролируется preset’ом (Material) и может расширяться. В headless режим не ограничивает renderer.
- **После выбора**: query очищается.
- **Фильтрация**: поведение контролируется флагами:
  - `hideSelectedOptions` (скрывать/не скрывать)
  - `pinSelectedOptions` (показывать выбранные наверху или на своих местах)
- **Backspace**: при пустом query удаляет последний выбранный.

### Решено (v1.6)

1) **Как отдаём изменения selection наружу**:
   - single: `onSelected(T)`
   - multiple: `selectedValues + onSelectionChanged(List<T>)` (controlled mode)
2) **Удаление по клику** (chips с крестиком):
   - да, через команды в renderer contract.
   - базовая команда: `removeById(ListboxItemId)` (устойчива к любому порядку отображения).
   - дополнительная удобная команда: `removeAt(index)` (индекс в `selectedItems` текущего render request).
3) **Композиция prefix**:
   - selected-values prefix больше не блокируется пользовательским `fieldSlots.prefix`.
   - если задан `fieldSlots.prefix`, он композиционируется вместе с selected-values prefix.
4) **Контракт на id**:
   - в multiple режиме `itemAdapter.id(value)` должен быть стабильным и уникальным
     (используется для toggle selection, checked state и chip removal).

---

## Реализовано в v1.6 (факт)

- Conformance report заполнен: `packages/components/headless_autocomplete/CONFORMANCE_REPORT.md`.
- A11y SLA тест добавлен: `packages/components/headless_autocomplete/test/conformance_a11y_sla_test.dart`.
- Keyboard/overlay поведение покрыто тестами, включая focus/dismissed‑policy:
  - `packages/components/headless_autocomplete/test/r_autocomplete_test.dart`.
- Multi-select режим:
  - `RAutocomplete.multiple<T>(...)`
  - toggle selection, clear query, backspace remove last
  - `hideSelectedOptions` / `pinSelectedOptions`
  - `selectedItemsIndices` в `RDropdownButtonState` для menu renderer.
- Material preset:
  - чекбоксы слева в меню при multi-select
  - рендер выбранных в поле через `RAutocompleteSelectedValuesRenderer`
    (chips / csv via `RAutocompleteSelectedValuesPresentation`).
  - удаление chip по крестику через `RAutocompleteSelectedValuesCommands.removeById(...)`

### Интеграционные тесты (iOS emulator)

- Добавлены E2E сценарии multi-select:
  - `apps/example/integration_test/autocomplete_test.dart` (IT-10 … IT-13)
  - `apps/example/integration_test/helpers/autocomplete_multi_select_scenario.dart`

---

## Definition of Done (v1.6)

- `headless_autocomplete/CONFORMANCE_REPORT.md` заполнен и соответствует реальности.
- Добавлен `test/conformance_a11y_sla_test.dart` для `RAutocomplete`.
- Keyboard/overlay поведение покрыто тестами (минимум: ArrowDown/Enter/Escape/Tab + expanded semantics).
- Все тесты проходят (`flutter test`).

