---
sidebar_position: 2
sidebar_label: "Getting Started"
---
# Users Guide

This guide is for people who want to ship UI quickly. If you are building
new components or presets, go to `docs/contributors/README.md`.

## One-screen quick start

This single file renders a button and a dropdown using the Material preset.

```dart
import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

void main() {
  runApp(const HeadlessMaterialApp(home: DemoScreen()));
}

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RTextButton(
              onPressed: () {},
              child: const Text('Save'),
            ),
            const SizedBox(height: 16),
            RDropdownButton<String>(
              items: const ['Paris', 'Berlin', 'Tokyo'],
              itemAdapter: HeadlessItemAdapter.simple(
                id: (v) => ListboxItemId(v),
                titleText: (v) => v,
              ),
              value: 'Paris',
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}
```

## Safe path vs Advanced path

- **Safe path (recommended)**: use `style:` and token-friendly presets. Avoid custom renderers/slots until you really need them.
- **Advanced path**: use `slots` / renderer contracts / custom themes only when you need structural control or a full visual takeover.

## Quick start (Material preset)

```dart
import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

void main() {
  runApp(const HeadlessMaterialApp(home: Placeholder()));
}
```

## Quick start (Cupertino preset)

```dart
import 'package:flutter/cupertino.dart';
import 'package:headless/headless.dart';

void main() {
  runApp(const HeadlessCupertinoApp(home: Placeholder()));
}
```

## Quick start (custom visuals)

Use this only if you are providing your own renderers.

```dart
import 'package:flutter/widgets.dart';
import 'package:headless_theme/headless_theme.dart';

final class MyTheme extends HeadlessTheme {
  @override
  T? capability<T>() => null;
}

void main() {
  runApp(
    HeadlessApp(
      theme: MyTheme(),
      appBuilder: (overlayBuilder) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) => overlayBuilder(
              context,
              const Placeholder(),
            ),
          ),
        );
      },
    ),
  );
}
```

## Most common recipes

- Button style: `docs/users/COOKBOOK.md#button-style`
- Button slots: `docs/users/COOKBOOK.md#button-slots-decorate-surface`
- Dropdown with items: `docs/users/COOKBOOK.md#dropdown-with-items`
- Dropdown menu style: `docs/users/COOKBOOK.md#dropdown-menu-style-simple`
- Dropdown menu surface: `docs/users/COOKBOOK.md#dropdown-menu-surface-wrap-structure`
- Dropdown row with selection indicator: `docs/users/COOKBOOK.md#dropdown-item-row-with-selection-indicator-checkbox--label`
- Checkbox slots: `docs/users/COOKBOOK.md#checkbox-slots-decorate-box`
- CheckboxListTile tile slot: `docs/users/COOKBOOK.md#checkboxlisttile-tile-slot-decorate`
- SafeDropdownRenderer template: `docs/users/COOKBOOK.md#safedropdownrenderer-full-takeover-minimal-template`
- TextField recipes: `docs/users/COOKBOOK_TEXTFIELD.md`
- Autocomplete recipes: `docs/users/COOKBOOK_AUTOCOMPLETE.md`
- Advanced recipes (scopes + defaults): `docs/users/COOKBOOK_ADVANCED.md`
- Guardrails: `docs/users/GUARDRAILS.md`
- Select-like control: use `RDropdownButton<T>` (no separate Select component).

## Troubleshooting

| Issue | What it means | Fix |
| --- | --- | --- |
| `MissingOverlayHostException` | No overlay host in the tree | Use `HeadlessMaterialApp` / `HeadlessCupertinoApp`, or wrap with `AnchoredOverlayEngineHost`. |
| `MissingThemeException` (debug only) | No Headless theme provider | Use `HeadlessMaterialApp` / `HeadlessCupertinoApp`, or wrap with `HeadlessThemeProvider`. |
| `MissingCapabilityException` (debug only) | Theme exists but missing a renderer | Use a preset or provide the renderer in your theme. |
| Release behavior | The app does not crash | A diagnostic placeholder is rendered and the error is reported via `FlutterError.reportError`. |

## Where to go next

- Users Cookbook: `docs/users/COOKBOOK.md`
- Example app: `apps/example`
- Contributors guide: `docs/contributors/README.md`

## Example screens (code)

- Home: `apps/example/lib/screens/home_screen.dart`
- Button: `apps/example/lib/screens/button_demo_screen.dart`
- Dropdown: `apps/example/lib/screens/dropdown_demo_screen.dart`
- Autocomplete: `apps/example/lib/screens/autocomplete_demo_screen.dart`
- TextField: `apps/example/lib/screens/textfield_demo_screen.dart`
- Phone field: `apps/example/lib/screens/phone_field_demo_screen.dart`
- Pinput: `apps/example/lib/screens/pinput_demo_screen.dart`
- Switch: `apps/example/lib/screens/switch_demo_screen.dart`
- Glassmorphism: `apps/example/lib/screens/glass_demo_screen.dart`
- Intentional errors: `apps/example/lib/screens/intentional_errors_screen.dart`
