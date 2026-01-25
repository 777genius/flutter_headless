import 'package:flutter/widgets.dart';

import 'headless_theme.dart';
import 'require_capability.dart';
import '../diagnostics/headless_setup_hints.dart';

/// Provides [HeadlessTheme] to descendant widgets.
///
/// Wrap your app (or a subtree) with this widget to make the theme
/// available via [HeadlessThemeProvider.of] or [HeadlessThemeProvider.themeOf].
///
/// Example:
/// ```dart
/// HeadlessThemeProvider(
///   theme: MyCustomTheme(),
///   child: MaterialApp(...),
/// )
/// ```
class HeadlessThemeProvider extends InheritedWidget {
  const HeadlessThemeProvider({
    super.key,
    required this.theme,
    required super.child,
  });

  /// The theme to provide to descendants.
  final HeadlessTheme theme;

  /// Get the [HeadlessTheme] from the widget tree.
  ///
  /// Returns null if no [HeadlessThemeProvider] is found.
  /// Prefer [themeOf] when you expect the theme to always be present.
  static HeadlessTheme? of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<HeadlessThemeProvider>();
    return provider?.theme;
  }

  /// Get the [HeadlessTheme] from the widget tree.
  ///
  /// Throws [MissingThemeException] if no [HeadlessThemeProvider] is found.
  /// Use this when the theme is required (most component use cases).
  static HeadlessTheme themeOf(BuildContext context) {
    final theme = of(context);
    if (theme == null) {
      assert(() {
        throw const MissingThemeException();
      }());
      return const _MissingHeadlessTheme();
    }
    return theme;
  }

  /// Convenience method to get a required capability from the theme.
  ///
  /// Combines [themeOf] + [requireCapability] in one call.
  /// This is the recommended way for components to access capabilities.
  ///
  /// Example:
  /// ```dart
  /// final renderer = HeadlessThemeProvider.capabilityOf<RButtonRenderer>(
  ///   context,
  ///   componentName: 'RTextButton',
  /// );
  /// ```
  static T capabilityOf<T>(
    BuildContext context, {
    required String componentName,
  }) {
    final theme = themeOf(context);
    return requireCapability<T>(theme, componentName: componentName);
  }

  /// Safe capability lookup.
  ///
  /// - In debug/profile: asserts with a detailed, searchable error.
  /// - In release: returns null (callers should render a fallback and report).
  static T? maybeCapabilityOf<T>(
    BuildContext context, {
    required String componentName,
  }) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<HeadlessThemeProvider>();
    final theme = provider?.theme;
    if (theme == null) {
      assert(() {
        throw const MissingThemeException();
      }());
      return null;
    }
    final capability = theme.capability<T>();
    if (capability == null) {
      assert(() {
        throw MissingCapabilityException(
          capabilityType: T.toString(),
          componentName: componentName,
        );
      }());
      return null;
    }
    return capability;
  }

  @override
  bool updateShouldNotify(HeadlessThemeProvider oldWidget) {
    return theme != oldWidget.theme;
  }
}

/// Exception thrown when [HeadlessThemeProvider] is not found in the widget tree.
@immutable
final class MissingThemeException implements Exception {
  const MissingThemeException();

  @override
  String toString() {
    return '[Headless] No HeadlessThemeProvider found in widget tree.\n'
        '${headlessGoldenPathHint()}\n'
        'Preset fix (fastest):\n'
        '- Material: wrap your app with HeadlessMaterialApp(...)\n'
        '- Cupertino: wrap your app with HeadlessCupertinoApp(...)\n'
        'Custom fix (preset-agnostic):\n'
        '- HeadlessApp(theme: ..., appBuilder: ...)\n'
        'Spec: docs/SPEC_V1.md';
  }
}

final class _MissingHeadlessTheme extends HeadlessTheme {
  const _MissingHeadlessTheme();

  @override
  T? capability<T>() => null;
}
