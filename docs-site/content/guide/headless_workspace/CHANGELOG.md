# Documentation Changelog

Здесь логируются заметные изменения в документации (не в коде).

## [Unreleased]

### 2026-01-17 — DX docs sync (HIGH)

- Синхронизированы entrypoints и DX‑формулы:
  - `README.md`, `docs/en/README.md` — добавлены `style:`/priority/defaults/scopes.
  - `docs/users/README.md` — единая формулировка для `style:` и приоритетов.
- Актуализированы внутренние RU‑доки:
  - `docs/ru/README.md`, `docs/ru/README_INTERNAL.md`, `docs/WHY_HEADLESS.md`.
- Унифицированы формулировки в README/LLM компонентных пакетов:
  - `headless_button`, `headless_dropdown_button`, `headless_textfield`,
    `headless_checkbox`, `headless_autocomplete`.

### 2026-01-11 — Spec-first слой документации (CRITICAL)

- Добавлены нормативные документы для экосистемы:
  - `docs/SPEC_V1.md` — Headless Component Spec v1 (MUST/SHOULD/MAY).
  - `docs/CONFORMANCE.md` — как заявлять Headless‑совместимость + минимальный чеклист/тесты.
- Усилена архитектурная фиксация “делаем только так”:
  - `docs/ARCHITECTURE.md` — Spec-first секция + Definition of Done для Headless‑совместимого package + обновлённое дерево `docs/`.
- Обновлены кросс‑ссылки:
  - `README.md` — позиционирование spec-first + ссылки на SPEC/CONFORMANCE.
  - `docs/V1_DECISIONS.md` — добавлена ссылка на `docs/CONFORMANCE.md`.

---

## Формат

Каждая запись включает:
- **Дата**
- **Категория** (CRITICAL/HIGH/MEDIUM/LOW)
- **Краткое описание**
- **Список затронутых файлов**
