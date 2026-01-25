## I19 — Conformance & Policies v1: A11y/Semantics SLA + Focus policy + Interaction contracts

### Контекст и мотивация

Мы уже закрыли большой класс “визуальных” проблем через:

- capability-based theme + per-instance overrides
- overlay positioning + reposition SLA (I15–I18)
- listbox foundation (I16)

Следующий класс проблем, который обычно “всплывает позже” и стоит дорого:

- a11y/semantics ломается незаметно при развитии preset’ов/renderer’ов
- фокус и клавиатурные сценарии расходятся между компонентами
- “activation vs navigation vs selection” начинает жить по разным правилам

Цель I19 — не реализовать один компонент, а **зафиксировать системные SLA/контракты и поставить тестовый периметр**, чтобы архитектура выдерживала рост.

### Scope (что делаем)

#### 1) A11y/Semantics SLA для всех `R*`

Определяем минимальный SLA (must-pass) для компонентов:

- **role**: button/textField/menuButton и т.п.
- **name**: label / semanticLabel
- **state**: enabled/disabled, expanded/collapsed, readOnly, focused
- **keyboard-only**: базовые сценарии без мыши (Enter/Space/Escape/Arrows)

Формат: “conformance tests” (как overlay SLA), которые **не привязаны к конкретному renderer**, а проверяют поведение/semantics контракта компонента.

#### 2) Focus policy для композитных паттернов

Фиксируем правила (policy), а не только ownership:

- **restore**: при закрытии overlay фокус возвращается на trigger (или на заданный узел)
- **menu focus**: при открытии menu/dropdown фокус остается на trigger или переходит в overlay — правило должно быть единым и тестируемым
- **disable/remove**: если selected/highlighted/active item стал disabled/removed — поведение детерминированно

Минимум в I19: restore policy + тесты на Dropdown/Overlay.

#### 3) Interaction contracts (единые контракты)

Документируем, как разделяем:

- **activation** (button-like): вызывает callbacks, имеет pressed state
- **navigation** (list/menu-like): перемещает highlight/active, не “активирует”
- **selection** (select-like): commit selection и закрытие overlay

И связываем это с уже существующими слоями:

- `HeadlessPressableController/Region` (activation)
- `ListboxController` (navigation + typeahead)
- Dropdown controllers (selection orchestration)

### Deliverables

#### D1) `headless_test` как место для conformance harness

Добавляем reusable test helpers:

- SemanticsSla (role/name/state assertions)
- Semantics utils без deprecated API

#### D2) Conformance tests для первых компонентов

- `headless_button`: Semantics SLA (button role, enabled/disabled, label)
- `headless_textfield`: Semantics SLA (textField role, enabled/disabled, readOnly)
- `headless_dropdown_button`: Semantics SLA (button role + expanded state)

#### D3) Документация

- обновляем `docs/CONFORMANCE.md` (явно добавить “SLA test suites” как MUST evidence)
- фиксируем contracts в `docs/ARCHITECTURE.md` (interaction contracts + focus restore policy)

### Acceptance criteria

- `melos run analyze` и `melos run test` проходят.
- В `headless_test` есть стабильные helpers без deprecated APIs.
- Для каждого из 3 компонентов есть отдельный “Conformance / A11y SLA” тест-набор.
- Контракты зафиксированы письменно (не только в итерации).

### Follow-ups (следующие итерации)

- I20: Select/Combobox reference implementation (Listbox + overlay + IME) + расширенный a11y suite
- I21: Focus trap policies для dialog/popover + conformance
- I22: Performance guardrails + microbench suite (rebuild/notify budgets)

