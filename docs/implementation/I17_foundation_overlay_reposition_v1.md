## I17 — Foundation v1: Overlay Reposition Policy (≤ 1/frame) + triggers (scroll/resize/keyboard)

### Цель

Сделать overlay‑позиционирование “уровня библиотеки”, чтобы anchored overlays (Dropdown/Tooltip/Popover/Menu):

- корректно пересчитывали flip/shift/maxHeight при изменениях окружения,
- не создавали performance‑проблем (reposition ≤ 1 раза на frame),
- не требовали от каждого компонента “костылей” вокруг scroll/keyboard.

Основание: `docs/V1_DECISIONS.md` → “Overlay SLA v1 (positioning/updates/stacking)”.

### Проблема

Anchored overlays должны “следовать” за anchor и при этом корректно пересчитывать flip/shift/maxHeight, но:

- flip decision (above/below) и `maxHeight` зависят от текущего `anchorRect` и viewport,
- viewport меняется при клавиатуре (`viewInsets.bottom`) и safe area,
- scroll/resize/metrics должны вызывать пересчёт,
- частые события scroll нельзя превращать в “measure→setState tight loop”.

### Решение (SRP/DIP)

#### 1) Anchor rect как источник истины (не “снимок при open”)

Добавляем в overlay entry возможность получать **актуальный** `anchorRect`:

- `Rect Function()? anchorRectGetter`

Если getter есть — он имеет приоритет над старым `anchorGlobalPosition + anchorSize` (legacy).

#### 2) Reposition scheduler (≤ 1/frame)

В `OverlayController` добавляется:

- `requestReposition()`

Семантика:

- можно вызывать хоть на каждый scroll event,
- фактический `notifyListeners()` произойдёт **не чаще 1 раза на frame** (коалесинг через post-frame callback),
- никакого “measure→notify→measure” цикла.

#### 3) Triggers (v1 минимум)

Reposition запрашивается при:

- `ScrollNotification` (nested scroll containers)
- `WidgetsBindingObserver.didChangeMetrics` (resize/orientation/keyboard)

Компоненты не должны вручную дергать reposition для базовых случаев.

### Артефакты

- `packages/headless_foundation/lib/src/overlay/overlay_controller.dart`:
  - `requestReposition()` + coalescing
  - `show(..., anchorRectGetter: ...)`
- `packages/headless_foundation/lib/src/overlay/overlay_entry_data.dart`:
  - поле `anchorRectGetter`
- `packages/headless_foundation/lib/src/overlay/overlay_host.dart`:
  - scroll/metrics triggers
  - anchored layout использует текущий anchor rect
- `packages/headless_foundation/lib/src/overlay/overlay_content.dart`:
  - anchored positioning применяет текущий `anchorRect` и `viewportRect` через layout delegate
- tests:
  - `requestReposition` coalescing (≤1/frame)
  - anchor rect getter precedence (smoke)

### Проверки

```bash
melos run analyze
melos run test
```

