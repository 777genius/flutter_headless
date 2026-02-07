/// Cupertino (iOS) preset for Headless components.
///
/// Provides iOS-styled renderers and token resolvers that implement
/// the capability contracts from headless_contracts.
///
/// Usage:
/// ```dart
/// HeadlessThemeProvider(
///   theme: CupertinoHeadlessTheme(),
///   child: MyApp(),
/// )
/// ```
///
/// For scoped theme changes:
/// ```dart
/// HeadlessThemeProvider(
///   theme: CupertinoHeadlessTheme.dark(),
///   child: DarkSection(),
/// )
/// ```
library;

export 'src/accessibility/cupertino_tap_target_policy.dart';
export 'headless_cupertino_app.dart';
export 'button.dart';
export 'checkbox.dart';
export 'checkbox_list_tile.dart';
export 'dropdown.dart';
export 'primitives.dart';
export 'textfield.dart';
export 'theme.dart';
