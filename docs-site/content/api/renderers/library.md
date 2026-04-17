---
title: "renderers"
description: "API documentation for the renderers library"
outline: [2, 3]
---

# renderers

Renderer contracts for Headless components.

## Classes {#section-classes}

| Class | Description |
|---|---|
| [HeadlessRendererPolicy](/api/src_renderers_renderer_policy/HeadlessRendererPolicy) | Optional renderer policy for stricter contracts in debug/test. |
| [RAutocompleteSelectedValuesCommands](/api/src_renderers_autocomplete_r_autocomplete_selected_values_commands/RAutocompleteSelectedValuesCommands) | Commands for rendering and interacting with selected values (multi-select). |
| [RAutocompleteSelectedValuesOverrides](/api/src_renderers_autocomplete_r_autocomplete_selected_values_overrides/RAutocompleteSelectedValuesOverrides) | Per-instance overrides for selected values rendering (contract level). |
| [RAutocompleteSelectedValuesRenderer](/api/src_renderers_autocomplete_r_autocomplete_selected_values_renderer/RAutocompleteSelectedValuesRenderer) | Renderer capability for selected values display (multi-select autocomplete). |
| [RAutocompleteSelectedValuesRenderRequest](/api/src_renderers_autocomplete_r_autocomplete_selected_values_renderer/RAutocompleteSelectedValuesRenderRequest) | Render request passed to selected-values renderer with selected items, commands, and optional overrides. |
| [RButtonCallbacks](/api/src_renderers_button_r_button_callbacks/RButtonCallbacks) | Callback references for button rendering (visual-only). |
| [RButtonContentContext](/api/src_renderers_button_r_button_slots/RButtonContentContext) | Context for the button content slot. |
| [RButtonIconContext](/api/src_renderers_button_r_button_slots/RButtonIconContext) | Context for the button icon slots. |
| [RButtonMotionTokens](/api/src_renderers_button_r_button_motion_tokens/RButtonMotionTokens) | Motion tokens for button visual transitions. |
| [RButtonOverrides](/api/src_renderers_button_r_button_overrides/RButtonOverrides) | Per-instance override contract for Button components. |
| [RButtonRenderer](/api/src_renderers_button_r_button_renderer/RButtonRenderer) | Renderer capability for Button components. |
| [RButtonRendererTokenMode](/api/src_renderers_button_r_button_renderer/RButtonRendererTokenMode) | Optional renderer extension that declares resolved-tokens usage. |
| [RButtonRenderRequest](/api/src_renderers_button_r_button_renderer/RButtonRenderRequest) | Render request containing everything a button renderer needs. |
| [RButtonResolvedTokens](/api/src_renderers_button_r_button_resolved_tokens/RButtonResolvedTokens) | Resolved visual tokens for button rendering. |
| [RButtonSemantics](/api/src_renderers_button_r_button_semantics/RButtonSemantics) | Semantic information for button accessibility. |
| [RButtonSlots](/api/src_renderers_button_r_button_slots/RButtonSlots) | Button slots for partial customization (Replace/Decorate/Enhance). |
| [RButtonSpec](/api/src_renderers_button_r_button_renderer/RButtonSpec) | Button specification (static, from widget props). |
| [RButtonSpinnerContext](/api/src_renderers_button_r_button_slots/RButtonSpinnerContext) | Context for the button spinner slot. |
| [RButtonState](/api/src_renderers_button_r_button_renderer/RButtonState) | Button interaction state. |
| [RButtonSurfaceContext](/api/src_renderers_button_r_button_slots/RButtonSurfaceContext) | Context for the button surface slot. |
| [RButtonTokenResolver](/api/src_renderers_button_r_button_token_resolver/RButtonTokenResolver) | Token resolver capability for Button components. |
| [RCheckboxBoxContext](/api/src_renderers_checkbox_r_checkbox_renderer/RCheckboxBoxContext) | Context for checkbox box slot. |
| [RCheckboxListTileCheckboxContext](/api/src_renderers_checkbox_list_tile_r_checkbox_list_tile_slots/RCheckboxListTileCheckboxContext) | Context for the checkbox indicator slot. |
| [RCheckboxListTileMotionTokens](/api/src_renderers_checkbox_list_tile_r_checkbox_list_tile_motion_tokens/RCheckboxListTileMotionTokens) | Motion tokens for checkbox list tile visual transitions. |
| [RCheckboxListTileOverrides](/api/src_renderers_checkbox_list_tile_r_checkbox_list_tile_overrides/RCheckboxListTileOverrides) | Per-instance override contract for CheckboxListTile components. |
| [RCheckboxListTileRenderer](/api/src_renderers_checkbox_list_tile_r_checkbox_list_tile_renderer/RCheckboxListTileRenderer) | Renderer capability for CheckboxListTile components. |
| [RCheckboxListTileRenderRequest](/api/src_renderers_checkbox_list_tile_r_checkbox_list_tile_renderer/RCheckboxListTileRenderRequest) | Render request containing everything a checkbox list tile renderer needs. |
| [RCheckboxListTileResolvedTokens](/api/src_renderers_checkbox_list_tile_r_checkbox_list_tile_resolved_tokens/RCheckboxListTileResolvedTokens) | Resolved visual tokens for checkbox list tile rendering. |
| [RCheckboxListTileSecondaryContext](/api/src_renderers_checkbox_list_tile_r_checkbox_list_tile_slots/RCheckboxListTileSecondaryContext) | Context for the secondary slot. |
| [RCheckboxListTileSemantics](/api/src_renderers_checkbox_list_tile_r_checkbox_list_tile_semantics/RCheckboxListTileSemantics) | Semantic information for checkbox list tile accessibility. |
| [RCheckboxListTileSlots](/api/src_renderers_checkbox_list_tile_r_checkbox_list_tile_slots/RCheckboxListTileSlots) | Slots for checkbox list tile parts (Replace/Decorate/Enhance). |
| [RCheckboxListTileSpec](/api/src_renderers_checkbox_list_tile_r_checkbox_list_tile_spec/RCheckboxListTileSpec) | Checkbox list tile specification (static, from widget props). |
| [RCheckboxListTileState](/api/src_renderers_checkbox_list_tile_r_checkbox_list_tile_state/RCheckboxListTileState) | Checkbox list tile interaction state. |
| [RCheckboxListTileTextContext](/api/src_renderers_checkbox_list_tile_r_checkbox_list_tile_slots/RCheckboxListTileTextContext) | Context for title/subtitle slots. |
| [RCheckboxListTileTileContext](/api/src_renderers_checkbox_list_tile_r_checkbox_list_tile_slots/RCheckboxListTileTileContext) | Context for the list tile slot (wraps the default ListTile). |
| [RCheckboxListTileTokenResolver](/api/src_renderers_checkbox_list_tile_r_checkbox_list_tile_token_resolver/RCheckboxListTileTokenResolver) | Token resolver capability for CheckboxListTile components. |
| [RCheckboxMarkContext](/api/src_renderers_checkbox_r_checkbox_renderer/RCheckboxMarkContext) | Context for checkbox mark slot. |
| [RCheckboxMotionTokens](/api/src_renderers_checkbox_r_checkbox_motion_tokens/RCheckboxMotionTokens) | Motion tokens for checkbox visual transitions. |
| [RCheckboxOverrides](/api/src_renderers_checkbox_r_checkbox_overrides/RCheckboxOverrides) | Per-instance override contract for Checkbox components. |
| [RCheckboxPressOverlayContext](/api/src_renderers_checkbox_r_checkbox_renderer/RCheckboxPressOverlayContext) | Context for checkbox press overlay slot. |
| [RCheckboxRenderer](/api/src_renderers_checkbox_r_checkbox_renderer/RCheckboxRenderer) | Renderer capability for Checkbox components. |
| [RCheckboxRenderRequest](/api/src_renderers_checkbox_r_checkbox_renderer/RCheckboxRenderRequest) | Render request containing everything a checkbox renderer needs. |
| [RCheckboxResolvedTokens](/api/src_renderers_checkbox_r_checkbox_resolved_tokens/RCheckboxResolvedTokens) | Resolved visual tokens for checkbox rendering. |
| [RCheckboxSemantics](/api/src_renderers_checkbox_r_checkbox_semantics/RCheckboxSemantics) | Semantic information for checkbox accessibility. |
| [RCheckboxSlots](/api/src_renderers_checkbox_r_checkbox_renderer/RCheckboxSlots) | Checkbox slots for partial customization (Replace/Decorate/Enhance). |
| [RCheckboxSpec](/api/src_renderers_checkbox_r_checkbox_renderer/RCheckboxSpec) | Checkbox specification (static, from widget props). |
| [RCheckboxState](/api/src_renderers_checkbox_r_checkbox_renderer/RCheckboxState) | Checkbox interaction state. |
| [RCheckboxTokenResolver](/api/src_renderers_checkbox_r_checkbox_token_resolver/RCheckboxTokenResolver) | Token resolver capability for Checkbox components. |
| [RDropdownAnchorContext](/api/src_renderers_dropdown_r_dropdown_slots/RDropdownAnchorContext) | Context for the anchor (trigger button) slot. |
| [RDropdownButtonRenderer](/api/src_renderers_dropdown_r_dropdown_button_renderer/RDropdownButtonRenderer) | Renderer capability for DropdownButton components. |
| [RDropdownButtonSlots](/api/src_renderers_dropdown_r_dropdown_slots/RDropdownButtonSlots) | Dropdown slots for partial customization (Replace/Decorate pattern). |
| [RDropdownButtonSpec](/api/src_renderers_dropdown_r_dropdown_spec/RDropdownButtonSpec) | Dropdown specification (static, from widget props). |
| [RDropdownButtonState](/api/src_renderers_dropdown_r_dropdown_state/RDropdownButtonState) | Dropdown interaction state. |
| [RDropdownChevronContext](/api/src_renderers_dropdown_r_dropdown_slots/RDropdownChevronContext) | Context for the chevron slot inside the trigger. |
| [RDropdownCommands](/api/src_renderers_dropdown_r_dropdown_commands/RDropdownCommands) | Commands for dropdown interactions (internal component API). |
| [RDropdownItemContentContext](/api/src_renderers_dropdown_r_dropdown_slots/RDropdownItemContentContext) | Context for item content inside the menu item. |
| [RDropdownItemContext](/api/src_renderers_dropdown_r_dropdown_slots/RDropdownItemContext) | Context for an individual menu item slot. |
| [RDropdownItemTokens](/api/src_renderers_dropdown_r_dropdown_resolved_tokens/RDropdownItemTokens) | Resolved tokens for dropdown menu items. |
| [RDropdownMenuContext](/api/src_renderers_dropdown_r_dropdown_slots/RDropdownMenuContext) | Context for the menu slot. |
| [RDropdownMenuMotionTokens](/api/src_renderers_dropdown_r_dropdown_menu_motion_tokens/RDropdownMenuMotionTokens) | Motion tokens for dropdown menu open/close. |
| [RDropdownMenuRenderRequest](/api/src_renderers_dropdown_r_dropdown_request/RDropdownMenuRenderRequest) | Render request for the dropdown menu (overlay). |
| [RDropdownMenuSurfaceContext](/api/src_renderers_dropdown_r_dropdown_slots/RDropdownMenuSurfaceContext) | Context for the menu surface (background/container) slot. |
| [RDropdownMenuTokens](/api/src_renderers_dropdown_r_dropdown_resolved_tokens/RDropdownMenuTokens) | Resolved tokens for the dropdown menu surface. |
| [RDropdownOverrides](/api/src_renderers_dropdown_r_dropdown_overrides/RDropdownOverrides) | Per-instance override contract for Dropdown components. |
| [RDropdownRenderRequest](/api/src_renderers_dropdown_r_dropdown_request/RDropdownRenderRequest) | Render request containing everything a dropdown renderer needs. |
| [RDropdownResolvedTokens](/api/src_renderers_dropdown_r_dropdown_resolved_tokens/RDropdownResolvedTokens) | Resolved visual tokens for dropdown rendering. |
| [RDropdownSemantics](/api/src_renderers_dropdown_r_dropdown_semantics/RDropdownSemantics) | Semantic information for dropdown accessibility. |
| [RDropdownTokenResolver](/api/src_renderers_dropdown_r_dropdown_token_resolver/RDropdownTokenResolver) | Token resolver capability for Dropdown components. |
| [RDropdownTriggerRenderRequest](/api/src_renderers_dropdown_r_dropdown_request/RDropdownTriggerRenderRequest) | Render request for the dropdown trigger (anchor). |
| [RDropdownTriggerTokens](/api/src_renderers_dropdown_r_dropdown_resolved_tokens/RDropdownTriggerTokens) | Resolved tokens for the dropdown trigger button. |
| [RenderOverrides](/api/src_renderers_render_overrides/RenderOverrides) | Per-instance override bag for renderers and token resolvers. |
| [RenderOverridesDebugTracker](/api/src_renderers_render_overrides/RenderOverridesDebugTracker) | Debug-only tracker for consumed override types. |
| [RSwitchListTileMotionTokens](/api/src_renderers_switch_list_tile_r_switch_list_tile_motion_tokens/RSwitchListTileMotionTokens) | Motion tokens for switch list tile visual transitions. |
| [RSwitchListTileOverrides](/api/src_renderers_switch_list_tile_r_switch_list_tile_overrides/RSwitchListTileOverrides) | Per-instance override contract for SwitchListTile components. |
| [RSwitchListTileRenderer](/api/src_renderers_switch_list_tile_r_switch_list_tile_renderer/RSwitchListTileRenderer) | Renderer capability for SwitchListTile components. |
| [RSwitchListTileRenderRequest](/api/src_renderers_switch_list_tile_r_switch_list_tile_renderer/RSwitchListTileRenderRequest) | Render request containing everything a switch list tile renderer needs. |
| [RSwitchListTileResolvedTokens](/api/src_renderers_switch_list_tile_r_switch_list_tile_resolved_tokens/RSwitchListTileResolvedTokens) | Resolved visual tokens for switch list tile rendering. |
| [RSwitchListTileSecondaryContext](/api/src_renderers_switch_list_tile_r_switch_list_tile_slots/RSwitchListTileSecondaryContext) | Context for the secondary slot. |
| [RSwitchListTileSemantics](/api/src_renderers_switch_list_tile_r_switch_list_tile_semantics/RSwitchListTileSemantics) | Semantic information for switch list tile accessibility. |
| [RSwitchListTileSlots](/api/src_renderers_switch_list_tile_r_switch_list_tile_slots/RSwitchListTileSlots) | Slots for switch list tile parts (Replace/Decorate/Enhance). |
| [RSwitchListTileSpec](/api/src_renderers_switch_list_tile_r_switch_list_tile_spec/RSwitchListTileSpec) | Switch list tile specification (static, from widget props). |
| [RSwitchListTileState](/api/src_renderers_switch_list_tile_r_switch_list_tile_state/RSwitchListTileState) | Switch list tile interaction state. |
| [RSwitchListTileSwitchContext](/api/src_renderers_switch_list_tile_r_switch_list_tile_slots/RSwitchListTileSwitchContext) | Context for the switch indicator slot. |
| [RSwitchListTileTextContext](/api/src_renderers_switch_list_tile_r_switch_list_tile_slots/RSwitchListTileTextContext) | Context for title/subtitle slots. |
| [RSwitchListTileTileContext](/api/src_renderers_switch_list_tile_r_switch_list_tile_slots/RSwitchListTileTileContext) | Context for the list tile slot (wraps the default ListTile). |
| [RSwitchListTileTokenResolver](/api/src_renderers_switch_list_tile_r_switch_list_tile_token_resolver/RSwitchListTileTokenResolver) | Token resolver capability for SwitchListTile components. |
| [RSwitchMotionTokens](/api/src_renderers_switch_r_switch_motion_tokens/RSwitchMotionTokens) | Motion tokens for switch visual transitions. |
| [RSwitchOverrides](/api/src_renderers_switch_r_switch_overrides/RSwitchOverrides) | Per-instance override contract for Switch components. |
| [RSwitchPressOverlayContext](/api/src_renderers_switch_r_switch_renderer/RSwitchPressOverlayContext) | Context for switch press overlay slot. |
| [RSwitchRenderer](/api/src_renderers_switch_r_switch_renderer/RSwitchRenderer) | Renderer capability for Switch components. |
| [RSwitchRenderRequest](/api/src_renderers_switch_r_switch_renderer/RSwitchRenderRequest) | Render request containing everything a switch renderer needs. |
| [RSwitchResolvedTokens](/api/src_renderers_switch_r_switch_resolved_tokens/RSwitchResolvedTokens) | Resolved visual tokens for switch rendering. |
| [RSwitchSemantics](/api/src_renderers_switch_r_switch_semantics/RSwitchSemantics) | Semantic information for switch accessibility. |
| [RSwitchSlots](/api/src_renderers_switch_r_switch_renderer/RSwitchSlots) | Switch slots for partial customization (Replace/Decorate/Enhance). |
| [RSwitchSpec](/api/src_renderers_switch_r_switch_renderer/RSwitchSpec) | Switch specification (static, from widget props). |
| [RSwitchState](/api/src_renderers_switch_r_switch_renderer/RSwitchState) | Switch interaction state. |
| [RSwitchThumbContext](/api/src_renderers_switch_r_switch_renderer/RSwitchThumbContext) | Context for switch thumb slot. |
| [RSwitchTokenResolver](/api/src_renderers_switch_r_switch_token_resolver/RSwitchTokenResolver) | Token resolver capability for Switch components. |
| [RSwitchTrackContext](/api/src_renderers_switch_r_switch_renderer/RSwitchTrackContext) | Context for switch track slot. |
| [RTextFieldCommands](/api/src_renderers_textfield_r_text_field_commands/RTextFieldCommands) | Commands for TextField renderer (v1). |
| [RTextFieldOverrides](/api/src_renderers_textfield_r_text_field_overrides/RTextFieldOverrides) | Per-instance overrides for TextField components (contract level). |
| [RTextFieldRenderer](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldRenderer) | Renderer capability for TextField components. |
| [RTextFieldRenderRequest](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldRenderRequest) | Render request containing everything a text field renderer needs. |
| [RTextFieldResolvedTokens](/api/src_renderers_textfield_r_text_field_resolved_tokens/RTextFieldResolvedTokens) | Resolved visual tokens for TextField rendering. |
| [RTextFieldSemantics](/api/src_renderers_textfield_r_text_field_semantics/RTextFieldSemantics) | Semantic information for TextField accessibility (v1). |
| [RTextFieldSlots](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldSlots) | TextField slots for partial customization (Replace/Decorate pattern). |
| [RTextFieldSpec](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldSpec) | TextField specification (static, from widget props). |
| [RTextFieldState](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldState) | TextField interaction state. |
| [RTextFieldTokenResolver](/api/src_renderers_textfield_r_text_field_token_resolver/RTextFieldTokenResolver) | Token resolver capability for TextField components. |
| [SafeDropdownChevronContext](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownChevronContext) | No description available in source docs. |
| [SafeDropdownEmptyStateContext](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownEmptyStateContext) | No description available in source docs. |
| [SafeDropdownItemContentContext](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownItemContentContext) | No description available in source docs. |
| [SafeDropdownItemContext](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownItemContext) | No description available in source docs. |
| [SafeDropdownMenuSurfaceContext](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownMenuSurfaceContext) | No description available in source docs. |
| [SafeDropdownRenderer](/api/src_renderers_dropdown_safe_dropdown_renderer/SafeDropdownRenderer) | Safe scaffold for full dropdown renderer customization. |
| [SafeDropdownTriggerContext](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownTriggerContext) | No description available in source docs. |

## Enums {#section-enums}

| Enum | Description |
|---|---|
| [RAutocompleteSelectedValuesPresentation](/api/src_renderers_autocomplete_r_autocomplete_selected_values_overrides/RAutocompleteSelectedValuesPresentation) | Presentation style for selected values (multi-select). |
| [RButtonSize](/api/src_renderers_button_r_button_renderer/RButtonSize) | Button size variants. |
| [RButtonVariant](/api/src_renderers_button_r_button_renderer/RButtonVariant) | Button visual variants. |
| [RCheckboxControlAffinity](/api/src_renderers_checkbox_list_tile_r_checkbox_list_tile_spec/RCheckboxControlAffinity) | Placement of the checkbox relative to text content. |
| [RDropdownSize](/api/src_renderers_dropdown_r_dropdown_spec/RDropdownSize) | Dropdown size variants. |
| [RDropdownVariant](/api/src_renderers_dropdown_r_dropdown_spec/RDropdownVariant) | Dropdown visual variants. |
| [ROverlayPhase](/api/src_renderers_dropdown_r_dropdown_state/ROverlayPhase) | Overlay lifecycle phases. |
| [RSwitchControlAffinity](/api/src_renderers_switch_list_tile_r_switch_list_tile_spec/RSwitchControlAffinity) | Placement of the switch relative to text content. |
| [RTextFieldOverlayVisibilityMode](/api/src_renderers_textfield_r_text_field_overlay_visibility_mode/RTextFieldOverlayVisibilityMode) | Visibility mode for overlay elements in text fields (prefix, suffix, clear button). |
| [RTextFieldVariant](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldVariant) | TextField visual variants. |

## Functions {#section-functions}

| Function | Description |
|---|---|
| [mergeOverridesWithFallbacks](/api/src_renderers_style_merge/mergeOverridesWithFallbacks) | Merge multiple sugar layers into overrides with POLA priority. |
| [mergeStyleIntoOverrides\<TStyle, TOverride extends Object\>](/api/src_renderers_style_merge/mergeStyleIntoOverrides) | Merge a simple style object into [RenderOverrides](/api/src_renderers_render_overrides/RenderOverrides) with POLA priority. |

## Typedefs {#section-typedefs}

| Typedef |
|---|
| [SafeDropdownChevronBuilder](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownChevronBuilder) |
| [SafeDropdownEmptyStateBuilder](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownEmptyStateBuilder) |
| [SafeDropdownItemBuilder](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownItemBuilder) |
| [SafeDropdownItemContentBuilder](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownItemContentBuilder) |
| [SafeDropdownMenuSurfaceBuilder](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownMenuSurfaceBuilder) |
| [SafeDropdownTriggerBuilder](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownTriggerBuilder) |

