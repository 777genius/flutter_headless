## Monorepo архитектура (feature-first + DDD + SOLID) (part 1) (part 5)

Back: [Index](./ARCHITECTURE_part_01.md)


---

### i18n policy (v1)

- Core предоставляет **контракт** (`RenderlessStrings`/`RenderlessI18n`) и scope для переопределения строк.
- Дефолты по возможности берём из `MaterialLocalizations` / `CupertinoLocalizations`.
- Это **не** про “Material дизайн в core”: используем только строки, а визуальные дефолты остаются вне core.
- Переводы “30+ языков” не кладём в core (при необходимости — отдельным пакетом позже).

---

### Parts policy (v1)

- Точки расширения рендера — только **typed** (renderer contracts + slots `Replace/Decorate`).
- Не используем string-based part identifiers (аналог `data-part`), чтобы сохранить type-safety и избежать “тихо не сработало”.

#### 4) “Перехват переходов” (аналог `stateReducer`) — для продуктовых исключений

Для компонентов, где продукт неизбежно попросит особые правила:

- даём опциональный hook: “вот текущий state + proposed next state + event → верни итоговый next state”
- это позволяет кастомизировать поведение **без форка** и без хака внутренних полей

#### 5) Что НЕ делаем (важно)

- Не требуем пользователю `get_it`/`injectable`/`modularity_dart`/любой DI как обязательную часть.
- Не вводим глобальный store внутри дизайн‑системы.
- Не заставляем все компоненты жить на одном “общем” state manager.

#### 6) Где живёт состояние в архитектуре пакетов

- **Тема (`ThemeScope`)**: состояние темы решается на уровне приложения (любой стейтменеджер), библиотека предоставляет только scope/контракты.
- **Состояния интеракций** (hover/pressed/focus) и нормализация — общие механизмы в `headless_foundation`.
- **Доменное состояние компонента** (например, выбранное значение селекта) — controller/value в компонентном пакете.

---

### Важные нюансы (must-have для “уровня библиотеки”)

#### Ownership и lifecycle controller (кто dispose?)

- **Правило 1**: если controller передан снаружи — **мы его не диспоузим**.
- **Правило 2**: если controller не передан — компонент может создать внутренний controller и **обязан его диспоузить** при dispose.
- **Правило 3**: если внешний controller меняется между билдами — компонент корректно “переподписывается” (без утечек и без двойных listeners).

Это базовый POLA‑контракт: пользователь ожидает поведение как у `TextField`/`ScrollController`.

#### Приоритет controlled/uncontrolled (чтобы не было сюрпризов)

- Если передан `value/state` или `controller` — компонент работает в **controlled режиме**.
- В controlled режиме внутреннее состояние допускается только как **производное** (например, computed state), но не как источник истины.
- Компонент **не должен** самовольно менять `value` без явного callback (`onChanged`) или без события/контракта.

#### Защита от sync-циклов и “дрожания” UI

При синхронизации внешнего состояния и внутренних событий легко получить цикл:
`onChanged → родитель сетит value → компонент снова триггерит onChanged`.

- Важно иметь **стабильное сравнение** (equality) для state/value и не эмитить события, если “ничего не изменилось”.
- Любая “нормализация” (например, clamp, dedupe) должна быть **детерминированной** и отражаться в API предсказуемо.

#### Где нельзя хранить состояние (DDD дисциплина)

- `domain/` внутри компонента — это спецификации/контракты/инварианты.
  **Никаких** контроллеров, подписок, `ValueListenable`, overlay/focus логики.
- Реактивность и жизненный цикл — это `presentation/`, `headless_foundation/` и `anchored_overlay_engine/`.

**Запрещённые Flutter типы в domain/application слоях:**

| Категория | Запрещённые типы | Альтернатива |
|-----------|------------------|--------------|
| **Widgets** | `Widget`, `State`, `BuildContext`, `Element` | — (только в presentation/) |
| **Rendering** | `Color`, `TextStyle`, `BoxDecoration` | Semantic tokens |
| **Events** | `PointerEvent`, `KeyEvent`, `TapDetails` | Abstract domain events |
| **Focus** | `FocusNode`, `FocusScopeNode` | Effects в foundation |
| **Animation** | `AnimationController`, `Ticker` | `AnimationPolicy` контракт |
| **Overlay** | `OverlayEntry`, `OverlayState` | `OverlayController` в anchored_overlay_engine |
| **Gestures** | `GestureDetector`, `Listener` | `InteractionController` в foundation |

**CI проверка (локально):**
```bash
# Domain и Application файлы НЕ импортят package:flutter/*
grep -r "package:flutter" packages/*/lib/src/domain/
grep -r "package:flutter" packages/*/lib/src/application/
# Должны вернуть пустой результат
```

**CI Pipeline Integration (GitHub Actions):**

Добавить в `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  architecture-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Check domain layer purity
        run: |
          echo "Checking domain layer for Flutter imports..."
          if grep -r "package:flutter" packages/*/lib/src/domain/ 2>/dev/null; then
            echo "::error::Flutter imports found in domain layer!"
            echo "Domain layer must not depend on Flutter types."
            echo "Use semantic tokens, abstract events, and foundation mechanisms."
            exit 1
          fi
          echo "✓ Domain layer is clean"

      - name: Check application layer purity
        run: |
          echo "Checking application layer for Flutter widget imports..."
          if grep -r "package:flutter/widgets" packages/*/lib/src/application/ 2>/dev/null; then
            echo "::error::Widget imports found in application layer!"
            exit 1
          fi
          if grep -r "package:flutter/material" packages/*/lib/src/application/ 2>/dev/null; then
            echo "::error::Material imports found in application layer!"
            exit 1
          fi
          echo "✓ Application layer is clean"

      - name: Check DAG (no circular dependencies)
        run: |
          echo "Checking for circular dependencies..."
          # Используем dart pub deps для проверки
          cd packages/headless_foundation && dart pub deps --no-dev 2>&1 | grep -i circular && exit 1 || true
          cd ../headless_contracts && dart pub deps --no-dev 2>&1 | grep -i circular && exit 1 || true
          cd ../headless_theme && dart pub deps --no-dev 2>&1 | grep -i circular && exit 1 || true
          echo "✓ No circular dependencies"

  # ... остальные jobs (lint, test, build)
```

**Инварианты CI:**
- PR не мержится если domain layer содержит Flutter imports
- PR не мержится если есть циклические зависимости
- Автоматическая проверка на каждый push/PR

**Pre-commit hook (опционально):**
```bash
#!/bin/bash
# .git/hooks/pre-commit

if grep -r "package:flutter" packages/*/lib/src/domain/ 2>/dev/null; then
  echo "ERROR: Flutter imports in domain layer"
  echo "Domain layer must be pure Dart."
  exit 1
fi
```

Подробнее о Domain Layer: см. `V1_DECISIONS.md` → "Domain Layer Invariants"

#### Bounded Contexts (DDD)

| Context | Entities | Domain Events | Value Objects | Invariants |
|---------|----------|---------------|---------------|------------|
| **Button** | `ButtonState` | `Pressed`, `Released` | `ButtonSpec`, `ButtonVariant`, `ButtonSize` | Button cannot be both pressed and disabled |
| **Menu/Listbox** | `MenuState`, `ListboxState` | `MenuOpened`, `ItemHighlighted`, `ItemSelected`, `MenuClosed` | `ListboxItemMeta` (id, label, disabled) | Only one item can be highlighted at a time |
| **Overlay** | `OverlayEntry` | `OverlayOpened`, `OverlayClosing`, `OverlayClosed` | `OverlayAnchor`, `FocusPolicy`, `DismissPolicy` | Overlay must complete close within timeout |
| **Interaction** | `InteractionController` | `PressStart`, `PressEnd`, `PressCancel`, `HoverEnter`, `HoverExit` | `PointerType`, `WidgetStateSet` | Pointer type determines feedback behavior |
| **Dialog** | `DialogState` | `DialogOpened`, `DialogClosing`, `DialogDismissed` | `DialogSpec`, `DialogRole` | Modal dialogs trap focus until closed |

**Правила контекстов:**
- Каждый контекст владеет своими entities и events
- Коммуникация между контекстами — через effects или shared foundation
- Не допускаются циклические зависимости между контекстами

#### Ubiquitous Language (глоссарий терминов)

| Термин | Определение | Где используется |
|--------|-------------|------------------|
| **highlighted** | Визуально подсвечен при навигации (клавиатура) | Menu, Listbox, Select |
| **selected** | Выбранное значение (controlled state) | Select, Listbox, RadioGroup |
| **pressed** | Нажат (pointer down, Space/Enter) | Button, MenuItem, всё интерактивное |
| **focused** | Имеет keyboard focus | Все focusable элементы |
| **hovered** | Курсор над элементом | Button, MenuItem, Link |
| **disabled** | Неактивен, не реагирует на input | Все интерактивные элементы |
| **closing** | Exit-анимация идёт | Overlay, Dialog, Menu |
| **opening** | Enter-анимация идёт | Overlay, Dialog, Menu |
| **spec** | Value object с параметрами компонента | Все компоненты |
| **renderer** | Отвечает за visual output | Theme layer |
| **capability** | Набор возможностей для группы компонентов | Theme layer |
| **effect** | Side effect от reducer (focus, overlay, announce) | Foundation, Components |
| **slot** | Точка расширения структуры компонента | Dialog, Dropdown, Select |
| **anchor** | Референс для позиционирования overlay | Overlay, Dropdown, Tooltip |

**Инвариант:** `highlighted` ≠ `selected`. Highlight — временное визуальное состояние при навигации, selection — выбранное значение.

#### StateReducer (перехват переходов) — правила безопасности

- Hook не должен позволять “сломать инварианты” компонента (например, вернуть невозможное состояние).
- Компонент должен корректно обрабатывать “странные” редьюсы: не падать, не уходить в бесконечные переходы.
- Документируем, какие события редьюсер может менять и какие поля state считаются “owned by component” (если такие есть).

#### Производительность (важно для headless)

- Минимизируем количество rebuild: подписки и listeners должны быть точечными.
- Не раздуваем state: храним только то, что нужно для поведения/а11y, остальное — в renderer/style resolve.

---

### Policy: context splitting (чтобы избежать “re-render storms”)

Проблема из экосистемы (compound components/context): когда value пересоздаётся на каждый build, все потребители перерисовываются, и perf деградирует.

**Правило для Headless:**
- В `Scope`/контекстах **не передаём** “большие” value-объекты, которые пересоздаются каждый build.
- Предпочитаем:
  - `ValueListenable`/`Listenable` + точечные `ValueListenableBuilder`
  - `InheritedNotifier` (или аналогичный паттерн), чтобы обновлялись только подписчики на конкретный notifier
- Для overlay/listbox важно разделять:
  - “open/close state”
  - “highlight/selection state”
  - “positioning state”
  чтобы не заставлять весь subtree ребилдиться на каждое движение highlight/scroll.


