## I20 — Component Skeleton v1 (golden path) + guardrails

### Цель

Сделать масштабирование количества компонентов “без боли”:

- новые компоненты создаются по **единому скелету** (POLA),
- архитектурные инварианты защищены **автоматическими guardrails**,
- пользователю очевидно “как пользоваться” (не надо читать весь репозиторий).

### Что входит в “golden path”

#### 1) Структура package (feature-slice)

```
packages/components/<component_name>/
  lib/
    <component_name>.dart
    src/
      presentation/
        ... widgets + state ownership (coordination only)
      render_request/
        ... сборка RenderRequest (pure-ish)
      logic/
        ... чистые алгоритмы (keyboard mapping, typeahead, index math)
      domain/
        ... (опционально) value objects / invariants (без flutter imports)
  test/
    ... минимальный набор тестов (см. ниже)
  LLM.txt
  CONFORMANCE_REPORT.md
```

#### 2) Обязательные зависимости

- `headless_foundation` — overlay/listbox/interactions/effects primitives
- `headless_contracts` — renderer/token contracts + slots/overrides
- `headless_theme` — capability discovery + overrides + bootstrap
- `headless_tokens` — token types (если применимо)
- `headless_test` — тестовые SLA helpers (semantics/keyboard/overlay)

#### 3) Ownership правила

- Controlled/uncontrolled: controlled входы **не перетираются** внутренним стейтом.
- Внешние controller’ы компонент **не** dispose’ит; внутренние — dispose’ит.
- Сборка render request **не** живёт в `State` (выносится в отдельный объект).
- UI не выносить в `_build*` методы — только отдельные виджеты/файлы.

### Минимальная тест-матрица (MUST)

Для каждого non-placeholder компонента:

- Semantics/a11y:
  - role (button/textfield/etc)
  - disabled state
  - label/semanticLabel
- Keyboard-only:
  - Enter/Space activation (где применимо)
  - Escape closes overlay (если overlay)
  - Focus restore (если overlay)
- Controlled/uncontrolled:
  - controlled value отражается в state/render request
  - uncontrolled updates через callbacks
- Overlay lifecycle (если overlay):
  - close() → closing
  - completeClose() → closed

### Guardrails (автоматические проверки)

#### 1) LLM metadata MUST

Каждый пакет в `packages/*` должен иметь `LLM.txt`.

#### 2) Conformance report MUST (для components)

Каждый пакет в `packages/components/*` должен иметь `CONFORMANCE_REPORT.md`.

#### 3) Запрет component → component deps (MUST)

Компоненты не должны зависеть от других компонентных пакетов.
Разрешены зависимости только на foundation/tokens/theme/test.

### Как запускать guardrails

```bash
melos run guardrails
```

