import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:headless_cupertino/headless_cupertino.dart';
import 'package:headless_material/headless_material.dart';
import 'package:headless_theme/headless_theme.dart';

/// Adaptive theme provider for Headless components.
///
/// Chooses Material or Cupertino presets based on platform, so all components
/// become adaptive without per-widget constructors.
class HeadlessAdaptiveTheme extends StatelessWidget {
  const HeadlessAdaptiveTheme({
    super.key,
    this.materialTheme,
    this.cupertinoTheme,
    this.platformOverride,
    required this.child,
  });

  /// Optional Material preset override.
  final HeadlessTheme? materialTheme;

  /// Optional Cupertino preset override.
  final HeadlessTheme? cupertinoTheme;

  /// Optional platform override for deterministic testing.
  final TargetPlatform? platformOverride;

  /// Child subtree that will receive the selected headless theme.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final hasMaterialTheme =
        context.findAncestorWidgetOfExactType<Theme>() != null;
    final platform = platformOverride ??
        (hasMaterialTheme ? Theme.of(context).platform : defaultTargetPlatform);

    final useCupertino =
        platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;

    final theme = useCupertino
        ? (cupertinoTheme ?? CupertinoHeadlessTheme())
        : (materialTheme ?? MaterialHeadlessTheme());

    return HeadlessThemeProvider(
      theme: theme,
      child: child,
    );
  }
}
