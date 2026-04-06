## I12 — Example app v1: реальный preset вместо тестовых renderers

### Цель

Сделать `apps/example` “витриной” headless‑подхода:
- подключить `headless_material`,
- показать **быстрый старт** и **максимальную кастомизацию**:
  - default preset,
  - per-instance contract overrides,
  - slots/parts,
  - scoped theme (локальная тема на subtree).

### Ссылки

- Preset архитектура: `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`
- P0 приоритеты: `docs/MUST.md`
- I11: `docs/implementation/I11_headless_material_preset_v1.md`
- Spec/Conformance: `docs/SPEC_V1.md`, `docs/CONFORMANCE.md`

---

## Что делаем

### 1) Заменить “test renderer” на реальный preset

В `apps/example`:
- обернуть приложение в `HeadlessThemeProvider(theme: MaterialHeadlessTheme(...))` (happy-path)
- оставить возможность “без theme / без capability” **только как намеренный demo** (MissingThemeException / MissingCapabilityException) — отдельный экран/сценарий, не влияющий на остальное приложение

Тонкий момент:
- “демо ошибки” должно быть намеренным, а не случайным.

---

### 1.1 Предлагаемая структура example app (чтобы PR был прямолинейным)

Минимальный набор экранов/разделов:
- **Home**: список демо (кнопки навигации)
- **Button demo**
- **Dropdown demo**
- **Intentional errors** (демо MissingTheme/MissingCapability — отдельно)

Рекомендуемая структура файлов (ориентир, можно чуть иначе, но цель — не смешивать всё в `main.dart`):
- `apps/example/lib/main.dart` — только bootstrap, theme provider, routes
- `apps/example/lib/screens/home_screen.dart`
- `apps/example/lib/screens/button_demo_screen.dart`
- `apps/example/lib/screens/dropdown_demo_screen.dart`
- `apps/example/lib/screens/intentional_errors_screen.dart`

Правило: `main.dart` не разрастается до “полотна”.

---

### 1.2 Критично: `AnchoredOverlayEngineHost` для dropdown (иначе демо сломается)

`RDropdownButton` требует `AnchoredOverlayEngineHost` в ancestor tree. Если его нет — будет `MissingOverlayHostException`.

Правило для example app:
- в `main.dart` (или общий app wrapper) оборачиваем subtree в:
  - `AnchoredOverlayEngineHost(controller: OverlayController(), child: ...)`

Тонкие моменты:
- это **не** responsibility preset’а и не responsibility renderer’а — это foundation слой.
- `OverlayController` должен жить достаточно высоко, чтобы dropdown demo работал на всех экранах.

### 2) Экран Button demo

Показать 3 варианта рядом:

1) Default:
- `RTextButton(onPressed: ..., child: Text(...))`

2) Per-instance contract overrides:
- `overrides: RenderOverrides({ RButtonOverrides: RButtonOverrides.tokens(...) })`

3) Scoped theme:
- вложенный `HeadlessThemeProvider` на часть дерева с другими default’ами

Тонкие моменты:
- показать, что overrides влияют на токены (визуально: bg/border/padding/minSize).
- показать, что **overrides не меняют поведение** (поведение остаётся в компоненте).

#### 2.1 Конкретные сценарии (PR-ready)

- **B1 — Default**:
  - Нажать кнопку мышью → `onPressed` 1 раз
  - Space (down/up) → `onPressed` 1 раз
  - Enter (down) → `onPressed` 1 раз

- **B2 — Per-instance overrides (contract)**:
  - Передать `RenderOverrides({ RButtonOverrides: RButtonOverrides.tokens(...) })`
  - Визуально отличить (например borderRadius/цвет/паддинг)
  - Убедиться, что disabled/keyboard поведение не “сломалось”

- **B3 — Scoped theme**:
  - Вложить `HeadlessThemeProvider(theme: MaterialHeadlessTheme(...))` только вокруг секции экрана
  - Показать рядом две кнопки: “глобальная тема” vs “локальная тема”
  - Убедиться, что локальная тема **не протекает** наружу

---

### 3) Экран Dropdown demo

Показать:

1) Default dropdown + keyboard-only сценарий (подсказка на экране)
2) Per-instance dropdown overrides (`RDropdownOverrides.tokens(...)`)
3) Slots: кастомизировать `menuSurface` (рекомендуемо через `Decorate`, `Replace` только для full takeover)

Тонкие моменты:
- показать “highlighted ≠ selected” (например, подпись на экране).
- показать, что close contract работает (можно визуально: анимация закрытия/кнопка “close”).

---

#### 3.1 Конкретные сценарии (PR-ready)

- **D1 — Keyboard-only**:
  - Focus на trigger (Tab) → Enter открывает меню
  - ArrowDown/ArrowUp двигают highlight (selected не меняется)
  - Enter выбирает highlighted (selected меняется) и закрывает меню
  - Escape закрывает без изменения selected

Тонкий момент:
- если меню “не открывается вообще” — первым делом проверить `AnchoredOverlayEngineHost` в дереве (см. раздел 1.2).

- **D2 — Per-instance overrides (contract)**:
  - Передать `RenderOverrides({ RDropdownOverrides: RDropdownOverrides.tokens(...) })`
  - Визуально: triggerBorderColor/menuMaxHeight/itemPadding

- **D3 — Slots**:
  - Важно: API слотов в v1 — это **`Decorate` / `Replace` / `Enhance`** (см. `headless_contracts` → slots contracts).
  - Рекомендуемый путь (wrap/structure): `slots: RDropdownButtonSlots(menuSurface: Decorate((ctx, child) => ... child ...))`. Если нужно “просто стиль” — используйте `RenderOverrides({ RDropdownOverrides: RDropdownOverrides.tokens(...) })`.
  - Альтернатива: `Replace((ctx) => MySurface(child: ctx.child))` — **полный takeover**, вы обязаны явно использовать `ctx.child`, иначе потеряете дефолтное содержимое меню.
  - Убедиться, что:
    - поведение (close contract, keyboard) не сломалось,
    - слот видит нужный контекст (`ctx.child` используется, чтобы не потерять содержимое)

---

### 3.2 Что именно выводим на экран (чтобы демо было “самообъясняющимся”)

Рекомендуемые “индикаторы” в UI:
- Текущий `value`/`selectedValue` (текстом)
- Подсказка “highlighted ≠ selected”
- Чекбокс/переключатель “Disable dropdown” чтобы проверить disabled поведение

Тонкий момент:
- В v1 компонент не экспонирует `highlightedIndex` наружу — это внутренняя keyboard-навигация.
  Для демо достаточно подсказки + поведения: highlight двигается, selection меняется только на Enter.

#### 3.3 Критично: какие items использовать в примерах

В `apps/example` **нужно использовать публичный API компонента**:
- `items + HeadlessItemAdapter<T>` (golden path) или `options`

Не использовать в примерах `HeadlessListItemModel` — это **renderer contract (UI-only)**, без `value`.

---

### 4) Простейшая документация прямо в app

Минимум:
- заголовок “Headless UI for Flutter (Material preset)”
- ссылки на `docs/SPEC_V1.md` и `docs/FLEXIBLE_PRESETS...` (можно как текст)

---

### 5) Экран Intentional errors (важно, чтобы не ломать happy-path)

Цель: показать разработчику, **что именно пойдёт не так**, если забыть тему/capability.

Сценарии:
- **E1 — MissingThemeException**: показать реальный формат ошибки (без нестабильных “ручных mount” трюков)
  - допустимо: вывести `MissingThemeException().toString()` + пример кода, который её вызывает (`HeadlessThemeProvider.themeOf(context)`)
- **E2 — MissingCapabilityException**: показать реальный формат ошибки
  - вариант v1 (стабильно): вызвать `requireCapability<RButtonRenderer>(_EmptyTheme(), componentName: 'RTextButton')` и вывести `toString()`
  - (опционально) второй вариант: отдельный subtree с `HeadlessThemeProvider(theme: EmptyTheme())`, который не предоставляет renderer

Тонкий момент (важно):
- Так как всё приложение обёрнуто в `HeadlessThemeProvider`, “настоящую” MissingThemeException на этом же экране получить сложно без искусственного отдельного subtree/route.
- Поэтому v1 политика для example: **показываем формат и инструкции**, а не пытаемся ломать дерево виджетов ради “реального броска”.

Правила:
- этот экран не должен быть “по умолчанию”
- ошибки должны быть ожидаемыми (лучше через кнопку “Run error demo”, чтобы не падать на старте)

---

## Тесты

- smoke tests для example уже есть; минимум — оставить.
- Важно: example должен собираться и запускаться без ручных манипуляций.

---

## Артефакты итерации

- `apps/example/lib/main.dart` обновлён под `headless_material`
- возможно: отдельные demo страницы/виджеты

---

## Критерии готовности (DoD)

- Example app показывает Button/Dropdown на реальном Material preset.
- Есть демонстрация per-instance overrides и slots.
- Есть демонстрация scoped theme.

---

## Чеклист

- [ ] `apps/example` использует `HeadlessThemeProvider` + `MaterialHeadlessTheme`.
- [ ] Demo: Button default + per-instance overrides + scoped theme.
- [ ] Demo: Dropdown default + per-instance overrides + slots.
- [ ] Нет случайных “missing capability” в основном happy-path.
- [ ] Есть отдельный экран “Intentional errors”, который не ломает старт приложения.

