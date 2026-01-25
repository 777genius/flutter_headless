import 'package:flutter/widgets.dart';

/// Owns a [TextEditingController] unless an external one is provided.
///
/// Responsibilities:
/// - Create an internal controller when external is null
/// - Swap between external/internal controllers on widget updates
/// - Dispose only the internally-owned controller
///
/// Non-responsibilities:
/// - Does NOT add/remove listeners (component should manage its listeners)
/// - Does NOT implement controlled-mode syncing (value -> text) or IME policies
final class HeadlessTextEditingControllerOwner {
  HeadlessTextEditingControllerOwner({
    TextEditingController? external,
    String? initialText,
  })  : _external = external,
        _controller = external ?? TextEditingController(text: initialText),
        _ownsController = external == null;

  TextEditingController? _external;
  TextEditingController _controller;
  bool _ownsController;

  TextEditingController get controller => _controller;

  /// Rebind owner to a potentially new external controller.
  ///
  /// Call from `State.didUpdateWidget` when `widget.controller` changes.
  /// When switching to internal controller, [initialText] is used.
  void update({
    required TextEditingController? external,
    String? initialText,
  }) {
    if (identical(_external, external)) return;

    final oldController = _controller;
    final oldOwned = _ownsController;

    _external = external;
    _controller = external ?? TextEditingController(text: initialText);
    _ownsController = external == null;

    if (oldOwned) {
      oldController.dispose();
    }
  }

  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
  }
}

