# headless

Facade package for the Headless ecosystem.

`headless` gives you the standard Headless setup from a single dependency:

- behavior-first UI components
- Material and Cupertino presets
- the shared runtime for focus, keyboard, overlay, slots, and visual overrides

Use this package when you want one import surface for most application code.

## Install

```yaml
dependencies:
  headless: ^1.0.0
```

## What you get

`headless` re-exports:

- tokens, foundation, contracts, and theme runtime
- `HeadlessMaterialApp`, `HeadlessCupertinoApp`, and `HeadlessApp`
- `RTextButton`, `RCheckbox`, `RSwitch`, `RDropdownButton`, `RTextField`, and `RAutocomplete`

The goal is simple:

- keep behavior and accessibility consistent
- swap presets without rewriting component logic
- customize visuals with slots and overrides instead of forking behavior

## Quick start

```dart
import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

void main() {
  runApp(const HeadlessMaterialApp(home: Demo()));
}

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  bool enabled = true;
  String? fruit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RTextButton(
              onPressed: () => setState(() => enabled = !enabled),
              child: Text(enabled ? 'Disable' : 'Enable'),
            ),
            const SizedBox(height: 16),
            RSwitch(
              value: enabled,
              onChanged: (value) => setState(() => enabled = value),
            ),
            const SizedBox(height: 16),
            RDropdownButton<String>(
              value: fruit,
              onChanged: enabled ? (value) => setState(() => fruit = value) : null,
              items: const ['apple', 'banana', 'cherry'],
              itemAdapter: HeadlessItemAdapter.simple(
                id: (value) => ListboxItemId(value),
                titleText: (value) => value,
              ),
              placeholder: 'Pick a fruit',
            ),
          ],
        ),
      ),
    );
  }
}
```

## Customization model

Prefer this order:

1. preset defaults
2. `style:` convenience APIs
3. `overrides: RenderOverrides(...)`
4. `slots:` with `Decorate(...)`

That keeps behavior in Headless while still giving you control over visuals and structure.

## When to use the facade package

Pick `headless` when:

- you are building an app, not a preset package
- you want one dependency for common components
- you want to start with Material or Cupertino and customize later

Pick individual packages when:

- you are building a custom preset or design system package
- you want a very narrow dependency surface
- you only need one or two Headless components
