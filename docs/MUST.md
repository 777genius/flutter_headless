### P0: “приземление” для реального прод-использования (чтобы это не выглядело over-engineering)

Цель P0: чтобы обычный пользователь мог **быстро подключить** и получить “почти как Material/Cupertino”, не создавая свои renderer’ы с нуля, но сохранив headless‑контракты и возможность замены визуала.

- **P0.1 — Preset packages (Material first)**
  - `headless_material` (или аналог): реализация renderer’ов + token resolver’ов для Button/Dropdown (минимум v1).
  - Поддержка **per-instance кастомизации** через контрактные overrides (см. `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`).
  - Advanced‑ветка: возможность передать preset‑специфичные overrides (Material/Cupertino) без привязки core.

- **P0.2 — “Быстрый старт” в `apps/example`**
  - пример не с тестовыми renderer’ами, а с реальным preset’ом (Material v1),
  - показать 3 сценария: default / per-instance overrides / slot override.

- **P0.3 — Conformance как продуктовая гарантия (I10)**
  - `CONFORMANCE_REPORT.md` для `headless_button` и `headless_dropdown_button`,
  - CI‑проверка наличия отчётов там, где заявлено “passes conformance”.

- **P0.4 — Ограничить v1, чтобы не раздувать контракты**
  - не тащить 100 параметров Material/Cupertino в core компоненты,
  - расширения только аддитивно, а “мощность” через overrides/slots/scoped theme.

---

### Улучшения, которые реально повысят “headless” (с оценкой по 10-балльной шкале)
Ниже **оценка = ROI** (насколько “стоит делать”: польза/универсальность/долговечность относительно сложности).

- **1) Вынести рендеринг из `R*` в “renderer contract” (настоящий headless) — 9/10**
  - **Почему**: если `RTextButton` задаёт структуру (Container/Row/loader), это ограничивает бренды. Правильнее: поведение/состояния → *renderer*, который решает структуру, эффекты, примитивы (Ink/Material/градиенты/шейпы).
  - **Что взять у мира**: React Aria “parts + slots + contexts”, Ark UI “unstyled parts”.

- **2) Parts/Slots API для каждого сложного компонента — 8/10**
  - **Почему**: `Dialog/Select/DatePicker` почти всегда требуют “анатомии” (`Root/Trigger/Content/...`), чтобы дизайн мог менять структуру без форка.
  - **Результат**: композиция вместо монолита, меньше “copyWith hell”.

- **3) Реальная Interface Segregation для темы (минимальный контракт + capability composition) — 9/10**
  - **Почему**: `RenderlessTheme` с десятками `resolveX` быстро станет источником breaking changes.
  - **Решение**: отдельные `ButtonResolver/InputResolver/...` + агрегатор с дефолтами/адаптерами; темы собираются композиционно.

- **4) Контролируемость как в Downshift: controlled/uncontrolled + “перехват переходов” (`stateReducer`-аналог) — 7/10**
  - **Почему**: неизбежно появятся продуктовые “исключения” (не закрывать меню при выборе, кастомные правила фокуса, и т.д.).
  - **Эффект**: расширения без форков, предсказуемые кастомы.

- **5) Единый слой “state resolution” (приоритеты состояний) — 8/10**
  - **Почему**: `Set<WidgetState>` сам по себе не задаёт приоритеты комбинаций. Без явных правил будут неожиданные баги.
  - **Как**: мапа правил/матрица (как идея `FWidgetStateMap`), где порядок/специфичность заданы явно.

- **6) FSM (конечные автоматы) для сложных интерактивных паттернов — 8/10**
  - **Почему**: `Select/Menu/Combobox` ломаются на краях (фокус, клавиатура, закрытие, nested overlays). FSM резко снижает “случайные” баги.
  - **Что взять**: Ark UI/Zag.js концептуально (не обязателен exact port).

- **7) Overlay/Popover инфраструктура как отдельный модуль (стратегии позиционирования/скролла) — 7/10**
  - **Почему**: диалоги/меню/тултипы должны делить один мощный слой.  
  - **Что взять**: Angular CDK Overlay (OverlayRef + стратегии), Floating UI (пайплайн “middleware” идейно полезен).

- **8) Семантические токены поверх “сырых” (semantic tokens) — 7/10**
  - **Почему**: бренды меняются не по “primary=фиолетовый”, а по “actionPrimaryBg”, “dangerFg”, “surfaceRaisedBg”.  
  - **Эффект**: multi-brand становится проще, меньше каскадных правок.

- **9) Политика стабильности API + версионирование контрактов — 8/10**
  - **Почему**: дизайн-система — библиотека. Её боль — ломать пользователей.
  - **Как**: capability discovery/optional resolvers/адаптеры/дефолтные реализации.

- **10) Тестовая стратегия уровня “поведение + a11y” (не golden UI) — 7/10**
  - **Почему**: в headless важнее корректность событий/фокуса/семантики, чем пиксели.
  - **Что тестить**: переходы состояния, фокус-трап, клавиатурные сценарии, семантика.

---

### Дополнения из свежего ресёрча (2025–2026)

- **11) Focus management как first-class механизм (trap/restore/close button) — 9/10**
  - **Почему**: это главный источник критических багов (keyboard trap, focus на скрытых, broken announcements).
  - **Как**: общий механизм в `headless_foundation` + требования в `docs/V1_DECISIONS.md`.

- **12) WCAG 2.2 baseline (Target Size 24×24, Focus Not Obscured/ensureVisible) — 8/10**
  - **Почему**: комплаенс с 2025, лучше иметь базовые гарантии по умолчанию.

- **13) W3C Design Tokens 2025.10 import (CLI) — 8/10**
  - **Почему**: стандартный формат → проще multi-brand и интеграция с Figma/Tools.
  - **Как**: CLI команда вида `headless tokens import design-tokens.json` (позже реализуем), поддержка `$extends` как наследование бренда.

- **14) Context splitting policy (avoid re-render storms) — 8/10**
  - **Почему**: на больших деревьях “context value per build” убивает perf.
  - **Как**: `ValueListenable`/`InheritedNotifier` и разделение контекстов по смыслу (open/highlight/positioning).

- **15) Animations as first-class (enter/exit + overlay closing phase) — 9/10**
  - **Почему**: типовая проблема headless UI — exit-анимации ломаются, когда subtree удаляют “сразу”.
  - **Как**: overlay механизм должен поддерживать “closing phase” (держать subtree до завершения exit), а renderer contracts — принимать motion policy (durations/easing).

- **16) AI/MCP metadata (LLM.txt) для правильного использования компонентов агентами — 8.5/10**
  - **Почему**: генерация UI без инвариантов даёт несогласованность и баги; метаданные + доки резко повышают шанс корректного использования.
  - **Как**: в каждом пакете держим короткий `LLM.txt` (или эквивалентный документ), где описаны инварианты, точки расширения, примеры правильного использования.

- **17) a11y test helpers + ручные проверки (automation 30–50%) — 8.5/10**
  - **Почему**: автоматизация ловит только часть проблем; без хелперов тесты будут нерегулярными и неполными.
  - **Как**: добавить тестовые matchers/assertions для semantics/focus/keyboard и закрепить manual checklist (VoiceOver/NVDA/keyboard).

- **18) Unified press events (как “usePress”, но по‑Flutter) — 8.5/10**
  - **Почему**: нажатия приходят из разных источников (mouse/touch/keyboard/assistive tech), и без единой политики `pressed` будет “залипать”/ломаться на краях.
  - **Как**: общий механизм в `headless_foundation/interactions` (press events + pointerType + cancel/drag-off semantics), который используют все `R*`.

- **19) Positioning middleware pipeline (Floating UI‑style) — 8.5/10**
  - **Почему**: стабильное позиционирование overlay требует композиции правил (offset/flip/shift/arrow) и автообновления на scroll/resize/layout.
  - **Как**: typed middleware в `anchored_overlay_engine/positioning` + coalesce обновлений до 1/frame (perf guardrail).

---

### Подходы/принципы, которые ты назвал (и как они ложатся на Headless)
- **Composition > Inheritance — 10/10**
  - Это прям основа headless: поведение/рендер/токены/варианты собираются “как конструктор”.  
  - Практически: меньше `BaseTheme extends ...`, больше “theme = композиция резолверов/токенов/политик”.

- **Principle of Least Astonishment (POLA) — 9/10**
  - В headless это критично: API должно вести себя “как ожидает разработчик Flutter”.
  - Правила POLA, которые особенно важны:
    - предсказуемые дефолты (disabled/loading/focus),
    - стабильные имена и роли (variant/size/state),
    - минимальные “магические” сайд-эффекты (не закрываем/не меняем фокус без причины),
    - единая модель controlled/uncontrolled.

---

### Если выбирать 3 “самых правильных” улучшения в твоём контексте
1) **Renderer contract (настоящий headless)** — 9/10  
2) **Segregated theme contract + композиция резолверов** — 9/10  
3) **Parts/Slots API для сложных компонентов** — 8/10  

Скажи, какой у тебя приоритет: **максимальная гибкость для брендов** или **скорость выпуска набора компонентов** — и я от этого предложу “целевую” архитектуру (минимальный набор контрактов + раскладка по модулям/пакетам).