# headless_dropdown_button

Headless `RDropdownButton<T>` for Flutter.

This package implements the “select-like” use case in this repo: **Select/Combobox is intentionally not a separate component**. Use `RDropdownButton` for single selection.

## Quick start (preset)

```dart
import 'package:flutter/material.dart';
import 'package:headless_dropdown_button/headless_dropdown_button.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless/headless.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? value;

  @override
  Widget build(BuildContext context) {
    return RDropdownButton<String>(
      value: value,
      onChanged: (v) => setState(() => value = v),
      items: const ['a', 'b'],
      itemAdapter: HeadlessItemAdapter.simple(
        id: (v) => ListboxItemId(v),
        titleText: (v) => v == 'a' ? 'Option A' : 'Option B',
      ),
    );
  }
}

void main() {
  runApp(const HeadlessMaterialApp(home: MyApp()));
}
```

## Quick start (custom)

```dart
import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_dropdown_button/headless_dropdown_button.dart';
import 'package:headless_theme/headless_theme.dart';

final class MyDropdownRenderer implements RDropdownButtonRenderer {
  @override
  Widget render(RDropdownRenderRequest request) => const SizedBox.shrink();
}

final class MyTheme extends HeadlessTheme {
  @override
  T? capability<T>() {
    if (T == RDropdownButtonRenderer) return MyDropdownRenderer() as T;
    return null;
  }
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
              const RDropdownButton<String>(
                value: null,
                onChanged: null,
                options: <RDropdownOption<String>>[],
              ),
            ),
          ),
        );
      },
    ),
  );
}
```

## Requirements (manual wiring)

- If you don't use `HeadlessMaterialApp` / `HeadlessCupertinoApp` / `HeadlessApp`,
  you must provide `HeadlessThemeProvider` with a theme that provides
  `RDropdownButtonRenderer`, and install `AnchoredOverlayEngineHost` above the widget tree.

## Simple style sugar

```dart
RDropdownButton<String>(
  value: value,
  onChanged: setValue,
  items: items,
  itemAdapter: itemAdapter,
  style: const RDropdownStyle(
    triggerBackgroundColor: Color(0xFFF2F2F2),
    triggerBorderColor: Color(0xFFCCCCCC),
    triggerPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    triggerRadius: 12,
    menuBackgroundColor: Color(0xFFFFFFFF),
  ),
)
```

This is a convenience layer that is internally converted to
`RenderOverrides.only(RDropdownOverrides.tokens(...))`.

Priority (strong -> weak):
1) `overrides: RenderOverrides(...)`
2) `style: RDropdownStyle(...)`
3) theme/preset defaults

## Per-instance overrides (visual only)

```dart
RDropdownButton<String>(
  value: value,
  onChanged: setValue,
  items: items,
  itemAdapter: itemAdapter,
  overrides: RenderOverrides({
    RDropdownOverrides: RDropdownOverrides.tokens(
      menuMaxHeight: 240,
      triggerBorderRadius: BorderRadius.circular(16),
    ),
  }),
)
```

## Slots (structural customization)

Use `Decorate` to wrap defaults:

```dart
RDropdownButton<String>(
  value: value,
  onChanged: setValue,
  items: items,
  itemAdapter: itemAdapter,
  slots: RDropdownButtonSlots(
    menuSurface: Decorate((ctx, child) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      );
    }),
  ),
)
```

## Common errors

- `MissingOverlayHostException`: you forgot `AnchoredOverlayEngineHost`.
- `MissingThemeException`: you forgot `HeadlessThemeProvider` (**debug**).
- `MissingCapabilityException`: theme exists, but does not provide `RDropdownButtonRenderer` (**debug**).

In release builds, missing theme/capability does not crash the app: the component renders a small diagnostic placeholder and reports the error via `FlutterError.reportError`.

## Conformance

See `CONFORMANCE_REPORT.md` and upstream docs:
- `docs/SPEC_V1.md`
- `docs/CONFORMANCE.md`

