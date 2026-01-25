## I21 — Scoped capability overrides (v1.1): локальная подмена renderer/token capabilities без “merge-магии”

### Цель

Сделать **безопасный и предсказуемый** способ локально (в subtree) подменять **отдельные capabilities** темы (например, только `RDropdownButtonRenderer`), не пересобирая весь preset (`MaterialHeadlessTheme/CupertinoHeadlessTheme`) и не вводя “умные” merge-политики.

Ключевое требование: **минимум минусов** и строгое следование POLA.

---

### Проблема (что сейчас болит)

Сейчас локальная кастомизация делается через:
- per-instance `RenderOverrides` (хорошо для токенов/визуала на одном виджете),
- вложенный `HeadlessThemeProvider(theme: MaterialHeadlessTheme(...))` (работает, но часто требует “пересоздать тему целиком” даже ради 1 capability).

Типичный кейс, который провоцирует форки:
- “На одном экране dropdown должен рендериться иначе, но кнопки/инпуты пусть остаются как у пресета”.

---

### Не-цели (важно)

- **Не делаем merge объектов темы** (никаких “склеек” ColorScheme/TextTheme/дефолтов автоматически).
- **Не делаем частичное наследование внутри capability** (например, “подменить только один метод” в renderer).
- **Не вводим сложные правила приоритетов** помимо стандартных:
  - ближайший `HeadlessThemeProvider` выигрывает;
  - внутри одной темы: overrides выигрывают у base.
- **Не завязываемся на Material/Cupertino типы** в core контрактах.

---

### Архитектурное решение (одно, простое)

В `headless_theme` добавляем “обёртку темы”:

- `HeadlessThemeWithOverrides(base, overrides)`
  - `base`: `HeadlessTheme`
  - `overrides`: типобезопасный bag `Type -> Object` (только для capabilities)
  - `capability<T>()`:
    1) если override задан для `T`, вернуть его
    2) иначе вернуть `base.capability<T>()`

Это **не composition engine**. Это ровно “если есть override — используй, иначе делегируй”.

---

### Требования к API (POLA + совместимость)

#### 1) Прозрачный приоритет

- **Provider nesting**: как в Flutter — ближайший `HeadlessThemeProvider` выигрывает.
- **Overrides внутри темы**: override всегда выигрывает над base.

#### 2) Типовая идентичность = как сейчас в preset’ах

Сейчас `MaterialHeadlessTheme.capability<T>()` определяет capability через сравнение `T == RButtonRenderer` и т.д.
Значит в override bag **ключом должен быть тот же самый `Type`**, что используется в `capability<T>()`.

Никаких строковых ключей и никаких runtime-рефлексий.

**Важно (POLA):** capability-контракты в v1/v1.1 держим **non-generic**. Это сохраняет простую и однозначную идентичность ключей `Type`.

#### 3) Никаких “магических” интерфейсов

Override задаётся **конкретным объектом**, реализующим контракт capability.
Например:
- `RDropdownButtonRenderer -> CustomDropdownRenderer()`
- `RDropdownTokenResolver -> CustomDropdownTokenResolver(...)`

#### 4) Безопасность и отладка

В debug режиме полезно иметь:
- `toString()` или `debugDescribeCapabilities()` у `HeadlessThemeWithOverrides`
  - показывает: base theme type + список overridden capability types.

Это должно быть *pure debug*, без логов в release.

---

### Предлагаемый public API (минимальный)

#### A) Новый тип override bag (не путать с RenderOverrides!)

В `headless_theme`:
- `CapabilityOverrides` (аналогично `RenderOverrides`, но **только** для theme capabilities)
  - `CapabilityOverrides.empty()`
  - `CapabilityOverrides.only<T extends Object>(T value)` — безопасно: ключ = `T`, значение = `T`
  - `CapabilityOverrides.build((b) => b..set<T>(...)..set<U>(...))` — безопасно для нескольких capabilities
  - `T? get<T>()`
  - `bool has<T>()`
  - `CapabilityOverrides merge(CapabilityOverrides other)` (последний wins)

Нейминг важен: **не использовать `RenderOverrides`**, чтобы не смешивать “override tokens per instance” и “override capability per subtree”.

**Тонкая деталь (критично):** не давать пользователю публичный конструктор вида `CapabilityOverrides({Type: Object})`.
Такой API позволит случайно написать:
`{ RDropdownButtonRenderer: SomeOtherObject() }`
и ошибка проявится поздно (в рантайме при касте), а не в момент сборки.

Поэтому public API должен быть построен вокруг `set<T>(T value)` / `only<T>(T value)`.

#### B) Обёртка темы

- `final class HeadlessThemeWithOverrides extends HeadlessTheme`
  - `HeadlessThemeWithOverrides({required HeadlessTheme base, required CapabilityOverrides overrides})`
  - `@override T? capability<T>()`

#### C) Минимальный UX в UI дереве

Самый простой и POLA-friendly usage — через `HeadlessThemeProvider`:

```dart
final base = HeadlessThemeProvider.themeOf(context);

return HeadlessThemeProvider(
  theme: HeadlessThemeWithOverrides(
    base: base,
    overrides: CapabilityOverrides.build((b) {
      b
        ..set<RDropdownButtonRenderer>(MyDropdownRenderer())
        ..set<RDropdownTokenResolver>(MyDropdownTokenResolver());
    }),
  ),
  child: ...,
);
```

Но лучше DX дать хелпер-виджет (опционально, v1.1):

- `HeadlessThemeOverridesScope(...)`
  - внутри берёт `base = HeadlessThemeProvider.themeOf(context)`
  - заворачивает `child` в `HeadlessThemeProvider(theme: HeadlessThemeWithOverrides(...))`

Важно: это **не обязано** существовать, но сильно уменьшает boilerplate и ошибки.

---

### Тонкости / edge-cases

#### 1) Generic capabilities (опасно)

Если в будущем появится capability типа `RListItemRenderer<T>`, то `Type` ключ будет зависеть от `T` и станет неудобным.

Политика v1/v1.1:
- **Capabilities должны быть non-generic** (как сейчас `RDropdownButtonRenderer`).
- Если нужен generic — делаем отдельный non-generic contract, который внутри принимает typed request.

Это сохраняет простоту `Type`-discovery и override bag.

#### 2) Reference equality vs structural

`HeadlessThemeProvider.updateShouldNotify` сейчас сравнивает `theme != oldWidget.theme`.
Если `HeadlessThemeWithOverrides` создаётся каждый build — это может вызвать лишние нотификации.

Политика:
- Рекомендуем создавать overrides scope так, чтобы theme объект был **стабилен** (например, через отдельный виджет, который хранит `HeadlessThemeWithOverrides` в `State` и пересоздаёт только при изменении входных override-объектов).
- `==/hashCode` для `CapabilityOverrides` — опциональная оптимизация, но не обязательная для корректности.

#### 3) Нельзя создавать циклы в capability lookup

`HeadlessThemeWithOverrides` должен делегировать в `base`, который не должен ссылаться обратно на wrapper.
Это легко соблюдается, просто не делаем “двунаправленные” ссылки.

#### 4) Жизненный цикл capability-объектов (важно, чтобы не было скрытых утечек)

Capabilities — это **не** виджеты. Их никто автоматически не `dispose`.

Политика:
- capability-объекты **должны быть безопасны для шаринга** (обычно `const`/immutable либо “stateless service” без подписок).
- если capability внутри держит ресурсы (listeners/таймеры) — ответственность за их lifecycle остаётся на стороне приложения/темы (в v1 мы не вводим общий dispose-контракт для `HeadlessTheme`).

#### 5) Согласованность “renderer ↔ token resolver” (частая ловушка)

В пресетах renderer обычно предполагает, что токены/метрики пришли “его” resolver’ом.
Если в subtree подменить только renderer (или только resolver), можно получить:
- визуальные несостыковки (padding/shape/цвета),
- разные ожидания по `resolvedTokens == null` (если renderer рассчитывает, что токены всегда есть).

Политика v1.1 (без магии, но с подсказкой):
- допускается подменять по одному capability, но **рекомендуемый путь** — подменять связанную пару (например, dropdown renderer + dropdown token resolver) одной операцией.
- в Iteration 2 можно добавить DX-хелпер `HeadlessThemeOverridesScope.dropdown(...)`, который ставит оба capability сразу (это sugar, не контракт).

---

### План итерации (что делаем в коде)

#### Итерация 1 — core primitives (минимальный риск)

**Файлы (новые):**
- `packages/headless_theme/lib/src/theme/capability_overrides.dart`
- `packages/headless_theme/lib/src/theme/headless_theme_with_overrides.dart`

**Файлы (изменить):**
- `packages/headless_theme/lib/headless_theme.dart`
  - экспортировать новые типы из `src/theme/*`

**Тесты (новые):**
- `packages/headless_theme/test/headless_theme_with_overrides_test.dart`
  - “override wins over base”
  - “fallback to base”
  - “merge overrides last wins”
  - “type-safety: нельзя положить неправильный тип через публичный API” (на уровне компиляции — через отсутствие небезопасного конструктора)

**Документация:**
- обновить `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md` (механизм 3) ссылкой на этот doc

#### Итерация 2 — DX sugar (опционально)

**Новый виджет:**
- `HeadlessThemeOverridesScope` (или статический helper у `HeadlessThemeProvider`)
  - гарантирует корректное использование `HeadlessThemeProvider.themeOf(context)`
  - минимизирует boilerplate
  - может держать `HeadlessThemeWithOverrides` стабильно (см. edge-case 2)
  - может предлагать узкие хелперы для “связанных пар” capabilities (см. edge-case 5)

**Дополнительно:**
- debug helper `debugDescribeCapabilities()` / `toString()`

---

### Критерии готовности (Definition of Done)

- Можно локально подменить один renderer capability на subtree без переписывания темы.
- Никаких merge политик и “магии”; приоритеты задокументированы.
- Есть тесты в `headless_theme`, покрывающие базовую семантику overrides.
- В доках есть короткий пример “override dropdown renderer только на экран”.

