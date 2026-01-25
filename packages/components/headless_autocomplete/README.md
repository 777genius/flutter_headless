# headless_autocomplete

Headless `RAutocomplete<T>` for Flutter.

## Quick start (preset)

```dart
import 'package:flutter/material.dart';
import 'package:headless_autocomplete/headless_autocomplete.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless/headless.dart';

final _countryAdapter = HeadlessItemAdapter.simple<String>(
  id: (v) => ListboxItemId(v),
  titleText: (v) => v,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RAutocomplete<String>(
      source: RAutocompleteLocalSource(
        options: (value) {
          final q = value.text.trim().toLowerCase();
          if (q.isEmpty) return const <String>[];
          return ['France', 'Finland', 'Fiji']
              .where((c) => c.toLowerCase().contains(q));
        },
      ),
      itemAdapter: _countryAdapter,
      onSelected: (v) {},
      placeholder: 'Country',
    );
  }
}

void main() {
  runApp(const HeadlessMaterialApp(home: MyApp()));
}
```

## Multi-select (preset)

Use `RAutocomplete.multiple<T>(...)` for multiple selection.

```dart
import 'package:flutter/material.dart';
import 'package:headless_autocomplete/headless_autocomplete.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless/headless.dart';

final _adapter = HeadlessItemAdapter<String>.simple(
  id: (v) => ListboxItemId(v),
  titleText: (v) => v,
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> selected = const [];

  @override
  Widget build(BuildContext context) {
    return RAutocomplete<String>.multiple(
      source: const RAutocompleteLocalSource(
        options: (v) => ['Georgia', 'Florida', 'California'],
      ),
      itemAdapter: _adapter,
      selectedValues: selected,
      onSelectionChanged: (next) => setState(() => selected = next),
      placeholder: 'Select states',
      // Menu behavior:
      hideSelectedOptions: false,
      pinSelectedOptions: false,
      // Field presentation (Material preset):
      selectedValuesPresentation: RAutocompleteSelectedValuesPresentation.chips,
    );
  }
}

void main() {
  runApp(const HeadlessMaterialApp(home: MyApp()));
}
```

Notes:
- Selecting toggles a value and clears the query by default.
- You can control this via `clearQueryOnSelection` (multiple mode).
- Backspace on empty query removes the last selected value.
- Material menu automatically renders checkboxes for multi-select.
- Chips "x" removal is handled via `RAutocompleteSelectedValuesCommands.removeById(...)`.
  `removeAt(...)` exists as a convenience when a renderer keeps `selectedItems` order.
- For multiple mode, `itemAdapter.id(value)` must be stable and unique (used for toggling and removal).

## Quick start (custom)

For custom theming, autocomplete needs three renderers:

| Renderer | Purpose |
|----------|---------|
| `RTextFieldRenderer` | Renders the input field (wraps EditableText) |
| `RDropdownButtonRenderer` | Renders the options dropdown menu |
| `RAutocompleteSelectedValuesRenderer` | Renders selected chips (multi-select only) |

> **Tip:** Single-select mode only requires `RTextFieldRenderer` + `RDropdownButtonRenderer`.

Import `wiring.dart` for all contracts in one import:

```dart
import 'package:flutter/widgets.dart';
import 'package:headless_autocomplete/headless_autocomplete.dart';
import 'package:headless_autocomplete/wiring.dart';
import 'package:headless_theme/headless_theme.dart';

final class MyTextFieldRenderer implements RTextFieldRenderer {
  @override
  Widget render(RTextFieldRenderRequest request) => request.input;
}

final class MyDropdownRenderer implements RDropdownButtonRenderer {
  @override
  Widget render(RDropdownRenderRequest request) => const SizedBox.shrink();
}

final class MySelectedValuesRenderer implements RAutocompleteSelectedValuesRenderer {
  @override
  Widget render(RAutocompleteSelectedValuesRenderRequest request) =>
      const SizedBox.shrink();
}

final class MyTheme extends HeadlessTheme {
  @override
  T? capability<T>() {
    if (T == RTextFieldRenderer) return MyTextFieldRenderer() as T;
    if (T == RDropdownButtonRenderer) return MyDropdownRenderer() as T;
    if (T == RAutocompleteSelectedValuesRenderer) {
      return MySelectedValuesRenderer() as T;
    }
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
              RAutocomplete<String>(
                source: const RAutocompleteLocalSource(options: (_) => <String>[]),
                itemAdapter: HeadlessItemAdapter.simple(
                  id: (v) => ListboxItemId(v),
                  titleText: (v) => v,
                ),
                onSelected: (_) {},
              ),
            ),
          ),
        );
      },
    ),
  );
}
```

## Simple style sugar

```dart
RAutocomplete<String>(
  source: const RAutocompleteLocalSource(options: (value) => ['One', 'Two']),
  itemAdapter: _countryAdapter,
  onSelected: (_) {},
  style: const RAutocompleteStyle(
    field: RAutocompleteFieldStyle(
      containerPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      containerBorderColor: Color(0xFFDDDDDD),
      containerRadius: 10,
      textStyle: TextStyle(fontSize: 14),
      placeholderColor: Color(0xFF999999),
    ),
    options: RAutocompleteOptionsStyle(
      optionsBackgroundColor: Color(0xFFFFFFFF),
      optionsBorderColor: Color(0xFFEEEEEE),
      optionsRadius: 12,
      optionsElevation: 2,
      optionTextStyle: TextStyle(fontSize: 14),
      optionPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
  ),
);
```

This is a convenience layer that is internally converted to field/menu overrides
via `RenderOverrides.only(...)`.

Priority (strong -> weak):
1) `overrides: RenderOverrides(...)`
2) `style: RAutocompleteStyle(...)`
3) theme/preset defaults

## Requirements (manual wiring)

- If you don't use `HeadlessMaterialApp` / `HeadlessCupertinoApp` / `HeadlessApp`,
  you must provide `HeadlessThemeProvider` with a theme that provides
  `RTextFieldRenderer` and `RDropdownButtonRenderer` (and for multi-select: `RAutocompleteSelectedValuesRenderer`),
  and install `AnchoredOverlayEngineHost`
  above the widget tree.
