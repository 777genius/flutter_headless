## Implementation plan (итерации)

Эта папка — **итерационный план реализации** Headless: что делать, в каком порядке, и какие критерии “готово” у каждой итерации.

Политика:
- Идём **снизу вверх**: сначала core contracts (foundation/theme/tokens), потом компоненты.
- Никаких “магических” shortcut’ов, которые ломают Spec-first подход.
- Каждая итерация заканчивается **чеклистом** и критериями готовности.

### Навигация

- [I00 — Bootstrap (monorepo skeleton)](./I00_bootstrap.md)
- [I01 — CI guardrails (DAG + domain purity + format/analyze/test)](./I01_ci_guardrails.md)
- [I02 — Tokens v1: минимальный набор и API-границы](./I02_tokens_v1_min.md)
- [I03 — Foundation Overlay v1: phase/close contract (skeleton → usable)](./I03_foundation_overlay_v1.md)
- [I04 — Effects executor v1 (E1/A1): типы + выполнение + дедуп/порядок](./I04_effects_executor_v1.md)
- [I05 — Theme v1: capability discovery + required capability failures](./I05_theme_capabilities_v1.md)
- [I06 — Reference component: Button (первый end-to-end вертикальный срез)](./I06_component_button_v1.md)
- [I07 — Reference component: DropdownButton (overlay + listbox + keyboard)](./I07_component_dropdown_button_v1.md)
- [I08 — Token Resolution Layer v1: state→tokens + расширенные RenderRequest](./I08_token_resolution_and_render_requests_v1.md)
- [I09 — Протянуть расширенные RenderRequest в Button/Dropdown + закрыть conformance gaps](./I09_apply_resolved_tokens_button_dropdown_v1.md)
- [I10 — Conformance reports v1: отчёты и evidence для publishable packages](./I10_conformance_reports_v1.md)
- [I11 — Preset v1: headless_material (renderers + token resolvers + overrides)](./I11_headless_material_preset_v1.md)
- [I12 — Example app v1: реальный preset вместо тестовых renderers](./I12_example_app_with_material_preset_v1.md)
- [I13 — Preset v1: headless_cupertino (parity + platform POLA)](./I13_headless_cupertino_preset_v1.md)
- [I14 — Component v1: Headless TextField на базе EditableText (contracts + renderer split)](./I14_headless_textfield_editabletext_v1.md)
- [I15 — Foundation v1: Anchored Overlay Positioning (flip/shift/maxHeight + keyboard/safe area)](./I15_foundation_overlay_positioning_v1.md)
- [I16 — Foundation v1: Listbox (registry + navigation + typeahead)](./I16_foundation_listbox_v1.md)
- [I17 — Foundation v1: Overlay Reposition Policy (≤ 1/frame) + triggers (scroll/resize/keyboard)](./I17_foundation_overlay_reposition_v1.md)
- [I18 — Foundation v1.1: Overlay update triggers (scroll/metrics + optional tickers) + conformance tests (Overlay SLA)](./I18_foundation_overlay_update_triggers_v1_1.md)
- [I19 — Conformance & Policies v1: A11y/Semantics SLA + Focus policy + Interaction contracts](./I19_conformance_a11y_focus_interaction_policies_v1.md)
- [I26 — Anchored Overlay Engine v1.3: отдельный пакет + Portal/Entry insertion backends](./I26_overlay_engine_portal_v1_3.md)
- [I27 — DX v1.4: Error policy (no release crash) + guardrails for custom renderers](./I27_dx_error_policy_and_guardrails_v1_4.md)
- [I28 — Users docs simplification + cookbook + README (v1.5)](./I28_users_cookbook_and_readme_v1_5.md)
- [I30 — Parts/Slots + Primitives + Safe Wrappers (v1.7)](./I30_parts_slots_primitives_and_safe_wrappers_v1_7.md)
- [I23 — Rich List Item Model (vNext): typed item anatomy + features for listbox/select-like components](./I23_rich_list_item_model_vnext.md)
- [I24 — Autocomplete v1: composable “TextField + Menu” (Flutter-like API) без дублирования логики](./I24_autocomplete_v1.md)
- [I29 — Autocomplete v1.6: conformance + a11y SLA + keyboard/overlay polish + план multi-select](./I29_autocomplete_conformance_and_multiselect_v1_6.md)
- [I31 — Autocomplete vNext: Local/Remote/Hybrid sources + RequestFeatures (no overrides abuse)](./I31_autocomplete_sources_vnext.md)
- [I32 — Component v1: Switch (Material/Cupertino parity, Flutter-like API)](./I32_component_switch_v1.md)
- [I33 — Switch Interaction Parity v1 (Material ripple + Drag thumb like Flutter)](./I33_switch_interaction_parity_v1.md)
- [I35 — headless_material: Material TextField variants parity v1 (filled/outlined/underlined)](./I35_material_textfield_variants_parity_v1.md)

### Основные источники требований (читать параллельно)

- Архитектура и границы: [`docs/ARCHITECTURE.md`](../ARCHITECTURE.md)
- Контракты v1 (0.1–0.7): [`docs/V1_DECISIONS.md`](../V1_DECISIONS.md)
- Spec-first для community: [`docs/SPEC_V1.md`](../SPEC_V1.md), [`docs/CONFORMANCE.md`](../CONFORMANCE.md)
- ROI/приоритеты: [`docs/MUST.md`](../MUST.md)
- Гибкая кастомизация preset’ов и per-instance overrides: [`docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`](../FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md)

