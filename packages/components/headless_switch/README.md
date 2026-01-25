# headless_switch

Headless `RSwitch` and `RSwitchListTile` for Flutter.

This package provides switch behavior (state, focus, keyboard, semantics) and delegates visuals to renderer capabilities from your `HeadlessThemeProvider`.

## Quick start (preset)

```dart
import 'package:flutter/material.dart';
import 'package:headless_switch/headless_switch.dart';
import 'package:headless/headless.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RSwitch(
          value: value,
          onChanged: (v) => setState(() => value = v),
          semanticLabel: 'Dark mode',
        ),
        RSwitchListTile(
          value: value,
          onChanged: (v) => setState(() => value = v),
          title: const Text('Dark mode'),
        ),
      ],
    );
  }
}

void main() {
  runApp(const HeadlessMaterialApp(home: MyApp()));
}
```

## Simple style sugar

```dart
RSwitch(
  value: value,
  onChanged: (v) => setState(() => value = v),
  style: const RSwitchStyle(
    activeTrackColor: Color(0xFF0066FF),
    inactiveTrackColor: Color(0xFFCCCCCC),
  ),
)
```

```dart
RSwitchListTile(
  value: value,
  onChanged: (v) => setState(() => value = v),
  title: const Text('Dark mode'),
  style: const RSwitchListTileStyle(
    minHeight: 56,
    horizontalGap: 12,
  ),
)
```

These are convenience layers that are internally converted to
`RenderOverrides.only(RSwitchOverrides.tokens(...))` and
`RenderOverrides.only(RSwitchListTileOverrides.tokens(...))`.

Priority (strong -> weak):
1) `overrides: RenderOverrides(...)`
2) `thumbIcon:` parameter (for RSwitch only)
3) `style: RSwitchStyle(...)` / `style: RSwitchListTileStyle(...)`
4) theme/preset defaults

Note: The `thumbIcon` parameter on `RSwitch` takes precedence over `style.thumbIcon`.
This follows POLA: a direct parameter is more explicit than a nested style property.

## Slots (Decorate-first)

Use slots to customize visuals without reimplementing renderers.

```dart
import 'package:headless_contracts/headless_contracts.dart';

RSwitch(
  value: value,
  onChanged: (v) => setState(() => value = v),
  slots: RSwitchSlots(
    track: Decorate(
      (ctx, child) => ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: child,
      ),
    ),
  ),
)
```

```dart
import 'package:headless_contracts/headless_contracts.dart';

RSwitchListTile(
  value: value,
  onChanged: (v) => setState(() => value = v),
  title: const Text('Dark mode'),
  slots: RSwitchListTileSlots(
    tile: Decorate(
      (ctx, child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: child,
      ),
    ),
  ),
)
```

Rules:
- Prefer `Decorate` over `Replace`.
- Do not add activation handlers in renderers or slots.

## Per-instance overrides (visual only)

```dart
RSwitch(
  value: value,
  onChanged: (v) => setState(() => value = v),
  overrides: RenderOverrides({
    RSwitchOverrides: RSwitchOverrides.tokens(
      activeTrackColor: Color(0xFF0066FF),
      trackBorderRadius: BorderRadius.circular(16),
    ),
  }),
)
```

## Requirements (manual wiring)

- If you don't use `HeadlessMaterialApp` / `HeadlessCupertinoApp` / `HeadlessApp`,
  you must provide `HeadlessThemeProvider` with a theme that provides
  `RSwitchRenderer` and `RSwitchListTileRenderer`.

## Common errors

- `MissingThemeException`: you forgot `HeadlessThemeProvider` (**debug**).
- `MissingCapabilityException`: theme exists, but does not provide required renderer capability (**debug**).

In release builds, missing theme/capability does not crash the app: the component renders a small diagnostic placeholder and reports the error via `FlutterError.reportError`.

## Conformance

See `CONFORMANCE_REPORT.md` and upstream docs:
- `docs/SPEC_V1.md`
- `docs/CONFORMANCE.md`
