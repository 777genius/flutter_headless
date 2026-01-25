import 'package:flutter/widgets.dart';

import '../model/overlay_request.dart';
import '../policies/overlay_barrier_policy.dart';
import '../policies/overlay_dismiss_policy.dart';
import '../policies/overlay_focus_policy.dart';
import 'overlay_entry_data.dart';
import '../lifecycle/overlay_phase.dart';
import '../lifecycle/overlay_handle.dart';
import '../lifecycle/overlay_handle_impl.dart';

/// Default diagnostic handler for fail-safe timeout.
void _defaultFailSafeHandler(OverlayHandle handle) {
  debugPrint(
    '[AnchoredOverlayEngine] Close contract timeout: renderer did not call completeClose(). '
    'Fix: call OverlayHandle.completeClose() after exit animation. '
    'Tip: use CloseContractRunner.',
  );
}

/// Controller for managing overlay layers.
///
/// Provides [show] to create new overlays and manages stacking (LIFO).
/// Each [show] call returns a new [OverlayHandle] - handles are never reused.
class OverlayController extends ChangeNotifier {
  OverlayController({
    Duration failSafeTimeout = kOverlayFailSafeTimeout,
    OverlayTimeoutCallback? onFailSafeTimeout,
  })  : _failSafeTimeout = failSafeTimeout,
        _onFailSafeTimeout = onFailSafeTimeout ?? _defaultFailSafeHandler;

  final Duration _failSafeTimeout;
  final OverlayTimeoutCallback _onFailSafeTimeout;

  final List<OverlayEntryData> _entries = [];
  bool _isDisposed = false;

  /// Track phase listeners for cleanup during dispose.
  final Map<OverlayHandleImpl, VoidCallback> _phaseListeners = {};
  bool _repositionScheduled = false;

  /// Current overlay entries (LIFO order: last = topmost).
  List<OverlayEntryData> get entries => List.unmodifiable(_entries);

  /// Whether there are any active overlays.
  bool get hasActiveOverlays => _entries.isNotEmpty;

  /// Show a new overlay with the given request.
  ///
  /// Returns a new [OverlayHandle] to control the overlay lifecycle.
  OverlayHandle show(OverlayRequest request) {
    final handle = OverlayHandleImpl(
      failSafeTimeout: _failSafeTimeout,
      onFailSafeTimeout: _onFailSafeTimeout,
    );

    final focusScopeNode = FocusScopeNode(debugLabel: 'OverlayScope');

    late final OverlayEntryData entry;
    VoidCallback? restoreFocusListener;

    void removeEntry() {
      final index = _entries.indexOf(entry);
      if (index != -1) {
        _entries.removeAt(index);

        // Restore focus if specified
        final shouldRestoreFocus = switch (request.focus) {
          ModalFocusPolicy(:final restoreOnClose) => restoreOnClose,
          NonModalFocusPolicy(:final restoreOnClose) => restoreOnClose,
        };

        final restoreFocus = request.restoreFocus;
        if (shouldRestoreFocus &&
            restoreFocus != null &&
            restoreFocus.canRequestFocus) {
          restoreFocus.requestFocus();
        }

        if (!_isDisposed) notifyListeners();
      }
    }

    // Listen for closed phase to remove entry
    void onPhaseChange() {
      if (handle.phase.value == OverlayPhase.closed) {
        handle.phase.removeListener(onPhaseChange);
        _phaseListeners.remove(handle);
        final restoreFocus = request.restoreFocus;
        if (restoreFocusListener != null && restoreFocus != null) {
          try {
            restoreFocus.removeListener(restoreFocusListener);
          } catch (_) {}
        }
        removeEntry();
        // Defer dispose to avoid calling during notifyListeners
        Future.microtask(() {
          try {
            focusScopeNode.dispose();
          } catch (_) {}
          handle.dispose();
        });
      }
    }

    handle.phase.addListener(onPhaseChange);
    _phaseListeners[handle] = onPhaseChange;

    final barrierPolicy = request.barrier ??
        OverlayBarrierPolicy.fromDismissPolicy(request.dismiss);

    entry = OverlayEntryData(
      handle: handle,
      overlayBuilder: request.overlayBuilder,
      dismissPolicy: request.dismiss,
      barrierPolicy: barrierPolicy,
      focusPolicy: request.focus,
      repositionPolicy: request.reposition,
      stackPolicy: request.stack,
      focusScopeNode: focusScopeNode,
      onRemove: removeEntry,
      anchor: request.anchor,
      restoreFocus: request.restoreFocus,
    );

    _entries.add(entry);
    if (!_isDisposed) notifyListeners();

    // Mark as open on next frame (after build)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handle.markOpen();
    });

    // Apply initial focus for modal overlays after mount.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!handle.isOpen) return;
      final policy = request.focus;
      if (policy is ModalFocusPolicy && policy.initialFocus != null) {
        // Wait one more frame so the focus node is guaranteed to be attached
        // to the focus tree under the overlay scope.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!handle.isOpen) return;
          final node = policy.initialFocus!;
          if (node.canRequestFocus) {
            node.requestFocus();
          }
        });
      } else if (policy is ModalFocusPolicy) {
        // For modal overlays we want the overlay scope to participate in focus.
        try {
          focusScopeNode.requestFocus();
        } catch (_) {}
      }
    });

    // Non-modal dismiss-on-focus-loss: close when the anchor/trigger loses focus.
    //
    // This avoids forcing overlay scope focus (which would steal focus from
    // non-modal triggers like autocomplete text fields).
    final restoreFocus = request.restoreFocus;
    if (request.dismiss.dismissOnFocusLoss && restoreFocus != null) {
      restoreFocusListener = () {
        if (!handle.isOpen) return;
        if (!restoreFocus.hasFocus) {
          handle.close();
        }
      };
      restoreFocus.addListener(restoreFocusListener);
    }

    return handle;
  }

  /// Request overlay reposition for anchored overlays.
  ///
  /// Coalesces multiple requests to at most 1 notify per frame.
  void requestReposition({bool ensureFrame = true}) {
    if (_repositionScheduled) return;
    if (_entries.isEmpty) return;
    if (!_entries.any((entry) => entry.needsReposition)) return;
    _repositionScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _repositionScheduled = false;
      if (_entries.isEmpty) return;
      if (!_isDisposed) notifyListeners();
    });

    if (ensureFrame) {
      // Ensure a frame will be produced even if reposition is requested while
      // the scheduler is idle (e.g. manual calls from application code).
      WidgetsBinding.instance.scheduleFrame();
    }
  }

  /// Close all active overlays.
  void closeAll() {
    // Close in reverse order (topmost first)
    for (final entry in _entries.reversed.toList()) {
      entry.handle.close();
    }
  }

  /// Close the topmost overlay.
  void closeTop() {
    if (_entries.isNotEmpty) {
      _entries.last.handle.close();
    }
  }

  /// Dismiss the topmost overlay using its [DismissPolicy].
  ///
  /// Intended for user-driven dismissal (e.g. Escape key). If the topmost
  /// overlay does not allow dismissal via Escape, this is a no-op.
  void dismissTopByEscape() {
    if (_entries.isEmpty) return;
    final top = _entries.last;
    if (!top.dismissPolicy.dismissOnEscape) return;
    top.handle.close();
  }

  @override
  void dispose() {
    _isDisposed = true;
    // Remove all phase listeners first to avoid memory leaks
    for (final entry in _phaseListeners.entries) {
      entry.key.phase.removeListener(entry.value);
    }
    _phaseListeners.clear();

    // Dispose all handles
    for (final entry in _entries) {
      try {
        entry.focusScopeNode.dispose();
      } catch (_) {}
      entry.handle.dispose();
    }
    _entries.clear();
    super.dispose();
  }
}
