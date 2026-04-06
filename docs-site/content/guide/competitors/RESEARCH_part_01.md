## Исследование конкурентов и подходов (part 1)

Back: [Index](./RESEARCH.md)

# Исследование конкурентов и подходов

## Как мы используем ресёрч (важно)

Ресёрч — это **не инструкция “делаем как у них”**. Это сырьё для решений.

### Статусы для каждого наблюдения

- **Adopt (берём)**: это совместимо с нашей архитектурой и реально снижает риски/стоимость поддержки.
- **Reject (не делаем)**: это добавляет “магию”, ломает POLA, тащит лишнюю сложность или плохо ложится на Flutter.
- **Open (вопрос)**: пока не ясно; нужна проверка/прототип/обсуждение.

### Критерии “Adopt”

Мы считаем идею достойной переноса в архитектуру только если:
- это улучшает **инварианты** (overlay/focus/keyboard/a11y/perf) или снижает cost of change,
- это укладывается в **E1 (events + pure reducer + effects)** и наши границы пакетов (DAG),
- это не превращает API в “мешок флагов” и не создаёт скрытых сайд‑эффектов.

### Где фиксируем итог

- **Только факты ресёрча** → остаются в `docs/RESEARCH.md`
- **Принятое решение v1** → попадает в `docs/V1_DECISIONS.md` (и при необходимости в `docs/ARCHITECTURE.md`/`docs/MUST.md`)
- **“Так делать нельзя”** → фиксируем явно как anti-pattern/guardrail (обычно в `docs/V1_DECISIONS.md` и/или PR checklist в `docs/ARCHITECTURE.md`)

### Decision Log (ресёрч → решение) с оценкой 1–10

Оценка 1–10 = **ROI / важность**.  
Для **Reject** это “насколько важно запретить/не делать”.

| Category | Тема | Статус | Оценка | Почему | Где зафиксировано |
|---|---|---:|---:|---|---|
| Guardrails | `as/asChild` / cloneElement-style мердж | Reject | 10 | скрытая магия, ломает типобезопасность и инварианты | `docs/V1_DECISIONS.md` (guardrails) |
| Guardrails | Boolean explosion (`isX` флаги вместо state/events) | Reject | 9 | неконтролируемые комбинации, POLA ломается | `docs/V1_DECISIONS.md` (E1/guardrails) |
| Guardrails | Material defaults в core | Reject | 8 | platform mismatch, ломает multi-brand | `docs/V1_DECISIONS.md` (guardrails) |
| Guardrails | “A11y потом” | Reject | 10 | самый дорогой класс багов/репутации | `docs/V1_DECISIONS.md`, `docs/MUST.md` |
| Guardrails | Overlay positioning как “простая задача” | Reject | 9 | без foundation слоя будет зоопарк костылей | `docs/V1_DECISIONS.md` (overlay SLA) |
| Guardrails | “Миграции потом” | Reject | 9 | пользователи бросают библиотеку после одного большого breaking | `docs/ARCHITECTURE.md` (SemVer/deprecation) |
| Guardrails | Shared components с business/domain logic | Reject | 8 | растёт coupling, ломает масштабирование и владение | `docs/ARCHITECTURE.md` |

| Architecture | Lockstep SemVer | Adopt | 9 | один релиз = одна совместимая версия всей системы | `docs/ARCHITECTURE.md`, `docs/V1_DECISIONS.md` |
| Architecture | DAG (без циклов) + запрет component→component | Adopt | 9.5 | предотвращает “спагетти зависимостей” | `docs/ARCHITECTURE.md` |
| Architecture | D2a (public foundation primitives) | Adopt | 9 | power users без раздувания per-component engine API | `docs/V1_DECISIONS.md` |
| Architecture | E1 (events + pure reducer + effects) | Adopt | 9.5 | тестируемость, предсказуемость, путь к D2b без ломаний | `docs/V1_DECISIONS.md` |
| Architecture | Минималистичные FSM как дисциплина (не Zag 1:1) | Adopt | 8.5 | “невозможные состояния невозможны”, но без магии | `docs/V1_DECISIONS.md` |
| Architecture | “State-management agnostic” (не навязываем Riverpod/BLoC/…) | Adopt | 8 | библиотека должна жить в любых приложениях | `docs/ARCHITECTURE.md`, `docs/WHY_HEADLESS.md` |
| Architecture | Не навязывать DI (get_it/modularity/…) | Adopt | 8 | меньше vendor lock-in, меньше косвенных зависимостей | `docs/ARCHITECTURE.md` |

| Overlay | Overlay close/closing + completeClose (A1) | Adopt | 9 | exit-анимации + корректный lifecycle | `docs/V1_DECISIONS.md` |
| Overlay | Overlay phase as `ValueListenable` (opening/open/closing/closed) | Adopt | 9 | enter/exit без костылей, Flutter-native | `docs/V1_DECISIONS.md`, `docs/ARCHITECTURE.md` |
| Overlay | Animations as first-class (enter/exit) | Adopt | 9 | иначе потом будет “ломаем API ради анимаций” | `docs/V1_DECISIONS.md`, `docs/MUST.md` |
| Overlay | Floating UI middleware pipeline (offset/flip/shift/…) | Adopt | 8.5 | устойчивое positioning + 1/frame coalesce | `docs/MUST.md`, `docs/RESEARCH.md` |

| A11y | Focus trap/restore (полная реализация) | Adopt | 9 | критично для Dialog/Menu/Select | `docs/V1_DECISIONS.md` |
| A11y | WCAG 2.2 baseline (Target Size 24×24, Focus Not Obscured) | Adopt | 8.5 | комплаенс/качество по умолчанию | `docs/V1_DECISIONS.md`, `docs/MUST.md` |
| A11y | a11y test helpers + manual layer | Adopt | 8.5 | automation ловит ~30–50% | `docs/V1_DECISIONS.md`, `docs/ARCHITECTURE.md` |

| Interactions | Unified press events (usePress идея) | Adopt | 8.5 | единая политика pressed/cancel/keyboard/screenReader | `docs/V1_DECISIONS.md`, `docs/MUST.md` |
| Performance | Context splitting (avoid re-render storms) | Adopt | 8 | perf гигиена для compound компонентов | `docs/MUST.md`, `docs/ARCHITECTURE.md` |
| Performance | Запрет tight loops measure→setState→measure | Adopt | 8.5 | защищает от jank на больших деревьях | `docs/V1_DECISIONS.md` |

| Tokens | W3C Design Tokens import + `$extends` | Adopt | 9 | multi-brand без копипасты + стандартный формат | `docs/V1_DECISIONS.md`, `docs/RESEARCH.md` |
| Tokens | Semantic tokens v1 (hybrid) | Adopt | 9.5 | стабильный global слой + component tokens | `docs/V1_DECISIONS.md` |
| Tokens | Display P3 / OKLCH как входные данные | Adopt | 9 | принимаем на вход, но конвертим в sRGB на импорте (v1 без сюрпризов) | `docs/V1_DECISIONS.md` |

| AI | AI/MCP metadata (`LLM.txt`) | Adopt | 8.5 | повышает консистентность AI/codegen | `docs/V1_DECISIONS.md`, `docs/ARCHITECTURE.md` |
| Governance | Ownership + PR checklist как обязательное правило | Adopt | 8 | качество важнее скорости PR | `docs/ARCHITECTURE.md`, `docs/RESEARCH.md` |
| Tools | theme_tailor / ThemeExtension codegen | Open | 6 | полезно приложению, но не должно быть обязательной зависимостью core | `docs/RESEARCH.md` |
| Tools | Tokens import tooling (design_tokens_builder/figma2flutter) | Reject | 6.5 | генерят ThemeData/виджеты, конфликтует с headless/renderer contracts | `docs/RESEARCH.md` |
| Flutter native | WidgetState как единый enum состояний | Adopt | 8 | Flutter-native, меньше изобретений, совместимо со state resolution | `docs/RESEARCH.md`, `docs/ARCHITECTURE.md` |
| Patterns | Builder `state.when` как основной API | Reject | 7 | часто провоцирует rebuild’ы и расползание поведения в UI; лучше E1 + renderer contracts | `docs/RESEARCH.md` |
| Patterns | Method chaining (styled_widget) как стиль API | Reject | 6 | DSL/extension‑API раздувает surface area и усложняет поддержку | `docs/RESEARCH.md` |
| Patterns | White-label Provider pattern | Adopt | 7.5 | соответствует multi-brand: theme через scope/provider в app, без форков | `docs/ARCHITECTURE.md`, `docs/WHY_HEADLESS.md` |
| Tools | CLI генерация тем/каркасов renderer’ов | Adopt | 8.5 | только skeleton (без UI логики), ускоряет старт без вреда | `docs/V1_DECISIONS.md` |

### Resolved design decisions (ранее Open вопросы)

Эти вопросы были решены и зафиксированы в `docs/V1_DECISIONS.md`.

| Вопрос | Решение | Дата |
|--------|---------|------|
| **Display P3 / OKLCH** | v1 принимает на вход, конвертирует в sRGB на импорте (CLI) | 2025-01 |
| **Figma MCP интеграция** | v1 НЕ делает прямую интеграцию; MCP-friendly через `LLM.txt` + W3C tokens | 2025-01 |
| **CLI генерация тем/renderer'ов** | Только skeleton generator (без UI логики) | 2025-01 |

Подробности решений: см. соответствующие разделы в `docs/V1_DECISIONS.md`.

## Headless библиотеки

### naked_ui (leoafarias) — 7.5/10
**Версия:** 0.2.0-beta.7

```dart
NakedButton(
  builder: (context, state, child) {
    final color = state.when(
      pressed: Colors.blue.shade900,
      hovered: Colors.blue.shade700,
      orElse: Colors.blue,
    );
    return Container(color: color, child: child);
  },
)
```

**Плюсы:**
- 100% headless
- Builder pattern
- state.when() для состояний
- 12 компонентов

**Минусы:**
- Нет вариантов (primary/danger)
- Нет тем
- Нет токенов
- Не exhaustive

---

### Mix + Remix (leoafarias) — 6.3/10
**Версия:** Mix 1.7.0 (2.0.0-rc.0), Remix 0.1.0-beta.2

```dart
final style = Style(
  $box.height(48),
  $box.color.ref($primary),
  $on.disabled($box.color(Colors.grey)),
);

PressableBox(
  style: style,
  child: StyledText('Click'),
)
```

**Плюсы:**
- Utility-first (как Tailwind)
- Варианты через Variant()
- Headless через Remix

**Минусы:**
- Свой DSL ($box, $on, $text)
- String токены = runtime
- Кривая обучения

---

### pixl_primitives — заброшен
**Версия:** 1.0.0 (19 месяцев назад, 7 загрузок)

Unstyled primitives, но проект мёртв.

---

## Готовые Design Systems

### Forui — 7.5/10
**Версия:** 0.17.0

```dart
FButton(
  style: (style) => style.copyWith(
    enabledStyle: style.enabledStyle.copyWith(
      backgroundColor: Colors.red,
    ),
  ),
  onPress: () {},
  child: Text('Click'),
)
```

**Плюсы:**
- 40+ виджетов
- CLI для генерации тем
- FWidgetStateMap для состояний
- Активная разработка

**Минусы:**
- НЕ headless — готовый визуал
- Нельзя полностью переопределить рендеринг

---

### shadcn_ui — 6.5/10
**Версия:** 0.43.0

```dart
ShadButton(
  child: Text('Click'),
  onPressed: () {},
)
```

**Плюсы:**
- Популярный shadcn дизайн
- 30+ компонентов
- Можно миксовать с Material

**Минусы:**
- НЕ headless
- Привязан к shadcn стилю

---

### shadcn_flutter — 6.0/10
**Версия:** 0.0.47

84+ компонентов, но тот же недостаток — не headless.

---

## Code Generation

### theme_tailor — 7.0/10
**Версия:** 3.1.2

```dart
@TailorMixin()
class MyTheme extends ThemeExtension<MyTheme> with _$MyThemeTailorMixin {
  const MyTheme({required this.primary});
  final Color primary;
}
// Генерирует: copyWith, lerp, ==, hashCode
```

**Плюсы:**
- Убирает boilerplate ThemeExtension
- JSON сериализация
- Nested themes

**Минусы:**
- Только токены, не виджеты

**Decision:** Open **6/10**  
Это может быть полезно для приложений, но **не должно становиться обязательной зависимостью core**. Мы остаёмся на своих токенах/контрактах; генераторы — только как optional tooling.

---

### design_tokens_builder (simpleclub)
Figma → Flutter ThemeData генерация.

### figma2flutter
Tokens Studio JSON → Flutter код.

**Decision:** Reject **6.5/10**  
Это про генерацию ThemeData/виджетов. Для Headless это обычно ведёт к “готовому визуалу” и ломает идею renderer contracts + строгих инвариантов.

---

## Нативные Flutter механизмы

### WidgetState (Flutter 3.22+)
```dart
enum WidgetState {
  hovered,
  focused,
  pressed,
  dragged,
  selected,
  disabled,
  error,
}
```

### WidgetStateProperty
```dart
WidgetStateProperty.resolveWith<Color?>((states) {
  if (states.contains(WidgetState.pressed)) return Colors.blue.shade900;
  if (states.contains(WidgetState.hovered)) return Colors.blue.shade700;
  return Colors.blue;
})
```

**Можно использовать** нативный WidgetState вместо своего!

**Decision:** Adopt **8/10**  
Используем Flutter-native `WidgetState` как базовый enum, а предсказуемость комбинаций/приоритетов решаем через наш `state_resolution` (не через ad-hoc if’ы).

---

