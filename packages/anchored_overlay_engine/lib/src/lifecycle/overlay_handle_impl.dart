import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'overlay_handle.dart';
import 'overlay_phase.dart';

/// Concrete implementation of [OverlayHandle].
///
/// Lifecycle phases (monotonic transitions only):
/// - opening → open → closing → closed
/// - opening → closing → closed (race: close during opening)
///
/// Invariants:
/// - [close] is idempotent (repeated calls are no-op after first)
/// - [completeClose] is idempotent
/// - Phase transitions are monotonic (no rollback)
/// - Subtree is not removed until [closed] phase
class OverlayHandleImpl implements OverlayHandle {
  OverlayHandleImpl({
    Duration failSafeTimeout = kOverlayFailSafeTimeout,
    OverlayTimeoutCallback? onFailSafeTimeout,
  })  : _failSafeTimeout = failSafeTimeout,
        _onFailSafeTimeout = onFailSafeTimeout;

  final Duration _failSafeTimeout;
  final OverlayTimeoutCallback? _onFailSafeTimeout;

  final ValueNotifier<OverlayPhase> _phase =
      ValueNotifier(OverlayPhase.opening);

  Timer? _failSafeTimer;
  bool _completeCloseScheduled = false;

  /// Whether this handle has been disposed.
  bool _disposed = false;

  @override
  ValueListenable<OverlayPhase> get phase => _phase;

  @override
  bool get isOpen {
    final current = _phase.value;
    return current == OverlayPhase.opening || current == OverlayPhase.open;
  }

  /// Transition to [open] phase.
  ///
  /// Called when the overlay subtree has been mounted.
  /// No-op if already past [opening] phase.
  void markOpen() {
    if (_disposed) return;
    if (_phase.value != OverlayPhase.opening) return;
    _phase.value = OverlayPhase.open;
  }

  @override
  void close() {
    if (_disposed) return;

    final current = _phase.value;
    // Idempotent: no-op if already closing or closed
    if (current == OverlayPhase.closing || current == OverlayPhase.closed) {
      return;
    }

    _phase.value = OverlayPhase.closing;
    _startFailSafeTimer();
  }

  @override
  void completeClose() {
    if (_disposed) return;

    // Idempotent: no-op if already closed
    if (_phase.value == OverlayPhase.closed) return;

    // Calling completeClose synchronously during a widget build can crash the
    // framework because ValueNotifier listeners (ValueListenableBuilder, etc.)
    // may attempt to rebuild while already building.
    //
    // Make it safe by deferring completion to the end of the frame.
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      if (_completeCloseScheduled) return;
      _completeCloseScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _completeCloseScheduled = false;
        completeClose();
      });
      return;
    }

    _cancelFailSafeTimer();
    _phase.value = OverlayPhase.closed;
  }

  void _startFailSafeTimer() {
    _failSafeTimer?.cancel();
    _failSafeTimer = Timer(_failSafeTimeout, _onFailSafeTriggered);
  }

  void _cancelFailSafeTimer() {
    _failSafeTimer?.cancel();
    _failSafeTimer = null;
  }

  void _onFailSafeTriggered() {
    if (_disposed) return;
    if (_phase.value != OverlayPhase.closing) return;

    // Diagnostic callback (may call completeClose internally)
    _onFailSafeTimeout?.call(this);

    // Re-check: callback may have already closed or disposed
    if (_disposed || _phase.value != OverlayPhase.closing) return;

    // Force close
    _phase.value = OverlayPhase.closed;
  }

  /// Dispose resources.
  ///
  /// Should be called when the overlay is removed from the tree.
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _cancelFailSafeTimer();
    _phase.dispose();
  }
}
