import 'package:flutter/widgets.dart';
import 'package:anchored_overlay_engine/anchored_overlay_engine.dart';

/// Backwards-compatible wrapper for [AnchoredOverlayEngineHost].
class OverlayHost extends StatelessWidget {
  const OverlayHost({
    super.key,
    required this.controller,
    required this.child,
    this.useRootOverlay = false,
    this.enableAutoRepositionTicker = false,
    this.insertionBackend,
  });

  final OverlayController controller;
  final Widget child;
  final bool useRootOverlay;
  final bool enableAutoRepositionTicker;
  final OverlayInsertionBackend? insertionBackend;

  @override
  Widget build(BuildContext context) {
    return AnchoredOverlayEngineHost(
      controller: controller,
      child: child,
      useRootOverlay: useRootOverlay,
      enableAutoRepositionTicker: enableAutoRepositionTicker,
      insertionBackend: insertionBackend,
    );
  }

  static OverlayController? maybeOf(BuildContext context) {
    return AnchoredOverlayEngineHost.maybeOf(context);
  }

  static OverlayController of(
    BuildContext context, {
    String componentName = 'Widget',
  }) {
    return AnchoredOverlayEngineHost.of(
      context,
      componentName: componentName,
    );
  }
}
