import 'package:flutter/widgets.dart';

/// Semantic information for dropdown accessibility.
///
/// This is passed in the render request so the renderer can
/// provide appropriate semantic annotations if needed.
@immutable
final class RDropdownSemantics {
  const RDropdownSemantics({
    this.label,
    required this.isExpanded,
    required this.isEnabled,
    this.hint,
  });

  /// Accessibility label for screen readers.
  final String? label;

  /// Whether the dropdown is currently expanded (menu open).
  final bool isExpanded;

  /// Whether the dropdown is currently enabled.
  final bool isEnabled;

  /// Optional hint for screen readers.
  final String? hint;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RDropdownSemantics &&
        other.label == label &&
        other.isExpanded == isExpanded &&
        other.isEnabled == isEnabled &&
        other.hint == hint;
  }

  @override
  int get hashCode => Object.hash(label, isExpanded, isEnabled, hint);
}
