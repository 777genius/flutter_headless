---
title: "headless_material"
description: "API documentation for the headless_material library"
outline: [2, 3]
---

# headless_material

Material 3 preset for Headless components.

Provides Material-styled renderers and token resolvers that implement
the capability contracts from headless_contracts.

Usage:

```dart
HeadlessThemeProvider(
  theme: MaterialHeadlessTheme(),
  child: MyApp(),
)
```

For scoped theme changes:

```dart
HeadlessThemeProvider(
  theme: MaterialHeadlessTheme.dark(),
  child: DarkSection(),
)
```

## Classes {#section-classes}

| Class | Description |
|---|---|
| [HeadlessMaterialApp](/api/headless_material_app/HeadlessMaterialApp) | MaterialApp bootstrap for Headless. |
| [MaterialButtonOverrides](/api/src_overrides_material_button_overrides/MaterialButtonOverrides) | Preset-specific advanced overrides for Material buttons. |
| [MaterialButtonTokenResolver](/api/src_button_material_button_token_resolver/MaterialButtonTokenResolver) | Material 3 token resolver for Button components. |
| [MaterialCheckboxListTileRenderer](/api/src_checkbox_list_tile_material_checkbox_list_tile_renderer/MaterialCheckboxListTileRenderer) | Material 3 renderer for CheckboxListTile components. |
| [MaterialCheckboxListTileTokenResolver](/api/src_checkbox_list_tile_material_checkbox_list_tile_token_resolver/MaterialCheckboxListTileTokenResolver) | Material 3 token resolver for CheckboxListTile components. |
| [MaterialCheckboxRenderer](/api/src_checkbox_material_checkbox_renderer/MaterialCheckboxRenderer) | Material 3 renderer for Checkbox components. |
| [MaterialCheckboxTokenResolver](/api/src_checkbox_material_checkbox_token_resolver/MaterialCheckboxTokenResolver) | Material 3 token resolver for Checkbox components. |
| [MaterialDropdownOverrides](/api/src_overrides_material_dropdown_overrides/MaterialDropdownOverrides) | Preset-specific advanced overrides for Material dropdowns. |
| [MaterialDropdownRenderer](/api/src_dropdown_material_dropdown_renderer/MaterialDropdownRenderer) | Material 3 renderer for Dropdown components. |
| [MaterialDropdownTokenResolver](/api/src_dropdown_material_dropdown_token_resolver/MaterialDropdownTokenResolver) | Material 3 token resolver for Dropdown components. |
| [MaterialFlutterParityButtonRenderer](/api/src_button_material_flutter_parity_button_renderer/MaterialFlutterParityButtonRenderer) | Material parity renderer that delegates visual rendering to Flutter's own `FilledButton` / `OutlinedButton` widgets. |
| [MaterialHeadlessDefaults](/api/src_material_headless_defaults/MaterialHeadlessDefaults) | User-friendly defaults for MaterialHeadlessTheme. |
| [MaterialHeadlessTheme](/api/src_material_headless_theme/MaterialHeadlessTheme) | Material 3 theme preset for Headless components. |
| [MaterialListTileOverrides](/api/src_overrides_material_list_tile_overrides/MaterialListTileOverrides) | Preset-specific advanced overrides for Material list-tile-like components. |
| [MaterialParityButtonStateAdapter](/api/src_button_material_parity_button_state_adapter/MaterialParityButtonStateAdapter) | Maps [RButtonState](/api/src_renderers_button_r_button_renderer/RButtonState) to Flutter's `WidgetState` set for Material widgets. |
| [MaterialParityButtonStyleFactory](/api/src_button_material_parity_button_style_factory/MaterialParityButtonStyleFactory) | Builds a `ButtonStyle` delta from [RButtonOverrides](/api/src_renderers_button_r_button_overrides/RButtonOverrides). |
| [MaterialParityFocusOverlay](/api/src_button_material_parity_focus_overlay/MaterialParityFocusOverlay) | Focus overlay that matches M3 InkWell focus highlight. |
| [MaterialParityFocusOverlayResolver](/api/src_button_material_parity_focus_overlay_resolver/MaterialParityFocusOverlayResolver) | Resolves M3 focus overlay colors and border sides for the parity renderer. |
| [MaterialTapTargetPolicy](/api/src_accessibility_material_tap_target_policy/MaterialTapTargetPolicy) | Material tap target policy based on Flutter's `ButtonStyleButton._InputPadding`. |
| [MaterialTextFieldAffixVisibilityResolver](/api/src_textfield_material_text_field_affix_visibility_resolver/MaterialTextFieldAffixVisibilityResolver) | Resolves prefix/suffix visibility based on [RTextFieldOverlayVisibilityMode](/api/src_renderers_textfield_r_text_field_overlay_visibility_mode/RTextFieldOverlayVisibilityMode) and current [RTextFieldState](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldState). |
| [MaterialTextFieldDecorationFactory](/api/src_textfield_material_text_field_decoration_factory/MaterialTextFieldDecorationFactory) | Builds `InputDecoration` from [RTextFieldSpec](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldSpec), [RTextFieldSlots](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldSlots), and interaction state. |
| [MaterialTextFieldInputDecorator](/api/src_textfield_material_text_field_input_decorator/MaterialTextFieldInputDecorator) | Thin `StatelessWidget` wrapper over `InputDecorator`. |
| [MaterialTextFieldOverrides](/api/src_overrides_material_text_field_overrides/MaterialTextFieldOverrides) | Preset-specific advanced overrides for Material text fields. |
| [MaterialTextFieldRenderer](/api/src_textfield_material_text_field_renderer/MaterialTextFieldRenderer) | Material 3 renderer for TextField components. |
| [MaterialTextFieldStateAdapter](/api/src_textfield_material_text_field_state_adapter/MaterialTextFieldStateAdapter) | Adapts [RTextFieldState](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldState) to the flag set expected by `InputDecorator`. |
| [MaterialTextFieldTokenResolver](/api/src_textfield_material_text_field_token_resolver/MaterialTextFieldTokenResolver) | Material 3 token resolver for TextField components. |

## Enums {#section-enums}

| Enum | Description |
|---|---|
| [MaterialComponentDensity](/api/src_overrides_material_override_types/MaterialComponentDensity) | Density knobs for Material components. |
| [MaterialCornerStyle](/api/src_overrides_material_override_types/MaterialCornerStyle) | Corner radius policy for Material components. |

