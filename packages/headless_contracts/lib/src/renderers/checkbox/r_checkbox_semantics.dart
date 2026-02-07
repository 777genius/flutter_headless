import 'package:flutter/widgets.dart';

/// Semantic information for checkbox accessibility.
@immutable
final class RCheckboxSemantics {
  const RCheckboxSemantics({
    this.label,
    required this.isEnabled,
    required this.value,
    required this.isTristate,
  });

  /// Accessibility label for screen readers.
  final String? label;

  /// Whether the checkbox is currently enabled.
  final bool isEnabled;

  /// The current checkbox value.
  ///
  /// If [isTristate] is false, this should be non-null.
  final bool? value;

  /// Whether the checkbox supports the indeterminate state.
  final bool isTristate;

  bool get isChecked => value == true;
  bool get isIndeterminate => isTristate && value == null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RCheckboxSemantics &&
        other.label == label &&
        other.isEnabled == isEnabled &&
        other.value == value &&
        other.isTristate == isTristate;
  }

  @override
  int get hashCode => Object.hash(label, isEnabled, value, isTristate);
}
