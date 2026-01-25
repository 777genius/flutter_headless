import 'package:flutter/widgets.dart';

/// Semantic information for checkbox list tile accessibility.
@immutable
final class RCheckboxListTileSemantics {
  const RCheckboxListTileSemantics({
    this.label,
    required this.isEnabled,
    required this.value,
    required this.isTristate,
  });

  final String? label;
  final bool isEnabled;
  final bool? value;
  final bool isTristate;

  bool get isChecked => value == true;
  bool get isIndeterminate => isTristate && value == null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RCheckboxListTileSemantics &&
        other.label == label &&
        other.isEnabled == isEnabled &&
        other.value == value &&
        other.isTristate == isTristate;
  }

  @override
  int get hashCode => Object.hash(label, isEnabled, value, isTristate);
}

