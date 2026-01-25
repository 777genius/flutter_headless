import 'package:flutter/widgets.dart';

/// Owns a [FocusNode] unless an external one is provided.
///
/// Responsibilities:
/// - Create an internal FocusNode when external is null
/// - Swap between external/internal nodes on widget updates
/// - Dispose only the internally-owned node
/// - Unfocus owned node before dispose (prevents focus tree issues)
///
/// Non-responsibilities:
/// - Does NOT add/remove listeners (component should manage its listeners)
final class HeadlessFocusNodeOwner {
  HeadlessFocusNodeOwner({
    FocusNode? external,
    String? debugLabel,
  })  : _external = external,
        _debugLabel = debugLabel,
        _node = external ?? FocusNode(debugLabel: debugLabel),
        _ownsNode = external == null;

  FocusNode? _external;
  final String? _debugLabel;
  FocusNode _node;
  bool _ownsNode;

  FocusNode get node => _node;

  /// Rebind owner to a potentially new external node.
  ///
  /// Call from `State.didUpdateWidget` when `widget.focusNode` changes.
  void update(FocusNode? external) {
    if (identical(_external, external)) return;

    final oldNode = _node;
    final oldOwned = _ownsNode;

    _external = external;
    _node = external ?? FocusNode(debugLabel: _debugLabel);
    _ownsNode = external == null;

    if (oldOwned) {
      _safeDispose(oldNode);
    }
  }

  /// Dispose the owned node (no-op when using external node).
  void dispose() {
    if (_ownsNode) {
      _safeDispose(_node);
    }
  }

  void _safeDispose(FocusNode node) {
    if (node.hasFocus) {
      node.unfocus();
    }
    node.dispose();
  }
}

