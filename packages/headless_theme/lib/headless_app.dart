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
    this.focusHighlightController,
    this.focusHighlightPolicy = const HeadlessFlutterFocusHighlightPolicy(),
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

  /// Optional external focus highlight controller.
  ///
  /// If provided, it will NOT be disposed by this widget.
  final HeadlessFocusHighlightController? focusHighlightController;

  /// Policy used when [focusHighlightController] is not provided.
  ///
  /// Defaults to Flutter-like focus highlight behavior:
  /// show focus highlight only in keyboard navigation mode.
  final HeadlessFocusHighlightPolicy focusHighlightPolicy;

  /// When enabled, AnchoredOverlayEngineHost will request reposition every frame while overlays
  /// are active.
  final bool enableAutoRepositionTicker;

  @override
  State<HeadlessApp> createState() => _HeadlessAppState();
}

class _HeadlessAppState extends State<HeadlessApp> {
  late final OverlayController _overlayController;
  late final bool _ownsOverlayController;
  late final HeadlessFocusHighlightController _focusHighlightController;
  late final bool _ownsFocusHighlightController;

  @override
  void initState() {
    super.initState();
    final external = widget.overlayController;
    _ownsOverlayController = external == null;
    _overlayController = external ?? OverlayController();

    final externalFocus = widget.focusHighlightController;
    _ownsFocusHighlightController = externalFocus == null;
    _focusHighlightController = externalFocus ??
        HeadlessFocusHighlightController(policy: widget.focusHighlightPolicy);
  }

  @override
  void dispose() {
    if (_ownsOverlayController) {
      _overlayController.dispose();
    }
    if (_ownsFocusHighlightController) {
      _focusHighlightController.dispose();
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
      child: HeadlessFocusHighlightScope(
        controller: _focusHighlightController,
        child: widget.appBuilder(overlayBuilder),
      ),
    );
  }
}
