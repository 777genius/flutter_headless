import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../controller/overlay_controller.dart';
import '../controller/overlay_entry_data.dart';
import '../insertion/overlay_insertion_backend.dart';
import '../lifecycle/overlay_handle.dart';
import '../lifecycle/overlay_phase.dart';
import 'overlay_content.dart';
import 'overlay_hit_test_tag.dart';

final class AnchoredOverlayPortalStack extends StatelessWidget {
  const AnchoredOverlayPortalStack({
    super.key,
    required this.controller,
    required this.child,
    required this.insertionHandles,
    required this.backend,
    required this.targetRootOverlay,
  });

  final OverlayController controller;
  final Widget child;
  final Map<OverlayHandle, OverlayInsertionHandle> insertionHandles;
  final OverlayInsertionBackend backend;
  final bool targetRootOverlay;

  @override
  Widget build(BuildContext context) {
    final entries = controller.entries;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        controller.requestReposition(ensureFrame: false);
        return false;
      },
      child: OverlayOutsideTapDismissLayer(
        controller: controller,
        child: Stack(
          fit: StackFit.expand,
          children: [
            child,
            ...entries.map(
              (entry) => AnchoredOverlayPortalLayer(
                key: ValueKey(entry.handle),
                entry: entry,
                insertionHandle: insertionHandles[entry.handle],
                backend: backend,
                targetRootOverlay: targetRootOverlay,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class OverlayOutsideTapDismissLayer extends StatefulWidget {
  const OverlayOutsideTapDismissLayer({
    super.key,
    required this.controller,
    required this.child,
  });

  final OverlayController controller;
  final Widget child;

  @override
  State<OverlayOutsideTapDismissLayer> createState() =>
      _OverlayOutsideTapDismissLayerState();
}

final class _OverlayOutsideTapDismissLayerState
    extends State<OverlayOutsideTapDismissLayer> {
  int? _downPointer;
  bool _downOnOverlay = false;
  Offset? _downPosition;
  bool _moved = false;
  OverlayHandle? _downTopHandle;
  int _downEntryCount = 0;

  bool _hitIsOnOverlay(Offset globalPosition) {
    final result = HitTestResult();
    final viewId = View.of(context).viewId;
    GestureBinding.instance.hitTestInView(result, globalPosition, viewId);
    return result.path.any((entry) {
      final target = entry.target;
      return target is RenderMetaData &&
          identical(target.metaData, overlayHitTestTag);
    });
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons != kPrimaryButton) {
      return;
    }

    _downPointer = event.pointer;
    _downOnOverlay = _hitIsOnOverlay(event.position);
    _downPosition = event.position;
    _moved = false;
    final entriesAtDown = widget.controller.entries;
    _downEntryCount = entriesAtDown.length;
    _downTopHandle = entriesAtDown.isEmpty ? null : entriesAtDown.last.handle;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (event.pointer != _downPointer) return;
    final down = _downPosition;
    if (down == null) return;
    if ((event.position - down).distanceSquared > 16) {
      _moved = true;
    }
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (event.pointer != _downPointer) return;
    _resetPointerState();
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (event.pointer != _downPointer) return;
    final wasOnOverlay = _downOnOverlay;
    final moved = _moved;
    final downTopHandle = _downTopHandle;
    final downEntryCount = _downEntryCount;

    _resetPointerState();

    if (wasOnOverlay || moved) return;
    if (downEntryCount == 0 || downTopHandle == null) return;

    final entries = widget.controller.entries;
    if (entries.isEmpty) return;
    final top = entries.last;
    if (!identical(top.handle, downTopHandle)) return;
    if (!top.dismissPolicy.dismissOnOutsideTap) return;
    if (!top.dismissPolicy.barrierDismissible) return;
    top.handle.close();
  }

  void _resetPointerState() {
    _downPointer = null;
    _downOnOverlay = false;
    _downPosition = null;
    _moved = false;
    _downTopHandle = null;
    _downEntryCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      child: widget.child,
    );
  }
}

final class AnchoredOverlayPortalLayer extends StatelessWidget {
  const AnchoredOverlayPortalLayer({
    super.key,
    required this.entry,
    required this.insertionHandle,
    required this.backend,
    required this.targetRootOverlay,
  });

  final OverlayEntryData entry;
  final OverlayInsertionHandle? insertionHandle;
  final OverlayInsertionBackend backend;
  final bool targetRootOverlay;

  @override
  Widget build(BuildContext context) {
    final handle = insertionHandle;
    if (handle == null) {
      return const SizedBox.shrink();
    }

    return backend.build(
      handle: handle,
      overlayBuilder: (overlayContext) {
        return ValueListenableBuilder<OverlayPhase>(
          valueListenable: entry.handle.phase,
          builder: (context, phase, _) {
            if (phase == OverlayPhase.closed) {
              return const SizedBox.shrink();
            }

            final canDismissOnOutsideTap =
                entry.dismissPolicy.barrierDismissible &&
                    entry.dismissPolicy.dismissOnOutsideTap;

            return OverlayContent(
              phase: phase,
              builder: entry.overlayBuilder,
              onBarrierTap:
                  canDismissOnOutsideTap ? () => entry.handle.close() : null,
              onFocusLoss: entry.dismissPolicy.dismissOnFocusLoss
                  ? () => entry.handle.close()
                  : null,
              onEscapePressed: entry.dismissPolicy.dismissOnEscape
                  ? () => entry.handle.close()
                  : null,
              focusPolicy: entry.focusPolicy,
              focusScopeNode: entry.focusScopeNode,
              barrierPolicy: entry.barrierPolicy,
              anchorRectGetter: entry.anchor?.rect,
              restoreFocus: entry.restoreFocus,
            );
          },
        );
      },
      child: const SizedBox.shrink(),
      targetRootOverlay: targetRootOverlay,
    );
  }
}
