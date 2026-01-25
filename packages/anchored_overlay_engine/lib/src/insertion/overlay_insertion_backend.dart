import 'package:flutter/widgets.dart';

abstract interface class OverlayInsertionHandle {
  bool get isShowing;
  void show();
  void hide();
}

abstract interface class OverlayInsertionBackend {
  OverlayInsertionHandle createHandle({String? debugLabel});

  Widget build({
    required OverlayInsertionHandle handle,
    required WidgetBuilder overlayBuilder,
    Widget? child,
    required bool targetRootOverlay,
  });
}
