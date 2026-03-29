import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../controller/overlay_controller.dart';
import '../insertion/overlay_insertion_backend.dart';
import '../insertion/overlay_portal_insertion_backend.dart';
import '../lifecycle/overlay_handle.dart';
import '../lifecycle/overlay_phase.dart';
import 'anchored_overlay_engine_host_content.dart';
import 'anchored_overlay_portal_stack.dart';
import 'missing_overlay_host_exception.dart';

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
        builder: (context, _) => AnchoredOverlayPortalStack(
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

  Widget _content(BuildContext context) {
    final hasOverlays = widget.controller.hasActiveOverlays;
    _updateTicker(hasOverlays: hasOverlays);
    final shouldAutofocusHost =
        hasOverlays && FocusManager.instance.primaryFocus == null;

    return AnchoredOverlayEngineHostContent(
      controller: widget.controller,
      child: widget.child,
      insertionHandles: _insertionHandles,
      backend: _backend,
      targetRootOverlay: widget.useRootOverlay,
      hasOverlays: hasOverlays,
      shouldAutofocusHost: shouldAutofocusHost,
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
      return _content(context);
    }

    return Overlay(
      initialEntries: <OverlayEntry>[
        _localOverlayEntry,
      ],
    );
  }
}
