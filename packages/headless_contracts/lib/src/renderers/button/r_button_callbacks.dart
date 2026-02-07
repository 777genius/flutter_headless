import 'package:flutter/widgets.dart';

/// Callback references for button rendering (visual-only).
///
/// Renderer uses these for ink/highlight effects, not for activation.
/// The component remains the single source of activation.
@immutable
final class RButtonCallbacks {
  const RButtonCallbacks({
    this.onPressed,
  });

  /// Reference to the press handler.
  ///
  /// Used by renderer for visual feedback only.
  final VoidCallback? onPressed;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RButtonCallbacks && other.onPressed == onPressed;
  }

  @override
  int get hashCode => onPressed.hashCode;
}
