## I22 — Next Architecture Steps (v1.1): Spec/Conformance + Unconsumed Overrides + Slot Anatomy + Preset-specific Advanced Overrides (part 2)

Back: [Index](./I22_architecture_next_steps_overrides_slots_presets_v1_1.md)

## 3) Slot anatomy: расширяем slots аддитивно (без форков renderer’ов)

### 3.1 Цель

Сделать так, чтобы 80% структурных кастомизаций делались:
- либо через slots (структура),
- либо через overrides (токены),
без переписывания renderer целиком.

### 3.2 Решение (лучший вариант)

Важно: у нас сейчас **2 разных класса “слотов”**:

- **Override slots** (Replace/Decorate/Enhance, через `SlotOverride<C>`) — сейчас это `RDropdownButtonSlots`.
- **Static widget slots** (просто `Widget?`) — это `RButtonSlots` и `RTextFieldSlots`.

Это нормально для v1, но означает: “уровни безопасности Replace/Decorate” применимы только к override-slots.

Дальше расширяем slots **по анатомии компонента** и (где есть override-slots) вводим “уровни безопасности”:

- **Decorate-safe** слоты: разрешён только `Decorate` (оборачивать), чтобы не ломать контракты/close/a11y.
- **Replace-allowed** слоты: разрешён `Replace`, когда это безопасно (например, menuSurface).

**Самый безопасный вариант (v1.1):**
- фиксируем “decorate-only” слоты **в документации + debug assert** (без изменения типов полей, чтобы не получить accidental breaking).

**Компиляторный guardrail** допускается только для *новых* слотов:
- если слот добавляем впервые и точно знаем, что `Replace` там никогда не будет безопасен,
  тогда тип поля можно сделать `Decorate<C>?` (это аддитивно, т.к. слот новый).

### 3.3 Конкретные предложения по слотам (v1.1)

#### Button

Текущие static slots: `child`, `icon` (см. `RButtonSlots`).

**v1.1 (минимальный риск, аддитивно):**
- добавить `trailingIcon` (Widget?)
- добавить `spinner` (Widget?) — на будущее для loading UX (если/когда появится)

Не переводим button на SlotOverride-модель в v1.1 (это отдельный, более крупный редизайн контракта).

#### Dropdown

Текущие override-slots: `anchor`, `menu`, `item`, `menuSurface` (см. `RDropdownButtonSlots`).

**v1.1 (аддитивно, узкие точки расширения):**
- добавить `chevron` (SlotOverride<RDropdownChevronContext>?) — отдельная точка для иконки
- добавить `itemContent` (SlotOverride<RDropdownItemContentContext>?) — менять layout строки, не переписывая весь item
- добавить `emptyState` (SlotOverride<RDropdownMenuContext>?) — если items пусты

Тонкость: новые слоты должны быть “узкими”, чтобы уменьшить мотивацию делать Replace на крупных слотах (`anchor`/`menu`/`item`).

Тонкость 2 (очень важная для DX): для “узких” слотов нужен контекст с `child` (default виджет), иначе slot становится Replace-only по факту.
Поэтому вводим новые context-типы (аддитивно, без изменения существующих):
- `RDropdownChevronContext { spec/state/selectedItem/callbacks + Widget child }`
- `RDropdownItemContentContext { item/index/isHighlighted/isSelected/callbacks + Widget child }`
Так пользователь сможет **Decorate/Enhance** вокруг дефолта без полного takeover.

#### TextField

Текущие static slots уже есть: `leading`, `trailing`, `prefix`, `suffix` (см. `RTextFieldSlots`).

**v1.1:** новых слотов не добавляем (избегаем распухания контракта без подтверждённого спроса).

**v1.2 (кандидаты при реальном спросе):**
- `labelWidget` (Widget?) — если нужно рендерить кастомный label вместо строки
- `messageWidget` (Widget?) — если нужно кастомно склеивать helper/error

### 3.4 Тонкости (самое важное)

- **Semantics ownership**: корневые semantics принадлежат компоненту, слоты не должны ломать роли/label/disabled.
- **Overlay close contract**: слоты в dropdown/dialog не должны bypass’ить `completeClose()`.
- **Keyboard**: заменяемые части не должны перехватывать key events.
- **Stable context**: slot context должен быть минимальным и стабильным (не тащить огромные объекты).
- **Backwards compatibility**: существующие слоты не меняем по типам/семантике; новые слоты только добавляем.

### 3.4.1 Guardrails через conformance-тесты (самый надёжный контроль)

Минимальный набор для dropdown (override-slots):
- slot `menuSurface` не должен обходить close contract
- slot `itemContent`/`item` не должен позволить выбрать disabled item (policy)

### 3.5 Изменения файлов (план)

Для каждого компонента:
- обновить contracts:
  - dropdown slots: `packages/headless_contracts/lib/src/renderers/dropdown/r_dropdown_slots.dart`
  - button slots: `packages/headless_contracts/lib/src/renderers/button/r_button_renderer.dart` (там живёт `RButtonSlots`)
  - textfield slots: `packages/headless_contracts/lib/src/renderers/textfield/r_text_field_renderer.dart` (там живёт `RTextFieldSlots`)
- обновить renderer implementations (Material/Cupertino) чтобы использовать новые слоты
- обновить demo app (пример Replace/Decorate)
- обновить conformance тесты (1-2 ключевых слота)

### 3.6 Критерии готовности

- Новые слоты доступны, не ломают старые.
- Есть демонстрация и хотя бы один тест на “slot не ломает контракт”.

---

## 4) Preset-specific advanced overrides (Material/Cupertino) без фрагментации

### 4.1 Проблема

Contract-level overrides намеренно ограничены.
Но пользователи часто хотят “материаловские ручки” (density/feedback/shape policies) без форка renderer’а.

### 4.2 Решение (лучший вариант)

Вводим **двухуровневую модель**:

- **Уровень A (core, preset-agnostic)**: `RButtonOverrides`, `RDropdownOverrides`, `RTextFieldOverrides` в `headless_contracts`.
- **Уровень B (preset-specific, advanced)**: `MaterialButtonOverrides`, `MaterialDropdownOverrides`, … в `headless_material`; аналогично `Cupertino*Overrides` в `headless_cupertino`.

Правило приоритетов (фиксируем и не меняем):
- preset-specific override (если есть) → wins
- затем contract-level override
- затем дефолты preset

**Тонкая деталь:** приоритет должен быть одинаковым и для token resolvers, и для renderers (если renderer читает overrides напрямую).

### 4.2.1 Жёсткий whitelist и критерии “куда класть knob”

Чтобы это не создало сильных минусов, фиксируем правила:

- **Если knob влияет только на один preset** (Material/Cupertino) и завязан на его визуальные идиомы → это кандидат в advanced overrides.
- **Если knob универсален** (подходит и Material, и Cupertino, и кастомным пресетам) → это кандидат в contract-level overrides в `headless_contracts`.
- **Запрещено** принимать произвольные callback’и/билдеры/пол-`ThemeData`:
  - это ломает предсказуемость и создаёт “второй API Material”.
- Advanced overrides должны быть **простыми данными**: enums/doubles/bools, чтобы:
  - tokenResolver оставался детерминированным,
  - изменения можно было переносить/валидировать,
  - не появлялись скрытые side effects.

### 4.2.2 Минимальный whitelist для v1.1 (по одному компоненту, чтобы проверить подход)

Чтобы не раздувать API, в v1.1 ограничиваемся **Button + Dropdown** и 2–3 knob’а на компонент.

**Material (кандидаты):**
- Button:
  - `density` (enum: compact/standard/comfortable) → влияет на padding/minSize
  - `cornerStyle` (enum: sharp/rounded/pill) → влияет на borderRadius policy
- Dropdown:
  - `menuWidthPolicy` (enum: matchTrigger/intrinsic/fixed)
  - `fixedMenuWidth` (double?, используется только при fixed)

**Cupertino:**
- Начать с нуля и добавить только при реальном запросе.
  - Иначе рискуем сделать фрагментацию без пользы.

### 4.2.3 Где эти типы живут (чтобы не засорять core)

- `headless_material`:
  - `lib/src/overrides/material_button_overrides.dart`
  - `lib/src/overrides/material_dropdown_overrides.dart`
- `headless_cupertino`:
  - симметрично, но только если whitelist действительно нужен

### 4.2.4 Как применяются (важная тонкость)

Рекомендуемый подход:
- **Только tokenResolver** читает advanced overrides и “переводит” их в итоговые `ResolvedTokens`.
- Renderer остаётся максимально тупым: использует `ResolvedTokens` и не знает про advanced overrides.

Так мы избегаем:
- рассинхронизации приоритетов (resolver vs renderer),
- скрытых зависимостей от пресета,
- и размазывания логики по двум слоям.

### 4.3 Тонкости (не допустить минусов)

- Не допустить превращения advanced overrides в “второй API Material”.
  - Ввести жёсткий whitelist: только 5–10 самых частых “knobs”.
- Не ломать переносимость:
  - в docs явно: advanced overrides = opt-in, снижает portability.
- Не дублировать одно и то же поле на двух уровнях:
  - если поле полезно всем — поднимаем в contract-level.

### 4.3.1 Анти-паттерны (явно запрещаем в плане)

- “Advanced overrides как дамп ThemeData/ButtonStyle”: создаёт тяжёлую связность и фактически форкит Material API.
- “Renderer читает overrides напрямую”: часто приводит к разным приоритетам и неотлаживаемым багам.
- “Knobs без тестов на приоритет”: потом невозможно безопасно менять.

### 4.4 Изменения файлов (план)

- `headless_material`:
  - новые override типы в `src/.../material_*_overrides.dart`
  - token resolvers читают их из `RenderOverrides` (и применяют приоритеты как в 4.2)
- `headless_cupertino`:
  - аналогично
- docs:
  - обновить `FLEXIBLE_PRESETS...` с чёткими примерами двух уровней
  - добавить “portability warning”

### 4.5 Тесты

- Тест: preset-specific override применяется (и имеет приоритет над contract-level).
- Тест: при отсутствии preset-specific — работает contract-level как раньше.

### 4.6 Критерии готовности

- 1–2 компонента (Button + Dropdown) имеют working advanced overrides в material + cupertino.
- Нет распухания API и нет breaking.

---

## Порядок реализации (рекомендуемый)

1) **(1) Spec/Conformance** — быстро, фиксирует стандарт для ecosystem.
2) **(2) Unconsumed RenderOverrides debug** — максимальный DX без риска.
3) **(3) Slot anatomy** — аккуратно, аддитивно, с guardrails.
4) **(4) Advanced overrides** — после того как слоты/diagnostics стабилизировались.

### Релизная стратегия (чтобы не получить большие минусы)

- **v1.1**:
  - (1) Spec/Conformance тексты + пример
  - (2) debug unconsumed RenderOverrides
  - (3) dropdown: только узкие add-on слоты (chevron/itemContent/emptyState)
  - (4) advanced overrides: только Material, только 1–2 компонента, только whitelist (если реально нужен)

- **v1.2**:
  - расширение button/textfield slots — только при подтверждённом спросе
  - расширение advanced overrides — только через whitelist; приоритетно поднимать универсальные knobs в contract-level

---

## PR-Checklist (для каждой итерации)

- Изменения аддитивны, без breaking.
- Обновлены docs (Spec/Conformance/Implementation).
- Есть тесты на ключевые инварианты (особенно для overlay/keyboard/a11y).
- Нет лишнего шума в debug (diagnostics only when overrides действительно переданы).

