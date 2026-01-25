import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import 'package:headless_theme/src/theme/headless_theme.dart';
import 'package:headless_theme/src/theme/headless_theme_provider.dart';

/// Universal bootstrap for Headless.
///
/// This is the minimal, preset-agnostic wrapper that installs:
/// - [HeadlessThemeProvider]
/// - [AnchoredOverlayEngineHost] (via [appBuilder])
/// - lifecycle management for [OverlayController] (unless provided externally)
///
/// Use this when you want DRY setup without tying to Material/Cupertino.
///
/// Preset-specific helpers (`HeadlessMaterialApp`, `HeadlessCupertinoApp`)
/// can be implemented on top of this shell.
class HeadlessApp extends StatefulWidget {
  const HeadlessApp({
    super.key,
    required this.theme,
    required this.appBuilder,
    this.overlayController,
    this.enableAutoRepositionTicker = false,
  });

  /// Headless capability provider (required).
  final HeadlessTheme theme;

  /// Builds the app widget (Material/Cupertino/etc) and installs [AnchoredOverlayEngineHost]
  /// in the correct place (typically via `MaterialApp.builder` / `CupertinoApp.builder`).
  final Widget Function(TransitionBuilder overlayBuilder) appBuilder;

  /// Optional external overlay controller.
  ///
  /// If provided, it will NOT be disposed by this widget.
  final OverlayController? overlayController;

  /// When enabled, AnchoredOverlayEngineHost will request reposition every frame while overlays
  /// are active.
  final bool enableAutoRepositionTicker;

  @override
  State<HeadlessApp> createState() => _HeadlessAppState();
}

class _HeadlessAppState extends State<HeadlessApp> {
  late final OverlayController _overlayController;
  late final bool _ownsOverlayController;

  @override
  void initState() {
    super.initState();
    final external = widget.overlayController;
    _ownsOverlayController = external == null;
    _overlayController = external ?? OverlayController();
  }

  @override
  void dispose() {
    if (_ownsOverlayController) {
      _overlayController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget overlayBuilder(BuildContext context, Widget? child) {
      return AnchoredOverlayEngineHost(
        controller: _overlayController,
        enableAutoRepositionTicker: widget.enableAutoRepositionTicker,
        child: child ?? const SizedBox.shrink(),
      );
    }

    return HeadlessThemeProvider(
      theme: widget.theme,
      child: widget.appBuilder(overlayBuilder),
    );
  }
}

