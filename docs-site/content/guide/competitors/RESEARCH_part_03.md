## Исследование конкурентов и подходов (part 3)

Back: [Index](./RESEARCH.md)

## Новые открытия (Часть 2, 2025–2026) — что важно учесть в Headless

### 11) React Server Components + headless UI: архитектурная несовместимость (урок для нас)

**Суть:** в web‑экосистеме headless UI часто завязан на hooks/render‑props, а RSC ломает эти паттерны (server/client граница, `use client`, DoS риски).

**Вывод для Headless (Flutter):**
- У нас нет server/client разрыва, поэтому “headless как hooks” не нужен.
- Но урок полезен: **не строить API на механизмах, которые завязаны на конкретный runtime/рендер-пайплайн**.
- В `foundation` держим чистые механизмы (events/state/effects), а не “магические” контракты, которые трудно переносить.

### 12) Figma MCP Server (GA) и W3C Tokens native: ускорение, но не автопилот

**Decision:** Open **6.5/10** (Figma MCP интеграция/экспорт), Adopt **8.5/10** (AI metadata policy).  
**Что считаем применимым:**
- Закладываем путь к **W3C tokens import CLI** (уже в планах).
- Добавляем **AI‑совместимые метаданные**: короткое описание API/инвариантов для каждого пакета (см. ниже `LLM.txt` policy).

**Что НЕ обещаем:**
- “генерация 70% UI” не заменяет архитектуру/инварианты. В headless важнее политики, чем “скрин в код”.

### 13) AI + Design Systems: 50–80% готовности максимум → значит нужны политики

**Что берём как правило:** “From Screens to Policies”.
- Документация инвариантов (focus/dismiss/overlay/keyboard) — обязательна.
- Компоненты должны быть модульными (small surface area, typed contracts).
- Метаданные для AI (LLM.txt) повышают шанс, что агент/генератор не нарушит правила.

### 14) Анимации + headless UI: типовой конфликт → анимации должны быть first-class

**Вывод:** если overlay/панели удаляются из дерева “сразу”, exit‑анимации ломаются.

**Decision:** Adopt **9/10**.  
**Что считаем применимым (Adopt):**
- В v1 фиксируем: **enter/exit анимации — часть контракта** (не afterthought).
- Overlay механизм должен поддерживать “closing phase” (держать subtree до завершения exit).
- Renderer contracts должны позволять theme задавать motion policy (durations/easing).

### 15) Micro-frontends + Design Systems: общий урок про ownership и границы

**Decision:** Adopt **8/10**.  
**Что считаем применимым:** shared компоненты не должны содержать domain/business logic — только UI‑механики.  
Для Headless это совпадает с архитектурой: `foundation/tokens/theme` + компоненты, без бизнес‑слоя.

### 16) Kobalte/Tailwind modifiers: стилизация по состояниям (аналог для Flutter)

**Идея:** в web это `data-*` / модификаторы классов (`ui-expanded`, `ui-disabled`).

**Вывод для Headless:**
- Мы уже имеем `Set<WidgetState>` как единый источник истины по состояниям.
- Важно дать удобный “state targeting” в теме/рендерере (через state resolution + typed slots), а не через 20 boolean props.

### 17) Verdict 2025: hooks vs compound vs render-props (урок применимости)

**Вывод для Headless (Flutter):**
- Низкоуровневые механизмы = `foundation` (аналог “hooks/builders” по смыслу).
- Высокоуровневый API = `R*` + typed slots/parts (аналог “compound components”).
- Render-props‑стиль как основной API избегаем (часто даёт лишние rebuild’ы), но допускаем точечно через typed slots.

### 18) Accessibility testing: автоматизация ловит 30–50%

**Decision:** Adopt **8.5/10**.  
**Что считаем применимым (Adopt):**
- Нужны **test helpers** (matchers/assertions) для типовых a11y требований (semantics, focusability, keyboard).
- Автотесты не заменяют ручные проверки: keyboard + реальные screen readers (VoiceOver/NVDA/JAWS) — должны быть в release checklist.

### 19) Bits UI layered architecture: “двухуровневость” — это норма

**Вывод:** наш выбранный подход совпадает:
- `headless_foundation` ≈ Melt UI (механизмы)
- `components/headless_*` ≈ Bits UI (готовые компоненты)

### 20) Flutter State Management 2025: hybrid strategy (урок для библиотеки)

**Вывод:** Headless должен оставаться state-management agnostic:
- transient UI state (open/highlight/pressed) локально/контроллерами,
- бизнес‑логика/доменные сторы — вне библиотеки.

---

## Глубокий разбор (2025–2026): топ решений, которые стоит заимствовать

> Важно: это **не список “делаем как X”**. Это разбор чужих решений.  
> Мы берём только то, что **укладывается в нашу архитектуру** (E1 + foundation mechanisms + renderer contracts) и не добавляет “магии”.

### 1) Zag.js: минимальные state machines для UI

**Почему интересно:** философия “маленькие и простые машины” даёт предсказуемые переходы без тяжелых концептов (spawn/invoke/nested).

**Что берём в Headless (совместимо с E1):**
- FSM как **режимы в state** (`closed/opening/open/closing`) и строгие правила переходов.
- Переходы остаются **pure** (switch exhaustive), side effects уходят в **effects executor** (у нас это уже E1).
- Таймеры/отложенные операции — только через effects (никаких “watcher’ов”, которые мутируют state).

**Что НЕ берём (важно):**
- Мутабельный context через Proxy / “watch/computed как реактивщина” → в библиотеке это часто источник скрытых сайд‑эффектов и perf проблем.
- Вместо этого: derived значения = **чистые селекторы** от state + токены/политики.

### Короткая проверка “ложится на нашу архитектуру или нет”

| Идея из ресёрча | Ложится на Headless? | Почему / как адаптируем |
|---|---:|---|
| “Маленькие FSM” (Zag философия) | ✅ | Как дисциплина моделирования режимов внутри **E1**; state immutable, transitions pure |
| Мутабельный context + watch/computed | ❌ | Скрытые сайд‑эффекты и perf риски; у нас selectors + effects |
| “render callback / render prop” как основной API | ⚠️ | В Flutter часто даёт лишние rebuild’ы и размывает контракты; вместо этого **typed slots/parts + renderer contracts**. Render‑callback допускаем точечно как внутренний инструмент renderer’а, но не как основной public API |
| Unified press (usePress идея) | ✅ | Это foundation‑механизм `interactions`, единый источник `pressed/hovered/focus` |
| Positioning middleware pipeline (Floating UI) | ✅ | Это core overlay positioning контракт (typed middleware + autoUpdate + 1/frame coalesce) |
| Focus trap с sentinel‑логикой | ✅ | Как foundation механизм focus/overlay; обязателен для Dialog и menu‑оверлеев |

### 2) Radix Slot / `asChild` (и проблема `cloneElement`)

**Вывод для Headless:** это подтверждает наш guardrail (без копирования реализации):
- не делаем “полиморфизм компонента” (`as/asChild`) и скрытое мерджение обработчиков.
- расширяемость обеспечиваем **typed slots/parts** + renderer contracts (Replace/Decorate).

### 3) React Aria `usePress`: unified press events

**Почему важно:** реальные устройства дают разные “каналы” ввода (touch/mouse/keyboard/assistive tech), а “нажатие” должно вести себя одинаково.

**Decision:** Adopt **8.5/10**.  
**Что считаем применимым (Adopt):**
- Foundation‑примитив “press” (унифицированные события + pointerType) для согласованных `pressed/hovered/focused` состояний.
- Отдельная обработка `cancel` и “drag off element” сценариев, чтобы `pressed` не залипал.

### 4) Floating UI: positioning engine как middleware pipeline

**Почему важно:** устойчивое позиционирование overlay = не “одна формула”, а pipeline:
`offset → flip → shift → arrow` + autoUpdate на scroll/resize/layout.

**Decision:** Adopt **8.5/10**.  
**Что считаем применимым (Adopt):**
- Typed middleware pipeline в `anchored_overlay_engine/positioning`.
- Обязательный coalesce обновлений до 1/frame (perf guardrail).

### 5) Focus trap: полная реализация

**Decision:** Adopt **9/10**.  
**Что считаем применимым (Adopt):**
- В v1 обязателен полноценный focus trap/restore (уже зафиксировано), но важно зафиксировать практику:
  - initialFocus policy
  - returnFocus policy
  - escapable boundaries (Esc/close button/outside tap policy)
  - ensureVisible/preventScroll политика как часть focus/overlay инфраструктуры
