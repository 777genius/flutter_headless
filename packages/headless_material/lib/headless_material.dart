/// Material 3 preset for Headless components.
///
/// Provides Material-styled renderers and token resolvers that implement
/// the capability contracts from headless_contracts.
///
/// Usage:
/// ```dart
/// HeadlessThemeProvider(
///   theme: MaterialHeadlessTheme(),
///   child: MyApp(),
/// )
/// ```
///
/// For scoped theme changes:
/// ```dart
/// HeadlessThemeProvider(
///   theme: MaterialHeadlessTheme.dark(),
///   child: DarkSection(),
/// )
/// ```
library;

export 'src/accessibility/material_tap_target_policy.dart';
export 'headless_material_app.dart';
export 'button.dart';
export 'checkbox.dart';
export 'checkbox_list_tile.dart';
export 'dropdown.dart';
export 'textfield.dart';
export 'theme.dart';
