import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../controller/overlay_controller.dart';
import '../insertion/overlay_insertion_backend.dart';
import '../lifecycle/overlay_handle.dart';
import 'anchored_overlay_portal_stack.dart';
import 'anchored_overlay_engine_host.dart';

final class AnchoredOverlayEngineHostContent extends StatelessWidget {
  const AnchoredOverlayEngineHostContent({
    super.key,
    required this.controller,
    required this.child,
    required this.insertionHandles,
    required this.backend,
    required this.targetRootOverlay,
    required this.hasOverlays,
    required this.shouldAutofocusHost,
  });

  final OverlayController controller;
  final Widget child;
  final Map<OverlayHandle, OverlayInsertionHandle> insertionHandles;
  final OverlayInsertionBackend backend;
  final bool targetRootOverlay;
  final bool hasOverlays;
  final bool shouldAutofocusHost;

  @override
  Widget build(BuildContext context) {
    final stack = AnchoredOverlayPortalStack(
      controller: controller,
      child: child,
      insertionHandles: insertionHandles,
      backend: backend,
      targetRootOverlay: targetRootOverlay,
    );

    return Shortcuts(
      shortcuts: hasOverlays
          ? const <ShortcutActivator, Intent>{
              SingleActivator(LogicalKeyboardKey.escape): CloseOverlayIntent(),
            }
          : const <ShortcutActivator, Intent>{},
      child: Actions(
        actions: hasOverlays
            ? <Type, Action<Intent>>{
                CloseOverlayIntent: CallbackAction<CloseOverlayIntent>(
                  onInvoke: (intent) {
                    controller.dismissTopByEscape();
                    return null;
                  },
                ),
              }
            : const <Type, Action<Intent>>{},
        child: Focus(
          autofocus: shouldAutofocusHost,
          canRequestFocus: hasOverlays,
          skipTraversal: !hasOverlays,
          child: stack,
        ),
      ),
    );
  }
}
