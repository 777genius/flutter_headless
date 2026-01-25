## I25 — DX Simplification (v1.2): “простая дорожка” поверх contracts без потери гибкости (part 1)

Back: [Index](./I25_user_dx_simplification_v1_2.md)

## I25 — DX Simplification (v1.2): “простая дорожка” поверх contracts без потери гибкости

### Цель

Сильно упростить использование Headless для обычного Flutter‑разработчика, не ломая:
- spec-first подход,
- capability contracts,
- per-instance overrides,
- scoped theme overrides,
- slots/parts.

Идея: “простая дорожка” должна быть **sugar**, который компилируется в существующие механизмы (spec → tokens → renderer), а не альтернативной архитектурой.

---

## Проблема (как выглядит сейчас для пользователя)

Для “чуть поменять визуал” пользователь часто вынужден:
- знать про `RenderOverrides` и конкретные типы `R*Overrides`,
- понимать scoped capability overrides (generic типы),
- читать spec/архититектуру, чтобы не нарушить инварианты.

Это снижает adoption, даже если внутри система сильная.

---

## 1) Две дорожки API: Simple vs Advanced

### 1.1 Simple API (P0)

Для каждого компонента ввести минимальный, Flutter‑like слой:
- `style:` (маленький объект, по смыслу как `ButtonStyle`)
- и/или 0–2 часто используемых параметра, если это реально “универсально” и не дублирует текущий API.

Правило: **Simple API не должен требовать знания tokens/contracts**.

#### Нейминг “tone” (важно не раздуть API)

В текущих компонентах уже есть `variant` (`RButtonVariant`, `RDropdownVariant`, …).
Поэтому отдельный `tone` как новый параметр часто будет:
- дублировать `variant`,
- вводить ещё один “уровень” выбора, который трудно объяснять.

Рекомендация v1.2:
- **Не вводить `tone` как отдельный параметр** для Button/Dropdown, если `variant` уже покрывает “семантическую разновидность”.
- Если позже понадобится более общее название для нескольких компонентов (в редких случаях), использовать один термин на все компоненты:
  - `intent` (часто в design systems: primary/danger/success),
  - или `appearance`/`emphasis` (если речь про filled/outlined/ghost).

Но по умолчанию: `variant + size + style`.

### 1.2 Advanced API (P1)

Оставить текущие механизмы:
- `overrides: RenderOverrides(...)`
- `slots: ...`
- `HeadlessThemeOverridesScope` (capability overrides на subtree)

### 1.3 Инварианты

- Simple API компилируется в contract overrides (например `RButtonOverrides`) и/или влияет на `spec` аддитивно.
- Никакого component→component deps.
- Никаких “магических” приоритетов: POLA.

#### Приоритеты (POLA)

Рекомендуемый порядок (сильнее → слабее):
1) Явный `overrides: RenderOverrides(...)` (advanced)
2) `style: R*Style(...)` (simple sugar)
3) Theme/preset defaults (token resolvers)

---

## 2) Flutter-like Style объекты поверх RenderOverrides

### 2.1 Предложение

Добавить в component packages (например `headless_button`) новые публичные типы:
- `RButtonStyle` (маленький, не “100 полей”)
- `RDropdownStyle`
- `RTextFieldStyle`

Компонент мержит:
- `style` → `RenderOverrides.only(R*Overrides.tokens(...))`
- + `overrides` (если передан)

### 2.1.1 Стандарт (обязательный) — как делать единообразно во всех компонентах

Чтобы `style:` был предсказуемым и одинаковым везде, фиксируем “шаблон” реализации:

#### Публичные файлы (в component package)

- `lib/r_<component>_style.dart` → экспорт `src/presentation/r_<component>_style.dart`
- `lib/<package>.dart` → экспортирует `r_<component>_style.dart` рядом с `r_<component>.dart`

#### Публичный тип

- Нейминг: `R<Component>Style` (например `RButtonStyle`, `RDropdownStyle`)
- Аннотация: `@immutable`
- Содержит только “curated” поля (6–12)
- Имеет метод:
  - `R<Component>Overrides toOverrides()` (где `R<Component>Overrides` — контрактный override type из `headless_contracts`)

#### В компоненте (R* widget)

- Добавить параметр: `final R<Component>Style? style;`
- В `build()` в одном месте вычислять “effective overrides”:
  - `effective = mergeStyleAndOverrides(style: widget.style, overrides: widget.overrides, toOverrides: (s) => s.toOverrides(), overrideType: R<Component>Overrides)`
- Везде одинаковый POLA:
  - `explicit overrides` **win** over `style` sugar

#### Запреты (чтобы не распухло)

- Style **не** должен требовать `BuildContext`.
- Style **не** должен включать renderer-specific эффекты/анимации/overlay lifecycle.
- Style **не** должен добавлять новый слой приоритетов (только sugar).

### 2.1.2 Общий helper для merge (DRY)

Чтобы не копировать `_mergeStyleAndOverrides` в каждом компоненте, вводим один общий helper
в core (не UI), который работает с `RenderOverrides`:

- Место: `headless_contracts` (например `lib/src/renderers/style_merge.dart`) или `headless_theme` (если хотите держать DX-хелперы там).
- Сигнатура (концепт):
  - `RenderOverrides? mergeStyleIntoOverrides<TStyle, TOverride extends Object>({ required TStyle? style, required RenderOverrides? overrides, required TOverride Function(TStyle) toOverride })`
- Реализация должна:
  - возвращать `null`, если всё null
  - создавать `RenderOverrides.only<TOverride>(...)` для style
  - делать merge так, чтобы `overrides` имели приоритет над `style`

Таким образом во всех компонентах будет одинаковая логика и меньше ошибок.

### 2.1.3 Единый набор тестов (обязательный)

Для каждого компонента, где добавили `style:`, добавляем 2 теста (копипаст‑шаблон):
- `style sugar flows into resolver and affects resolvedTokens`
- `explicit overrides win over style sugar (POLA)`

### 2.1.4 Единый текст документации (обязательный)

В README каждого component package:
- секция “Simple style sugar”
- 1 пример `style:`
- 1 пример `overrides:`
- приоритеты (3 строки)

В `LLM.txt` каждого component package:
- 2 строки: “R*Style is sugar → overrides” + “Priority: overrides > style > defaults”

#### Чем Style отличается от `R*Overrides.tokens(...)`

`R*Overrides.tokens` — это **контрактный низкоуровневый** путь, который:
- даёт больше полей (максимальная выразительность),
- требует знать override type (`RButtonOverrides`, `RDropdownOverrides`, …),
- требует знать `RenderOverrides` (bag).

`R*Style` — это **узкий, curated** путь:
- 6–12 самых частых полей (padding/radius/colors/typography),
- без знания `RenderOverrides`,
- единообразный по всем компонентам.

Важно: `R*Style` не должен превращаться в “второй контракт”. Это только sugar.

### 2.2 Тонкости

- Не пытаться повторить весь `ButtonStyle` Flutter. В v1.2 достаточно 6–10 полей.
- Стиль не должен требовать `BuildContext` (иначе сломаем чистоту/тестируемость).
- Порядок приоритетов:
  1) explicit `overrides`
  2) `style`
  3) theme defaults

#### Пример минимального `RButtonStyle` (ориентир)

- `padding`
- `minSize` (a11y)
- `radius` (или `borderRadius`)
- `foregroundColor` / `backgroundColor` / `borderColor`
- `textStyle`
- `disabledOpacity`

Не включать в style:
- overlay lifecycle,
- визуальные эффекты уровня renderers,
- preset-specific нюансы (пусть остаются в presets/overrides).

---

## 3) Theme-level defaults без токенов для пользователя

### 3.1 Предложение

Сделать в preset пакетах (например `headless_material`) “user-friendly конфиг”:
- `MaterialHeadlessTheme(brand: HeadlessBrand(...))`
- или `MaterialHeadlessTheme.defaults(button: ..., dropdown: ..., textField: ...)`

Где `brand/defaults` — компактные объекты 10–20 параметров:
- corner radius policy
- density
- typography policy
- base colors mapping

Внутри это конфигурирует token resolvers (детерминированно).

### 3.2 Инварианты

- Не вводить merge-magic: только override-wins.
- Preset должен оставаться optional (HeadlessApp поддерживает custom theme).

#### Позиционирование “где живёт density/shape”

Чтобы не раздувать per-instance API:
- `density` и “corner radius policy” чаще должны жить на уровне **theme defaults**,
- а per-instance остаётся через `style` / `overrides`.

---

## 4) Scoped Overrides sugar widgets (без generics для пользователя)

### 4.1 Предложение

Добавить в `headless_theme` (или в facade `headless`) тонкие обёртки:
- `HeadlessButtonScope(...)`
- `HeadlessDropdownScope(...)`
- `HeadlessTextFieldScope(...)`

Семантика: внутри они используют `HeadlessThemeOverridesScope.only<T>()`, но пользователь не пишет generic и не ищет правильный capability type.

Пример:
- `HeadlessButtonScope(tokenResolver: ..., renderer: ..., child: ...)`

#### DRY (обязательное)

Реализация scopes должна быть единообразной и не копипаститься:
- один приватный helper (например `_HeadlessCapabilityScope`) принимает `CapabilityOverrides` и `child`,
- публичные `HeadlessButtonScope/HeadlessDropdownScope/...` только собирают `CapabilityOverrides` из опциональных аргументов.

---

## 5) Документация: разделить “Users” vs “Contributors”

### 5.1 Users docs (P0)

Сделать короткий “cookbook” без spec:
- quick start preset
- 10–20 рецептов (как поменять padding/radius/colors на одной кнопке; как задать brand на весь апп; как локально переопределить dropdown)
- troubleshooting (MissingCapabilityException / MissingOverlayHostException)

### 5.2 Contributors docs (P1)

Оставить и развивать:
- Spec/Conformance/Architecture
- implementation docs (эта папка)

Правило: обычный пользователь не должен видеть spec как “обязательное чтение”.

---

## 6) Contributor DX: CLI skeleton generator + golden path

### 6.1 Generator (P1)

Расширить `tools/headless_cli`:
- команда `generate component <name>`
- генерирует:
  - package skeleton (folders, pubspec, exports)
  - базовые conformance tests (копия/шаблон + placeholders)
  - LLM.txt template
  - melos wiring hints

### 6.2 Golden path

Один файл “как добавить компонент правильно”:
- шаги
- checklists
- минимум ручной работы

---

