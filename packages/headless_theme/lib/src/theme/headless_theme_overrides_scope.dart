import 'package:flutter/widgets.dart';

import 'capability_overrides.dart';
import 'headless_theme_provider.dart';
import 'headless_theme_with_overrides.dart';
import 'headless_theme.dart';

/// Scoped capability overrides for a subtree.
///
/// This widget is a DX helper on top of:
/// - [HeadlessThemeProvider]
/// - [HeadlessThemeWithOverrides]
/// - [CapabilityOverrides]
///
/// Key goals:
/// - POLA: overrides win, otherwise base theme is used.
/// - No merge-magic.
/// - Avoids recreating the wrapper theme on every build when inputs are stable.
class HeadlessThemeOverridesScope extends StatefulWidget {
  const HeadlessThemeOverridesScope({
    super.key,
    required this.overrides,
    required this.child,
  });

  final CapabilityOverrides overrides;
  final Widget child;

  /// Convenience helper for the common case: one capability override.
  static Widget only<T extends Object>({
    required T capability,
    required Widget child,
    Key? key,
  }) {
    return HeadlessThemeOverridesScope(
      key: key,
      overrides: CapabilityOverrides.only<T>(capability),
      child: child,
    );
  }

  @override
  State<HeadlessThemeOverridesScope> createState() =>
      _HeadlessThemeOverridesScopeState();
}

class _HeadlessThemeOverridesScopeState extends State<HeadlessThemeOverridesScope> {
  HeadlessTheme? _base;
  CapabilityOverrides? _overrides;
  late HeadlessTheme _effectiveTheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final base = HeadlessThemeProvider.themeOf(context);
    _rebuildIfNeeded(base: base, overrides: widget.overrides);
  }

  @override
  void didUpdateWidget(covariant HeadlessThemeOverridesScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.overrides != oldWidget.overrides) {
      // Base may be the same; keep it and rebuild only because overrides changed.
      final base = _base ?? HeadlessThemeProvider.themeOf(context);
      _rebuildIfNeeded(base: base, overrides: widget.overrides);
    }
  }

  void _rebuildIfNeeded({
    required HeadlessTheme base,
    required CapabilityOverrides overrides,
  }) {
    final baseChanged = !identical(_base, base);
    final overridesChanged = _overrides != overrides;

    if (!baseChanged && !overridesChanged) return;

    _base = base;
    _overrides = overrides;
    _effectiveTheme = HeadlessThemeWithOverrides(
      base: base,
      overrides: overrides,
    );
  }

  @override
  Widget build(BuildContext context) {
    return HeadlessThemeProvider(
      theme: _effectiveTheme,
      child: widget.child,
    );
  }
}

