import 'package:flutter/widgets.dart';

/// Semantic information for button accessibility.
///
/// This is passed in the render request so the renderer can
/// provide appropriate semantic annotations if needed.
///
/// Note: The component already wraps with Semantics widget,
/// but the renderer may need this info for tooltip/aria hints.
@immutable
final class RButtonSemantics {
  const RButtonSemantics({
    this.label,
    required this.isEnabled,
    this.onTapHint,
  });

  /// Accessibility label for screen readers.
  final String? label;

  /// Whether the button is currently enabled.
  final bool isEnabled;

  /// Optional hint for what happens on tap.
  final String? onTapHint;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RButtonSemantics &&
        other.label == label &&
        other.isEnabled == isEnabled &&
        other.onTapHint == onTapHint;
  }

  @override
  int get hashCode => Object.hash(label, isEnabled, onTapHint);
}
