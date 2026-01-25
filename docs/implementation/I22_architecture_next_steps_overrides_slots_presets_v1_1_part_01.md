## I22 — Next Architecture Steps (v1.1): Spec/Conformance + Unconsumed Overrides + Slot Anatomy + Preset-specific Advanced Overrides (part 1)

Back: [Index](./I22_architecture_next_steps_overrides_slots_presets_v1_1.md)

## I22 — Next Architecture Steps (v1.1): Spec/Conformance + Unconsumed Overrides + Slot Anatomy + Preset-specific Advanced Overrides

### Цель

Сделать следующие 4 улучшения **с максимальным ROI и минимальными минусами**:

1) Закрепить scoped capability overrides как экосистемный паттерн в `SPEC_V1`/`CONFORMANCE`.
2) Добавить debug-only диагностику **unconsumed** `RenderOverrides` (и, опционально, `CapabilityOverrides`).
3) Расширить typed slots (“анатомию”) в ключевых компонентах **аддитивно** (без ломания API).
4) Ввести preset-specific advanced overrides (Material/Cupertino) **без фрагментации** и без распухания core API.

Документ описывает **план итераций**, дизайн решений, тонкости и guardrails.

---

## Общие принципы (обязательные)

- **POLA**: поведение предсказуемое, без магии и “внезапных” приоритетов.
- **Additive-only** в minor: новые слоты/опции/overrides добавляем аддитивно; никаких breaking.
- **No runtime strings**: ключи — типы/контракты, не строки.
- **Release safety**: debug диагностика не должна ломать release и не должна шуметь без причины.
- **Renderer/tokenResolver separation**: renderer не вычисляет токены; tokenResolver детерминированен.

---

## 1) Spec/Conformance: scoped capability overrides как стандарт экосистемы

### 1.1 Решение (лучший вариант)

В `docs/SPEC_V1.md` добавляем **SHOULD**-требование:

- Компоненты/пресеты/приложения **SHOULD** поддерживать subtree‑scoped replacement capabilities через `HeadlessThemeProvider` nesting и/или `HeadlessThemeOverridesScope`.
- Это **не** MUST для каждого component package, потому что:
  - core уже задаёт механизм (`headless_theme`);
  - component package не обязан демонстрировать это в тестах, если он не трогает тему.

В `docs/CONFORMANCE.md` добавляем уточнение:

- Для пакетов, которые заявляют совместимость и предоставляют custom theme composition/preset, **SHOULD** иметь маленький тест, что локальный capability override работает.

### 1.2 Тонкие детали (не пропустить)

- В Spec формулировать **как паттерн**, а не как “используйте конкретный класс”.
  - То есть: “capabilities MUST be discoverable by type and replaceable via subtree composition”.
- Никаких требований про merge: только override-wins + base fallback.
- Уточнить, что capability contracts должны оставаться **non-generic** (иначе type-key становится неустойчивым).
- Уточнить, что “scoped override” — это **замена capability объектов**, а не “слияние настроек темы”.

### 1.2.1 Шаблон текста для SPEC_V1 (копипаст, v1.1)

Рекомендуемая вставка в `docs/SPEC_V1.md` (рядом с секциями про capability discovery/renderer contracts):

```text
### 2.X Scoped capability overrides (SHOULD)

- SHOULD: Consumers (apps/presets) should be able to override renderer/token resolver capabilities on a subtree via theme composition (nested theme scopes).
- SHOULD: Override behavior must be POLA: override-wins, otherwise fallback to the base theme.
- MUST NOT: Do not require “theme merging” semantics (no automatic merging of preset configuration objects).
- SHOULD: Capability contracts used for discovery should be non-generic (type identity must be stable).
```

### 1.2.2 Шаблон текста для CONFORMANCE (копипаст, v1.1)

Рекомендуемая вставка в `docs/CONFORMANCE.md` (как SHOULD, только для preset/theme packages):

```text
- SHOULD (preset/theme packages): verify subtree-scoped capability overrides:
  - given a base theme that provides capability X,
  - when a subtree overrides X,
  - then capability lookup inside the subtree returns the overridden instance.
```

### 1.3 Изменения файлов

- `docs/SPEC_V1.md`: новый подпункт (например, 2.x или 6.x) про scoped overrides.
- `docs/CONFORMANCE.md`: маленькое дополнение в раздел тестов (как SHOULD).
- `docs/implementation/I21_scoped_theme_capability_overrides_v1.md`: ссылка из I22 как реализация.

### 1.4 Критерии готовности

- В Spec/Conformance есть чёткий текст, не противоречащий текущим контрактам.
- Есть короткий пример “override dropdown renderer на subtree”.

---

## 2) Debug-only “unconsumed RenderOverrides” (минимум боли — максимум DX)

### 2.1 Проблема

Пользователь может передать `RenderOverrides`, но:
- tokenResolver не читает этот тип override,
- renderer его игнорирует,
- или override тип не поддерживается данным preset’ом.

В итоге: “я передал — не работает”, а причина не очевидна.

### 2.2 Решение (лучший, безопасный вариант)

Вводим debug-only “consumption tracking” для `RenderOverrides`:

- Внутри render/token resolution flow (в компоненте или resolver’е) **помечаем** override-тип как “прочитан”, когда кто-то делает `overrides.get<T>()`.
- В конце render request pipeline (в компоненте) можем (debug-only) проверить:
  - были ли переданы overrides,
  - и были ли они “прочитаны”.

Но! Сейчас `RenderOverrides` — общий контейнер, и многие места просто передают его дальше.
Нам нужен трекинг, который:
- не меняет сигнатуры `R*TokenResolver` (это публичные контракты),
- не вводит глобальное состояние,
- не даёт аллокаций/логов в release.

#### Предлагаемый API (v1.1, debug-only, реалистичный под текущий код)

Делаем tracking через **debug-only “обёрнутый RenderOverrides”**, который можно передать вниз без изменения типов:

- `RenderOverridesDebugTracker` (в `headless_contracts`): хранит `Set<Type> consumed`.
- `RenderOverrides.debugTrack(RenderOverrides base, RenderOverridesDebugTracker tracker)`:
  - **debug**: возвращает `RenderOverrides`, который делит тот же bag и помечает типы при `get<T>()`.
  - **release**: возвращает `base` (no-op).
- `RenderOverrides.debugProvidedTypes()`:
  - **debug**: возвращает `Set<Type>` ключей bag.
  - **release**: возвращает `const <Type>{}`.

**Ключевой guardrail:** tracker не участвует в `==/hashCode` (иначе возможны неожиданные ребилды/кеши).

**Важная реализационная тонкость (чтобы не упереться в код):**
- Сейчас `RenderOverrides` — `final class` (не подлежит наследованию), поэтому “обёртка” должна быть реализована **не через subclass**, а через:
  - private debug-field внутри `RenderOverrides` (например, `_debugTracker`), который:
    - устанавливается только через `debugTrack(...)`,
    - учитывается только внутри `get<T>()` (добавляет `T` в tracker),
    - игнорируется в `==/hashCode`.
  - либо через композицию с отдельным типом, но тогда придётся менять тип в контрактах (это уже не v1.1).
Рекомендуемый вариант — **private debug-field**: минимальный риск, полностью аддитивно.

### 2.3 Где запускать проверку (важная архитектурная точка)

Проверку лучше делать **в компоненте**, а не в renderer’е:
- компонент знает, что overrides были переданы,
- компонент знает фазу pipeline (tokenResolver/render),
- компонент может выдать одну понятную диагностику.

### 2.3.1 Конкретная точка в pipeline (как делать правильно)

В компоненте, где формируется render request:

- если `overrides == null` → ничего не делаем
- иначе (debug-only):
  - `final tracker = RenderOverridesDebugTracker();`
  - `final tracked = RenderOverrides.debugTrack(overrides, tracker);`
  - передаём `tracked` вниз вместо исходного `overrides`
  - после render (debug-only) считаем:
    - `provided = tracked.debugProvidedTypes()`
    - `consumed = tracker.consumed`
    - `unconsumed = provided - consumed`
  - если `unconsumed.isNotEmpty` → репортим 1 предупреждение

### 2.4 Как избежать ложных срабатываний (тонкость)

Если overrides переданы как “на другой preset”, они могут быть не использованы — это ок.
Поэтому:
- по умолчанию диагностика **warn** (через `FlutterError.reportError` в debug) или `assert` с сообщением.
- приоритетно выводить “возможно, ваш preset не поддерживает эти overrides”.

Дополнительный guardrail против шума:
- предупреждать только если **(providedTypes - consumedTypes) не пусто**,
- и только если `RenderOverrides` реально передан пользователем (не автогенерируется пресетом).

### 2.4.1 Формат сообщения (фиксируем, чтобы было удобно искать)

Рекомендуемый формат debug-warning:

```text
[Headless] Unconsumed RenderOverrides detected
Component: <R* component name>
Provided: <Type1, Type2, ...>
Consumed: <Type1, ...>
Unconsumed: <Type2, ...>
Hint: Your preset may not support these overrides for this component.
```

### 2.5 Расширение (опционально)

Аналогично можно сделать для `CapabilityOverrides`:
- warn если override поставили на subtree, но capability никогда не запрашивалась (сложно и часто не нужно).
Скорее **не делаем** в v1.1, чтобы не увеличивать шум.

### 2.6 Изменения файлов (план)

- `packages/headless_contracts/lib/src/renderers/render_overrides.dart`
  - добавить `RenderOverridesDebugTracker` + `debugTrack(...)` + `debugProvidedTypes()`, не ломая существующий API
- Компоненты (`headless_button`, `headless_dropdown_button`, `headless_textfield`)
  - точечно, в debug, после token resolution + render, дергать `maybeReportUnconsumedOverrides(...)`.
- `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`
  - документировать, что debug может предупреждать про unconsumed overrides.

### 2.7 Тесты (обязательные)

- Unit test на `RenderOverrides` debug wrapper:
  - “get<T>() помечает T как consumed”
  - “без get — пусто”
  - “в release wrapper не создаётся” (на уровне поведения: debug методы возвращают no-op)

### 2.8 Критерии готовности

- В debug при неиспользованных overrides есть понятная подсказка.
- В release нет изменения поведения и нет аллокаций/логов.

---

