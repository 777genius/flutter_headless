## Monorepo архитектура (feature-first + DDD + SOLID) (part 1) (part 2)

Back: [Index](./ARCHITECTURE_part_01.md)

## Monorepo архитектура (feature-first + DDD + SOLID)

Цель: **не монолит**, а набор независимых модулей "по фичам", при этом сохраняем **DDD** (Variants/Specs/Resolved/Contracts), **SOLID** (особенно ISP/DIP) и требования из `docs/MUST.md`.

### Связанные документы

| Документ | Содержание | Ключевые секции |
|----------|-----------|-----------------|
| [`V1_DECISIONS.md`](./V1_DECISIONS.md) | Зафиксированные решения v1 | [Contracts 0.1-0.7](./V1_DECISIONS.md#оглавление-quick-links), [API Stability](./V1_DECISIONS.md#api-stability-matrix-v10-зафиксировано), [D2a/D2b](./V1_DECISIONS.md#dual-api-d2a-сейчас-путь-к-d2b-потом--зафиксировано) |
| [`MUST.md`](./MUST.md) | ROI приоритеты | Renderer contract (9/10), ISP (9/10), Parts/Slots (8/10) |
| [`RESEARCH.md`](./RESEARCH.md) | Анализ конкурентов | React Aria, Zag.js, Radix, Floating UI |
| [`SPEC_V1.md`](./SPEC_V1.md) | Нормативная спецификация для community-компонентов | Требования MUST/SHOULD, совместимость (conformance), правила публикации |
| [`CONFORMANCE.md`](./CONFORMANCE.md) | Как заявлять Headless‑совместимость | Минимальный чеклист и обязательные тесты |
| [`implementation/I13_interaction_layers_and_owners.md`](./implementation/I13_interaction_layers_and_owners.md) | Детали реализации (reference) | Interaction layers + owners (FocusNode/TextEditingController) |
| [`README.md`](../README.md) | Roadmap | P0-P3 приоритеты, базовые задачи |

### Оглавление (Quick Links)

**Структура:**
- [Дерево папок](#дерево-папок-целевое)
- [Правила зависимостей (DDD + SOLID)](#правила-зависимостей-ddd--solid)
- [Dual API policy](#dual-api-policy-d2a-сейчас-путь-к-d2b-потом)

**DDD/Clean Architecture:**
- [Domain Layer Invariants](#где-нельзя-хранить-состояние-ddd-дисциплина)
- [Bounded Contexts](#bounded-contexts-ddd)
- [Ubiquitous Language](#ubiquitous-language-глоссарий-терминов)
- [CI Pipeline Integration](#ci-pipeline-integration-github-actions)

**Качество:**
- [Renderer contracts](#renderer-contracts-capability-discovery--политика-стабильности-api-v1)
- [LLM.txt policy](#llmtxt-policy-для-каждого-пакета-компонента)
- [Interaction layers + Owners (зафиксировано)](#interaction-layers--owners-зафиксировано-как-делать-правильно)
- [Производительность](#производительность-важно-для-headless)

---

### TL;DR (что будет в итоге)

- **Monorepo**: один репозиторий → много пакетов.
- **Компонентный подход**: каждый компонент — отдельный пакет, сгруппированный в `packages/components/*`.
- **Общие кирпичи**: `tokens`, `foundation`, `theme` — отдельные пакеты.
- **UX/дискавери**: один фасад‑пакет `headless` ре-экспортирует “разумный дефолтный набор”, чтобы пользователю не собирать 10+ импортов.
- **Headless по-настоящему**: визуал и структура живут в **renderer contracts + renderer implementations**, а не внутри `R*`.
- **AI-friendly**: пакеты документируют инварианты и примеры в `LLM.txt` (или `docs/LLM.md`), чтобы агенты/генераторы не ломали правила.

Решения, зафиксированные для v1 перед реализацией: `docs/V1_DECISIONS.md`.

---

### Spec-first: Headless = стандарт для экосистемы (и мы делаем только так)

Цель проекта — не только “ещё одна библиотека компонентов”, а **спецификация (standard) + core contracts**, по которым:

- любой автор может сделать publishable пакет компонента и заявить совместимость,
- другие люди могут использовать этот пакет, не боясь скрытых зависимостей и “магического” поведения.

**Единственный допустимый путь совместимости:**

- **Core контракты и инварианты** фиксируются в `docs/V1_DECISIONS.md` (и реализуются в core пакетах).
- **Требования к внешним пакетам** формулируются нормативно в `docs/SPEC_V1.md` (MUST/SHOULD/MAY).
- **Процесс “passes conformance”** и чеклист совместимости описаны в `docs/CONFORMANCE.md`.

Если пакет **не** следует `docs/SPEC_V1.md` или не может пройти conformance — он **не считается Headless‑совместимым** (даже если “похож” по API).

#### Definition of Done: Headless‑совместимый package (v1)

Пакет можно называть Headless‑совместимым только если выполнены все пункты:

- **Следует `docs/SPEC_V1.md`**: структура слоёв, зависимости, headless separation, ownership, и т.д.
- **Проходит conformance**: минимальные проверки/тесты из `docs/CONFORMANCE.md` реализованы и зелёные.
- **Нет component → component deps**: пакет не импортит другие `packages/components/*`.
- **Renderer capability обязательна**: нет скрытого baseline UI; отсутствие capability даёт понятную диагностику.
- **Controlled/uncontrolled корректны**: внешний `controller/value` не перетирается; ownership dispose соблюдён.
- **Есть `LLM.txt`**: Purpose/Non-goals/Invariants/Correct usage/Anti-patterns.

**Core contracts v1** (см. `docs/V1_DECISIONS.md` → "Minimal public contract surface v1"):
- `0.1` — Renderer contracts (theme + slots)
- `0.2` — Overlay (Host/Controller/Handle + FocusPolicy)
- `0.3` — Listbox (Controller/Registry + ListboxNavigation)
- `0.4` — StateResolution (Policy/Map)
- `0.5` — Test helpers
- `0.6` — Interactions (Controller → WidgetStateSet)
- `0.7` — Effects executor (lifecycle + order)

---

### Как мы фиксируем ресёрч (чтобы не делать “как у них”)

- **`docs/RESEARCH.md`**: сырой ресёрч, сравнения, идеи. Там же помечаем: **Adopt / Reject / Open**.
- **`docs/V1_DECISIONS.md`**: только **принятые решения v1** (чёткие контракты и инварианты).
- **`docs/ARCHITECTURE.md`**: только то, что уже стало **правилом архитектуры** (границы пакетов, зависимости, инварианты).
- **`docs/SPEC_V1.md`**: **нормативные требования** к сторонним пакетам, чтобы они считались Headless‑совместимыми (conformance).
- **`docs/CONFORMANCE.md`**: **как заявлять совместимость** и какие минимальные тесты/проверки обязательны.

Правило: если идея из ресёрча “кажется классной”, но ломает POLA/DDD/DAG или добавляет магию — мы **явно пишем, что это плохо, и не делаем**.

---

### Дерево папок (целевое)

```text
headless/
├─ packages/
│  ├─ headless_tokens/                  # Raw + semantic tokens (extension types)
│  │  └─ lib/src/{raw,semantic}/...
│  │
│  ├─ anchored_overlay_engine/         # Overlay engine (lifecycle/policies/positioning)
│  │  └─ lib/src/
│  │     ├─ host/                       # AnchoredOverlayEngineHost + scope (владение слоями)
│  │     ├─ controller/                 # OverlayController + OverlayHandle (show/close/update)
│  │     ├─ positioning/                # Anchor/placement/flip/shift/collision
│  │     ├─ policies/                   # Dismiss/Focus/Barrier/Stack policies
│  │     └─ insertion/                  # OverlayPortal backend
│  │
│  ├─ headless_foundation/              # Общие UI-движки поведения (focus/fsm/state/listbox)
│  │  └─ lib/src/
│  │     ├─ focus/
│  │     ├─ interactions/                  # Unified press/hover/focus политики (одно место для input edge-cases)
│  │     ├─ fsm/
│  │     ├─ listbox/                       # ItemRegistry + navigation/typeahead (menu-like patterns)
│  │     └─ state_resolution/
│  │
│  ├─ headless_contracts/               # Renderer contracts + slots + overrides
│  │  └─ lib/src/
│  │     ├─ renderers/                    # Renderer contracts (ButtonRenderer/...)
│  │     └─ slots/                        # SlotOverride/Replace/Decorate/Enhance
│  │
│  ├─ headless_theme/                   # Theme runtime + capability overrides + bootstrap
│  │  └─ lib/src/
│  │     ├─ theme/                        # Capability discovery + overrides scopes
│  │     ├─ motion/                       # Motion theming helpers
│  │     └─ widget_states/                # State normalization helpers
│  │
│  ├─ headless_material/                # Preset renderers (Material 3), не в core
│  │  └─ lib/src/...
│  ├─ headless_cupertino/               # Preset renderers (Cupertino), не в core
│  │  └─ lib/src/...
│  │
│  ├─ headless_test/                    # Опциональные test helpers (a11y/overlay/focus/keyboard), без UI
│  │  └─ lib/src/...
│  │
│  ├─ components/                         # Группировка пакетов компонентов (не “пакет components”)
│  │  ├─ headless_button/               # Компонент: Button
│  │  │  └─ lib/src/
│  │  │     ├─ domain/                    # variants/specs/resolved только для кнопки
│  │  │     ├─ presentation/              # RTextButton + parts/slots API (если нужно)
│  │  │     └─ infra/                     # адаптеры/бриджи (без baseline визуала по умолчанию)
│  │  │
│  │  ├─ headless_dropdown_button/      # Компонент: DropdownButton (listbox + overlay)
│  │  └─ ...                              # Остальные компоненты по мере роста
│  │
│  └─ headless/                         # Facade пакет (единый public API)
│     └─ lib/headless.dart              # ре-экспорт компонентов и общих модулей
│
├─ tools/
│  └─ headless_cli/                     # Optional tooling: W3C import + skeleton generation (без UI логики)
│
├─ apps/
│  └─ example/                            # Пример приложения (демо брендов/кейсов)
│
└─ docs/
   ├─ ARCHITECTURE.md
   ├─ V1_DECISIONS.md
   ├─ SPEC_V1.md
   ├─ CONFORMANCE.md
   ├─ MUST.md
   ├─ RESEARCH.md
   ├─ WHY_HEADLESS.md
   ├─ CHANGELOG.md
   └─ competitors/
```

---

### Правила зависимостей (DDD + SOLID)

#### Внутри каждого пакета компонента (`packages/components/headless_*`)

```text
presentation  -> domain
infra         -> domain
presentation  -> (headless_contracts, headless_theme, headless_foundation, headless_tokens)
infra         -> (headless_contracts, headless_theme, headless_tokens)
domain        -> (ничего, либо только dart:* / meta)
```

Overlay API живёт в `anchored_overlay_engine`; в переходный период допускается импорт
через `headless_foundation/overlay.dart` (compat).

- **Запрет циклов (обязательное правило)**:
  - Граф зависимостей пакетов должен быть **DAG** (никаких циклических зависимостей).

- **Запрет “компонент → компонент” (рекомендуемое правило)**:
  - компонент Dialog не зависит от Button, `headless_dropdown_button` не зависит от dialog‑компонента, и т.д.
  - Если кажется, что “нужно”, значит общий механизм должен жить в `headless_foundation` или `headless_theme`, а не в конкретном компоненте.

---

### Public API discipline (критично для масштабирования)

Цель: пользователи и другие пакеты должны зависеть **только от стабильного публичного API**, а не от внутренних деталей.

- **MUST**: нельзя импортировать/экспортировать чужие внутренние файлы: `package:<pkg>/src/...`.
- **MUST**: кросс‑пакетные импорты должны идти **только через entrypoint**: `package:<pkg>/<pkg>.dart`.
- **MUST**: entrypoint (`lib/<pkg>.dart`) **не экспортит `src/` напрямую** — вместо этого он экспортит публичные `lib/*.dart` фасады.

Это гарантируется guardrails‑проверками (см. `tools/headless_cli/bin/guardrails.dart`).

---

### Таблица зависимостей (что кому можно импортить)

Цель: простое правило для ревью — **не допускаем неявных связей** между компонентами.

| Пакет | Разрешённые зависимости | Запрещено |
|------|--------------------------|----------|
| `headless_tokens` | `dart:*`, `dart:ui` (Color, etc.) | `flutter:*`, всё остальное |
| `headless_foundation` | `headless_tokens`, `dart:*`, `flutter:foundation`, `flutter:widgets`, `flutter:rendering` | `headless_contracts`, `headless_theme`, любые компоненты |
| `headless_contracts` | `headless_foundation`, `dart:*`, `flutter:foundation`, `flutter:widgets` | любые компоненты |
| `headless_theme` | `headless_tokens`, `headless_foundation`, `headless_contracts`, `dart:*`, `flutter:foundation`, `flutter:widgets` | любые компоненты |
| `headless_material` | `headless_tokens`, `headless_foundation`, `headless_contracts`, `headless_theme`, `dart:*`, `flutter:*` | любые компоненты, `headless` (facade) |
| `headless_cupertino` | `headless_tokens`, `headless_foundation`, `headless_contracts`, `headless_theme`, `dart:*`, `flutter:*` | любые компоненты, `headless` (facade) |
| `headless_test` | `flutter_test`, `headless_tokens`, `headless_foundation`, `headless_contracts`, `headless_theme`, `dart:*`, `flutter:*` | любые компоненты, `headless` (facade) |
| `packages/components/headless_*` (любой компонент) | `headless_tokens`, `headless_foundation`, `headless_contracts`, `headless_theme`, `dart:*`, `flutter:*` | другие компоненты (и любые циклы) |
| `headless` (facade) | `headless_tokens`, `headless_foundation`, `headless_contracts`, `headless_theme`, компоненты | обратные зависимости (никто не должен зависеть от facade) |
| `apps/example` | `headless` (предпочтительно) и/или любые пакеты | — |

#### Визуальная DAG диаграмма зависимостей

```text
                           ┌─────────────────┐
                           │   apps/example  │
                           └────────┬────────┘
                                    │
                           ┌────────▼────────┐
                           │   headless    │  (facade)
                           │    (re-export)  │
                           └────────┬────────┘
                                    │
        ┌───────────────────────────┼───────────────────────────┐
        │                           │                           │
┌───────▼───────┐         ┌─────────▼─────────┐       ┌─────────▼─────────┐
│  headless_  │         │  headless_      │       │  headless_      │
│  button       │         │  dropdown_button  │       │  dialog           │
└───────┬───────┘         └─────────┬─────────┘       └─────────┬─────────┘
        │                           │                           │
        └───────────────────────────┼───────────────────────────┘
                                    │
             ┌──────────────────────┼──────────────────────┐
             │                      │                      │
    ┌────────▼────────┐    ┌────────▼────────┐    ┌────────▼────────┐
    │ headless_test │    │ headless_     │    │ headless_     │
    │  (dev only)     │    │ presets        │    │ theme           │
    └────────┬────────┘    └────────┬────────┘    └────────┬────────┘
             │                      │                      │
             │                      │                      │
             └──────────────────────┼──────────────────────┘
                                    │
                           ┌────────▼────────┐
                           │  headless_    │
                           │  foundation     │
                           └────────┬────────┘
                                    │
                           ┌────────▼────────┐
                           │  headless_    │
                           │  tokens         │
                           └────────┬────────┘
                                    │
                           ┌────────▼────────┐
                           │    dart:core    │
                           │    dart:ui      │
                           └─────────────────┘

Стрелки направлены ВНИЗ = "зависит от". Циклы запрещены (DAG).
```
