## Implementation plan (итерации)

Эта папка — **итерационный план реализации** Headless: что делать, в каком порядке, и какие критерии “готово” у каждой итерации.

Политика:
- Идём **снизу вверх**: сначала core contracts (foundation/theme/tokens), потом компоненты.
- Никаких “магических” shortcut’ов, которые ломают Spec-first подход.
- Каждая итерация заканчивается **чеклистом** и критериями готовности.

### Навигация

- [I00 — Bootstrap (monorepo skeleton)](/guide/implementation/I00_bootstrap)
- [I01 — CI guardrails (DAG + domain purity + format/analyze/test)](/guide/implementation/I01_ci_guardrails)
- [I02 — Tokens v1: минимальный набор и API-границы](/guide/implementation/I02_tokens_v1_min)
- [I03 — Foundation Overlay v1: phase/close contract (skeleton → usable)](/guide/implementation/I03_foundation_overlay_v1)
- [I04 — Effects executor v1 (E1/A1): типы + выполнение + дедуп/порядок](/guide/implementation/I04_effects_executor_v1)
- [I05 — Theme v1: capability discovery + required capability failures](/guide/implementation/I05_theme_capabilities_v1)
- [I06 — Reference component: Button (первый end-to-end вертикальный срез)](/guide/implementation/I06_component_button_v1)
- [I07 — Reference component: DropdownButton (overlay + listbox + keyboard)](/guide/implementation/I07_component_dropdown_button_v1)
- [I08 — Token Resolution Layer v1: state→tokens + расширенные RenderRequest](/guide/implementation/I08_token_resolution_and_render_requests_v1)
- [I09 — Протянуть расширенные RenderRequest в Button/Dropdown + закрыть conformance gaps](/guide/implementation/I09_apply_resolved_tokens_button_dropdown_v1)
- [I10 — Conformance reports v1: отчёты и evidence для publishable packages](/guide/implementation/I10_conformance_reports_v1)
- [I11 — Preset v1: headless_material (renderers + token resolvers + overrides)](/guide/implementation/I11_headless_material_preset_v1)
- [I12 — Example app v1: реальный preset вместо тестовых renderers](/guide/implementation/I12_example_app_with_material_preset_v1)
- [I13 — Preset v1: headless_cupertino (parity + platform POLA)](/guide/implementation/I13_headless_cupertino_preset_v1)
- [I14 — Component v1: Headless TextField на базе EditableText (contracts + renderer split)](/guide/implementation/I14_headless_textfield_editabletext_v1)
- [I15 — Foundation v1: Anchored Overlay Positioning (flip/shift/maxHeight + keyboard/safe area)](/guide/implementation/I15_foundation_overlay_positioning_v1)
- [I16 — Foundation v1: Listbox (registry + navigation + typeahead)](/guide/implementation/I16_foundation_listbox_v1)
- [I17 — Foundation v1: Overlay Reposition Policy (≤ 1/frame) + triggers (scroll/resize/keyboard)](/guide/implementation/I17_foundation_overlay_reposition_v1)
- [I18 — Foundation v1.1: Overlay update triggers (scroll/metrics + optional tickers) + conformance tests (Overlay SLA)](/guide/implementation/I18_foundation_overlay_update_triggers_v1_1)
- [I19 — Conformance & Policies v1: A11y/Semantics SLA + Focus policy + Interaction contracts](/guide/implementation/I19_conformance_a11y_focus_interaction_policies_v1)
- [I26 — Anchored Overlay Engine v1.3: отдельный пакет + Portal/Entry insertion backends](/guide/implementation/I26_overlay_engine_portal_v1_3)
- [I27 — DX v1.4: Error policy (no release crash) + guardrails for custom renderers](/guide/implementation/I27_dx_error_policy_and_guardrails_v1_4)
- [I28 — Users docs simplification + cookbook + README (v1.5)](/guide/implementation/I28_users_cookbook_and_readme_v1_5)
- [I30 — Parts/Slots + Primitives + Safe Wrappers (v1.7)](/guide/implementation/I30_parts_slots_primitives_and_safe_wrappers_v1_7)
- [I23 — Rich List Item Model (vNext): typed item anatomy + features for listbox/select-like components](/guide/implementation/I23_rich_list_item_model_vnext)
- [I24 — Autocomplete v1: composable “TextField + Menu” (Flutter-like API) без дублирования логики](/guide/implementation/I24_autocomplete_v1)
- [I29 — Autocomplete v1.6: conformance + a11y SLA + keyboard/overlay polish + план multi-select](/guide/implementation/I29_autocomplete_conformance_and_multiselect_v1_6)
- [I31 — Autocomplete vNext: Local/Remote/Hybrid sources + RequestFeatures (no overrides abuse)](/guide/implementation/I31_autocomplete_sources_vnext)
- [I32 — Component v1: Switch (Material/Cupertino parity, Flutter-like API)](/guide/implementation/I32_component_switch_v1)
- [I33 — Switch Interaction Parity v1 (Material ripple + Drag thumb like Flutter)](/guide/implementation/I33_switch_interaction_parity_v1)
- [I35 — headless_material: Material TextField variants parity v1 (filled/outlined/underlined)](/guide/implementation/I35_material_textfield_variants_parity_v1)
- [I36 — Button: Flutter parity renderer (visual-only) + Tap target policy separation v1](/guide/implementation/I36_button_flutter_parity_renderer_tap_target_policy_v1)
- [I37 — Button: appearance-variants (filled/tonal/outlined/text) + deterministic focus highlight + token-mode + demo/tests v1](/guide/implementation/I37_button_variants_focus_highlight_token_mode_demo_v1)

### Основные источники требований (читать параллельно)

- Архитектура и границы: [`docs/ARCHITECTURE.md`](/guide/ARCHITECTURE)
- Контракты v1 (0.1–0.7): [`docs/V1_DECISIONS.md`](../V1_DECISIONS.md)
- Spec-first для community: [`docs/SPEC_V1.md`](/guide/SPEC_V1), [`docs/CONFORMANCE.md`](/guide/CONFORMANCE)
- ROI/приоритеты: [`docs/MUST.md`](/guide/MUST)
- Гибкая кастомизация preset’ов и per-instance overrides: [`docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`](/guide/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES)

