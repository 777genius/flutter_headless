## Headless Component Spec v1

**Статус:** Draft (до первого релиза v1 может уточняться/дополняться, но изменения делаем только осознанно и с сохранением POLA).

Цель: сделать **единый, проверяемый стандарт**, по которому сторонние авторы могут создавать совместимые headless‑компоненты/пакеты для Flutter/Dart и делиться ими с сообществом.

Этот документ — **нормативный**. Он описывает требования уровня “MUST/SHOULD/MAY”.

### Важно для community (внешние репозитории)

- Пакеты **не обязаны копировать** `docs/` из этого репозитория.
- При заявлении совместимости пакет **ссылается на upstream**: на конкретный релиз/тег/коммит, где опубликованы `docs/SPEC_V1.md` и `docs/CONFORMANCE.md`.

### Чем это отличается от других документов

- `docs/ARCHITECTURE.md`: архитектура **этого репозитория** (границы пакетов, правила зависимостей, policy).
- `docs/V1_DECISIONS.md`: зафиксированные **решения v1 для core контрактов** (overlay/listbox/effects/theme/tokens) и инварианты, на которые опирается совместимость.
- `docs/SPEC_V1.md` (этот файл): требования к **сторонним пакетам**, чтобы они были “Headless‑совместимыми”.
- `docs/CONFORMANCE.md`: как именно пакет **заявляет совместимость** и какой минимальный набор проверок/тестов обязателен.

### Термины

- **Component package**: publishable пакет компонента (например, `packages/components/headless_<feature>` в этом репозитории), который предоставляет `R*` виджеты/контроллеры и использует core контракты.
- **Core contracts**: пакеты `headless_tokens`, `headless_foundation`, `headless_contracts`.
- **Renderer capability**: интерфейс рендера/возможности темы, который `R*` требует через capability discovery.
- **Conformance**: набор проверок/тестов, подтверждающих соблюдение Spec v1.

### Не‑цели (Non-goals)

- Spec v1 **не** стандартизирует визуал или “Material‑по‑умолчанию”.
- Spec v1 **не** навязывает стейт‑менеджер приложения (Riverpod/BLoC/MobX/Redux).
- Spec v1 **не** требует Navigator/Route для overlay‑паттернов.

---

## 1) Требования к пакету компонента (обязательные)

### 1.1 Public API и нейминг

- **MUST**: публичные виджеты headless‑компонента именуются `R*` (Flutter‑like POLA, без конфликтов имён).
- **MUST**: пакет должен иметь чётко выделенный “entrypoint” (`lib/<package>.dart`) и экспортировать только публичное API.
- **MUST NOT**: использовать или документировать импорты внутренних файлов `package:<pkg>/src/...` как публичный способ использования.
- **SHOULD**: кросс‑пакетные импорты по возможности должны идти только через entrypoint (`package:<pkg>/<pkg>.dart`) — это упрощает миграции и снижает риск поломок.
- **SHOULD**: публичный API быть минимальным, расширение — через опциональные параметры/slots/capabilities.

### 1.2 Структура слоёв (DDD/Clean Architecture внутри пакета)

Компонентный пакет **MUST** быть организован как минимум так:

```text
lib/
  src/
    domain/            # если нужно (value objects, events, variants)
      variants/
      specs/
      resolved/        # если нужно (но без UI типов)
    presentation/
      widgets/         # R* виджеты и glue для поведения/a11y
      controllers/     # controllers/value listenables (если есть)
    infra/
      adapters/        # интеграция с theme/foundation (без baseline UI)
```

- **MUST**: `domain/` не зависит от Flutter UI типов (см. `docs/ARCHITECTURE.md` → “Где нельзя хранить состояние”).
- **MUST**: `presentation/` отвечает за поведение/состояния/a11y и сбор spec/state.
- **MUST NOT**: хранить baseline визуал внутри компонента; визуал делегируется renderer’у через `headless_contracts` (capability discovery — через `headless_theme`).

#### Минимальный пакет (исключение для простых компонентов)

Для очень простых компонентов v1 (например, Button), где:
- нет доменной модели кроме нескольких enum/параметров,
- нет отдельной инфраструктуры кроме прямого доступа к capability,

допускается **не создавать пустые папки `domain/` и/или `infra/`**.

Инварианты при этом остаются:
- headless separation соблюдён,
- публичный API стабилен и минимален,
- нет импорта renderer реализаций,
- conformance тесты присутствуют.

### 1.3 Зависимости (DAG)

- **MUST**: пакет компонента **не** зависит от других компонентных пакетов (`packages/components/*` политика).
- **MUST**: зависимости соответствуют таблице из `docs/ARCHITECTURE.md` (“что кому можно импортить”).
- **MUST**: граф зависимостей пакетов остаётся DAG (без циклов).

---

## 2) Headless‑контракт: поведение отдельно от визуала

### 2.1 Renderer contract и capability discovery

- **MUST**: `R*` компонент получает renderer capability из темы/композиции (capability discovery), а не импортирует конкретные renderer реализации.
- **MUST**: отсутствие capability должно приводить к понятной диагностике (assert/throw с инструкцией подключения).

См. `docs/V1_DECISIONS.md`:
- 0.1 Renderer contracts
- “Отсутствие renderer’а = явная ошибка”

### 2.1.1 Scoped capability overrides (SHOULD)

- **SHOULD**: приложения/пресеты могут переопределять renderer/token resolver capabilities на subtree через композицию темы (nested theme scopes).
- **SHOULD**: поведение override должно быть POLA: override-wins, иначе fallback к базовой теме.
- **MUST NOT**: не требовать “слияния тем” как обязательной семантики (никакой auto-merge preset конфигов).
- **SHOULD**: capability контракты, используемые для discovery, должны быть non-generic (стабильная type identity).

### 2.1.2 App-level motion theme (SHOULD)

Цель: дать людям один понятный “рычаг” для единых длительностей/кривых анимаций на уровне приложения, без правок renderer’ов.

- **SHOULD**: приложения могут предоставлять `HeadlessMotionTheme` как capability и переопределять его на subtree.
- **MUST**: renderer должен уважать motion tokens в resolved tokens.
- **MUST**: приоритет разрешения motion (высокий → низкий):
  - per-instance motion tokens (`resolvedTokens.*.motion`, если заданы),
  - `HeadlessMotionTheme` capability (app/subtree),
  - preset defaults (например `HeadlessMotionTheme.material`/`HeadlessMotionTheme.cupertino`).

Пример: глобально задать motion профиль для всего приложения:

```dart
HeadlessThemeProvider(
  theme: MaterialHeadlessTheme(),
  child: HeadlessThemeOverridesScope.only<HeadlessMotionTheme>(
    capability: const HeadlessMotionTheme.standard(),
    child: MaterialApp(
      home: MyApp(),
    ),
  ),
)
```

Пример: локально “ускорить” motion только на одном экране:

```dart
HeadlessThemeOverridesScope.only<HeadlessMotionTheme>(
  capability: const HeadlessMotionTheme(
    dropdownMenu: RDropdownMenuMotionTokens(
      enterDuration: Duration(milliseconds: 120),
      exitDuration: Duration(milliseconds: 120),
      enterCurve: Curves.easeOut,
      exitCurve: Curves.easeOut,
      scaleBegin: 0.97,
    ),
    button: RButtonMotionTokens(
      stateChangeDuration: Duration(milliseconds: 120),
    ),
  ),
  child: SettingsScreen(),
)
```

### 2.1.3 Tokens-only визуальные параметры (MUST)

- **MUST**: renderer **не** вычисляет визуальные параметры из констант; все значения берутся из `resolvedTokens`.
- **MUST**: для прозрачных поверхностей opacity хранится отдельным token’ом (чтобы не терять `CupertinoDynamicColor`).

### 2.1.4 Strict tokens policy (MAY)

- **MAY**: приложение может предоставить capability `HeadlessRendererPolicy` с `requireResolvedTokens=true`,
  чтобы в debug/test режиме падать при отсутствии `resolvedTokens`.

Пример:

```dart
HeadlessThemeOverridesScope.only<HeadlessRendererPolicy>(
  capability: const HeadlessRendererPolicy(requireResolvedTokens: true),
  child: const HeadlessMaterialApp(home: Placeholder()),
)
```

Пример (dropdown menu):
- `backgroundOpacity`, `backdropBlurSigma`, `shadowColor`, `shadowBlurRadius`, `shadowOffset`.

### 2.2 Slots/Parts для точечного override

- **SHOULD**: сложные компоненты предоставляют typed slots/parts (Replace/Decorate/Enhance) как основной механизм кастомизации структуры.
- **MUST NOT**: использовать string-based part identifiers.

См. `docs/V1_DECISIONS.md` → “Slots override: Replace + Decorate”.

### 2.3 Границы интеракций (без “серых зон”) — MUST

Цель: один и тот же `R*` компонент должен иметь **одинаковое поведение** при любых renderer’ах (Material/Cupertino/custom), иначе headless separation теряет смысл.

- **MUST**: компонент владеет root‑интеракцией и accessibility корня.
  - Root‑surface активации (например, кнопка/триггер) обрабатывает pointer/keyboard через `headless_foundation` (например, `HeadlessPressableRegion`).
  - Root Semantics (`button`, `enabled`, `expanded`, label и т.д.) задаёт компонент, а не renderer.
- **MUST NOT**: renderer не должен вызывать “user callbacks” приложения (например, `onPressed`, `onChanged`) и не должен создавать второй независимый путь активации.
  - Запрещено: `InkWell(onTap: ...)` / `GestureDetector(onTap: ...)` на root‑surface, если это приводит к активации.
  - Причина: это создаёт double‑invoke и/или расхождение поведения между renderer’ами.
- **MAY**: renderer может “проводить провод” только к **командным** методам компонента, которые переданы в render request.
  - Это не “решение”, а wiring UI → командный API компонента.
  - Рекомендация (SHOULD): отличать по неймингу:
    - **User callbacks**: `on*` параметры `R*` виджета (принадлежат приложению).
    - **Commands**: императивные методы (`open()`, `close()`, `selectIndex(i)`, `highlight(i)`, `completeClose()`), которые живут в render request и принадлежат компоненту.

---

## 3) State model: controlled/uncontrolled (POLA)

- **MUST**: если передан `value/state` или `controller` — компонент работает в controlled‑режиме и не “перетирает” состояние сам.
- **MUST**: ownership controller — как у Flutter: внешний controller не диспоузим; внутренний — обязаны диспоузить.
- **SHOULD**: иметь защиту от sync‑циклов (`onChanged → parent sets value → onChanged`) через equality/dedupe.

См. `docs/ARCHITECTURE.md` → “Ownership и lifecycle controller”.

---

## 4) Overlay/Listbox/Effects: обязательные интеграции с core контрактами

Если компонент использует overlay/menu‑паттерны:

- **MUST**: использовать overlay инфраструктуру из `headless_foundation` (не Navigator).
- **MUST**: соблюдать close/phase контракт (opening/open/closing/closed + `completeClose()` + fail‑safe таймаут).
- **MUST**: keyboard navigation/typeahead строить на foundation listbox primitives (где применимо).
- **SHOULD**: побочные действия оформлять как effects (E1: events → reducer → effects executor), чтобы ядро оставалось pure.

См. `docs/V1_DECISIONS.md` → 0.2/0.3/0.7 и секции E1/A1.

---

## 5) Тесты и Conformance

### 5.1 Минимальный conformance‑набор (v1)

Пакет, который заявляет “совместим со Spec v1”, **MUST** иметь тесты, покрывающие:

- **A11y/semantics**: базовые роли/label/disabled состояния.
- **Keyboard-only сценарии**: фокус, Escape/Enter/Space, навигация по списку (если есть listbox).
- **Overlay lifecycle**: корректный переход в `closing`, завершение `completeClose()`, fail‑safe не зависает.
- **Controlled/uncontrolled**: корректная работа при внешнем value/controller.

### 5.2 Где живут тест‑хелперы

- **SHOULD**: использовать `headless_test` helpers (когда они появятся) вместо “самописных” тестовых утилит.

---

## 6) Версионирование и совместимость

- **MUST**: компонент указывает совместимый диапазон версий core контрактов (как минимум один MAJOR).
- **SHOULD**: придерживаться lockstep‑версии системы, если компонент публикуется как часть “официального набора”.

См. `docs/ARCHITECTURE.md` → “Политика версионирования (SemVer)”.

---

## 7) Метаданные для AI/генераторов (LLM.txt)

- **MUST**: publishable package содержит `LLM.txt` в корне (Purpose/Non-goals/Invariants/Correct usage/Anti-patterns).
- **MUST**: при изменении публичного API/инвариантов обновлять `LLM.txt` в том же PR.

См. `docs/ARCHITECTURE.md` → “AI/MCP metadata policy (LLM.txt)”.

