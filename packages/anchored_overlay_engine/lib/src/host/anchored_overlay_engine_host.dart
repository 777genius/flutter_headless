import 'package:flutter/scheduler.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'overlay_hit_test_tag.dart';

import 'package:flutter/services.dart';

import '../controller/overlay_controller.dart';
import '../controller/overlay_entry_data.dart';
import '../insertion/overlay_insertion_backend.dart';
import '../insertion/overlay_portal_insertion_backend.dart';
import '../lifecycle/overlay_handle.dart';
import '../lifecycle/overlay_phase.dart';
import 'missing_overlay_host_exception.dart';
import 'overlay_content.dart';

/// Intent to close the topmost overlay.
class CloseOverlayIntent extends Intent {
  const CloseOverlayIntent();
}

/// A widget that hosts anchored overlay layers.
class AnchoredOverlayEngineHost extends StatefulWidget {
  const AnchoredOverlayEngineHost({
    super.key,
    required this.controller,
    required this.child,
    this.useRootOverlay = false,
    this.enableAutoRepositionTicker = false,
    this.insertionBackend,
  });

  /// The controller managing overlay layers.
  final OverlayController controller;

  /// The child widget (your app content).
  final Widget child;

  /// When true, uses the closest root [Overlay] above this host.
  final bool useRootOverlay;

  /// When enabled, host will request reposition every frame while overlays
  /// are active.
  final bool enableAutoRepositionTicker;

  /// Optional insertion backend (defaults to [OverlayPortalInsertionBackend]).
  final OverlayInsertionBackend? insertionBackend;

  /// Get the nearest [OverlayController] from context.
  static OverlayController? maybeOf(BuildContext context) {
    return context
        .findAncestorWidgetOfExactType<AnchoredOverlayEngineHost>()
        ?.controller;
  }

  /// Get the nearest [OverlayController] from context.
  ///
  /// Throws [MissingOverlayHostException] if no host is found.
  static OverlayController of(
    BuildContext context, {
    String componentName = 'Widget',
  }) {
    final controller = maybeOf(context);
    if (controller == null) {
      throw MissingOverlayHostException(componentName: componentName);
    }
    return controller;
  }

  @override
  State<AnchoredOverlayEngineHost> createState() =>
      _AnchoredOverlayEngineHostState();
}

class _AnchoredOverlayEngineHostState extends State<AnchoredOverlayEngineHost>
    with WidgetsBindingObserver {
  late final OverlayEntry _localOverlayEntry;
  final Map<OverlayHandle, OverlayInsertionHandle> _insertionHandles = {};
  Ticker? _ticker;
  bool _tickerActive = false;

  OverlayInsertionBackend get _backend =>
      widget.insertionBackend ?? const OverlayPortalInsertionBackend();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.controller.addListener(_onControllerChanged);

    _localOverlayEntry = OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) => _OverlayPortalStack(
          controller: widget.controller,
          child: widget.child,
          insertionHandles: _insertionHandles,
          backend: _backend,
          targetRootOverlay: widget.useRootOverlay,
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(AnchoredOverlayEngineHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      // Be defensive: the controller may be disposed earlier than the host
      // (e.g. user-managed lifecycle). Avoid debug-mode crashes.
      try {
        oldWidget.controller.removeListener(_onControllerChanged);
      } catch (_) {}
      try {
        widget.controller.addListener(_onControllerChanged);
      } catch (_) {}
    }

    if (oldWidget.child != widget.child ||
        oldWidget.useRootOverlay != widget.useRootOverlay ||
        oldWidget.insertionBackend != widget.insertionBackend) {
      _localOverlayEntry.markNeedsBuild();
    }

    if (oldWidget.insertionBackend != widget.insertionBackend) {
      for (final handle in _insertionHandles.values) {
        handle.hide();
      }
      _insertionHandles.clear();
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    // Be defensive: controller might already be disposed.
    try {
      widget.controller.removeListener(_onControllerChanged);
    } catch (_) {}
    WidgetsBinding.instance.removeObserver(this);
    for (final handle in _insertionHandles.values) {
      handle.hide();
    }
    _insertionHandles.clear();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Keyboard / resize / orientation changes.
    widget.controller.requestReposition();
  }

  void _updateTicker({required bool hasOverlays}) {
    final shouldRun = widget.enableAutoRepositionTicker && hasOverlays;
    if (shouldRun == _tickerActive) return;
    _tickerActive = shouldRun;

    if (!shouldRun) {
      _ticker?.stop();
      return;
    }

    _ticker ??= Ticker((_) {
      // Frames are already produced by the engine; do not schedule a new one.
      widget.controller.requestReposition(ensureFrame: false);
    });
    _ticker!.start();
  }

  void _syncInsertionHandles() {
    final currentEntries = widget.controller.entries;
    final currentHandles = currentEntries.map((entry) => entry.handle).toSet();

    final removedHandles = _insertionHandles.keys
        .where((handle) => !currentHandles.contains(handle))
        .toList();
    for (final handle in removedHandles) {
      _insertionHandles.remove(handle)?.hide();
    }

    for (final entry in currentEntries) {
      _insertionHandles.putIfAbsent(
        entry.handle,
        () => _backend.createHandle(debugLabel: 'OverlayEntry'),
      );
    }
  }

  void _scheduleVisibilitySync() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final entry in widget.controller.entries) {
        final insertionHandle = _insertionHandles[entry.handle];
        if (insertionHandle == null) continue;
        if (entry.handle.phase.value == OverlayPhase.closed) {
          insertionHandle.hide();
        } else {
          insertionHandle.show();
        }
      }
    });
  }

  void _onControllerChanged() {
    _syncInsertionHandles();
    _scheduleVisibilitySync();
    setState(() {});
  }

  Widget _buildContent(BuildContext context) {
    final hasOverlays = widget.controller.hasActiveOverlays;
    _updateTicker(hasOverlays: hasOverlays);
    final shouldAutofocusHost =
        hasOverlays && FocusManager.instance.primaryFocus == null;

    final stack = _OverlayPortalStack(
      controller: widget.controller,
      child: widget.child,
      insertionHandles: _insertionHandles,
      backend: _backend,
      targetRootOverlay: widget.useRootOverlay,
    );

    // Always wrap in the same structure to preserve widget tree identity.
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
                    widget.controller.dismissTopByEscape();
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

  @override
  Widget build(BuildContext context) {
    if (widget.useRootOverlay && Overlay.maybeOf(context) == null) {
      throw FlutterError(
        'AnchoredOverlayEngineHost(useRootOverlay: true) requires an Overlay ancestor.',
      );
    }

    if (widget.useRootOverlay) {
      return _buildContent(context);
    }

    return Overlay(
      initialEntries: <OverlayEntry>[
        _localOverlayEntry,
      ],
    );
  }
}

class _OverlayPortalStack extends StatelessWidget {
  const _OverlayPortalStack({
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
      onNotification: (n) {
        controller.requestReposition(ensureFrame: false);
        return false;
      },
      child: _OutsideTapDismissLayer(
        controller: controller,
        child: Stack(
          fit: StackFit.expand,
          children: [
            child,
            ...entries.map(
              (entry) => _OverlayPortalLayer(
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

final class _OutsideTapDismissLayer extends StatefulWidget {
  const _OutsideTapDismissLayer({
    required this.controller,
    required this.child,
  });

  final OverlayController controller;
  final Widget child;

  @override
  State<_OutsideTapDismissLayer> createState() => _OutsideTapDismissLayerState();
}

final class _OutsideTapDismissLayerState extends State<_OutsideTapDismissLayer> {
  int? _downPointer;
  bool _downOnOverlay = false;
  Offset? _downPosition;
  bool _moved = false;
  OverlayHandle? _downTopHandle;
  int _downEntryCount = 0;

  bool _hitIsOnOverlay(Offset globalPosition) {
    final result = HitTestResult();
    // Use view-aware hit testing (multi-view safe).
    final viewId = View.of(context).viewId;
    GestureBinding.instance.hitTestInView(result, globalPosition, viewId);
    return result.path.any((entry) {
      final target = entry.target;
      return target is RenderMetaData && identical(target.metaData, overlayHitTestTag);
    });
  }

  void _handlePointerDown(PointerDownEvent e) {
    // Ignore non-primary mouse buttons.
    if (e.kind == PointerDeviceKind.mouse && e.buttons != kPrimaryButton) return;

    _downPointer = e.pointer;
    _downOnOverlay = _hitIsOnOverlay(e.position);
    _downPosition = e.position;
    _moved = false;
    final entriesAtDown = widget.controller.entries;
    _downEntryCount = entriesAtDown.length;
    _downTopHandle = entriesAtDown.isEmpty ? null : entriesAtDown.last.handle;

    if (_downOnOverlay) return;
  }

  void _handlePointerMove(PointerMoveEvent e) {
    if (e.pointer != _downPointer) return;
    final down = _downPosition;
    if (down == null) return;
    // Treat as a drag/scroll gesture if the pointer moved beyond a small slop.
    if ((e.position - down).distanceSquared > 16) {
      _moved = true;
    }
  }

  void _handlePointerCancel(PointerCancelEvent e) {
    if (e.pointer != _downPointer) return;
    _downPointer = null;
    _downOnOverlay = false;
    _downPosition = null;
    _moved = false;
    _downTopHandle = null;
    _downEntryCount = 0;
  }

  void _handlePointerUp(PointerUpEvent e) {
    if (e.pointer != _downPointer) return;
    final wasOnOverlay = _downOnOverlay;
    final moved = _moved;
    final downTopHandle = _downTopHandle;
    final downEntryCount = _downEntryCount;

    _downPointer = null;
    _downOnOverlay = false;
    _downPosition = null;
    _moved = false;
    _downTopHandle = null;
    _downEntryCount = 0;

    if (wasOnOverlay) return;
    if (moved) return;

    // Critical: only treat as "outside tap" if the overlay already existed at
    // pointer down. Otherwise the same click that opens an overlay would
    // immediately close it on pointer up (race with overlay insertion).
    if (downEntryCount == 0 || downTopHandle == null) return;

    // Close on "tap outside": down+up outside without drag.
    final entries = widget.controller.entries;
    if (entries.isEmpty) return;
    final top = entries.last;
    // Ensure we're closing the same overlay that existed on pointer down.
    if (!identical(top.handle, downTopHandle)) return;
    if (!top.dismissPolicy.dismissOnOutsideTap) return;
    if (!top.dismissPolicy.barrierDismissible) return;
    top.handle.close();
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

class _OverlayPortalLayer extends StatelessWidget {
  const _OverlayPortalLayer({
    required this.entry,
    required this.insertionHandle,
    required this.backend,
    required this.targetRootOverlay,
    super.key,
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
