## I26 — Anchored Overlay Engine v1.3: отдельный пакет `anchored_overlay_engine` (part 1) (part 2)

Back: [Index](./I26_overlay_engine_portal_v1_3_part_01.md)

## I26 — Anchored Overlay Engine v1.3: отдельный пакет `anchored_overlay_engine`

### Цель (переформулировка)

Сделать overlay‑движок “уровня библиотеки”, который:
- **можно вынести в отдельный publishable пакет** (без привязки к “headless” в имени/маркетинге),
- использует **Flutter primitives для insertion** (чтобы не поддерживать самописный stacking/hit-test слой),
- сохраняет наши обязательные инварианты:
  - phase model (`opening/open/closing/closed`)
  - close contract (`completeClose` обязателен + fail-safe)
  - dismiss/focus policies как конфигурируемые политики
  - reposition policy (≤ 1 раза на frame) + triggers
  - anchored positioning (flip/shift/maxHeight + keyboard/safe area)

Ключевое уточнение: мы **не обещаем “без велосипеда” вообще**. Мы обещаем:  
**велосипед только там, где Flutter не даёт готового решения (policies/контракт)**,  
а insertion делаем стандартным способом.

---

### Naming / Publishing (важно)

#### Выбрано имя пакета

Название: **`anchored_overlay_engine`**.

Причины:
- описывает главный value: anchored overlays + positioning/policies,
- не привязано к Material/Cupertino,
- не завязано на “headless” терминологию,
- не фиксирует конкретный insertion backend (Portal/Entry можно менять).

#### Можно ли было назвать без `headless`?

Да. Более того, для внешней аудитории это обычно лучше: “headless” для многих звучит либо непонятно, либо “без UI”, а overlay‑engine — это UI‑механизм.

Дальше в документе используем финальное имя пакета и пути.

---

### Что берём у Flutter, чтобы не писать лишнее

#### Берём (engine-level, дизайн-нейтрально)

- **Insertion (v1.3 default)**: `OverlayPortal` (через backend интерфейс)
- **Optional insertion (vNext)**: `OverlayEntry` backend — только если появится реальный кейс
- **Overlay layer**: `Overlay` (локальный или root)
- **Barrier**: `ModalBarrier` (в widgets) для “tap outside / block underlying”
- **Фокус/клавиатура**: `FocusScope`, `Shortcuts/Actions`
- **Триггеры updates**: `WidgetsBindingObserver.didChangeMetrics`, `NotificationListener<ScrollNotification>`

Важно про “fallback”:
- **Version fallback** (поддержка старых Flutter) и **Behavior fallback** (переключить insertion механизм при баге) — это разные вещи.
- Если пакет содержит `OverlayPortal`-backend, то пакет должен зафиксировать минимальную версию Flutter, где `OverlayPortal` доступен.
  Иначе код не соберётся, и “fallback на Entry” не поможет.

#### Не берём (оставляем пресетам/компонентам)

- Material-only API (`MenuAnchor`, `showMenu`, `PopupMenuButton`)
- Route/Navigator как основу overlay (это другая модель lifecycle)

---

### Новый пакет: границы и зависимости (уточнение)

Пакет:
- `packages/anchored_overlay_engine/`

Зависимости:
- Разрешено: `flutter` (widgets/foundation/rendering), unit/widget tests.
- Запрещено: `material`, `cupertino`, любые headless_* пакеты.

Почему так:
- движок должен быть полезен сам по себе: popover/menu/tooltip для любого дизайна.

Минимальная версия Flutter (фиксируем):
- **Flutter ≥ 3.10** (в 3.10 уже присутствует `OverlayPortal` в release notes).

---

### Публичный API (сжать и сделать “publishable”)

Нужно “держать поверхность маленькой”. Для внешнего пакета это критично.

#### 1) Lifecycle

- `enum OverlayPhase { opening, open, closing, closed }`

Переходы:

```text
opening -> open -> closing -> closed
opening -> closing -> closed
```

#### 2) Handle

- `OverlayHandle`
  - `ValueListenable<OverlayPhase> phase`
  - `bool get isOpen`
  - `void close()`
  - `void completeClose()`

Инварианты:
- `close()` идемпотентен
- `completeClose()` идемпотентен
- `close()` не удаляет subtree немедленно

#### 3) Controller

- `OverlayController`
  - `OverlayHandle show(OverlayRequest request)`
  - `void requestReposition({bool ensureFrame = true})`

#### 4) Request (вместо “Presentation”)

Слишком абстрактное “presentation” легко расползается. Лучше “request”:

- `OverlayRequest`
  - `WidgetBuilder overlayBuilder` (строит только overlay content, без insertion)
  - `OverlayAnchor? anchor` (optional)
  - `OverlayBarrierPolicy barrier`
  - `OverlayDismissPolicy dismiss`
  - `OverlayFocusPolicy focus`
  - `OverlayRepositionPolicy reposition`
  - `OverlayStackPolicy stack` (минимум: LIFO; дальше можно расширять)

#### 5) Anchor (один источник истины)

Оставляем то, что уже доказало полезность:

- `OverlayAnchor`
  - `Rect Function() get rect` (обязательный, не nullable)

Это намеренно жёстко:
- engine не должен “угадывать” rect по `LayerLink` или global keys.
- компонент/пользователь сам решает, как получить rect (через GlobalKey/RenderBox/собственные helpers).

Дополнительно можно дать sugar (но это не must для v1.3):
- `OverlayAnchorTarget` widget, который даёт `OverlayAnchor` и держит нужные измерения.

---

### Структура пакета (чтобы было понятно “куда что положить”)

`packages/anchored_overlay_engine/lib/`:
- `anchored_overlay_engine.dart` (public exports)
- `src/`
  - `lifecycle/overlay_phase.dart`
  - `lifecycle/overlay_handle.dart`
  - `controller/overlay_controller.dart`
  - `host/anchored_overlay_engine_host.dart`
  - `insertion/overlay_insertion_backend.dart`
  - `insertion/overlay_portal_insertion_backend.dart`
  - `insertion/overlay_entry_insertion_backend.dart` (vNext, если потребуется)
  - `policies/overlay_dismiss_policy.dart`
  - `policies/overlay_focus_policy.dart`
  - `policies/overlay_barrier_policy.dart`
  - `policies/overlay_reposition_policy.dart`
  - `positioning/anchored_overlay_layout.dart` (pure calculator)
  - `positioning/anchored_overlay_position_delegate.dart` (layout glue)
  - `model/overlay_request.dart`
  - `model/overlay_anchor.dart`

Правило: всё, что не нужно пользователю напрямую — остаётся в `src/` и не экспортируется.

---

### Insertion: backends (Portal / Entry) — фиксируем архитектуру

#### Зачем вообще backend, если можно “просто OverlayEntry”?

Потому что insertion — это деталь реализации. Пакет хочет быть:
- переносимым между проектами,
- устойчивым к эволюции Flutter primitives,
- без ломающих изменений для пользователей пакета.

Поэтому фиксируем минимальную абстракцию:

- `OverlayInsertionBackend`:
  - отвечает только за “куда и как вставлять overlay subtree” (Portal или Entry),
  - не знает про positioning/policies/phase.

Дефолт backend для v1.3:
- **Portal backend**, если целевая версия Flutter гарантирует `OverlayPortal`.

Entry backend:
- не входит в обязательный объём v1.3
- добавляем только при наличии конкретного кейса, где Portal insertion хуже/нестабилен

#### Зачем `Overlay` в host’е, если есть Portal backend?

Потому что и Portal, и Entry вставляются в **Overlay layer**.

`OverlayPortal` сам overlay слой не создаёт: он вставляет child в ближайший `Overlay` выше.

Поэтому у host’а есть два режима overlay layer:

- **Local overlay (default)**: host сам создаёт `Overlay` рядом с app subtree.
  - **Плюсы**: не зависит от `Navigator`, предсказуемо в тестах, композиционно (overlay “там, где host”).
  - **Минусы**: ещё один `Overlay` в дереве.

- **Use root overlay (optional)**: host не создаёт `Overlay`, а требует существующий `Overlay` выше (обычно от `Navigator`).
  - **Плюсы**: один overlay layer в приложении.
  - **Минусы**: зависимость от окружения.

#### `AnchoredOverlayEngineHost` (host пакета)

Ответственность:
- создать локальный `Overlay` (если `useRootOverlay == false`),
- предоставить `OverlayController` вниз по дереву,
- слушать triggers и дергать `requestReposition()`,
- рендерить активные overlays через выбранный `OverlayInsertionBackend`.

Важно: host — это часть дерева и остаётся “композиционным якорем”, как у вас сейчас.
Меняем не “где host”, а “как insertion делается”.

API host’а в v1.3:
- `AnchoredOverlayEngineHost({required Widget child, bool useRootOverlay = false, OverlayInsertionBackend? insertionBackend, ...})`

#### Overlay lifecycle (phase) и insertion

- `opening/open`: inserted
- `closing`: остаётся inserted до `completeClose` (exit animation живёт внутри overlay content)
- `closed`: removed

`fail-safe`:
- если `closing` завис, host/engine закрывает по таймауту и даёт диагностику.

---

### Позиционирование (фиксируем без двусмысленностей)

В v1.3:
- **дефолт: детерминированное positioning через calculator + layout delegate** (как в I15).
- `CompositedTransformFollower` **не является основой** (может быть позже как opt-in, но не в v1.3).

Причина: engine должен быть максимально предсказуемым и тестируемым.

---
