## I37 — Button: appearance-variants (filled/tonal/outlined/text) + deterministic focus highlight + token-mode + demo/tests v1

### Контекст

`I36` закрыла основу “pixel-perfect parity” для кнопок:

- **Renderer = visual-only** (инертный subtree, активация/semantics у компонента).
- **Tap target ≠ visual size** (capability `HeadlessTapTargetPolicy` применяется на уровне компонента).
- **Parity renderers**: Material (reuse Flutter widgets), Cupertino (visual port + pinned constants).

Следующий шаг — сделать API кнопок “как в нормальной UI библиотеке”, при этом:

- сохранить parity‑направление,
- убрать недетерминизм (focus ring),
- убрать лишнюю работу (token resolution overhead),
- сделать demo понятным (матрица вариантов/размеров/состояний),
- довести тесты/голдены/доки до консистентного состояния.

---

## 0) Source of truth (Flutter stable, pinned)

Как и в `I36`, parity/термины фиксируем по Flutter stable проекта:

- Flutter `3.38.6` stable, framework revision `8b87286849`

Ссылки на исходники (зафиксированы по revision):

- Material 3:
  - FilledButton (+ tonal):  
    `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/filled_button.dart`
  - OutlinedButton:  
    `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/outlined_button.dart`
  - TextButton:  
    `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/text_button.dart`
  - База (states/layout/tap target padding):  
    `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/material/button_style_button.dart`
- Cupertino:
  - CupertinoButton (plain/tinted/filled + focus ring):  
    `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/cupertino/button.dart`
  - Константы для tinted opacity / min sizes:  
    `https://github.com/flutter/flutter/blob/8b87286849/packages/flutter/lib/src/cupertino/constants.dart`

---

## 1) Что нужно “доделать” после I36 (и почему)

В I36 мы сознательно держали `RButtonVariant` как `primary/secondary` (минимальный v1).

Но дальше у нас появляются реальные продуктовые требования:

- **Больше вариантов** (универсальный нейминг, как в UI kit): `filled/outlined/text` + “мягкий” вариант.
- **Понятный demo**: примеры всех вариантов/размеров/disabled, плюс объяснения что “native parity”, а что “design-system extension”.
- **Детерминизм**: focus ring в Cupertino зависит от `FocusManager.highlightMode`, что делает тесты/поведение хрупкими.
- **Perf/POLA**: parity renderer почти не использует `resolvedTokens`, но компонент всё равно резолвит токены — лишняя работа.

Эта итерация фиксирует архитектурные решения и описывает, как довести всё до “готово”.

---

## 2) Главные решения (фиксируем)

Ниже решения соответствуют выбранным направлениям:

- **Focus highlight**: вариант **B** (общий контроллер/политика на вырост, централизовано).
- **Token overhead**: вариант **A** (token-mode интерфейс, без изменения базового `RButtonRenderer` контракта).
- **Variants naming**: appearance‑основанный нейминг (вариант “A/1” из обсуждения).

---

## 2.1 Variants: appearance-first (универсальный нейминг UI библиотек)

### Определение

`RButtonVariant` перестаёт быть “иерархией” (`primary/secondary`) и становится **appearance‑вариантом**:

- `filled` — заливка (high emphasis)
- `tonal` — “soft/toned” заливка (Material: **tonal**, iOS: **tinted**)
- `outlined` — контур (outline)
- `text` — “ghost/plain” (без фона и без контура)

**Почему `tonal`, если я раньше не слышал?**

- В Flutter Material это официальный термин и прямой API: `FilledButton.tonal` (см. `filled_button.dart`).
- В Flutter Cupertino это официальный термин и прямой API: `CupertinoButton.tinted` (см. `button.dart`).
- По смыслу это один и тот же класс визуала: “мягкая заливка от primary color”.

Чтобы не было когнитивного разрыва:

- в документации/демо всегда писать: **`tonal (aka tinted/soft)`**
- в комментариях к enum: указать прямые маппинги `Material: FilledButton.tonal`, `Cupertino: CupertinoButton.tinted`.

### Mapping по пресетам

#### Material preset (parity-by-reuse, native)

- `filled` → `FilledButton`
- `tonal` → `FilledButton.tonal`
- `outlined` → `OutlinedButton`
- `text` → `TextButton`

Это “нативные” варианты Flutter Material 3. Parity здесь честный.

#### Cupertino preset (native + один не‑нативный extension)

- `filled` → `CupertinoButton.filled` (native)
- `tonal` → `CupertinoButton.tinted` (native)
- `text` → `CupertinoButton` (plain, native)
- `outlined` → **design-system extension (не native)**:
  - iOS HIG не имеет “outlined button” как стандартного визуального стиля.
  - но UI библиотеки часто хотят единый набор вариантов.

**Правило честности (MUST):**

- Для Cupertino preset `outlined` — это **не parity**, а “design-system variant”.
- В демо и в доках явно помечаем как non-native.
- Golden parity “headless vs native” (E2E) не обязан покрывать `outlined` на iOS.

### Future (не в этой итерации)

Параллельная ось “intent” (например `destructive`) должна появляться **отдельно** (см. follow-ups).

---

## 2.2 Focus highlight: делаем детерминированно и переносимо (вариант B)

### Проблема

В Cupertino (и частично в Material) отображение focus highlight зависит от глобального “режима подсветки фокуса”:

- `FocusHighlightMode.traditional` (keyboard navigation) → показываем focus ring
- `FocusHighlightMode.touch` (pointer) → focus ring обычно скрыт

Если renderer читает `FocusManager.instance.highlightMode` напрямую:

- renderer становится **недетерминированным** (не чистая функция от request),
- тесты/голдены начинают требовать “магии” (посылать Tab, чтобы включить traditional),
- поведение может отличаться между окружениями.

### Решение

Ввести в foundation общий механизм:

- `HeadlessFocusHighlightPolicy` — как из `FocusHighlightMode` получить `showFocusHighlight`.
  - default: “как Flutter” (показывать только в `traditional`)
- `HeadlessFocusHighlightController` — подписка на `FocusManager` и `notifyListeners()` на смену режима.
- `HeadlessFocusHighlightScope` — `InheritedNotifier`, чтобы компоненты могли детерминированно зависеть от него.
- Устанавливаем scope в `HeadlessApp` (значит автоматически и в `HeadlessMaterialApp` / `HeadlessCupertinoApp`).

Компонент вычисляет флаг и кладёт в состояние:

- `RButtonState.showFocusHighlight: bool`

Renderer больше **не читает** `FocusManager` и не зависит от глобального состояния:

- `focusRing = isFocused && showFocusHighlight`

### Инварианты (MUST)

- Renderer **MUST NOT** читать `FocusManager` / `MediaQuery` “для режима фокуса” — только request.state.
- Смена highlightMode **MUST** приводить к rebuild кнопок (через scope/controller), чтобы визуал обновлялся.

### Тест‑стратегия

- Renderer/unit тесты проверяют focus ring через `RButtonState(showFocusHighlight: true)`.
- Golden parity для native‑части (CupertinoButton) может всё ещё требовать включить traditional режим (Tab) — это ок, но headless‑сторона больше не должна зависеть от Tab.

---

## 2.3 Token resolution overhead: пропускаем, если renderer не потребляет токены (вариант A)

### Проблема

Parity renderers (reuse Flutter widgets / visual port) либо:

- вообще не используют `resolvedTokens`, либо используют очень узкий subset,

но компонент всё равно вызывает `RButtonTokenResolver.resolve(...)` на каждый build.

### Решение

Добавить необязательный “маркер” к renderer’у:

- `RButtonRendererTokenMode { bool get usesResolvedTokens; }`

Правило компонента:

- если renderer implements `RButtonRendererTokenMode` и `usesResolvedTokens == false`,
  то компонент **не резолвит** токены (`tokenResolver = null`, `resolvedTokens = null`).
- если renderer не implements token-mode → считаем, что токены могут быть нужны (backward compatibility).

### Инварианты (MUST)

- Это не меняет `RButtonRenderer` контракт и не ломает существующие рендереры.
- Паритетные рендереры должны явно заявлять `usesResolvedTokens = false`.

### Что важно согласовать с strict-политикой

`HeadlessRendererPolicy(requireResolvedTokens: true)` — исторически “токен‑пайнлайн”.

Для кнопок при parity‑renderer:

- strict‑policy **не должна** превращаться в ложные падения (renderer не использует токены).
- DoD: strict‑policy тестами подтверждаем, что parity renderer не требует токены.

---

## 2.4 Overrides: честная граница parity и “настройки”

Итерация I36 уже определила подход:

- Contract overrides (`RButtonOverrides`) — небольшой переносимый subset.
- Preset‑specific overrides — для продвинутых пресетных ручек (в `headless_material`, `headless_cupertino`).

Для этой итерации важно:

- Таблица поддерживаемых overrides для parity renderers.
- В демо показать:
  - что работает (цвета/паддинги/shape),
  - что не гарантируется как parity (особенно на iOS для non-native outlined).

---

## 3) План работ (подробно, по шагам)

Ниже — план “как лучше довести до конца”, включая миграцию тестов/демо/голденов.

### 3.0 Подготовка (перед изменениями)

- Зафиксировать, что цель этой итерации — **API/демо/тесты**, а не переписывание визуала.
- Везде в документации указывать pinned revision (см. раздел 0).

### 3.1 Контракты: `RButtonVariant` → appearance-variants

**Файлы:**

- `packages/headless_contracts/lib/src/renderers/button/r_button_renderer.dart`
- `packages/components/headless_button/lib/src/presentation/r_text_button.dart`
- все usage в packages/tests/example/docs

**Что сделать:**

- Обновить enum на: `filled/tonal/outlined/text`.
- Обновить дефолт `RButtonSpec.variant` и `RTextButton.variant`, чтобы сохранить POLA:
  - рекомендуемый дефолт: `outlined` (как прежний “secondary → outlined”).
- Обновить доккомменты: “appearance variant”, плюс таблица mapping.

**Риски:**

- Это breaking change для внешних пользователей.
- Если релизная совместимость важна — нужен план semver (major bump) или временные alias.
  - Но alias увеличивает “legacy” в API: решаем отдельно, если потребуется.

### 3.2 Material parity renderer: добавить 4 варианта

**Файлы:**

- `packages/headless_material/lib/src/button/material_flutter_parity_button_renderer.dart`
- `packages/headless_material/test/button/helpers/parity_test_harness.dart`

**Что сделать:**

- `filled → FilledButton`
- `tonal → FilledButton.tonal`
- `outlined → OutlinedButton`
- `text → TextButton`

**Гарантии:**

- Visual-only: inert guard остаётся (`ExcludeSemantics + AbsorbPointer`).
- Tap target остаётся на компоненте (baseStyle `tapTargetSize: shrinkWrap`).

### 3.3 Cupertino parity renderer: добавить native `tinted` (tonal) и определить судьбу `outlined`

**Файлы:**

- `packages/headless_cupertino/lib/src/button/cupertino_flutter_parity_button_renderer.dart`
- `packages/headless_cupertino/test/button/helpers/parity_test_harness.dart`

**Что сделать:**

- `filled` → solid bg (как `CupertinoButton.filled`)
- `tonal` → tinted bg (как `CupertinoButton.tinted`):
  - opacity constants из Flutter:
    - light `0.12`
    - dark `0.26`
- `text` → plain (как обычный `CupertinoButton`)
- `outlined` → решить явно:
  - **рекомендация**: поддержать как design-system extension (custom outline), но пометить как non-native.

**Почему не запрещать outlined на iOS?**

- UI kits часто хотят единый набор appearance‑вариантов.
- Но тесты/доки обязаны честно отделять parity vs extension.

### 3.4 Token resolvers: обновить на новые variants (и пояснить, что это “не источник parity”)

**Файлы:**

- `packages/headless_material/lib/src/button/material_button_token_resolver.dart`
- `packages/headless_cupertino/lib/src/button/cupertino_button_token_resolver.dart`

**Что сделать:**

- Добавить ветки для `tonal` и `text`.
- Для Cupertino `tonal` цвета должны соответствовать tinted смыслу.
- Для `outlined` на iOS токены допустимы как “наш extension”.

**Важно:**

- Для parity renderers токены не являются обязательными.
- Token resolver остаётся для:
  - кастомных renderer’ов,
  - пресетных/контрактных overrides,
  - будущих “design-system mode” renderer’ов.

### 3.5 Deterministic focus highlight: внедрить policy/controller/scope и протащить флаг в `RButtonState`

**Файлы:**

- `packages/headless_foundation/lib/src/interaction/headless_focus_highlight_policy.dart`
- `packages/headless_foundation/lib/src/interaction/headless_focus_highlight_controller.dart`
- `packages/headless_foundation/lib/src/interaction/headless_focus_highlight_scope.dart`
- `packages/headless_theme/lib/headless_app.dart`
- `packages/components/headless_button/lib/src/presentation/r_text_button.dart`
- `packages/headless_cupertino/lib/src/button/cupertino_flutter_parity_button_renderer.dart`

**Что сделать:**

- Установить scope на уровне `HeadlessApp`.
- В компоненте вычислять `showFocusHighlight` из scope и передавать в state.
- В renderer’е использовать `request.state.showFocusHighlight` (без `FocusManager`).

### 3.6 Token-mode: пропускать token resolution для parity renderers

**Файлы:**

- `packages/headless_contracts/lib/src/renderers/button/r_button_renderer.dart` (интерфейс)
- `packages/components/headless_button/lib/src/presentation/r_text_button.dart` (условный resolve)
- parity renderers (`headless_material`, `headless_cupertino`) (декларация `usesResolvedTokens=false`)

**Что сделать:**

- Ввести `RButtonRendererTokenMode`.
- В компоненте: если renderer не использует токены — не вызывать resolver.

**Тесты (MUST):**

- добавить компонентный тест, что для parity renderer token resolver не дергается
  - (через тестовый resolver со счетчиком).

### 3.7 Golden tests / harness: расширить матрицу и честно разделить Cupertino outlined

**Material:**

- E2E parity: 4 variants × enabled/disabled → 8 golden.
- Renderer-only parity: 4 variants × pressed/hovered/focused/disabled → 16 golden.

**Cupertino:**

- E2E parity: только native variants (`filled/tonal/text`) × enabled/disabled + size mapping → отдельные golden.
- Renderer-only parity: можно тестировать `outlined` как non-native отдельно (без сравнения с native).

**Стратегия по файлам goldens:**

- Переименовать/перегенерировать goldens так, чтобы имена соответствовали enum `.name`.
- Старые goldens (`primary/secondary`) либо удалить, либо перенести в архив (предпочтительно удалить, чтобы не путать).

### 3.8 Example demo: сделать “как в UI kit”

**Файл сейчас:**

- `apps/example/lib/screens/button_demo_screen.dart` (секции B1/B2/B3)

**Что нужно:**

- Матрица `variant × size`:
  - `filled | tonal | outlined | text`
  - `small | medium | large`
- Toggle:
  - `disabled`
  - (опционально) переключатель “Material/Cupertino preset” если demo поддерживает
- Примеры overrides:
  - контрактные `RButtonOverrides` (цвета, паддинги, радиусы)
  - пресетные overrides (если актуально)
- Примеры состояния фокуса:
  - “реально” (Tab навигация) + подпись “focus ring появляется в keyboard mode”

**Код-качество (MUST, по правилам репо):**

- Не делать `_build*` методов.
- Вынести секции в отдельные виджеты в отдельные файлы (feature-slice под `apps/example/lib/screens/widgets/...`).
- Не раздувать один файл на сотни строк.

### 3.9 Доки: привести в соответствие

- `docs/implementation/I36...` — добавить ссылку на эту итерацию как follow-up.
- `docs/competitors/naked_ui_part_02.md` — заменить `primary/secondary` на новые appearance variants.
- По необходимости обновить `docs/implementation/I06_component_button_v1.md` (если там описан старый enum).

---

## 4) Definition of Done (DoD)

- API `RButtonVariant` = `filled/tonal/outlined/text` и консистентно используется во всех пакетах.
- Parity renderers:
  - Material: все 4 variants делегируются Flutter widgets, визуально сравнимы golden‑тестами.
  - Cupertino: `filled/tonal/text` parity с native, `outlined` явно non-native.
- Детерминизм:
  - renderer’ы не читают `FocusManager` для focus ring.
  - focus ring контролируется `RButtonState.showFocusHighlight`.
- Perf:
  - parity renderers не триггерят token resolve.
- Demo:
  - понятная матрица вариантов/размеров + disabled toggle + overrides примеры.
- Тесты:
  - `melos run analyze`
  - `melos run test`
  - goldens обновлены и стабильны (перегенерированы под новые имена).

---

## 5) Follow-ups (после этой итерации)

- **Intent axis**: `RButtonIntent` (primary/neutral/destructive/…) как отдельная ось от appearance.
- **Icon / spinner parity**: `.icon` фабрики / slot’ы и золотые тесты.
- **Overrides enforcement policy**: строгий режим для неподдерживаемых overrides (warn/throw).
- **Design-system outlined на iOS**: если окажется востребованным — формализовать как отдельный пресетный стиль/вариант, но не смешивать с parity.

