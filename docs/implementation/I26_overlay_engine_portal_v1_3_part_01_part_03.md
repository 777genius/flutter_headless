## I26 — Anchored Overlay Engine v1.3: отдельный пакет `anchored_overlay_engine` (part 1) (part 3)

Back: [Index](./I26_overlay_engine_portal_v1_3_part_01.md)


### Wheel/scroll UX (фиксируем железное правило)

- Engine/Host **никогда** не форвардит wheel события в “найденный Scrollable”.
- Если overlay‑контент не требует scroll — он **не должен быть ScrollView**.
- Если требует — scroll работает внутри overlay‑контента, как ожидает пользователь.

---

### План работ (улучшенный, без “может быть”)

#### Шаг 0 — выбрать имя пакета
- ✅ Выбрано: `anchored_overlay_engine`.

#### Шаг 1 — создать пакет + перенести contracts
- Создать `packages/anchored_overlay_engine/`
- Перенести туда:
  - phase/handle/controller
  - policies
  - reposition scheduler
  - fail-safe

#### Шаг 2 — реализовать `OverlayEngineHost` на OverlayPortal
Шаг разделяем, чтобы не смешивать ответственности:

- 2.1) Insertion backend API:
  - добавить `OverlayInsertionBackend`
  - реализовать `OverlayPortalInsertionBackend`
  - `OverlayEntryInsertionBackend` не делаем без реальной потребности

- 2.2) Host:
  - реализовать `AnchoredOverlayEngineHost`
  - default: local `Overlay`
  - `useRootOverlay: true` (не создаём Overlay, ожидаем существующий выше)
  - render: insertionBackend + barrier + positioning + focus/shortcuts

#### Шаг 3 — адаптировать `headless_foundation`
- `headless_foundation` перестаёт содержать overlay runtime
- остаётся либо re-export, либо thin wrapper (чтобы не делать массовый refactor импортов одномоментно)

#### Шаг 4 — тесты/конформанс
- Перенести overlay тест-матрицу из I03/I18:
  - lifecycle
  - idempotency
  - race close during opening
  - fail-safe
  - stacking LIFO
  - reposition ≤ 1/frame
  - triggers: scroll + metrics

Отдельно для `useRootOverlay`:
- если `useRootOverlay: true` и Overlay выше отсутствует — понятная ошибка/diagnostic (в debug/test).

---

### Риски и как их закрываем (чтобы не “сюрприз в проде”)

- **OverlayPortal availability / поведение на разных Flutter версиях**
  - в README пакета фиксируем минимальную версию Flutter (portal backend требует этого)
  - если нужно поддерживать старые Flutter, это отдельная стратегия (entry-only пакет или отдельная ветка), не “fallback в рантайме”

- **Два overlay слоя (local overlay)**
  - это норма для многих систем (локальные overlays для областей)
  - добавляем `useRootOverlay` для проектов, где принципиально один Overlay

- **Позиционирование и hit-test**
  - дефолт остаётся delegate-based positioning (как в текущей базе), потому что оно уже покрыто тестами и предсказуемо


---

### Non-goals (чётче)

- Не делаем full Floating UI middleware chain.
- Не добавляем стили/темы/рендеринг.
- Не пытаемся “унифицировать” overlay usage для всех компонентов одним виджетом; engine даёт contracts + host + policies.

---

### Позиционирование для pub.dev (кратко)

`anchored_overlay_engine` — это **engine**, а не “ещё один dropdown/tooltip”.  
Он решает системные задачи overlay‑слоёв:

- предсказуемый lifecycle (`opening/open/closing/closed`) + close‑контракт,
- стабильные policies (dismiss/focus/reposition),
- anchored positioning (flip/shift/maxHeight + safe area + keyboard),
- insertion через Flutter primitives (`OverlayPortal`), без зависимости от Material/Cupertino.

Если вы ищете готовые UI‑виджеты — это **не здесь**.  
Если вам нужен надёжный runtime для popover/menu/tooltip/dialog в собственном дизайне — это **сюда**.

---

### Критерии готовности (DoD)

- Новый пакет компилируется без material/cupertino и без headless_* deps.
- AnchoredOverlayEngineHost в headless работает через новый engine (OverlayHost — только compat wrapper), без wheel‑форвардинга.
- Все flutter tests зелёные через `melos run test:flutter`.

