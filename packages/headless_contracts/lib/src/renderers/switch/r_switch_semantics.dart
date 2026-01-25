import 'package:flutter/widgets.dart';

/// Semantic information for switch accessibility.
@immutable
final class RSwitchSemantics {
  const RSwitchSemantics({
    this.label,
    required this.isEnabled,
    required this.value,
  });

  /// Accessibility label for screen readers.
  final String? label;

  /// Whether the switch is currently enabled.
  final bool isEnabled;

  /// The current switch value.
  final bool value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RSwitchSemantics &&
        other.label == label &&
        other.isEnabled == isEnabled &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(label, isEnabled, value);
}
