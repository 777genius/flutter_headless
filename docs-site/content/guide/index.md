# Headless Guide

Learn how to use Headless to build Flutter UI with consistent behavior, accessibility, and swappable visuals.

## Getting Started

```yaml
dependencies:
  headless: ^1.0.0
```

```dart
import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

void main() => runApp(const HeadlessMaterialApp(home: MyApp()));
```

## Key Concepts

### Behavior vs Visuals

Headless separates **what a component does** (focus, keyboard, state transitions, accessibility) from **how it looks** (colors, shapes, animations). Behavior lives in `headless_foundation`, visuals are pluggable via renderer contracts.

### Renderers

A renderer decides the structure and appearance of a component. Headless ships two presets:

- **Material 3** (`headless_material`) - follows Material Design guidelines
- **Cupertino** (`headless_cupertino`) - follows Apple HIG

You can create your own renderer by implementing the renderer contract for any component.

### Customization Levels

| Level | When to use | Example |
|---|---|---|
| **Style** | Quick visual tweaks (colors, radii) | `style: RDropdownStyle(menuBorderRadius: ...)` |
| **Slots** | Replace structure per-instance | `slots: RButtonSlots(surface: Decorate(...))` |
| **Scoped Theme** | Override capabilities for a subtree | `HeadlessThemeOverridesScope(...)` |
| **Custom Renderer** | Full control over structure and visuals | Implement `RButtonRenderer` |

### Tokens

Design tokens are split into two layers:

- **Raw tokens** - primitive values (colors, spacing, radii, durations)
- **Semantic tokens** - contextual meanings (`actionPrimaryBg`, `surfaceRaisedBg`)

Tokens are pure Dart and live in `headless_tokens`.

## Guides

- [Why Headless?](/guide/WHY_HEADLESS) - when it makes sense and when it doesn't
- [Users Guide](/guide/users/README) - complete walkthrough for app developers
- [Cookbook](/guide/users/COOKBOOK) - common recipes and patterns
- [Guardrails](/guide/users/GUARDRAILS) - safe customization boundaries
- [Changelog](/guide/CHANGELOG) - what changed between versions
