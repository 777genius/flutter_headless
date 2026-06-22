# headless_adaptive

Adaptive helpers for Headless components.

This package has two layers:

- adaptive app/theme bootstrap for Material and Cupertino renderers
- unstyled responsive layout decisions and slot primitives for product design systems

Product apps should normally consume layout primitives through their own
design-system wrapper. Feature code should not import this package directly
unless it is building a low-level platform component.

## Responsive Layout Primitives

The layout layer computes environment, policy and decisions without owning
product styling.

```text
constraints / window / input capabilities
  -> AdaptiveEnvironment
  -> AdaptivePolicy
  -> AdaptiveDecision
  -> slot builders
  -> product design system visuals
```

Core primitives:

- `AdaptiveBuilder`
- `AdaptiveScope`
- `AdaptiveValue<T>`
- `AdaptiveSlotLayout`
- `AdaptiveListDetailScaffold`
- `AdaptiveNavigationShell`
- `AdaptiveMaxWidth`
- `AdaptivePaneController`

Define product breakpoints and policies outside feature screens:

```dart
const policy = AdaptivePolicy(
  breakpoints: AdaptiveBreakpointSet.materialLike,
  navigation: AdaptiveNavigationPolicy(
    compact: AdaptiveNavigationPattern.drawer,
    medium: AdaptiveNavigationPattern.rail,
    expanded: AdaptiveNavigationPattern.sidebar,
  ),
  panes: AdaptivePanePolicy(
    detailInlineFrom: AdaptiveScreenClass.expanded,
    supportingInlineFrom: AdaptiveScreenClass.wide,
  ),
);
```

Set shared policy once:

```dart
AdaptiveScope(
  policy: policy,
  child: AdaptiveBuilder(
    builder: (context, adaptive) {
      return Text(adaptive.decision.screenClass.name);
    },
  ),
)
```

Use slot layouts for canonical pane patterns:

```dart
AdaptiveSlotLayout(
  slots: AdaptiveSlots(
    primary: (context, state) => const FeedList(),
    detail: (context, state) => const FeedDetail(),
    supporting: (context, state) => const FeedFilters(),
  ),
)
```

Constrain large-screen content without styling:

```dart
AdaptiveMaxWidth(
  child: SettingsForm(),
)
```

Rules:

- prefer `AdaptiveEnvironment`, `AdaptivePolicy` and `AdaptiveDecision` over device-type checks
- prefer slot builders over styled widgets
- use `AdaptiveScope` for shared policy, not duplicated breakpoint constants
- use `LayoutBuilder` constraints for local layout decisions
- use `MediaQuery` only as an environment input, not as feature-level branching
- use controlled state through `AdaptivePaneController` when route or feature state owns pane selection

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
