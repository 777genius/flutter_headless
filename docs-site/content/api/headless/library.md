---
title: "headless"
description: "API documentation for the headless library"
outline: [2, 3]
---

# headless

Unified facade package for Headless.

Use `package:headless/headless.dart` when you want the golden path import that re-exports the most common runtime, theme, preset, and component APIs.

## What this package exports {#what-this-package-exports}

- Core runtime: `headless_foundation`, `headless_contracts`, `headless_theme`
- Tokens: `headless_tokens`
- Presets: `headless_material`, `headless_cupertino`
- Ready-to-use components: `headless_button`, `headless_checkbox`, `headless_switch`, `headless_dropdown_button`, `headless_textfield`, `headless_autocomplete`

## Quick start {#quick-start}

```dart
import 'package:headless/headless.dart';

HeadlessThemeProvider(
  theme: MaterialHeadlessTheme(),
  child: RTextButton(
    onPressed: () {},
    child: const Text('Continue'),
  ),
)
```

## When to import narrower packages {#narrower-packages}

Import a specific package such as `package:headless_button/headless_button.dart` or `package:headless_theme/headless_theme.dart` when you want tighter dependency boundaries or only need one slice of the public API.
