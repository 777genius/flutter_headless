## Исследование конкурентов и подходов (part 2)

Back: [Index](./RESEARCH.md)

## Интересные паттерны

### 1. Builder + state.when (naked_ui)
```dart
builder: (context, state, child) {
  final color = state.when(
    pressed: value1,
    hovered: value2,
    orElse: value3,
  );
}
```

**Decision:** Reject **7/10** как *основной public API*.  
Builder-подход допустим внутри renderer’ов/слотов точечно, но стандарт Headless — E1 + renderer contracts (иначе логика расползается по UI).

### 2. Method chaining (styled_widget)
```dart
Icon(Icons.home)
  .padding(all: 10)
  .decorated(color: Colors.blue)
  .card(elevation: 10);
```

**Decision:** Reject **6/10**  
DSL‑подобный API расширяет surface area и усложняет поддержку/совместимость; лучше держать контракты и токены.

### 3. White-label Provider pattern
```dart
Provider<CompanyTheme>(
  create: (_) => clientATheme,
  child: App(),
)
```

**Decision:** Adopt **7.5/10**  
Это естественный способ держать multi-brand на уровне приложения: theme/tokens/renderer выбираются через scope/provider, без форков.

### 4. CLI генерация тем (Forui)
```bash
dart run forui theme create zinc-light
dart run forui style create button
```

**Decision:** Open **6.5/10**  
Если делать, то как optional tooling поверх W3C tokens import (генерировать токены/каркасы renderer’ов), но не “генерить готовые виджеты”.

---

## Выводы

**Ниша свободна.** Никто не объединяет:
- Headless (naked_ui подход)
- Type-safe варианты (sealed classes)
- Zero-cost токены (extension types)
- Встроенный theming (multi-brand)
- Exhaustive pattern matching
- Нативный WidgetState

---

## Грабли и уроки экосистемы (2025–2026) — что НЕ делать в Headless

Ниже — типовые ошибки в headless/UI библиотеках в других экосистемах. Мы фиксируем их как **guardrails** для Headless v1+.

### 1) “as prop” / полиморфизм через подмену компонента

**Проблема:** при композиции компонентов часто “теряются” props/семантика/инварианты, появляются трудноотлавливаемые баги.  
**Решение для Headless:** **не нужен `as`**. Структуру/визуал определяет renderer через `render(request)` + slots (`Replace/Decorate`).

### 2) Boolean flags вместо явных состояний

**Проблема:** `isLoading/isError/isHovered/...` быстро дают \(2^n\) комбинаций, большинство из которых невалидны.  
**Решение для Headless:** для сложных интеракций используем **FSM**; для простых — `Set<WidgetState>` + явная нормализация/приоритеты (state resolution).

### 3) “Material везде” как дефолт

**Проблема:** platform mismatch и слабая кастомизация приводит к “мимо iOS/desktop”.  
**Решение для Headless:** core остаётся **unstyled**; любые “material-like” дефолты — только в отдельном пакете default renderers.

### 4) Доступность как afterthought

**Проблема:** неправильная семантика/структура ломает screen readers и клавиатуру; “починим потом” почти всегда дороже.  
**Решение для Headless:** тесты v1 — **behavior + a11y** (keyboard/focus/semantics), а не golden.

### 5) Overlay positioning как “простая задача”

**Проблема:** anchored overlays ломаются в скролл-контейнерах, при resize, при collision.  
**Решение для Headless:** overlay — это **foundation механизм** с позиционированием в стиле floating-ui (flip/shift/collision pipeline).

### 6) Миграции между версиями как “потом разберёмся”

**Проблема:** пользователи бросают библиотеку после одного большого breaking.  
**Решение для Headless:** capability discovery + lockstep SemVer + deprecation политика (см. `docs/ARCHITECTURE.md`).

---

## Лучшие подходы, которые выглядят перспективно (и как мы их переосмысляем в Headless)

### 1) FSM для сложных компонентов (референс: Zag.js / Ark UI)

**Почему это полезно:** предсказуемость, тестируемость, невозможные состояния невозможны.  
**Куда применяем:** `Dialog`, `Select/Combobox`, menu‑подобные паттерны.

### 2) Slots/Parts API (референс: Radix)

**Почему это полезно:** точечный override без переписывания всего renderer’а.  
**Как у нас:** `render(request)` + slots `Replace/Decorate` (см. `docs/V1_DECISIONS.md`).

### 3) `stateReducer` (референс: Downshift)

**Почему это полезно:** продуктовые команды смогут менять правила поведения без форков.  
**Как у нас:** hook “перехват переходов” на уровне state/events (см. `docs/ARCHITECTURE.md`).

### 4) Behavior primitives (референс: Angular CDK)

**Почему это полезно:** overlay/focus/dismiss как инфраструктура — переиспользуем везде.  
**Как у нас:** `headless_foundation` (overlay + listbox + focus).

### 5) Platform-aware defaults (референс: Compose Unstyled)

**Почему это полезно:** разные платформы ожидают разное поведение/анимации.  
**Как у нас:** это ответственность default renderers/theme, core остаётся headless.

---

## Глубокие уроки из Tier-1 конкурентов (почему “у них больно”, и что делаем иначе)

Эта секция — практические выводы уровня “не повторять чужие архитектурные ошибки”.

### Radix UI: perf и типобезопасность композиции

- **Проблема: forced reflow/дорогие измерения при open/close** (web): чтение layout/computed styles в критическом пути открытия модалки/поповера приводит к задержкам на больших деревьях.
- **Вывод для Headless:** мы не вводим дизайн, который требует “синхронно измерить мир” при каждом open/close. Для Flutter‑оверлеев:
  - позиционирование и измерения делаем **в overlay-механизме** (foundation) и **троттлим/коалесим** обновления,
  - опираемся на **layout/paint фазы** и callbacks (`postFrame`/animation status), а не на циклы “измерил → сразу перестроил → снова измерил”.
- **Проблема: `asChild` без строгой проверки контрактов** (web): композиция может тихо перестать работать.
- **Вывод для Headless:** мы не делаем `as/asChild` API; вместо этого — renderer contracts + typed slots (`Replace/Decorate`) и строго определённые контексты частей.

### React Aria: “enterprise”, но тяжёлый и конфликтный

- **Проблема: циклические зависимости ломают tree-shaking** → в бандл тянется лишнее.
- **Вывод для Headless:** жёсткий **DAG** между пакетами + запрет `component -> component` (кроме facade) — это не “красота”, а защита от разрастания.
- **Проблема: конфликты фокуса/диссмиса** между библиотеками из-за разных политик обработки pointer/focus.
- **Вывод для Headless:** делаем **единый overlay/dismiss/focus стек** в `headless_foundation`, чтобы все компоненты жили по одной политике и не “ломали” друг друга.
- **Проблема: DX/boilerplate** у hook-based подхода.
- **Вывод для Headless:** v1 = D2a: advanced уровень через foundation primitives, но основной путь — Flutter-like `R*` wrappers (POLA).

### Zag.js / Ark UI: FSM без удобных async и state sharing

- **Проблема: async операции неудобны** без явного механизма (вынуждают “watch” и внешний код).
- **Вывод для Headless:** в нашем стандарте E1 async делается через **effects → result events** (без “наблюдателей” как основного механизма).
- **Проблема: state sharing требует внешнего DI/библиотек**.
- **Вывод для Headless:** “state sharing” делаем нативно через **Scope/InheritedWidget** и controllers/listenables (без обязательных зависимостей).

### Compose Unstyled: реактивность в “ленивых” лямбдах

- **Проблема:** значения, вычисленные один раз, не обновляются при изменении state (detent/derived values).
- **Вывод для Headless:** любые “derived значения” должны быть либо:
  - вычисляемыми детерминированно из актуального state в reducer/renderer,
  - либо явными подписками/listenables, но не “замыканием, которое вызвали один раз”.

---

## Новые открытия (2025–2026) — что добавляем в планы Headless

### 1) W3C Design Tokens 2025.10 (stable)

**Почему важно:** появляется общий формат токенов для Figma/Sketch/Adobe → проще интеграция multi-brand без “ручных мостов”.  
**Decision:** Adopt **9/10** (W3C import + `$extends`), Open **6/10** (P3/OKLCH runtime).  
**Что считаем применимым (Adopt):**
- импорт токенов из W3C JSON как вход для генерации наших `extension type` токенов
- поддержка `$extends` как основной механизм наследования брендов (multi-brand)
- multi-brand через **group inheritance** (наследование групп токенов без копипасты)
- поддержка современных color spaces **Display P3 / OKLCH** на уровне данных токенов (с оговоркой: фактический рендер в Flutter зависит от платформы/движка)

**Риск/ограничение:** некоторые стили (например, сложные stroke patterns) остаются implementation-specific → не обещаем 1:1 рендер.

**Технические нюансы спецификации (важно для импорта):**
- Объект с `$value` — это **token**. Объект не может быть одновременно token и group: если есть `$value` и дочерние tokens/groups, инструменты **MUST** считать это ошибкой.
- Groups могут иметь **root token** через зарезервированное имя `$root` (для “базового значения” группы + вариантов).
- `$type` может задаваться на группе и **наследоваться** дочерними токенами, если они не объявляют свой `$type`.
- `$extends` — **только для групп**, не должен ссылаться на token, и по смыслу эквивалентен JSON Schema `$ref`.
- Aliases/refs:
  - curly brace синтаксис `{group.token}` поддерживается для эргономики,
  - JSON Pointer refs через `$ref: "#/path"` — для продвинутых сценариев (и как механизм интеграции с JSON Pointer).
- Порядок резолва внутри группы: local tokens → `$root` tokens → inherited via `$extends` (если не overridden) → nested groups.

### 2) Base UI v1.0: “render pattern” вместо `asChild`

**Почему важно:** `asChild`/cloneElement в web экосистеме порождает скрытую магию и дырки в type-safety.  
**Decision:** Adopt **9/10** (typed slots/parts + renderer contracts), Reject **7/10** (render-props как основной public API).  
**Что считаем применимым (Adopt):**
- никакого `as/asChild` (уже зафиксировано)
- эквивалент “render pattern” достигаем через **явный Replace/Decorate slots**: “вот часть, вот её контекст, вот замена/обёртка”

### 3) shadcn/radix урок: ownership и качество важнее скорости PR

**Почему важно:** отсутствие ревью и огромный backlog превращают DS в источник багов/регрессий.  
**Decision:** Adopt **8/10**.  
**Что считаем применимым (Adopt):**
- строгие **guardrails** и чеклист ревью (уже есть в `docs/ARCHITECTURE.md`)
- “маленький API surface” + DAG + lockstep SemVer (зафиксировано)
 - явное **ownership**: “кто отвечает за качество core”, иначе библиотека деградирует при росте PR/контрибьюций

### 4) Focus management = главная боль 2025

**Decision:** Adopt **9/10**.  
**Что считаем требованиями:** focus trap/restore, escapable границы, видимая/доступная close-кнопка для touch screen readers, предсказуемый tab-order.

### 5) WCAG 2.2: новые обязательные требования (с 2025)

**Decision:** Adopt **8.5/10**.  
**Что считаем требованиями:**
- **Target Size**: минимум 24×24px для интерактивных целей
- **Focus Not Obscured**: focused элемент не должен быть перекрыт (нужен ensureVisible/scroll-into-view policy)

**Что фиксируем как “не про core компонентов” (но помним):**
- **Dragging Alternatives**: относится к drag-and-drop компонентам (в Headless появится только если мы делаем drag/drop primitives).
- **Accessible Authentication** и **Consistent Help**: это требования уровня приложения/продукта, а не headless UI primitives.

### 6) Compound components: hidden complexity

**Вывод:** паттерны “только прямые children”, “prop collisions”, “context re-render storms” в Flutter проявляются иначе, но проблема та же.  
**Decision:** Adopt **8/10**.  
**Что считаем применимым (Adopt):**
- контекст-сплиттинг и `ValueListenable`/`InheritedNotifier` вместо “value object пересоздаётся каждый build”

### 7) Design system failures (компании): “culture > components”

**Decision:** Adopt **8/10**.  
**Что считаем применимым (Adopt):**
- стартуем с **5–7 core компонентов** (Button/Input/Card/Dialog/Select + минимум)
- добавляем по запросу, документация важнее количества

### 8) Flutter Architecture 2025: MVVM/UDF как стандарт

**Вывод:** наш E1 (events вверх, state вниз) — это натуральный **Unidirectional Data Flow**.  
Это упрощает тестирование и снижает “магические” сайд-эффекты.

### 9) Maintenance risk (single maintainer / слабый backing)

**Вывод для Headless:** external risk снижаем через:
- **zero dependencies** (уже зафиксировано),
- строгую release дисциплину и ownership (DAG + lockstep SemVer + ревью-чеклист).

---

