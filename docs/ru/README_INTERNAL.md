## Internal design notes (Russian)

Русские документы в `docs/` — это внутренние дизайн-ноты для проектирования.

## Problem (internal notes)

| Существующие решения | Проблема |
|---------------------|----------|
| Material / Cupertino | Навязывают визуал |
| Forui / shadcn | Готовый дизайн, не для multi-brand |
| Mix | Свой DSL, string-based токены |
| naked_ui | Headless, но без тем и вариантов |

## Solution (internal notes)

Headless — это библиотека, где:

- **Headless** — `R*` компоненты управляют поведением/состояниями/a11y и не знают “как выглядят”
- **Type-safe** — variants/specs как `sealed` (exhaustive checking)
- **Zero-cost tokens** — `extension type` для токенов
- **Multi-brand** — один набор компонентов, разные темы/рендереры
- **Zero dependencies** — минимальная зависимость от экосистемы

Дополнительно: Headless — это **spec-first стандарт** для экосистемы.  
Сторонние авторы могут делать свои publishable компоненты/библиотеки и заявлять совместимость через `docs/SPEC_V1.md` + `docs/CONFORMANCE.md`.

Почему это важно: `docs/WHY_HEADLESS.md` (design notes) / `docs/en/README.md` (community)  
Архитектура: `docs/ARCHITECTURE.md`  
Решения v1: `docs/V1_DECISIONS.md`  
Спецификация для community-компонентов: `docs/SPEC_V1.md`
Conformance (как заявлять совместимость): `docs/CONFORMANCE.md`
Исследование конкурентов: `docs/RESEARCH.md`  
Приоритеты/ROI: `docs/MUST.md`

---

## Текущий статус (актуально)

- Monorepo на `melos` настроен, общий `analysis_options.yaml` есть.
- Core пакеты в наличии: `headless_tokens`, `headless_foundation`, `headless_contracts`, `headless_theme`, `anchored_overlay_engine`.
- Пресеты: `headless_material`, `headless_cupertino`.
- Компоненты: `headless_button`, `headless_dropdown_button`, `headless_textfield`,
  `headless_checkbox`, `headless_autocomplete`.
- DX sugar: `R*Style` + `mergeStyleIntoOverrides`, `Headless*Scope`,
  `MaterialHeadlessDefaults`.
- Документация разделена на Users/Contributors + есть CLI generator и golden path.

---

## Bootstrap (сделано)

- [x] Monorepo tooling (`melos`) + `melos.yaml`.
- [x] Единые SDK constraints + workspace.
- [x] Пакеты-скелеты для core, components, presets, facade, test, example.
- [x] Общий `analysis_options.yaml`.
- [x] CI guardrails (format/analyze/test + policy checks).

## Ключевые решения v1 (зафиксировано)

- **Нейминг**: Flutter-like, но без конфликтов — `RTextButton`, `RDropdownButton<T>`, `RDialog` (v1).
- **Select-like**: отдельного `RSelect` в v1 нет — используем `RDropdownButton<T>`.
- **Строго headless**: структура/визуал делегируются в **renderer contracts**, `R*` отвечает за поведение/состояния/a11y
- **Overlay**: `AnchoredOverlayEngineHost` + `OverlayController` + `OverlayHandle` в `anchored_overlay_engine` (без Navigator), полный движок позиционирования (floating-ui идеи)
- **Menu-паттерны**: без `headless_menu` компонента — через `headless_foundation/listbox/*`
- **Dual API**: v1 = **D2a** (power-user через foundation primitives), путь к D2b — аддитивно
- **Стандарт поведения**: **E1** (`events` + pure `reduce` + `effects`), FSM допускается поверх E1
- **Async**: **A1** (effects executor → result events), reducer остаётся pure
- **i18n**: **I1** (контракт + дефолты через Flutter локализации), без “30 языков” в core
- **Parts**: **P1** (только typed slots/parts), без string/data-part

---

## Структура репозитория (monorepo)

```text
headless/
├─ packages/
│  ├─ headless_tokens/                 # Raw + semantic tokens
│  ├─ anchored_overlay_engine/         # overlay engine (lifecycle/policies/positioning)
│  ├─ headless_foundation/             # focus/listbox/fsm/state resolution
│  ├─ headless_contracts/              # renderer contracts + slots/overrides
│  ├─ headless_theme/                  # theme runtime + capability overrides
│  ├─ headless_material/               # Preset renderers (Material 3)
│  ├─ headless_cupertino/              # Preset renderers (Cupertino)
│  ├─ headless_test/                   # Опциональные test helpers (a11y/overlay/focus/keyboard)
│  ├─ components/
│  │  ├─ headless_button/
│  │  ├─ headless_dropdown_button/
│  │  └─ ...
│  └─ headless/                        # Facade (ре-экспорт “разумного набора”)
├─ apps/
│  └─ example/
├─ tools/
│  └─ headless_cli/                    # Optional tooling: W3C import + skeleton generation (без UI логики)
└─ docs/
```

---

## Roadmap

### План развития (пока только планируем, без реализации кода)

Актуальный статус по итерациям и закрытым задачам:
- `docs/implementation/README.md`
- `docs/implementation/I25_user_dx_simplification_v1_2.md`

Ниже **оценка = ROI (1–10)**: польза/универсальность/долговечность относительно сложности.  
Ключевые принципы: **Composition > Inheritance**, **POLA** (Principle of Least Astonishment).

#### P0 — закрепить “настоящий headless” и стабильность API

- [ ] **Renderer contract: вынести рендеринг из `R*` в контракты рендера — 9/10**
  - `R*` отвечает за поведение/состояния/a11y, а структура/визуал живут в “renderer”.
  - Итог: один и тот же headless-компонент можно визуально реализовать по-разному в разных брендах без форков.

- [ ] **Segregated theme contract + композиция capability-резолверов — 9/10**
  - Не раздувать тему десятками `resolveX` как обязательный контракт.
  - Собирать тему как композицию: `ButtonResolver`, `InputResolver`, `DialogResolver`, и т.д. (capability-based).

- [ ] **Parts/Slots API для сложных компонентов — 8/10**
  - Для `Dialog/Select/Menu/DatePicker` нужна “анатомия” (например `Root/Trigger/Content/...`) для полной композиции.

- [ ] **Политика стабильности API + версионирование контрактов — 8/10**
  - Capability discovery/дефолтные реализации/адаптеры, чтобы добавление новых возможностей не ломало пользователей.

#### P1 — расширяемость поведения без форков

- [ ] **Единый слой state resolution (приоритеты/комбинации состояний) — 8/10**
  - `Set<WidgetState>` не задаёт приоритеты. Нужны явные правила, чтобы поведение было предсказуемым (POLA).

- [ ] **FSM для сложных интерактивных паттернов — 8/10**
  - Для `Select/Combobox/Menu` конечные автоматы уменьшают количество “странных” багов (фокус/клавиатурa/закрытие).

- [ ] **Controlled/uncontrolled + перехват переходов (аналог `stateReducer`) — 7/10**
  - Позволяет продуктовым командам точечно менять поведение без копирования компонента.

#### P2 — общая инфраструктура UI

- [ ] **Overlay/Popover инфраструктура отдельным модулем — 7/10**
  - Общий слой для позиционирования/скролла/барьеров/фокус-трапа, чтобы `Dialog/Menu/Tooltip` не решали это по-разному.

- [ ] **Семантические токены поверх “сырых” — 7/10**
  - Сместить фокус с `primaryColor` на семантику (`actionPrimaryBg`, `dangerFg`, `surfaceRaisedBg`).

#### P3 — тесты на поведение и доступность

- [ ] **Тестовая стратегия “поведение + a11y” (без упора в golden) — 7/10**
  - Проверять переходы состояний, фокус, клавиатурные сценарии, семантику.

---

### Базовый список задач (после согласования плана)

- [x] Архитектура (слои и терминология)
- [ ] Core tokens (Spacing, Radii, Durations)
- [ ] Прототип: Button как headless (через renderer contract)
- [ ] Прототип: Dialog/Overlay (как foundation для parts/slots)
- [ ] Example themes (2+ бренда)
- [ ] Documentation
- [ ] pub.dev release

---

## Development

### Требования

- Dart SDK >=3.3.0
- Flutter >=3.16.0

### Локальный запуск

```bash
# Установка зависимостей
dart pub get
dart run melos bootstrap

# Проверки (как в CI)
dart run melos run format
dart run melos run analyze
dart run melos run test
```

---

## Лицензия

MIT

