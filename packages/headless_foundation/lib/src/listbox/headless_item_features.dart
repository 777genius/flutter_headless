import 'package:flutter/foundation.dart';

import '../features/headless_feature_key.dart';

export '../features/headless_feature_key.dart';

/// Backward-compatible alias for [HeadlessFeatureKey].
///
/// New code should use [HeadlessFeatureKey] directly.
@Deprecated('Use HeadlessFeatureKey instead')
typedef HeadlessItemKey<T> = HeadlessFeatureKey<T>;

@immutable
final class HeadlessItemFeatures {
  const HeadlessItemFeatures._(this._values);

  static const HeadlessItemFeatures empty =
      HeadlessItemFeatures._(<Symbol, Object>{});

  final Map<Symbol, Object> _values;

  bool get isEmpty => _values.isEmpty;

  static HeadlessItemFeatures build(
    void Function(HeadlessItemFeaturesBuilder b) build,
  ) {
    final b = HeadlessItemFeaturesBuilder._();
    build(b);
    return HeadlessItemFeatures._(Map<Symbol, Object>.unmodifiable(b._values));
  }

  /// Gets the value for a typed feature key.
  ///
  /// Returns null if the key is not present.
  /// In debug mode, asserts if the value type doesn't match the key type.
  T? get<T>(HeadlessFeatureKey<T> key) {
    final value = _values[key.id];
    if (value == null) return null;
    assert(
      value is T,
      'HeadlessItemFeatures: key $key expects $T but got ${value.runtimeType}',
    );
    return value as T;
  }

  /// Checks if a feature key is present.
  bool has<T>(HeadlessFeatureKey<T> key) => _values.containsKey(key.id);

  /// Merges this features with [other], returning a new instance.
  ///
  /// If the same key exists in both, [other]'s value takes precedence.
  /// In debug mode, asserts if types don't match for the same key.
  HeadlessItemFeatures merge(HeadlessItemFeatures other) {
    if (other.isEmpty) return this;
    if (isEmpty) return other;

    final merged = <Symbol, Object>{..._values};
    for (final entry in other._values.entries) {
      if (merged.containsKey(entry.key)) {
        final existing = merged[entry.key];
        assert(
          existing.runtimeType == entry.value.runtimeType,
          'HeadlessItemFeatures.merge: type mismatch for key ${entry.key}. '
          'Existing: ${existing.runtimeType}, New: ${entry.value.runtimeType}',
        );
      }
      merged[entry.key] = entry.value;
    }
    return HeadlessItemFeatures._(Map<Symbol, Object>.unmodifiable(merged));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HeadlessItemFeatures && mapEquals(other._values, _values);
  }

  @override
  int get hashCode => Object.hashAllUnordered(
        _values.entries.map((e) => Object.hash(e.key, e.value)),
      );
}

/// Builder for [HeadlessItemFeatures].
final class HeadlessItemFeaturesBuilder {
  HeadlessItemFeaturesBuilder._();

  final Map<Symbol, Object> _values = <Symbol, Object>{};

  /// Sets a typed feature value.
  ///
  /// In debug mode, asserts if the key was already set with a different type.
  void set<T>(HeadlessFeatureKey<T> key, T value) {
    assert(
      !_values.containsKey(key.id) || _values[key.id] is T,
      'HeadlessItemFeatures: key $key already set with ${_values[key.id]!.runtimeType}',
    );
    _values[key.id] = value as Object;
  }
}
