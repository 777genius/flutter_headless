## I02 — Tokens v1: минимальный набор и API-границы

### Цель

Зафиксировать минимальный, но расширяемый API токенов, который не ломает:
- multi-brand,
- W3C import pipeline (позже через CLI),
- стабильность API (additive-only в minor).

### Ссылки на требования

- Tokens pipeline: `docs/ARCHITECTURE.md` → “Tokens pipeline v1”
- Semantic tokens v1: `docs/V1_DECISIONS.md` → “Tokens: raw + semantic” и “Semantic tokens v1: W3C-first + Hybrid”
- OCP extension mechanism: `docs/V1_DECISIONS.md` → “Extension mechanism (OCP compliance)”

### Что делаем (подробно)

#### 1) Минимальный состав raw tokens (скелет)

Цель raw tokens на этом шаге — дать строительные блоки для semantic слоя и первых renderer’ов.

Минимальный набор (v1-min):
- **spacing**: `0, 2, 4, 8, 12, 16, 24`
- **radii**: `0, 6, 10, 16`
- **durations**: `fast, normal`

Артефакты:
- `packages/headless_tokens/lib/src/raw/*` (структура под генерацию)

Тонкие моменты:
- `headless_tokens` остаётся **pure Dart** (см. `docs/ARCHITECTURE.md` таблицу зависимостей).
- raw tokens считаются **generated source of truth** (runtime parsing запрещён).

#### 1.1 Представление значений (важный выбор v1-min)

Чтобы `headless_tokens` оставался максимально переносимым (и не требовал Flutter engine), значения кодируем так:

- **Color**: как `int` в формате ARGB (`0xAARRGGBB`), а не `dart:ui Color`.
- **Dimension**: как `double` (например, `24.0`).
- **Duration**: как `Duration`.

Тонкие моменты:
- Это не “визуал” и не “UI типы”, это чистые значения. Маппинг `int -> Color` (если нужен) делается выше (theme/renderers/app).

#### 2) Минимальный whitelist global semantic primitives (точный список)

Берём ровно тот baseline, который уже описан в `docs/V1_DECISIONS.md` (semantic tokens v1).
На старте не расширяем без необходимости.

**global.color.semantic.surface**
- `global.color.semantic.surface.canvas`
- `global.color.semantic.surface.base`
- `global.color.semantic.surface.raised`
- `global.color.semantic.surface.overlay`

**global.color.semantic.text**
- `global.color.semantic.text.primary`
- `global.color.semantic.text.secondary`
- `global.color.semantic.text.disabled`
- `global.color.semantic.text.inverse`

**global.color.semantic.action**
- `global.color.semantic.action.primaryBg`
- `global.color.semantic.action.primaryFg`

**global.color.semantic.border**
- `global.color.semantic.border.subtle`
- `global.color.semantic.border.default`
- `global.color.semantic.border.focus`

**global.color.semantic.status**
- `global.color.semantic.status.dangerFg`
- `global.color.semantic.status.dangerBg`
- `global.color.semantic.status.successFg`
- `global.color.semantic.status.successBg`

**global.dimension.semantic**
- `global.dimension.semantic.tapTargetMin` = 24px (WCAG 2.2 baseline)

**global.duration.semantic.motion**
- `global.duration.semantic.motion.fast`
- `global.duration.semantic.motion.normal`

Тонкие моменты:
- это **контракт стабильности**: изменения только additive-only в minor.
- hover/pressed “тонкости” не добавляем в global слой (см. `docs/V1_DECISIONS.md` rationale), они живут в component tokens.

#### 3) Component tokens (минимум под Button)

Цель: дать точность компоненту, не раздувая global слой.

Минимальный набор `components.button.*` (v1-min):
- `components.button.minTapTarget` = `{global.dimension.semantic.tapTargetMin}`
- `components.button.focusRing.color` = `{global.color.semantic.border.focus}`

- `components.button.color.bg.default` = `{global.color.semantic.surface.base}`
- `components.button.color.fg.default` = `{global.color.semantic.text.primary}`
- `components.button.color.bg.primary` = `{global.color.semantic.action.primaryBg}`
- `components.button.color.fg.primary` = `{global.color.semantic.action.primaryFg}`
- `components.button.color.fg.disabled` = `{global.color.semantic.text.disabled}`

Тонкие моменты:
- pressed/hover можно реализовать как renderer policy (state resolution) + transforms, не как отдельные global токены.

#### 4) Подготовка к tooling (W3C import позже)

Пока фиксируем только “куда это придёт”:
- директории `lib/src/raw` и `lib/src/semantic`
- документируем, что W3C JSON импортируется CLI (см. `docs/ARCHITECTURE.md` tokens pipeline)

### Что НЕ делаем

- Не делаем настоящий W3C JSON import сейчас (это отдельная итерация tooling).
- Не делаем “идеальную” семантику для всех компонентов — только фундамент.

### Диагностика (что считается ошибкой архитектуры)

- Появился `package:flutter/*` в `headless_tokens` → это стоп, откат/перенос.
- Начали добавлять component-specific визуал в global primitives → стоп, переносим в `components.*`.

### Критерии готовности (DoD)

- Есть минимальные raw/semantic API типы, которые можно использовать в renderer contracts.
- Нет Flutter зависимостей в `headless_tokens`.
- Решения согласованы с `docs/V1_DECISIONS.md` (hybrid/global+component tokens).

### Чеклист

- [x] `headless_tokens` остаётся pure Dart (без Flutter)
- [x] Raw tokens: spacing (0,2,4,8,12,16,24), radii (0,6,10,16), durations (fast,normal)
- [x] Global semantic primitives = точный whitelist (surface, text, action, border, status, dimension, motion)
- [x] Component tokens для Button (`components.button.*`) ссылаются на semantic
- [x] SemanticToken<T> interface для OCP extension
- [x] Зафиксировано "no runtime parsing" — только tooling (W3C import)
- [x] Тесты проходят (10 тестов)

