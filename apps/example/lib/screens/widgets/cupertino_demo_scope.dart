import 'package:flutter/cupertino.dart';
import 'package:headless/headless.dart';

import '../../example_cupertino_headless_theme.dart';
import '../../theme_mode_scope.dart';

class CupertinoDemoScope extends StatelessWidget {
  const CupertinoDemoScope({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scope = ThemeModeScope.of(context);
    final brightness = scope.isDark ? Brightness.dark : Brightness.light;

    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: brightness,
        primaryColor: brightness == Brightness.dark
            ? const Color(0xFF0A84FF)
            : const Color(0xFF007AFF),
      ),
      child: HeadlessThemeProvider(
        theme: scope.isDark
            ? ExampleCupertinoHeadlessTheme.dark()
            : ExampleCupertinoHeadlessTheme.light(),
        child: child,
      ),
    );
  }
}
