## I25 — DX Simplification (v1.2): “простая дорожка” поверх contracts без потери гибкости (part 2)

Back: [Index](./I25_user_dx_simplification_v1_2.md)

## 7) План работ (TODO)

- [x] Спроектировать `RButtonStyle/RDropdownStyle/RTextFieldStyle`: минимальный набор полей + маппинг в `R*Overrides` (без `BuildContext`).
- [x] Реализовать “style → overrides” в 1–2 компонентах (кнопка + dropdown) как proof.
- [x] Вынести общий helper `mergeStyleIntoOverrides` (DRY) и использовать его во всех компонентах.
- [x] Добавить `Headless*Scope` sugar widgets для subtree capability overrides.
- [x] Добавить “brand/defaults config” для `MaterialHeadlessTheme` (без ломающих изменений).
- [x] Разделить docs на Users vs Contributors (новые entrypoints + cookbook).
- [x] Добавить CLI генератор skeleton + conformance templates.
- [x] Прописать POLA/priority правила (style vs overrides vs theme defaults).
- [x] Style-rollout на существующие компоненты v1 (button/dropdown/textfield/checkbox/autocomplete).
- [ ] Style-rollout на новые компоненты по мере появления (dialog — когда будет реализован).

---

## Критерии готовности (DoD)

- Новичок может:
  - подключить preset,
  - “чуть поменять визуал” кнопки/дропдауна,
  - локально переопределить поведение/визуал на subtree,
  без чтения `SPEC_V1.md`.
- Advanced путь (tokens/overrides/slots/capabilities) остаётся доступен и не ломается.

