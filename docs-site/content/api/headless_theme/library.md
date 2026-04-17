---
title: "headless_theme"
description: "API documentation for the headless_theme library"
outline: [2, 3]
---

# headless_theme

Capability-based theme runtime and overrides for Headless.

## Classes {#section-classes}

| Class | Description |
|---|---|
| [CapabilityOverrides](/api/src_theme_capability_overrides/CapabilityOverrides) | Type-safe override bag for theme capabilities. |
| [CapabilityOverridesBuilder](/api/src_theme_capability_overrides/CapabilityOverridesBuilder) | Builder for [CapabilityOverrides](/api/src_theme_capability_overrides/CapabilityOverrides). |
| [HeadlessApp](/api/headless_app/HeadlessApp) | Universal bootstrap for Headless. |
| [HeadlessButtonScope](/api/scopes/HeadlessButtonScope) | Scoped capability overrides for buttons without generics. |
| [HeadlessCheckboxListTileScope](/api/scopes/HeadlessCheckboxListTileScope) | Scoped capability overrides for checkbox list tiles without generics. |
| [HeadlessCheckboxScope](/api/scopes/HeadlessCheckboxScope) | Scoped capability overrides for checkboxes without generics. |
| [HeadlessDropdownScope](/api/scopes/HeadlessDropdownScope) | Scoped capability overrides for dropdowns without generics. |
| [HeadlessMissingCapabilityWidget](/api/src_diagnostics_headless_missing_capability_widget/HeadlessMissingCapabilityWidget) | Fallback widget shown when a required Headless capability is missing. |
| [HeadlessMotionDefaults](/api/src_motion_headless_motion_defaults/HeadlessMotionDefaults) | Centralized motion defaults for Headless presets. |
| [HeadlessMotionTheme](/api/src_motion_headless_motion_theme/HeadlessMotionTheme) | App-level motion theme for Headless. |
| [HeadlessPressableSurfaceFactory](/api/src_interaction_headless_pressable_surface_factory/HeadlessPressableSurfaceFactory) | Capability interface for creating pressable surface wrappers. |
| [HeadlessTapTargetPolicy](/api/src_accessibility_headless_tap_target_policy/HeadlessTapTargetPolicy) | Contract for platform-specific minimum tap target sizing. |
| [HeadlessTextFieldScope](/api/scopes/HeadlessTextFieldScope) | Scoped capability overrides for text fields without generics. |
| [HeadlessTheme](/api/src_theme_headless_theme/HeadlessTheme) | Root capability discovery contract (v1 skeleton). |
| [HeadlessThemeOverridesScope](/api/src_theme_headless_theme_overrides_scope/HeadlessThemeOverridesScope) | Scoped capability overrides for a subtree. |
| [HeadlessThemeProvider](/api/src_theme_headless_theme_provider/HeadlessThemeProvider) | Provides [HeadlessTheme](/api/src_theme_headless_theme/HeadlessTheme) to descendant widgets. |
| [HeadlessThemeWithOverrides](/api/src_theme_headless_theme_with_overrides/HeadlessThemeWithOverrides) | Headless theme wrapper that overrides specific capabilities. |
| [HeadlessWidgetStateQuery](/api/src_widget_states_headless_widget_state_query/HeadlessWidgetStateQuery) | Canonical WidgetState interpretation for token resolvers. |

## Exceptions {#section-exceptions}

| Exception | Description |
|---|---|
| [MissingCapabilityException](/api/src_theme_require_capability/MissingCapabilityException) | Exception thrown when a required capability is missing from the theme. |
| [MissingThemeException](/api/src_theme_headless_theme_provider/MissingThemeException) | Exception thrown when [HeadlessThemeProvider](/api/src_theme_headless_theme_provider/HeadlessThemeProvider) is not found in the widget tree. |

## Enums {#section-enums}

| Enum | Description |
|---|---|
| [HeadlessDropdownItemVisualState](/api/src_widget_states_headless_dropdown_item_visual_state/HeadlessDropdownItemVisualState) | Canonical “dominant” visual state for a dropdown menu item. |
| [HeadlessDropdownTriggerVisualState](/api/src_widget_states_headless_dropdown_trigger_visual_state/HeadlessDropdownTriggerVisualState) | Canonical “dominant” visual state for dropdown trigger. |
| [HeadlessInteractionVisualState](/api/src_widget_states_headless_interaction_visual_state/HeadlessInteractionVisualState) | Canonical “dominant” interaction state for visuals. |
| [HeadlessTapTargetComponent](/api/src_accessibility_headless_tap_target_policy/HeadlessTapTargetComponent) | Component types that can have a custom tap target size. |

## Functions {#section-functions}

| Function | Description |
|---|---|
| [headlessGoldenPathHint](/api/src_diagnostics_headless_setup_hints/headlessGoldenPathHint) | Returns the recommended setup hint for fixing a missing Headless capability. |
| [headlessMissingCapabilityWidgetMessage](/api/src_diagnostics_headless_setup_hints/headlessMissingCapabilityWidgetMessage) | Builds the debug/diagnostic message shown when a required capability is missing. |
| [requireCapability\<T\>](/api/src_theme_require_capability/requireCapability) | Require a capability from the theme, throwing a standardized error if missing. |
| [resolveDropdownItemVisualState](/api/src_widget_states_headless_dropdown_item_visual_state/resolveDropdownItemVisualState) | Resolves the dominant visual state for a dropdown menu item from the current widget states. |
| [resolveDropdownTriggerVisualState](/api/src_widget_states_headless_dropdown_trigger_visual_state/resolveDropdownTriggerVisualState) | Resolves the dominant visual state for a dropdown trigger from the current widget states. |

