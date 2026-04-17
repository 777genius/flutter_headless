---
title: "headless_cupertino"
description: "API documentation for the headless_cupertino library"
outline: [2, 3]
---

# headless_cupertino

Cupertino (iOS) preset for Headless components.

Provides iOS-styled renderers and token resolvers that implement
the capability contracts from headless_contracts.

Usage:

```dart
HeadlessThemeProvider(
  theme: CupertinoHeadlessTheme(),
  child: MyApp(),
)
```

For scoped theme changes:

```dart
HeadlessThemeProvider(
  theme: CupertinoHeadlessTheme.dark(),
  child: DarkSection(),
)
```

## Classes {#section-classes}

| Class | Description |
|---|---|
| [CupertinoButtonOverrides](/api/src_overrides_cupertino_button_overrides/CupertinoButtonOverrides) | Preset-specific advanced overrides for Cupertino buttons. |
| [CupertinoButtonParityConstants](/api/src_button_cupertino_button_parity_constants/CupertinoButtonParityConstants) | Constants pinned from Flutter's CupertinoButton source (revision 8b87286849). |
| [CupertinoButtonTokenResolver](/api/src_button_cupertino_button_token_resolver/CupertinoButtonTokenResolver) | Cupertino token resolver for Button components. |
| [CupertinoCheckboxListTileRenderer](/api/src_checkbox_list_tile_cupertino_checkbox_list_tile_renderer/CupertinoCheckboxListTileRenderer) | Cupertino renderer for CheckboxListTile components. |
| [CupertinoCheckboxListTileTokenResolver](/api/src_checkbox_list_tile_cupertino_checkbox_list_tile_token_resolver/CupertinoCheckboxListTileTokenResolver) | Cupertino token resolver for CheckboxListTile components. |
| [CupertinoCheckboxRenderer](/api/src_checkbox_cupertino_checkbox_renderer/CupertinoCheckboxRenderer) | Cupertino renderer for Checkbox components. |
| [CupertinoCheckboxTokenResolver](/api/src_checkbox_cupertino_checkbox_token_resolver/CupertinoCheckboxTokenResolver) | Cupertino token resolver for Checkbox components. |
| [CupertinoDropdownOverrides](/api/src_overrides_cupertino_dropdown_overrides/CupertinoDropdownOverrides) | Preset-specific advanced overrides for Cupertino dropdowns. |
| [CupertinoDropdownRenderer](/api/src_dropdown_cupertino_dropdown_renderer/CupertinoDropdownRenderer) | Cupertino renderer for Dropdown components. |
| [CupertinoDropdownTokenResolver](/api/src_dropdown_cupertino_dropdown_token_resolver/CupertinoDropdownTokenResolver) | Cupertino token resolver for Dropdown components. |
| [CupertinoFlutterParityButtonRenderer](/api/src_button_cupertino_flutter_parity_button_renderer/CupertinoFlutterParityButtonRenderer) | Cupertino parity renderer — visual port of Flutter's `CupertinoButton`. |
| [CupertinoHeadlessTheme](/api/src_cupertino_headless_theme/CupertinoHeadlessTheme) | Cupertino (iOS) theme preset for Headless components. |
| [CupertinoMenuItem](/api/src_primitives_cupertino_menu_item/CupertinoMenuItem) | Lightweight Cupertino-styled menu row used by dropdown/popover item renderers. |
| [CupertinoPopoverSurface](/api/src_primitives_cupertino_popover_surface/CupertinoPopoverSurface) | Cupertino popover container surface for menu overlays. |
| [CupertinoPressableOpacity](/api/src_primitives_cupertino_pressable_opacity/CupertinoPressableOpacity) | Press feedback wrapper that applies Cupertino-like opacity changes on interaction. |
| [CupertinoPressableSurface](/api/src_primitives_cupertino_pressable_surface/CupertinoPressableSurface) | Cupertino implementation of [HeadlessPressableSurfaceFactory](/api/src_interaction_headless_pressable_surface_factory/HeadlessPressableSurfaceFactory). |
| [CupertinoTapTargetPolicy](/api/src_accessibility_cupertino_tap_target_policy/CupertinoTapTargetPolicy) | Cupertino tap target policy based on Apple HIG minimum 44x44 points. |
| [CupertinoTextFieldAffix](/api/src_primitives_textfield_cupertino_text_field_affix/CupertinoTextFieldAffix) | Wrapper for prefix/suffix widgets with visibility mode support. |
| [CupertinoTextFieldClearButton](/api/src_primitives_textfield_cupertino_text_field_clear_button/CupertinoTextFieldClearButton) | Cupertino-styled clear button for text fields. |
| [CupertinoTextFieldOverrides](/api/src_overrides_cupertino_text_field_overrides/CupertinoTextFieldOverrides) | Preset-specific advanced overrides for Cupertino text fields. |
| [CupertinoTextFieldRenderer](/api/src_textfield_cupertino_text_field_renderer/CupertinoTextFieldRenderer) | Cupertino renderer for TextField components. |
| [CupertinoTextFieldSurface](/api/src_primitives_textfield_cupertino_text_field_surface/CupertinoTextFieldSurface) | Cupertino-styled container surface for text fields. |
| [CupertinoTextFieldTokenResolver](/api/src_textfield_cupertino_text_field_token_resolver/CupertinoTextFieldTokenResolver) | Cupertino token resolver for TextField components. |
| [HeadlessCupertinoApp](/api/headless_cupertino_app/HeadlessCupertinoApp) | CupertinoApp bootstrap for Headless. |
| [RCupertinoTextField](/api/src_textfield_r_cupertino_text_field/RCupertinoTextField) | Cupertino-styled text field with DX-friendly API. |

## Enums {#section-enums}

| Enum | Description |
|---|---|
| [CupertinoComponentDensity](/api/src_overrides_cupertino_override_types/CupertinoComponentDensity) | Density knobs for Cupertino components. |
| [CupertinoCornerStyle](/api/src_overrides_cupertino_override_types/CupertinoCornerStyle) | Corner radius policy for Cupertino components. |

