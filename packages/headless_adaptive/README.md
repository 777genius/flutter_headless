# headless_adaptive

Adaptive helpers for Headless components.

## HeadlessAdaptiveTheme

Selects Material or Cupertino headless presets based on platform.

```dart
import 'package:headless_adaptive/headless_adaptive.dart';

HeadlessAdaptiveTheme(
  child: MyApp(),
)
```

Override presets or platform (useful for tests):

```dart
HeadlessAdaptiveTheme(
  platformOverride: TargetPlatform.iOS,
  materialTheme: MaterialHeadlessTheme(),
  cupertinoTheme: CupertinoHeadlessTheme(),
  child: MyApp(),
)
```

## HeadlessAdaptiveApp

Adaptive bootstrap that chooses `MaterialApp` or `CupertinoApp` and installs
the matching headless theme + `AnchoredOverlayEngineHost`.

```dart
import 'package:headless_adaptive/headless_adaptive.dart';

HeadlessAdaptiveApp(
  home: const MyHomePage(),
)
```

## Material-only overrides

Some layout knobs exist only in the Material preset and are applied via
Material overrides (so they don't exist in the Cupertino API).

Example: `titleAlignment` for `RCheckboxListTile`:

```dart
RCheckboxListTile(
  value: false,
  onChanged: (_) {},
  title: const Text('Title'),
  subtitle: const Text('Subtitle'),
  overrides: RenderOverrides.only(
    const MaterialListTileOverrides(
      titleAlignment: ListTileTitleAlignment.threeLine,
    ),
  ),
)
```

You can still pass Material/Cupertino app settings:

```dart
HeadlessAdaptiveApp(
  materialTheme: ThemeData(useMaterial3: true),
  cupertinoTheme: const CupertinoThemeData(),
  home: const MyHomePage(),
)
```
