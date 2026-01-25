## I14 — Component v1: Headless TextField на базе `EditableText` (contracts + renderer split) (part 3)

Back: [Index](./I14_headless_textfield_editabletext_v1.md)

## Тест-матрица v1 (PR-ready)

### Widget Tests (автоматизируемые, запускаются на CI)

#### T1 — Controlled/uncontrolled
- controlled: `value` меняется только через parent; `onChanged` вызывается корректно
- uncontrolled: внутреннее состояние хранится в controller внутри компонента

Под-кейсы (тонкие моменты):
- controlled: смена `value` не должна "сбрасывать" selection без необходимости
- controlled: `value` обновляется на тот же текст (idempotent) — не должно триггерить лишние события
- переходы: `controller` появляется/исчезает в `didUpdateWidget` — без утечек и без потери корректности

#### T2 — Focus/keyboard
- autofocus
- tab focus
- enter/next action (`textInputAction`)

#### T3 — Error state
- `errorText` меняет токены и semantics

#### T4 — Formatters
- inputFormatters реально применяются
- formatter не вызывает infinite loop

#### T5 — Overrides flow
- `RenderOverrides.only(RTextFieldOverrides(...))` влияет на `resolvedTokens`

#### T6 — ObscureText (widget test)
- T-PW-1: `obscureText=true` не раскрывает value в semantics

#### T7 — ReadOnly / Disabled (widget test)
- T-RO-1: `readOnly=true` позволяет focus, но EditableText получает readOnly=true
- T-DIS-1: `enabled=false` — semantics отражает disabled

#### T8 — Slots (widget test)
- T-SLOT-1: leading/trailing slots рендерятся корректно
- T-SLOT-2: slots не ломают focus/input

#### T9 — A11y (widget test)
- T-A11Y-1: Semantics.textField = true
- T-A11Y-2: label/hint доступны в semantics
- T-A11Y-ERR: error text доступен в semantics tree

---

### Integration / Manual Tests (на устройстве/эмуляторе)

Эти тесты сложно/нестабильно автоматизировать в widget tests.
Документируем как **manual checklist** в CONFORMANCE_REPORT.md.

#### M1 — IME Composing (CJK)
- M-IME-1: Ввод китайских/японских символов работает
- M-IME-2: Parent update во время composing не ломает IME
- M-IME-3: Pending value применяется после composing

#### M2 — Clipboard (platform-specific)
- M-CLIP-1: Copy/paste работает
- M-CLIP-2: readOnly разрешает copy, запрещает paste
- M-CLIP-3: paste вызывает onChanged ровно 1 раз

#### M3 — Autofill
- M-AF-1: autofillHints срабатывают на device keyboard
- M-AF-2: autofill не ломает controlled режим

#### M4 — Password reveal (если есть toggle)
- M-PW-1: toggle obscure работает без потери текста
- M-PW-2: semantics не читает пароль

---

### Удалено из v1 (Option A для validation)

~~T10 — Form/Validation~~
- Валидация через external `errorText`, не internal validator
- Тесты T3 (Error state) покрывают нужное

---

## Артефакты итерации (конкретные пути)

**Contracts** (`packages/headless_contracts/lib/src/renderers/textfield/`):
- `r_text_field_renderer.dart`
- `r_text_field_token_resolver.dart`
- `r_text_field_resolved_tokens.dart`
- `r_text_field_render_request.dart`
- `r_text_field_state.dart`
- `r_text_field_spec.dart`
- `r_text_field_overrides.dart`
- `r_text_field_slots.dart`

**Component** (`packages/components/headless_textfield/lib/`):
- `src/presentation/r_text_field.dart`
- `headless_textfield.dart` (barrel)

**Tests** (`packages/components/headless_textfield/test/`):
- `controlled_test.dart`
- `controller_driven_test.dart`
- `focus_test.dart`
- `error_state_test.dart`
- `formatters_test.dart`
- `overrides_test.dart`

**IME Testing Strategy**:
- `ime_composition_test.dart` — **manual test** (автоматизация IME в Flutter test ограничена)
- В тесте можно проверить `composing.isValid` logic через mock TextEditingValue
- Реальная проверка CJK ввода — ручной тест на устройстве/эмуляторе
- Документировать manual test steps в CONFORMANCE_REPORT.md

**Conformance** (по стандарту v1 — в пакете компонента):
- `packages/components/headless_textfield/CONFORMANCE_REPORT.md`

#### Conformance scope (v1)

В `CONFORMANCE_REPORT.md` явно отметить:
- supported: controlled/uncontrolled, keyboard basics, error semantics, overrides flow
- partial/manual: IME composing (если автотест нестабилен), autofill (может быть manual на CI)

##### Мини-шаблон `CONFORMANCE_REPORT.md` (для TextField)

````md
# Conformance Report

## Specification
- **Spec**: Headless Component Spec v1
- **Conformance**: [docs/CONFORMANCE.md](../../../docs/CONFORMANCE.md)

## Core Versions
- headless_tokens: 0.0.0
- headless_foundation: 0.0.0
- headless_contracts: 0.0.0
- headless_theme: 0.0.0

## Test Command
```bash
flutter test
```

#### Manual checklist (v1) — чтобы “огромная гибкость” была проверяема

В `CONFORMANCE_REPORT.md` добавить manual steps:
- IME composing: CJK ввод, pending value, нет “прыжков” курсора
- Autofill: автозаполнение email/phone/password (устройство/эмулятор)
- Password semantics: screen reader не читает содержимое

## Scope
| Feature | Supported |
|---------|-----------|
| Controlled/Uncontrolled | Yes |
| IME composing | Partial (manual) |
| Autofill | Partial (device/manual) |
| A11y semantics | Yes |

## Evidence
- T1–T8: see `test/*`
- Manual checklist: IME composing + autofill flows
````

---

## Критерии готовности (DoD)

- Компонент работает в example app c `headless_material` preset’ом.
- Есть базовая кастомизация: overrides + slots + scoped theme.
- Тесты проходят.
- Есть `CONFORMANCE_REPORT.md`.

---

## Чеклист

- [ ] Добавлены контракты textfield в `headless_contracts`.
- [ ] Создан компонентный пакет `headless_textfield`.
- [ ] Реализован core на `EditableText` (Вариант A).
- [ ] Поддержаны controlled/uncontrolled режимы.
- [ ] Поддержаны error/readOnly/disabled states.
- [ ] Добавлены overrides + slots.
- [ ] Написаны тесты по матрице (T1–T5).
- [ ] Добавлен conformance report и обновлены ссылки в документации.

