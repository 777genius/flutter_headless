## I18 — Foundation v1.1: Overlay update triggers (scroll/metrics + optional tickers) + conformance tests (Overlay SLA)

### Цель

Довести overlay‑позиционирование до уровня “не ломается в проде” для anchored overlays (Dropdown/Tooltip/Popover/Menu):

- **Update triggers**:
  - scroll (nested scroll containers)
  - metrics (resize/orientation/keyboard)
  - **optional ticker** (для кейсов, когда anchor движется из-за анимации/перестроения layout без ScrollNotification)
- **Reposition policy**: не чаще **1 раза на frame** (коалесинг обязателен)
- **Conformance tests**: автоматические тесты на Overlay SLA (минимум)

Основание: `docs/V1_DECISIONS.md` → “Overlay SLA v1 (positioning/updates/stacking)”.

### Почему нужен optional ticker

Даже с `ScrollNotification` и `didChangeMetrics`, остаются продовые кейсы:

- anchor перемещается из-за implicit animations/layout transitions (без scroll),
- меняется size/position “внутри” без metrics,
- overlay должен обновить **flip/maxHeight/shift** — поэтому нужен гарантированный trigger на пересчёт layout.

Ticker — опциональная страховка. Включается осознанно, потому что может давать лишние кадры.

### Решение (SRP/DIP)

#### 1) API: `OverlayController.requestReposition({bool ensureFrame = true})`

- **ensureFrame=true** (default): для scroll/metrics — гарантируем кадр.
- **ensureFrame=false**: для ticker — кадры уже идут, лишний `scheduleFrame()` не нужен.

Семантика неизменна: коалесинг до ≤ 1 notify per frame.

#### 2) Optional ticker в `AnchoredOverlayEngineHost`

Добавляем параметр:

- `AnchoredOverlayEngineHost(enableAutoRepositionTicker: bool)` (default false)

Поведение:

- когда overlays активны — запускаем ticker
- на каждом tick: `controller.requestReposition(ensureFrame: false)`
- когда overlays нет — ticker останавливаем

#### 3) Conformance tests (Overlay SLA)

В `headless_foundation/test` добавляем widget tests:

- **SLA-T1 (scroll → flip update)**:
  - anchored overlay открывается
  - scroll двигает anchor
  - overlay пересчитывает placement (flip) на следующем кадре
- **SLA-T2 (metrics/keyboard → maxHeight update)**:
  - меняем `viewInsets.bottom`
  - overlay пересчитывает viewportRect → maxHeight
  - overlay height уменьшается (content constrained)
- **SLA-T3 (ticker → updates without scroll/metrics)**:
  - anchor двигается через animation (без scroll notifications)
  - при включённом ticker overlay пересчитывает placement/constraints

### Артефакты

- `packages/headless_foundation/lib/src/overlay/overlay_controller.dart`
- `packages/headless_foundation/lib/src/overlay/overlay_host.dart`
- tests: `packages/headless_foundation/test/overlay_sla_conformance_test.dart`

### Команды

```bash
melos run analyze
melos run test
```

