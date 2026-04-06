## Iteration plan (v1.x): renderers baseline, commands, tokens-only, close contract, visual effects hooks

**Статус:** living doc (должен обновляться вместе с PR’ами).

### TL;DR (направление)

- **Core** = поведение + контракты + foundation (pressable/overlay/listbox/effects/theme/tokens).
- **Presets** (Material/Cupertino) = *baseline визуал*, который проходит conformance и даёт удобный старт, но **не конкурирует по полноте** с Flutter Material/Cupertino.
- **Правило без серых зон**: компонент — единственный источник активации/semantics корня; renderer — визуал + wiring к **commands**, без user callbacks.

---

## 0) Цели итерации (Definition of Success)

### Что улучшаем

- **Понятность границ** (component vs renderer): меньше “а почему тут onPressed, а там нет”.
- **Консистентность поведения**: keyboard/pointer/focus/a11y одинаковы при любых renderer’ах.
- **DX для внешних авторов**: написать свой preset/renderer без форка поведения и без угадываний.
- **Снижение стоимости поддержки**: меньше копипасты UI, больше переиспользования через primitives и общий close-contract паттерн.

### Метрики (простые)

- Conformance тесты ловят:
  - double-invoke/второй путь активации,
  - close contract regressions (closing/reopen/dispose),
  - a11y базовые SLA.
- Preset renderer’ы:
  - не разрастаются от копипасты,
  - используют токены как источник параметров,
  - имеют одинаковый “скелет” структуры (легко читать).

---

## 1) Scope / Anti-scope (чтобы это не превратилось в UI kit)

### Scope (делаем)

- Минимальный набор preset’ов, который:
  - выглядит прилично “из коробки”,
  - проходит conformance,
  - демонстрирует паттерны расширения (tokens/overrides/slots),
  - помогает внешним авторам писать свои skins.

### Anti-scope (не делаем)

- 100% parity с флаттеровскими `TextButton/ElevatedButton/CupertinoButton/...`.
- “универсальный UI kit” в core.
- перенос интеракций/активации в renderer.

---

## 2) Норматив: “без серых зон” (ссылка на Spec)

Нормативная формулировка уже в `docs/SPEC_V1.md` → “Границы интеракций (без серых зон) — MUST”.

Коротко:

- **Component owns**
  - root pointer/keyboard (через `headless_foundation`, напр. `HeadlessPressableRegion`);
  - root Semantics (button/enabled/expanded/label/value).
- **Renderer owns**
  - визуал и layout;
  - wiring UI → `commands.*`.
- **Renderer MUST NOT**
  - вызывать user callbacks (`onPressed`, `onChanged`, …);
  - создавать второй root путь активации.

---

## 3) Naming/Contracts: Commands vs User callbacks (P0 — сделано)

### Правило

- **User callbacks**: только `on*` параметры публичного `R*` API.
- **Commands**: только императивные методы в render request.

Deliverables (DONE):
- [x] Dropdown: `RDropdownCommands` + `commands` в render request.
- [x] TextField: `RTextFieldCommands` + `commands` в render request.
- [x] Button: renderer-level callbacks удалены (чтобы не было “а почему onPressed?”).
- [x] Docs/LLM обновлены.

Примечание по версиям:
- Если это уже “stable v1”, такие переименования требуют MAJOR.
- Если это pre-1.0 / internal alpha — допустимо как breaking внутри итерации.

---

## 4) Roadmap по приоритетам (P0 / P1 / P2)

### P0 (обязательное для v1.x baseline)

#### P0.1 Preset primitives (DRY внутри preset’ов, не в core)

**Проблема:** renderer’ы быстро обрастают копипастой (surface/focus/menu/item/spacing/animations).
**Решение:** вынести маленькие primitives-виджеты в preset пакеты.

Deliverables:
- [ ] `packages/headless_material/lib/src/primitives/`
  - `material_surface.dart` (фон/бордер/радиус; без gesture’ов)
  - `material_menu_surface.dart` (clip/elevation/maxHeight)
  - `material_menu_item.dart` (layout-only; tap → `commands.selectIndex`)
  - (опционально) `material_focus_ring.dart` если не складывается в surface
- [ ] `packages/headless_cupertino/lib/src/primitives/`
  - `cupertino_popover_surface.dart` (blur/shadow/radius)
  - `cupertino_menu_item.dart`
  - (опционально) `cupertino_focus_ring.dart`

Acceptance:
- Renderer’ы используют primitives (а не копипастят большие ветки).
- Никаких `_build*` методов: primitives — отдельные виджеты в отдельных файлах.
- Primitives принимают параметры **из tokens** или из явных аргументов, но без “магии”.

#### P0.2 Tokens-only policy для renderer’ов

Цель: tokens/resolvers = единственный источник параметров (цвета/радиусы/паддинги/анимации/размеры).

Deliverables:
- [ ] Убрать/минимизировать hardcoded дефолты в `Material*Renderer`/`Cupertino*Renderer`.
- [ ] Fallback’и (если tokens == null) — единообразные, временные и документированные.
- [ ] Motion/animation параметры тоже через токены (поддерживает conformance на duration/motion).

Acceptance:
- Основные визуальные параметры читаются из `resolvedTokens`.
- В preset renderer’ах не появляются новые `Colors.*`/`TextStyle(...)` как “источник дизайна” (если это не fallback).

#### P0.3 Close contract: единый паттерн использования

Цель: любой overlay menu закрывается одинаково и без флапов.

Deliverables:
- [ ] В preset’ах единый паттерн: `closing` → exit animation → `commands.completeClose()`.
- [ ] Conformance тесты на cancel-by-reopen + dispose-while-closing остаются зелёными.

Acceptance:
- Нет double-call `completeClose()`.
- Нет зависаний в `closing`.

### P1 (снижает поддержку, делает архитектуру крепче)

#### P1.1 Close contract helper в `headless_foundation` (UI-free)

Цель: перестать реализовывать одинаковую “осторожную” логику руками в каждом renderer’е.

Deliverables:
- [ ] Маленький helper/controller в `headless_foundation`, который:
  - помогает координировать `closing` lifecycle,
  - защищает от double-call,
  - корректно обрабатывает reopen/dispose.
- [ ] Presets используют helper, а анимации остаются в preset.

Acceptance:
- Логика close-contract больше не копируется между Material/Cupertino.

#### P1.2 Renderer template + checklist

Цель: внешний автор должен быстро понять, как писать renderer “правильно”.

Deliverables:
- [ ] Единый каркас renderer файла (одинаковый порядок: state/tokens/slots/primitives/close-contract).
- [ ] Короткий чеклист (можно в docs или в `LLM.txt` preset пакетов):
  - никаких root gesture’ов для активации,
  - semantics корня не дублировать,
  - все параметры из tokens,
  - close contract обязателен.

### P2 (улучшение UX без риска double-invoke)

#### P2.1 Visual effects hooks (capability-based, optional) — done

Цель: дать ripple/pressed highlight без второго пути активации.
См. `README.md` → Visual effects hooks (v1.x).

Deliverables:
- [x] Visual-effects controller + events in `headless_foundation`.
- [x] `HeadlessPressableRegion` dispatches **visual-only** events:
  - pointer down/up/cancel,
  - hover/focus changes,
  - **without** activation.
- [x] Presets subscribe and render effects (Material overlay / Cupertino opacity).

Acceptance:
- Conformance тест подтверждает отсутствие double-invoke.
- Компоненты работают без hooks (fallback по capability).

---

## 5) Definition of Done (DoD) для PR’ов этой итерации

- [ ] `dart run melos run analyze`
- [ ] `dart run melos run test`
- [ ] Если менялись контракты/инварианты — обновлены `docs/*` и `LLM.txt` (у затронутых пакетов).
- [ ] Новые primitives — отдельные файлы/виджеты, без `_build*` методов.
- [ ] Нет новых путей активации в renderer’ах (root gesture’ов).

