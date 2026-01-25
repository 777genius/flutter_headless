## Conformance (Headless совместимость) — v1

Этот документ фиксирует **как именно** пакет заявляет, что он Headless‑совместим.

### Что считается “Headless‑совместимым”

Пакет считается совместимым только если:

- выполняет требования `docs/SPEC_V1.md`,
- соблюдает v1‑контракты из `docs/V1_DECISIONS.md` (в части, которую он использует),
- имеет минимальный набор тестов (см. ниже).

Если что-то из этого не выполняется — пакет **не** должен называться “Headless‑совместимым”.

---

## 1) Минимальный conformance-чеклист (MUST)


### 1.1 Структура и зависимости

- **MUST**: нет зависимости на другие компоненты (`packages/components/*`).
- **MUST**: `domain/` не импортит `package:flutter/*`.
- **MUST**: публичный API минимальный; нет протечки renderer реализации.

### 1.2 Headless separation

- **MUST**: `R*` отвечает за поведение/состояния/a11y, а визуал делегирован в renderer capability (`headless_contracts`).
- **MUST**: отсутствие renderer capability даёт понятную диагностическую ошибку.

### 1.2.1 Scoped capability overrides (SHOULD)

- **SHOULD** (для preset/theme packages): есть тест, что subtree‑override capability работает:
  - base theme предоставляет capability X;
  - subtree переопределяет X;
  - lookup внутри subtree возвращает override.

### 1.3 Controlled/uncontrolled и ownership

- **MUST**: controlled‑режим не перетирается внутренним состоянием.
- **MUST**: внешний controller не диспоузится компонентом; внутренний — диспоузится.

### 1.4 Overlay/Listbox/Effects (если применимо)

Если компонент использует overlay/menu‑паттерн:

- **MUST**: overlay через `headless_foundation`, без Navigator/Route.
- **MUST**: соблюдается lifecycle phase contract (`opening/open/closing/closed`) и `completeClose()` + fail-safe.
- **MUST**: close contract (renderer ↔ overlay host) формализован и тестируется:
  - **MUST**: переход в `closing` означает “закрытие начато”.
  - **MUST**: `callbacks.onCompleteClose()` вызывается **ровно один раз** для каждого “реального” закрытия.
  - **MUST**: если `closing` **отменён** (фаза вернулась в `open/opening` до завершения анимации) — `onCompleteClose()` **не** вызывается.
  - **MUST**: если виджет/renderer **disposal** произошёл во время `closing`, `onCompleteClose()` всё равно **MUST** быть вызван (fail-safe, чтобы overlay не “завис”).
- **MUST**: keyboard navigation и typeahead (если есть список) реализованы через foundation listbox primitives или эквивалентно их инвариантам.

### 1.5 AI metadata

- **MUST**: publishable package содержит `LLM.txt` (Purpose / Non-goals / Invariants / Correct usage / Anti-patterns).

---

## 2) Минимальный набор тестов (MUST)

Пакет должен иметь тесты, которые проверяют:

- **Semantics/a11y**: роли/лейблы/disabled для ключевых состояний.
- **Keyboard-only**: основные сценарии фокуса и активации (Space/Enter/Escape).
- **Controlled/uncontrolled**: корректное поведение при внешнем `value/controller`.
- **Overlay** (если есть): `close()` переводит в `closing`, а завершение происходит через `completeClose()`; fail-safe не позволяет “зависнуть”.

---

## 3) Как заявлять совместимость

- **SHOULD**: в README пакета явно указать, что пакет соответствует Spec v1, и дать ссылки на `docs/SPEC_V1.md` и `docs/CONFORMANCE.md`.
- **SHOULD**: описать, какие части v1 контрактов использует пакет (overlay/listbox/effects).

### 3.1 Рекомендуемая формулировка для README (копипаст)

```text
Совместимость: соответствует Headless Spec v1 (см. upstream docs/SPEC_V1.md), проходит conformance (см. upstream docs/CONFORMANCE.md).

Compatibility: Conforms to Headless Spec v1 (see upstream docs/SPEC_V1.md), passes conformance (see upstream docs/CONFORMANCE.md).
```

---

## 4) Формат “passes conformance” (проверяемый отчёт) — MUST

Если пакет заявляет “passes conformance”, он **MUST** предоставить в репозитории пакета текстовый отчёт, который можно проверить.

**Важно:** для community‑пакетов, которые живут в отдельных репозиториях, ссылки на Spec/Conformance должны указывать на upstream (этот репозиторий) и быть привязаны к конкретному релизу/тегу/коммиту.

### 4.1 Где хранить отчёт

- **MUST**: файл `CONFORMANCE_REPORT.md` в корне пакета **или** секция “Conformance Report” в README пакета.

### 4.2 Минимальное содержимое отчёта (MUST)

Отчёт **MUST** содержать:

- **Spec version**: `Headless Component Spec v1` (ссылка на `docs/SPEC_V1.md`).
- **Core versions**: версии `headless_tokens`, `headless_foundation`, `headless_contracts`, `headless_theme` (и `headless_test`, если используется).
- **Date**: дата последней проверки.
- **Test command**: команда(ы), которыми прогонялась проверка (например `flutter test`, `dart test`, `melos test` — что реально используется в пакете).
- **Conformance scope**: какие части v1 контрактов применимы (например: `overlay: yes/no`, `listbox: yes/no`, `effects: yes/no`).
- **Evidence**: перечисление пройденных проверок/тест-наборов, минимум:
  - Semantics/a11y
  - Keyboard-only
  - Controlled/uncontrolled
  - Overlay lifecycle (если overlay применим)

### 4.3 Рекомендуемый шаблон (копипаст)

```text
## Conformance Report

- Spec: Headless Component Spec v1 (see docs/SPEC_V1.md)
- Conformance: passes (see docs/CONFORMANCE.md)

- Core versions:
  - headless_tokens: X.Y.Z
  - headless_foundation: X.Y.Z
  - headless_contracts: X.Y.Z
  - headless_theme: X.Y.Z
  - headless_test: X.Y.Z (optional)

- Date: YYYY-MM-DD
- Test command(s):
  - <command 1>
  - <command 2>

- Scope:
  - overlay: yes/no
  - listbox: yes/no
  - effects: yes/no

- Evidence:
  - Semantics/a11y: PASS
  - Keyboard-only: PASS
  - Controlled/uncontrolled: PASS
  - Overlay lifecycle: PASS (n/a if overlay=no)
```

