import 'package:flutter/foundation.dart';

/// Stable identifier for listbox items.
///
/// Components can derive ids from indices or values. The id must be stable
/// for the lifetime of the items list to avoid highlight/selection drift.
@immutable
final class ListboxItemId {
  const ListboxItemId(this.value);

  final String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ListboxItemId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'ListboxItemId($value)';
}
