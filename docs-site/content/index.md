---
layout: home
title: "Headless"
description: "Flutter UI building blocks with consistent behavior and accessibility"
hero:
  name: "Headless"
  text: Flutter UI Building Blocks
  tagline: Consistent behavior and accessibility. Material, Cupertino, or your own visuals.
  actions:
    - theme: brand
      text: Quick Start
      link: /guide/
    - theme: alt
      text: API Reference
      link: /api/
features:
  - icon: "\U0001F9E9"
    title: Headless Architecture
    details: Behavior, keyboard handling, and accessibility are separated from visuals. Swap renderers without forking logic.
  - icon: "\U0001F3A8"
    title: Multi-Brand Ready
    details: Ship Material, Cupertino, or a fully custom look from the same component set. No conditional branches or duplicated widgets.
  - icon: "\u2328\uFE0F"
    title: Keyboard & A11y
    details: Focus management, keyboard navigation, and state transitions live in headless_foundation. Semantics contracts are defined in headless_contracts and implemented by each renderer.
  - icon: "\U0001F527"
    title: Slots & Overrides
    details: Customize any part of a component per-instance via slots, style overrides, or scoped themes without touching the source.
---

## Why Headless?

When every team member writes custom widgets, behavior drifts fast: different hover/focus/disabled states, inconsistent keyboard handling, duplicated overlay logic. Headless fixes this by providing **contracts and mechanisms** rather than just a set of styled buttons.

- One component, many brands - swap renderers, tokens, or the entire theme without forking.
- Edge cases handled once - focus traps, nested overlays, dismiss-on-outside-click live in `headless_foundation`.
- Predictable by design - POLA (Principle of Least Astonishment) is enforced through controlled/uncontrolled models and explicit state priorities.

## 60-Second Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

void main() => runApp(const HeadlessMaterialApp(home: Demo()));

class Demo extends StatelessWidget {
  const Demo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RTextButton(
          onPressed: () {},
          child: const Text('Hello Headless'),
        ),
      ),
    );
  }
}
```

## Components

| Component | Package | Description |
|---|---|---|
| Button | `headless_button` | Text, icon, and loading button variants |
| Checkbox | `headless_checkbox` | Checkbox and checkbox list tile |
| Switch | `headless_switch` | Toggle switch with interaction states |
| Dropdown | `headless_dropdown_button` | Menu overlay with keyboard navigation and typeahead |
| TextField | `headless_textfield` | Input field with validation and editing controllers |
| Autocomplete | `headless_autocomplete` | Combobox with async sources and filtering |

## Package Architecture

```
headless                  # Facade - single import for apps
headless_foundation       # Overlay, focus, listbox, FSM, state resolution
headless_contracts        # Renderer contracts and slot overrides
headless_tokens           # Raw + semantic design tokens (pure Dart)
headless_theme            # Capability-based theme runtime
headless_material         # Material 3 preset (renderers + tokens)
headless_cupertino        # Cupertino preset (renderers + tokens)
headless_test             # A11y, overlay, focus, keyboard test helpers
anchored_overlay_engine   # Overlay positioning, policies, lifecycle
```

## Customization Levels

### 1. Style (quick visual tweak)

```dart
RDropdownButton<String>(
  items: cities,
  style: const RDropdownStyle(
    menuBackgroundColor: Color(0xFFFFFFFF),
    menuBorderRadius: BorderRadius.all(Radius.circular(12)),
  ),
  // ...
)
```

### 2. Slots (structural override per-instance)

```dart
RTextButton(
  onPressed: () {},
  slots: RButtonSlots(
    surface: Decorate(
      (ctx, child) => DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4B6FFF), Color(0xFF7B4BFF)],
          ),
        ),
        child: child,
      ),
    ),
  ),
  child: const Text('Upgrade'),
)
```

### 3. Scoped Theme (override capabilities for a subtree)

Wrap any subtree with a scoped theme to swap renderers, tokens, or interaction policies without touching individual widgets.

## When Headless Is a Good Fit

- 2+ brands (white-label) or product lines sharing a component set
- Multiple teams building UI in parallel and needing consistent behavior
- Complex interactive components (select, menu, dialog, autocomplete)
- Apps where accessibility and keyboard support are requirements, not afterthoughts
- A component library that needs to live and evolve for years

## When It Might Be Overkill

- One small app with default Material widgets
- No need for keyboard/a11y or overlay-heavy components
- No plans to customize visuals or share components across brands
