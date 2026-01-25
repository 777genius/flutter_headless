import 'package:flutter/widgets.dart';

import 'overlay_insertion_backend.dart';

final class OverlayPortalInsertionBackend implements OverlayInsertionBackend {
  const OverlayPortalInsertionBackend();

  @override
  OverlayInsertionHandle createHandle({String? debugLabel}) {
    return _OverlayPortalInsertionHandle(
      OverlayPortalController(debugLabel: debugLabel),
    );
  }

  @override
  Widget build({
    required OverlayInsertionHandle handle,
    required WidgetBuilder overlayBuilder,
    Widget? child,
    required bool targetRootOverlay,
  }) {
    final portalHandle = handle as _OverlayPortalInsertionHandle;

    return targetRootOverlay
        // TODO: Replace with non-deprecated root overlay API once Flutter exposes a stable
        // OverlayPortal root overlay configuration without targetsRootOverlay.
        // ignore: deprecated_member_use
        ? OverlayPortal.targetsRootOverlay(
            controller: portalHandle.controller,
            overlayChildBuilder: overlayBuilder,
            child: child,
          )
        : OverlayPortal(
            controller: portalHandle.controller,
            overlayChildBuilder: overlayBuilder,
            child: child,
          );
  }
}

final class _OverlayPortalInsertionHandle implements OverlayInsertionHandle {
  _OverlayPortalInsertionHandle(this.controller);

  final OverlayPortalController controller;

  @override
  bool get isShowing => controller.isShowing;

  @override
  void show() => controller.show();

  @override
  void hide() {
    if (!controller.isShowing) return;
    controller.hide();
  }
}
