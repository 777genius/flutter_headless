## I10 — Conformance reports v1: отчёты и evidence для publishable packages

### Цель

Закрыть обязательное требование из `docs/CONFORMANCE.md`:

- если пакет заявляет “passes conformance”, он **MUST** иметь `CONFORMANCE_REPORT.md` (или секцию в README) с проверяемыми данными.

Эта итерация делает процесс повторяемым и “без ручной магии”.

### Ссылки

- `docs/CONFORMANCE.md` → раздел 4) “passes conformance” — MUST
- `docs/SPEC_V1.md` → правила совместимости
- `docs/ARCHITECTURE.md` → Definition of Done для headless‑совместимых packages

---

## Что делаем

### 1) Определить “какие пакеты заявляют conformance”

В монорепо v1:
- `packages/components/headless_button` (да, потому что это reference component)
- `packages/components/headless_dropdown_button`
- (опционально позже) dialog‑компонент, когда он будет реально реализован

Тонкий момент:
- если пакет пока `publish_to: none`, отчёт всё равно полезен как “внутренний стандарт”. Но MUST в строгом смысле применяем к publishable/external.

---

### 2) Добавить `CONFORMANCE_REPORT.md` в каждый целевой пакет

Структура отчёта — по шаблону из `docs/CONFORMANCE.md`, но с реальными данными:

- Spec: `Headless Component Spec v1` (ссылка на upstream `docs/SPEC_V1.md`)
- Conformance: passes (ссылка на upstream `docs/CONFORMANCE.md`)
- Core versions:
  - `headless_tokens`
  - `headless_foundation`
  - `headless_contracts`
  - `headless_theme`
- Date
- Test command(s)
- Scope: overlay/listbox/effects yes/no
- Evidence: список проверок (Semantics/a11y, Keyboard-only, Controlled/uncontrolled, Overlay lifecycle)

Тонкие моменты:
- для монорепо core versions могут быть “workspace version” (`0.0.0`), но лучше фиксировать git sha или тег.
- “Evidence” должен ссылаться на конкретные test files/наборы.

---

### 3) Автоматизировать обновление отчёта (опционально v1.1)

В v1 можно оставить manual. В v1.1:
- `melos run conformance:report` генерирует/обновляет дату и команды (без автогенерации содержимого тестов).

---

## Критерии готовности (DoD)

- У `headless_button` и `headless_dropdown_button` есть `CONFORMANCE_REPORT.md` с корректным шаблоном и реальными командами.
- В CI добавлена проверка: если пакет помечен как “conformance passes”, отчёт обязателен (можно простым grep/наличием файла).

---

## Чеклист

- [ ] Добавлен `CONFORMANCE_REPORT.md` для `headless_button`.
- [ ] Добавлен `CONFORMANCE_REPORT.md` для `headless_dropdown_button`.
- [ ] В отчётах указаны команды тестов и scope.
- [ ] (Опционально) добавлена CI проверка наличия отчёта для целевых пакетов.

