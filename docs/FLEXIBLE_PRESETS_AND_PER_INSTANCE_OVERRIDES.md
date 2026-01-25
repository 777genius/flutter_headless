## Flexible presets + per-instance overrides (Material/Cupertino) — архитектура v1

### Зачем этот документ

Headless‑компоненты дают сильные гарантии (поведение/overlay/a11y/keyboard), но без продуманной кастомизации пользователи будут спрашивать: “зачем, если можно напрямую Material/Cupertino?”

Цель этого документа — зафиксировать архитектуру, при которой:
- **core остаётся headless** и не раздувается пропсами конкретных UI‑китов,
- у пользователя остаётся **per-component/per-instance гибкость**, сравнимая с прямым использованием Material/Cupertino,
- “быстрый прод‑старт” возможен без написания renderers с нуля.

---

### Ключевая идея

Мы не пытаемся прокинуть весь API Material/Cupertino в headless‑компоненты. Вместо этого мы даём 3 ортогональных механизма кастомизации:

1) **Slots/parts** (структурная кастомизация) — для замены частей дерева.
2) **Per-instance override bag** (параметры для preset’а) — для “как в Material: style на конкретной кнопке”.
3) **Scoped theme composition** (локальная тема/рендереры) — для “как Theme(...), но только на один экран/поддерево”.

Это покрывает почти все реальные сценарии, не ломая headless separation.

---

### Пакеты (слои ответственности)

#### 1) Core contracts (headless)
- `headless_contracts`: renderer contracts, token resolver contracts, slots/overrides (см. I05/I08).
- `headless_theme`: capability discovery и guard.
- `headless_foundation`: overlay/effects/focus primitives.
- `headless_tokens`: чистые токены (без Flutter UI типов).
- Компоненты (`headless_button`, `headless_dropdown_button`, …): поведение + сбор request.

#### 2) Presets (реализации визуала)
- `headless_material` (или `headless_material_renderers`): реализует renderer’ы и token resolver’ы под Material 3.
- `headless_cupertino`: то же под Cupertino.
- (опционально) `headless_default_presets`: удобные реэкспорты/композиции.

Правило: **preset пакеты зависят от core, core не зависит от preset’ов.**

---

### Механизм 1 — Slots/parts (пер-instance, структурная гибкость)

Слоты — это самый мощный механизм per-instance кастомизации, потому что позволяет заменить “часть структуры”, а не только стиль.

Принципы:
- слот **опционален** (POLA),
- Replace/Decorate — явная семантика,
- слот получает **контекст** (spec/state/items/callbacks), достаточный для корректного поведения.

Примеры v1:
- Dropdown: `anchor/menu/item/menuSurface` + узкие расширения `chevron/itemContent/emptyState`.
- Button: минимум `child/icon` (и расширяем аддитивно).

---

### Механизм 2 — Per-instance override bag (в стиле Flutter “style на конкретном виджете”)

Проблема, которую решаем:
Пользователь хочет “вот эта кнопка — с другим style”, но не хочет:
- писать свой renderer,
- городить локальную тему ради одного виджета,
- терять доступ к богатству Material/Cupertino.

Решение: **override bag**, который прокидывается из компонента в renderer/token resolver.

#### 2.1 Где живёт тип override bag

В `headless_contracts` (как часть контракта request), в максимально нейтральной форме:
- контейнер “Type → Object”,
- не тянет Material/Cupertino.

**SOLID-позиция (важно)**:
- ключи/типы в override bag должны быть **абстракциями (contracts)**, а не конкретными классами Material/Cupertino;
- preset пакеты могут добавлять свои конкретные реализации, но пользователь по умолчанию должен иметь возможность остаться на уровне контрактов.

Пример формы (псевдо‑API, идея на уровне контрактов):

```dart
final overrides = RenderOverrides({
  RButtonOverrides: RButtonOverrides.tokens(
    // token patch: влияет на resolvedTokens детерминированно
    // (типы тут из headless_contracts, а не из headless_tokens)
    /* ... */
  ),
});
```

Renderer preset’а просто читает нужный тип из bag и применяет.

Если пользователю нужен “максимум мощности” конкретного preset’а (Material/Cupertino),
он может передать и preset‑специфичный override объект, но это **advanced‑путь**, а не обязательный.

#### 2.2 Как это интегрировать в contracts (важно для I08)

В RenderRequest (Variant B) добавляем поле:
- `overrides` (optional) — per-instance hints/config для preset’а.

Также **token resolver capability** должен получать overrides, чтобы style/shape могли влиять на resolved tokens детерминированно:
- `resolve(spec, widgetStates, constraints?, overrides?, context) -> ResolvedTokens`

---

### Preset-specific advanced overrides (Material-only, opt-in)

Advanced overrides live in preset packages and are not portable across presets.
They are applied by token resolvers only, with higher priority than contract overrides.

Example (Material):

```dart
final overrides = RenderOverrides({
  RButtonOverrides: RButtonOverrides.tokens(
    padding: const EdgeInsets.all(1),
  ),
  MaterialButtonOverrides: const MaterialButtonOverrides(
    density: MaterialComponentDensity.comfortable,
    cornerStyle: MaterialCornerStyle.pill,
  ),
});
```

Cupertino presets can also opt-in via `CupertinoButtonOverrides` / `CupertinoDropdownOverrides`.

#### 2.3 Правила совместимости

- Core компоненты не интерпретируют overrides.
- Неизвестные overrides **игнорируются** renderer’ом (MAY).
- В debug можно добавить диагностику “unconsumed overrides” (опционально), но без падения в release.

---

### Механизм 3 — Scoped theme composition (локально, но без API‑раздувания)

Это “как Theme(...)”:
- пользователь может локально подменить capabilities для конкретного subtree,
- не меняя API компонентов.

Пример использования:
- на одном экране — другой dropdown renderer,
- для одной фичи — экспериментальный preset.

Технически:
- `HeadlessThemeProvider` уже есть как InheritedWidget,
- в v1 достаточно **вложенности** `HeadlessThemeProvider(...)` для локального переопределения.
- v1.1: добавляем безопасный механизм “подменить только нужные capabilities” без merge-магии: `docs/implementation/I21_scoped_theme_capability_overrides_v1.md`.

Правило приоритетов (предсказуемость):
1) scoped theme composition (самое локальное)
2) глобальная тема

Внутри одной темы приоритеты должны быть фиксированы:
1) per-instance overrides bag
2) theme defaults / global overrides

---

### Как избежать “потери гибкости” относительно прямого Material/Cupertino

#### 1) Preset должен использовать нативные виджеты там, где это не ломает наши контракты
Для Material preset’а — нормально строить визуал через `FilledButton/OutlinedButton` и т.д., но:
- источник активации остаётся в компоненте (чтобы не было double‑invoke),
- overlay close contract соблюдается (closing→completeClose),
- semantics/expanded/keyboard правила соблюдаются.

Если конкретный нативный виджет делает это невозможным — в preset пишем минимальную свою реализацию только для этого места.

#### 2) “Material‑подобные knobs” должны быть доступны per-instance
Например:
- для кнопки: style/shape/density/leading/trailing icon policy,
- для dropdown: menu surface style, item height/padding, max menu height, elevation, positioning hint.

Но всё это — через override bag или slots, а не через раздувание `RTextButton`/`RDropdownButton` параметрами Material.

---

### Anti-patterns (чего не делать)

- Не добавлять в core компоненты 50–100 параметров “как у Material”.
- Не давать renderer’у “самостоятельно” вызывать `onChanged/onPressed` на input событиях — это ломает политику single activation source и ведёт к double‑invoke.
- Не завязывать capability discovery на `toString()` generics в прод‑контрактах (в v1 лучше избегать generic renderer capabilities или вводить явную identity‑стратегию).

---

### Что это значит для итераций I08–I10

#### Можно ли реализовывать I08–I10 сейчас?
Да, **это не блокер**, но:
- в I08 лучше сразу предусмотреть `overrides` в RenderRequest и в token resolver signature как optional,
чтобы позже не делать болезненный breaking change.

#### Почему это важно именно сейчас
I08 фиксирует “полную форму RenderRequest”. Если мы добавим per-instance overrides позже, это будет либо:
- breaking изменение request,
- либо “костыль” через неявные каналы.

---

### Чеклист (как критерий “реально гибко”)

- [ ] Есть slots для структурной замены (button/dropdown минимум).
- [ ] Есть per-instance override bag в RenderRequest (optional).
- [ ] Token resolver учитывает overrides детерминированно.
- [ ] Есть scoped theme composition (локальные preset’ы/рендеры).
- [ ] Приоритеты кастомизации задокументированы и стабильны.
- [ ] Нет раздувания component API под Material/Cupertino.

---

### Практика: как это выглядит в реальном приложении (пример v1)

Цель примера: показать, что пользователь может:
- использовать готовый preset (Material),
- локально переопределить тему на subtree (scoped theme),
- на конкретном экземпляре виджета переопределить стиль (per-instance overrides),
- при необходимости заменить кусок структуры через slots.

#### 1) Быстрый старт: Material preset на всё приложение

```dart
HeadlessThemeProvider(
  theme: MaterialHeadlessTheme(), // из пакета headless_material
  child: const MyApp(),
);
```

#### 2) Scoped theme (локально, только на один экран/фичу)

```dart
HeadlessThemeProvider(
  theme: MaterialHeadlessTheme(), // глобально
  child: HeadlessThemeProvider(
    theme: MaterialHeadlessTheme(
      // например, другой shape/spacing policy только для этого экрана
      defaults: const MaterialDefaults(density: MaterialDensity.compact),
    ),
    child: const SettingsScreen(),
  ),
);
```

#### 3) Per-instance overrides (вот эта конкретная кнопка “особенная”)

```dart
RTextButton(
  onPressed: save,
  // overrides прокидываются в token resolver + renderer через request.
  overrides: RenderOverrides({
    // v1: preset-agnostic override на уровне контрактов.
    RButtonOverrides: RButtonOverrides.tokens(
      backgroundColor: Colors.red,
      borderRadius: BorderRadius.circular(8),
    ),

    // Note: Preset-specific overrides (MaterialButtonOverrides, etc.)
    // могут быть добавлены в будущих версиях как advanced-слой.
  }),
  child: const Text('Save'),
);
```

#### 4) Slots (структурная кастомизация — без переписывания поведения)

```dart
RDropdownButton<String>(
  value: value,
  onChanged: setValue,
  items: const ['a', 'b'],
  itemAdapter: HeadlessItemAdapter.simple(
    id: (v) => ListboxItemId(v),
    titleText: (v) => v == 'a' ? 'Option A' : 'Option B',
  ),
  slots: RDropdownButtonSlots(
    // Slots — для wrap/structure. Если нужно "просто стиль" (цвет/радиус/паддинги) —
    // используйте `overrides` / `style`, а не слоты.
    menuSurface: Decorate((ctx, child) {
      return DecoratedBox(
        decoration: const BoxDecoration(/* ... */),
        child: child,
      );
    }),
  ),
);
```

Примечание: `Material*` типы в примере — это **advanced‑ветка** для проектов,
которые сознательно выбирают Material preset. Каноничный путь остаётся через контрактные
override типы (`RButtonOverrides`, `RDropdownOverrides`, ...), чтобы не привязывать core к UI-киту.

---

### Нейминг v1: Dropdown вместо Select

В Flutter экосистеме понятие “Select” как имя виджета почти не используется. Для v1:
- используем **только** `RDropdownButton<T>` как компонент выбора (single select),
- отдельный `RSelect` **не вводим**, чтобы не плодить сущности и не путать пользователей,
- если в будущем появятся новые режимы (searchable/multi-select/combobox) — это будут отдельные компоненты с отдельными именами.

