import 'package:flutter/widgets.dart';

/// Semantic information for switch list tile accessibility.
@immutable
final class RSwitchListTileSemantics {
  const RSwitchListTileSemantics({
    this.label,
    required this.isEnabled,
    required this.value,
  });

  final String? label;
  final bool isEnabled;
  final bool value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RSwitchListTileSemantics &&
        other.label == label &&
        other.isEnabled == isEnabled &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(label, isEnabled, value);
}
