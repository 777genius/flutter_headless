---
layout: home
title: "Headless"
description: "Flutter UI building blocks with consistent behavior and accessibility"
hero:
  name: "Headless"
  text: Reusable Logic, Any Visual
  tagline: Write behavior once - focus, keyboard, accessibility, state. Style it however you want, in every project.
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
    title: Fully Customizable
    details: Ship Material, Cupertino, or a completely custom look from the same component set. Perfect for package authors - your users restyle everything via renderers, tokens, and slots without forking your code.
  - icon: "\u2328\uFE0F"
    title: Keyboard & A11y
    details: Focus management, keyboard navigation, and state transitions live in headless_foundation. Semantics contracts are defined in headless_contracts and implemented by each renderer.
  - icon: "\U0001F527"
    title: Slots & Overrides
    details: Customize any part of a component per-instance via slots, style overrides, or scoped themes without touching the source.
---

## Install

```bash
flutter pub add headless
# or
flutter pub add headless_button headless_checkbox headless_switch headless_dropdown_button headless_textfield headless_autocomplete
```

[View on pub.dev](https://pub.dev/packages/headless)

## Quick Start

<Tabs defaultValue="material">
  <TabItem label="Material" value="material">

Ready-to-use Material 3 theme out of the box. Just wrap your app and start building - all components get Material styling automatically. Switch to a custom theme later without changing any widget code.

```dart
import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

void main() => runApp(const HeadlessMaterialApp(home: Demo()));

class Demo extends StatelessWidget {
  const Demo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        RTextButton(
          onPressed: () {},
          child: const Text('Save'),
        ),
        RDropdownButton<String>(
          items: const ['Paris', 'Berlin', 'Tokyo'],
          itemAdapter: HeadlessItemAdapter.simple(
            id: (v) => ListboxItemId(v),
            titleText: (v) => v,
          ),
          value: 'Paris',
          onChanged: (_) {},
        ),
        RCheckboxListTile(
          value: true,
          onChanged: (_) {},
          title: const Text('I agree'),
        ),
      ]),
    );
  }
}
```

  </TabItem>
  <TabItem label="Cupertino" value="cupertino">

Same components, iOS look. Replace `HeadlessMaterialApp` with `HeadlessCupertinoApp` - every widget automatically renders with Cupertino styling. Your code stays the same.

```dart
import 'package:flutter/cupertino.dart';
import 'package:headless/headless.dart';

void main() => runApp(const HeadlessCupertinoApp(home: Demo()));

class Demo extends StatelessWidget {
  const Demo({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Headless')),
      child: SafeArea(
        child: Column(children: [
          RTextButton(onPressed: () {}, child: const Text('Save')),
          RDropdownButton<String>(
            items: const ['Paris', 'Berlin', 'Tokyo'],
            itemAdapter: HeadlessItemAdapter.simple(
              id: (v) => ListboxItemId(v),
              titleText: (v) => v,
            ),
            value: 'Paris',
            onChanged: (_) {},
          ),
        ]),
      ),
    );
  }
}
```

  </TabItem>
  <TabItem label="Gradient Button" value="gradient">

Customize a single widget without creating a renderer. Slots let you override any visual part (surface, icon, spinner) per-instance while keeping all behavior intact.

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
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: child,
      ),
    ),
  ),
  child: const Text('Upgrade'),
)
```

  </TabItem>
  <TabItem label="Brand Override" value="brand">

Start with Material as a base and swap renderers for specific components. Perfect when you want Material defaults but need a custom look for buttons or dropdowns in certain screens.

```dart
void main() => runApp(HeadlessMaterialApp(
  home: HeadlessThemeOverridesScope(
    overrides: CapabilityOverrides.build((b) {
      b.set<RButtonRenderer>(MyBrandButtonRenderer());
      b.set<RDropdownButtonRenderer>(MyBrandDropdownRenderer());
    }),
    child: const MyApp(),
  ),
));
```

  </TabItem>
  <TabItem label="Own Renderer" value="renderer">

Full control from scratch. Create your own theme by implementing `HeadlessTheme` - register custom renderers and token resolvers for every component. The same `RTextButton`, `RCheckbox` widgets render with your design.

```dart
class NeonTheme extends HeadlessTheme {
  final _capabilities = <Type, Object>{
    RButtonRenderer: NeonButtonRenderer(),
    RButtonTokenResolver: NeonButtonTokenResolver(),
    RCheckboxRenderer: NeonCheckboxRenderer(),
    RCheckboxTokenResolver: NeonCheckboxTokenResolver(),
  };

  @override
  T? capability<T>() => _capabilities[T] as T?;
}

void main() => runApp(HeadlessApp(
  theme: NeonTheme(),
  appBuilder: (overlayBuilder) => MaterialApp(
    builder: overlayBuilder,
    home: const MyApp(),
  ),
));

// Same RTextButton, RCheckbox widgets - completely different look
```

  </TabItem>
</Tabs>

## Components

| Component | Package | Description |
|---|---|---|
| [Button](/api/headless_button/library) | `headless_button` | Filled, outlined, tonal, and text variants with icon and loading support |
| [Checkbox](/api/headless_checkbox/library) | `headless_checkbox` | Checkbox and checkbox list tile |
| [Switch](/api/headless_switch/library) | `headless_switch` | Toggle switch with interaction states |
| [Dropdown](/api/headless_dropdown_button/library) | `headless_dropdown_button` | Menu overlay with keyboard navigation and typeahead |
| [TextField](/api/headless_textfield/library) | `headless_textfield` | Input field with validation and editing controllers |
| [Autocomplete](/api/headless_autocomplete/library) | `headless_autocomplete` | Combobox with async sources and filtering |

## Customization

<Tabs defaultValue="style">
  <TabItem label="Style" value="style">

Quick visual tweaks - colors, radii, spacing:

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

  </TabItem>
  <TabItem label="Slots" value="slots">

Replace structure per-instance - wrap, decorate, or swap any part:

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

  </TabItem>
  <TabItem label="Scoped Theme" value="scoped">

Override renderers, tokens, or policies for an entire subtree:

```dart
HeadlessThemeOverridesScope(
  overrides: CapabilityOverrides.build((b) {
    b.set<RButtonRenderer>(MyBrandButtonRenderer());
  }),
  child: MyFeatureScreen(),
)
```

:::info
All buttons inside `MyFeatureScreen` will use `MyBrandButtonRenderer` without any per-widget changes.
:::

  </TabItem>
</Tabs>

## Packages

| Package | Role |
|---|---|
| [`headless`](/api/headless/library) | All-in-one facade - single import for apps |
| [`headless_foundation`](/api/headless_foundation/library) | Overlay, focus, listbox, FSM, state resolution |
| [`headless_contracts`](/api/headless_contracts/library) | Renderer contracts and slot overrides |
| [`headless_tokens`](/api/headless_tokens/library) | Raw + semantic design tokens (pure Dart) |
| [`headless_theme`](/api/headless_theme/library) | Capability-based theme runtime |
| [`headless_material`](/api/headless_material/library) | Material 3 preset (renderers + tokens) |
| [`headless_cupertino`](/api/headless_cupertino/library) | Cupertino preset (renderers + tokens) |
| [`headless_test`](/api/headless_test/library) | A11y, overlay, focus, keyboard test helpers |

## Why Headless?

:::info The problem
When every team member writes custom widgets, behavior drifts: different hover/focus/disabled states, inconsistent keyboard handling, duplicated overlay logic. Headless provides **contracts and mechanisms** so the right path is the easy path.
:::

- **One component, many brands** - swap renderers, tokens, or the entire theme without forking
- **Edge cases handled once** - focus traps, nested overlays, dismiss-on-outside-click live in `headless_foundation`
- **Predictable by design** - POLA is enforced through controlled/uncontrolled models and explicit state priorities
- **Testable behavior** - test state transitions, callbacks, a11y semantics, and keyboard scenarios without pixel matching

## Built-in Presets

Headless ships with two ready-made renderer presets. Same components, different visuals:

<Tabs defaultValue="material">
  <TabItem label="Material 3" value="material">

```dart
import 'package:headless/headless.dart';

// Material look out of the box
void main() => runApp(const HeadlessMaterialApp(home: MyApp()));
```

  </TabItem>
  <TabItem label="Cupertino" value="cupertino">

```dart
import 'package:headless/headless.dart';

// iOS look - same components, different renderer
void main() => runApp(const HeadlessCupertinoApp(home: MyApp()));
```

  </TabItem>
</Tabs>

:::tip
Both presets use the exact same `RTextButton`, `RDropdownButton`, `RCheckbox` etc. - only the renderer changes.
:::

[Open Demo App](https://777genius.github.io/flutter_headless/demo/)

Current demo screens include Button, Dropdown, Autocomplete, TextField, Phone Field, Pinput, Switch, Glassmorphism, and Intentional Errors.

## Inspired By

| Project | What we borrowed |
|---|---|
| [React Aria](https://react-spectrum.adobe.com/react-aria/) | Parts/slots composition, unified press events across pointer/keyboard/assistive tech |
| [Ark UI / Zag.js](https://ark-ui.com/) | Minimal FSM discipline - "impossible states are impossible" |
| [Radix UI](https://www.radix-ui.com/) | Typed slots for point-wise overrides without full renderer rewrite |
| [Downshift](https://www.downshift-js.com/) | Controlled/uncontrolled pattern, stateReducer for intercepting transitions |
| [Angular CDK](https://material.angular.io/cdk/) | Overlay infrastructure - OverlayRef + positioning strategies |
| [Floating UI](https://floating-ui.com/) | Middleware pipeline for offset/flip/shift/arrow composition |
| [Forui](https://forui.dev/) | FWidgetStateMap for state combination handling |
| [W3C Design Tokens](https://tr.designtokens.org/) | Token format standardization, group inheritance ($extends) |

## Learn More

- [Why Headless in depth](/guide/headless_workspace/WHY_HEADLESS) - detailed comparison with "just write custom widgets"
- [Getting Started](/guide/headless_workspace/users/COOKBOOK) - install, configure, and build your first app
- [Cookbook](/guide/headless_workspace/users/COOKBOOK) - common recipes and patterns
- [GitHub](https://github.com/777genius/flutter_headless) - source code, issues, contributing
