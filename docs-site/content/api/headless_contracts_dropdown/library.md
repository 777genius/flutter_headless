---
title: "dropdown"
description: "API documentation for the dropdown library"
outline: [2, 3]
---

# dropdown

Dropdown renderer contracts.

## Classes {#section-classes}

| Class | Description |
|---|---|
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
| [SafeDropdownChevronContext](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownChevronContext) |  |
| [SafeDropdownEmptyStateContext](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownEmptyStateContext) |  |
| [SafeDropdownItemContentContext](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownItemContentContext) |  |
| [SafeDropdownItemContext](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownItemContext) |  |
| [SafeDropdownMenuSurfaceContext](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownMenuSurfaceContext) |  |
| [SafeDropdownRenderer](/api/src_renderers_dropdown_safe_dropdown_renderer/SafeDropdownRenderer) | Safe scaffold for full dropdown renderer customization. |
| [SafeDropdownTriggerContext](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownTriggerContext) |  |

## Enums {#section-enums}

| Enum | Description |
|---|---|
| [RDropdownSize](/api/src_renderers_dropdown_r_dropdown_spec/RDropdownSize) | Dropdown size variants. |
| [RDropdownVariant](/api/src_renderers_dropdown_r_dropdown_spec/RDropdownVariant) | Dropdown visual variants. |
| [ROverlayPhase](/api/src_renderers_dropdown_r_dropdown_state/ROverlayPhase) | Overlay lifecycle phases. |

## Typedefs {#section-typedefs}

| Typedef |
|---|
| [SafeDropdownChevronBuilder](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownChevronBuilder) |
| [SafeDropdownEmptyStateBuilder](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownEmptyStateBuilder) |
| [SafeDropdownItemBuilder](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownItemBuilder) |
| [SafeDropdownItemContentBuilder](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownItemContentBuilder) |
| [SafeDropdownMenuSurfaceBuilder](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownMenuSurfaceBuilder) |
| [SafeDropdownTriggerBuilder](/api/src_renderers_dropdown_safe_dropdown_contexts/SafeDropdownTriggerBuilder) |

