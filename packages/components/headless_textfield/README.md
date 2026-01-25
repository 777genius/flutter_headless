# headless_textfield

Headless `RTextField` for Flutter.

This package provides text input behavior (controller ownership, focus, keyboard, semantics) and delegates visuals to a renderer capability from your `HeadlessThemeProvider`.

## Quick start (preset)

```dart
import 'package:flutter/material.dart';
import 'package:headless/headless.dart';
import 'package:headless_textfield/headless_textfield.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String email = '';

  @override
  Widget build(BuildContext context) {
    return RTextField(
      value: email,
      onChanged: (v) => setState(() => email = v),
      label: 'Email',
      placeholder: 'Enter your email',
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
import 'package:headless_textfield/headless_textfield.dart';
import 'package:headless_theme/headless_theme.dart';

final class MyTextFieldRenderer implements RTextFieldRenderer {
  @override
  Widget render(RTextFieldRenderRequest request) => request.input;
}

final class MyTheme extends HeadlessTheme {
  @override
  T? capability<T>() {
    if (T == RTextFieldRenderer) return MyTextFieldRenderer() as T;
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
              RTextField(
                value: '',
                onChanged: (_) {},
              ),
            ),
          ),
        );
      },
    ),
  );
}
```

## Controller-driven mode

```dart
final c = TextEditingController();

RTextField(
  controller: c,
  onChanged: (v) {},
)
```

Do **not** pass both `value` and `controller` (throws `ArgumentError`).

## Simple style sugar

```dart
RTextField(
  value: email,
  onChanged: (v) => setState(() => email = v),
  label: 'Email',
  placeholder: 'Enter your email',
  style: const RTextFieldStyle(
    containerBackgroundColor: Color(0xFFF7F7F7),
    containerBorderColor: Color(0xFFCCCCCC),
    containerBorderWidth: 1,
    containerRadius: 12,
    textColor: Color(0xFF111111),
    placeholderColor: Color(0xFF888888),
  ),
)
```

This is a convenience layer that is internally converted to
`RenderOverrides.only(RTextFieldOverrides.tokens(...))`.

Priority (strong -> weak):
1) `overrides: RenderOverrides(...)`
2) `style: RTextFieldStyle(...)`
3) theme/preset defaults

## Per-instance overrides (visual only)

```dart
RTextField(
  value: '',
  onChanged: (_) {},
  label: 'Custom',
  overrides: RenderOverrides({
    RTextFieldOverrides: RTextFieldOverrides.tokens(
      containerBorderRadius: BorderRadius.circular(12),
    ),
  }),
)
```

## Requirements (manual wiring)

- If you don't use `HeadlessMaterialApp` / `HeadlessCupertinoApp` / `HeadlessApp`,
  you must provide `HeadlessThemeProvider` with a theme that provides
  `RTextFieldRenderer`.

## Common errors

- `MissingThemeException`: you forgot `HeadlessThemeProvider` (**debug**).
- `MissingCapabilityException`: theme exists, but does not provide `RTextFieldRenderer` (**debug**).

In release builds, missing theme/capability does not crash the app: the component renders a small diagnostic placeholder and reports the error via `FlutterError.reportError`.

## Conformance

See `CONFORMANCE_REPORT.md` and upstream docs:
- `docs/SPEC_V1.md`
- `docs/CONFORMANCE.md`

