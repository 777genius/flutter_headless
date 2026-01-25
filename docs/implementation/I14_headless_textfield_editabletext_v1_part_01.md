## I14 — Component v1: Headless TextField на базе `EditableText` (contracts + renderer split) (part 1)

Back: [Index](./I14_headless_textfield_editabletext_v1.md)

## I14 — Component v1: Headless TextField на базе `EditableText` (contracts + renderer split)

### Цель

Добавить компонент, который чаще всего определяет “готовность для продакшена”:
**headless TextField**, который:
- полностью контролирует поведение (focus, selection, keyboard, IME, a11y),
- остаётся headless (визуал через renderer + tokens),
- поддерживает контролируемый/неконтролируемый режим (как Flutter `TextField`),
- поддерживает per-instance overrides и scoped theme.

### Почему это отдельная итерация

Text input — это зона, где “просто обернуть Material TextField” почти всегда ломает:
- single source of truth,
- предсказуемость commands,
- а иногда и доступность/IME edge cases.

Поэтому v1 стратегия: **опираться на `EditableText` как поведенческое ядро**, визуал вынести в preset renderer.

### Ссылки

- Архитектура: `docs/ARCHITECTURE.md`
- Контракты/паттерны: `docs/V1_DECISIONS.md`
- Гибкость: `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`
- Token resolution + RenderRequest (Variant B): `docs/implementation/I08_token_resolution_and_render_requests_v1.md`
- Guardrails theme capabilities: `docs/implementation/I05_theme_capabilities_v1.md`
- Spec/Conformance: `docs/SPEC_V1.md`, `docs/CONFORMANCE.md`

---

