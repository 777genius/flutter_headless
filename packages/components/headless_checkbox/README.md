# headless_checkbox

Headless `RCheckbox` and `RCheckboxListTile` for Flutter.

This package provides checkbox behavior (state, focus, keyboard, semantics) and delegates visuals to renderer capabilities from your `HeadlessThemeProvider`.

## Quick start (preset)

```dart
import 'package:flutter/material.dart';
import 'package:headless_checkbox/headless_checkbox.dart';
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
        RCheckbox(
          value: value,
          onChanged: (v) => setState(() => value = v ?? false),
          semanticLabel: 'Accept terms',
        ),
        RCheckboxListTile(
          value: value,
          onChanged: (v) => setState(() => value = v),
          title: const Text('Accept terms'),
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
RCheckbox(
  value: value,
  onChanged: (v) => setState(() => value = v),
  style: const RCheckboxStyle(
    activeColor: Color(0xFF0066FF),
    borderColor: Color(0xFFCCCCCC),
    radius: 4,
  ),
)
```

```dart
RCheckboxListTile(
  value: value,
  onChanged: (v) => setState(() => value = v),
  title: const Text('Accept terms'),
  style: const RCheckboxListTileStyle(
    minHeight: 56,
    horizontalGap: 12,
  ),
)
```

These are convenience layers that are internally converted to
`RenderOverrides.only(RCheckboxOverrides.tokens(...))` and
`RenderOverrides.only(RCheckboxListTileOverrides.tokens(...))`.

Priority (strong -> weak):
1) `overrides: RenderOverrides(...)`
2) `style: RCheckboxStyle(...)` / `style: RCheckboxListTileStyle(...)`
3) theme/preset defaults

## Slots (Decorate-first)

Use slots to customize visuals without reimplementing renderers.

```dart
import 'package:headless_contracts/headless_contracts.dart';

RCheckbox(
  value: value,
  onChanged: (v) => setState(() => value = v),
  slots: RCheckboxSlots(
    box: Decorate(
      (ctx, child) => ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        child: child,
      ),
    ),
  ),
)
```

```dart
import 'package:headless_contracts/headless_contracts.dart';

RCheckboxListTile(
  value: value,
  onChanged: (v) => setState(() => value = v),
  title: const Text('Accept terms'),
  slots: RCheckboxListTileSlots(
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
RCheckbox(
  value: value,
  onChanged: (v) => setState(() => value = v),
  overrides: RenderOverrides({
    RCheckboxOverrides: RCheckboxOverrides.tokens(
      activeColor: Color(0xFF0066FF),
      borderRadius: BorderRadius.circular(4),
    ),
  }),
)
```

## Requirements (manual wiring)

- If you don't use `HeadlessMaterialApp` / `HeadlessCupertinoApp` / `HeadlessApp`,
  you must provide `HeadlessThemeProvider` with a theme that provides
  `RCheckboxRenderer` and `RCheckboxListTileRenderer`.

## Common errors

- `MissingThemeException`: you forgot `HeadlessThemeProvider` (**debug**).
- `MissingCapabilityException`: theme exists, but does not provide required renderer capability (**debug**).

In release builds, missing theme/capability does not crash the app: the component renders a small diagnostic placeholder and reports the error via `FlutterError.reportError`.

## Conformance

See `CONFORMANCE_REPORT.md` and upstream docs:
- `docs/SPEC_V1.md`
- `docs/CONFORMANCE.md`
