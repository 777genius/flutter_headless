import 'package:flutter/foundation.dart';
import 'package:headless_foundation/headless_foundation.dart';

/// Source of an autocomplete item (local or remote).
///
/// Used to mark items for visual differentiation in hybrid mode.
enum RAutocompleteItemSource {
  /// Item came from local/in-memory source.
  local,

  /// Item came from remote/async source.
  remote,
}

/// Section identifier for grouped display.
///
/// Allows renderers to group and visually separate items by section.
@immutable
final class RAutocompleteSectionId {
  /// Creates a section ID with the given value.
  const RAutocompleteSectionId(this.value);

  /// The section identifier string.
  final String value;

  /// Standard section ID for local items.
  static const local = RAutocompleteSectionId('local');

  /// Standard section ID for remote items.
  static const remote = RAutocompleteSectionId('remote');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RAutocompleteSectionId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'RAutocompleteSectionId($value)';
}

/// Feature key for item source in item features.
///
/// Use this key to read item source in renderers:
/// ```dart
/// final source = item.features.get(rAutocompleteItemSourceKey);
/// if (source == RAutocompleteItemSource.remote) {
///   // Style differently
/// }
/// ```
const rAutocompleteItemSourceKey = HeadlessFeatureKey<RAutocompleteItemSource>(
  #rAutocompleteItemSource,
  debugName: 'rAutocompleteItemSource',
);

/// Feature key for section ID in item features.
///
/// Use this key to read section ID in renderers for grouping:
/// ```dart
/// final sectionId = item.features.get(rAutocompleteSectionIdKey);
/// // Group items by sectionId
/// ```
const rAutocompleteSectionIdKey = HeadlessFeatureKey<RAutocompleteSectionId>(
  #rAutocompleteSectionId,
  debugName: 'rAutocompleteSectionId',
);
