---
title: "headless_dropdown_button"
description: "API documentation for the headless_dropdown_button library"
outline: [2, 3]
---

# headless_dropdown_button

Headless dropdown button component.

Provides a single-selection dropdown that owns focus, keyboard navigation, overlay lifecycle, and listbox behavior, while visual rendering comes from a themed [RDropdownButtonRenderer](/api/src_renderers_dropdown_r_dropdown_button_renderer/RDropdownButtonRenderer).

## Usage {#usage}

```dart
RDropdownButton<String>(
  items: const ['Russia', 'United States'],
  itemAdapter: HeadlessItemAdapter.simple(
    id: (v) => ListboxItemId(v),
    titleText: (v) => v,
  ),
  value: selectedValue,
  onChanged: (value) => setState(() => selectedValue = value),
)
```

## Classes {#section-classes}

| Class | Description |
|---|---|
| [RDropdownButton\<T\>](/api/src_presentation_r_dropdown_button/RDropdownButton) | Headless dropdown button with single selection and themed rendering. |
| [RDropdownOption\<T\>](/api/src_presentation_r_dropdown_option/RDropdownOption) | Single option entry used by [RDropdownButton](/api/src_presentation_r_dropdown_button/RDropdownButton). |
| [RDropdownStyle](/api/src_presentation_r_dropdown_style/RDropdownStyle) | Simple, Flutter-like styling sugar for [RDropdownButton](/api/src_presentation_r_dropdown_button/RDropdownButton). |

