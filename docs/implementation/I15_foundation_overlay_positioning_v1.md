## I15 — Foundation v1: Anchored Overlay Positioning (flip/shift/maxHeight + keyboard/safe area)

### Цель

Усилить фундамент для всех overlay‑паттернов (Dropdown/Select/Tooltip/Popover/Menu), вынеся позиционирование anchor‑оверлеев в `headless_foundation` как стабильный механизм.

Ключевые требования (см. `docs/V1_DECISIONS.md` → Overlay SLA v1):

- overlay остаётся привязан к anchor
- есть collision pipeline (flip → shift)
- maxHeight учитывает viewport + safe area + keyboard
- решения должны быть переиспользуемыми (не “математика внутри одного виджета”)

### Почему это критично для фундамента

Позиционирование — cross-cutting механизм. Если логика живёт локально в конкретном компоненте или прямо в `AnchoredOverlayEngineHost`,
то при росте системы получаем:

- дрейф поведения (dropdown ведёт себя не как tooltip),
- невозможность стабильно чинить “клавиатура перекрыла меню” в одном месте,
- трудно тестировать (нет чистой функции/калькулятора).

### Решение (Clean Architecture / SOLID)

#### 1) Выносим расчёт в чистый калькулятор (policy)

Добавлен модуль:

- `packages/headless_foundation/lib/src/overlay/positioning/anchored_overlay_layout.dart`

Внутри:

- `AnchoredOverlayLayoutCalculator` — **pure** вычисляет:
  - placement: below/above (**flip**)
  - горизонтальный **shift** чтобы не вылезать за viewport
  - `maxHeight` по доступному вертикальному пространству
- `computeOverlayViewportRect(MediaQueryData)` — нормализует viewport c учётом:
  - safe area (`padding`)
  - keyboard (`viewInsets.bottom`)
  - edge padding (по умолчанию 8)

Это соответствует SRP/DIP:

- калькулятор не знает про overlay entries/рендереры,
- `AnchoredOverlayEngineHost` зависит от абстракции “layout result”, а не от деталей вычисления.

#### 2) AnchoredOverlayEngineHost применяет результат (widget glue)

Файлы:

- `packages/headless_foundation/lib/src/overlay/overlay_content.dart`
- `packages/headless_foundation/lib/src/overlay/positioning/anchored_overlay_position_delegate.dart`

“Widget glue” реализован так:

- берём **актуальный** `anchorRect` через `anchorRectGetter` (если есть)
- вычисляем `viewportRect` через `computeOverlayViewportRect(MediaQueryData)` (safe area + keyboard + edge padding)
- применяем результат collision pipeline (flip → shift + maxHeight) **через layout delegate**:
  - `CustomSingleChildLayout` + `AnchoredOverlayPositionDelegate`
  - ширина фиксируется на `anchorSize.width` (или fallback), затем clamped в пределах viewport
  - `maxHeight` вычисляется по доступному месту above/below

Почему не `CompositedTransformFollower`:

- follower корректен для простого “следования” за anchor, но в widget tests часто даёт несовпадение между визуальной позицией и hit-testing (клики/drag уходят в barrier)
- delegate-based позиционирование даёт **детерминированный layout** и одинаковое поведение в runtime и тестах

#### 3) Тесты (proof)

Добавлен unit test:

- `packages/headless_foundation/test/anchored_overlay_layout_test.dart`

Покрывает:

- placement stays below
- flips above
- horizontal shift
- viewportRect учитывает keyboard

### Артефакты/изменения

- ✅ `packages/headless_foundation/lib/src/overlay/positioning/anchored_overlay_layout.dart`
- ✅ `packages/headless_foundation/lib/src/overlay/positioning/anchored_overlay_position_delegate.dart`
- ✅ `packages/headless_foundation/lib/src/overlay/overlay_content.dart` (использует delegate-based anchored positioning)
- ✅ `packages/headless_foundation/test/anchored_overlay_layout_test.dart`
- ✅ `packages/headless_foundation/lib/headless_foundation.dart` (export positioning module)
- ✅ `docs/ARCHITECTURE.md` (зафиксировано как “Overlay positioning” фундаментальный механизм)

### Проверки

Команды:

```bash
melos run analyze
melos run test
```

Ожидаемое: всё зелёное (возможны info‑warnings от существующих deprecated/лишних library names — это отдельный долг).

### Follow-ups (следующие фундаментальные шаги)

1) Listbox foundation (registry + navigation + typeahead) — второй “обязательный” механизм после overlay.
2) Reposition policy “не чаще 1/frame” + триггеры reposition (scroll/resize/keyboard) как единый механизм.
3) Conformance tests на инварианты overlay (flip/shift/maxHeight, focus restore, dismiss stack).

