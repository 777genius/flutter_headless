import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:headless_adaptive/headless_adaptive.dart';

class CheckboxTestApp extends StatelessWidget {
  const CheckboxTestApp({
    super.key,
    required this.child,
    this.platformOverride,
  });

  final Widget child;
  final TargetPlatform? platformOverride;

  @override
  Widget build(BuildContext context) {
    final platform = platformOverride ?? defaultTargetPlatform;
    final useCupertino =
        platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;

    final content = useCupertino
        ? CupertinoPageScaffold(child: SafeArea(child: child))
        : Scaffold(body: SafeArea(child: child));

    return HeadlessAdaptiveApp(
      platformOverride: platformOverride,
      materialTheme: ThemeData(useMaterial3: true),
      cupertinoTheme: const CupertinoThemeData(),
      home: content,
    );
  }
}
