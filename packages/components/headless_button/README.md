# headless_button

Headless `RTextButton` for Flutter.

This package provides **behavior + accessibility** (pressed/hover/focus/keyboard) and delegates **visual rendering** to a renderer capability from your `HeadlessThemeProvider`.

## Quick start (preset)

```dart
import 'package:flutter/material.dart';
import 'package:headless_button/headless_button.dart';
import 'package:headless/headless.dart';

void main() {
  runApp(
    const HeadlessMaterialApp(
      home: Scaffold(
        body: Center(
          child: RTextButton(
            onPressed: null,
            child: Text('Continue'),
          ),
        ),
      ),
    ),
  );
}
```

## Quick start (custom)

```dart
import 'package:flutter/widgets.dart';
import 'package:headless_button/headless_button.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

final class MyButtonRenderer implements RButtonRenderer {
  @override
  Widget render(RButtonRenderRequest request) => const SizedBox.shrink();
}

final class MyTheme extends HeadlessTheme {
  @override
  T? capability<T>() {
    if (T == RButtonRenderer) return MyButtonRenderer() as T;
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
              const RTextButton(
                onPressed: null,
                child: Text('Continue'),
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
  `RButtonRenderer`.

## Simple style sugar

```dart
RTextButton(
  onPressed: () {},
  style: const RButtonStyle(
    backgroundColor: Colors.deepOrange,
    foregroundColor: Colors.white,
    radius: 20,
  ),
  child: const Text('Custom'),
)
```

This is a convenience layer that is internally converted to
`RenderOverrides.only(RButtonOverrides.tokens(...))`.

Priority (strong -> weak):
1) `overrides: RenderOverrides(...)`
2) `style: RButtonStyle(...)`
3) theme/preset defaults

## Slots (Decorate-first)

Slots allow partial customization without reimplementing the renderer.

```dart
import 'package:headless_contracts/headless_contracts.dart';

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

Rules:
- Prefer `Decorate` over `Replace`.
- Do not add activation handlers in renderers or slots.

## Per-instance overrides (visual only)

```dart
RTextButton(
  onPressed: () {},
  overrides: RenderOverrides({
    RButtonOverrides: RButtonOverrides.tokens(
      backgroundColor: Colors.deepOrange,
      foregroundColor: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
  }),
  child: const Text('Custom'),
)
```

Overrides affect **tokens/visuals**, not behavior.

## Common errors

- `MissingThemeException`: you forgot `HeadlessThemeProvider` (**debug**).
- `MissingCapabilityException`: theme exists, but does not provide `RButtonRenderer` (**debug**).

In release builds, missing theme/capability does not crash the app: the component renders a small diagnostic placeholder and reports the error via `FlutterError.reportError`.

## Conformance

See `CONFORMANCE_REPORT.md` and upstream docs:
- `docs/SPEC_V1.md`
- `docs/CONFORMANCE.md`

