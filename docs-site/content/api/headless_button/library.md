---
title: "headless_button"
description: "API documentation for the headless_button library"
outline: [2, 3]
---

# headless_button

Headless Button component.

Provides [RTextButton](/api/src_presentation_r_text_button/RTextButton) - a button component that handles all behavior
(focus, keyboard, pointer input) but delegates visual rendering to
a [RButtonRenderer](/api/src_renderers_button_r_button_renderer/RButtonRenderer) capability from the theme.

## Usage {#usage}

```dart
RTextButton(
  onPressed: () => print('Pressed!'),
  child: Text('Click me'),
)
```

## Renderer Required {#renderer-required}

This component requires a [RButtonRenderer](/api/src_renderers_button_r_button_renderer/RButtonRenderer) capability from
[HeadlessThemeProvider](/api/src_theme_headless_theme_provider/HeadlessThemeProvider). In debug, missing capabilities trigger a
standardized error. In release, the component renders a diagnostic
placeholder instead of crashing.

## Classes {#section-classes}

| Class | Description |
|---|---|
| [RButtonStyle](/api/src_presentation_r_button_style/RButtonStyle) | Simple, Flutter-like styling sugar for [RTextButton](/api/src_presentation_r_text_button/RTextButton). |
| [RTextButton](/api/src_presentation_r_text_button/RTextButton) | A headless text button component. |

