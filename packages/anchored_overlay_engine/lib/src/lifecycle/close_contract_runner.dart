import 'package:flutter/foundation.dart';

/// A small helper to implement the overlay close contract safely.
///
/// Problem this solves:
/// - close can be triggered multiple times
/// - close can be cancelled by a quick reopen (race)
/// - dispose can happen mid-animation
///
/// This helper provides:
/// - token-based cancellation of pending async completions
/// - at-most-once completion
/// - a simple API that stays UI-free (presets own animations)
final class CloseContractRunner {
  CloseContractRunner({
    required VoidCallback onCompleteClose,
  }) : _onCompleteClose = onCompleteClose;

  final VoidCallback _onCompleteClose;

  int _token = 0;
  bool _closeInProgress = false;
  bool _didCompleteClose = false;

  bool get isClosing => _closeInProgress;

  /// Starts a close attempt and waits for [runExitAnimation] to complete.
  ///
  /// If a newer close/reopen happens while the future is pending, completion is ignored.
  void startClosing({
    required Future<void> Function() runExitAnimation,
  }) {
    if (_didCompleteClose) return;

    _token++;
    final token = _token;
    _closeInProgress = true;

    runExitAnimation().then((_) {
      if (token != _token) return;
      completeCloseOnce();
    }).catchError((_) {});
  }

  /// Cancels a pending close attempt (e.g. reopen happened).
  void cancelClosing() {
    _token++;
    _closeInProgress = false;
  }

  /// Completes close at most once.
  void completeCloseOnce() {
    if (_didCompleteClose) return;
    _didCompleteClose = true;
    _closeInProgress = false;
    _onCompleteClose();
  }

  /// Call from `dispose()` of the widget that owns the close animation.
  ///
  /// If the close is in progress, we still must complete close to avoid leaks.
  void dispose() {
    if (_closeInProgress && !_didCompleteClose) {
      completeCloseOnce();
    }
  }
}
