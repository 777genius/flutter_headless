import 'package:flutter/foundation.dart';

import 'headless_feature_key.dart';

/// Immutable bag of typed features for render requests.
///
/// Used to pass typed data (e.g., loading state, error info) from
/// headless components to renderers/presets without mixing with
/// visual overrides.
///
/// Example:
/// ```dart
/// const remoteStateKey = HeadlessFeatureKey<RemoteState>(#remoteState);
///
/// final features = HeadlessRequestFeatures.build((b) {
///   b.set(remoteStateKey, RemoteState.loading);
/// });
///
/// // In renderer/slot:
/// final state = request.features.get(remoteStateKey);
/// if (state?.isLoading == true) {
///   return CircularProgressIndicator();
/// }
/// ```
@immutable
final class HeadlessRequestFeatures {
  const HeadlessRequestFeatures._(this._values);

  /// Empty features instance.
  static const HeadlessRequestFeatures empty =
      HeadlessRequestFeatures._(<Symbol, Object>{});

  final Map<Symbol, Object> _values;

  /// Returns true if no features are set.
  bool get isEmpty => _values.isEmpty;

  /// Returns true if any features are set.
  bool get isNotEmpty => _values.isNotEmpty;

  /// Gets the value for a typed feature key.
  ///
  /// Returns null if the key is not present.
  /// In debug mode, asserts if the value type doesn't match the key type.
  T? get<T>(HeadlessFeatureKey<T> key) {
    final value = _values[key.id];
    if (value == null) return null;
    assert(
      value is T,
      'HeadlessRequestFeatures: key $key expects $T but got ${value.runtimeType}',
    );
    return value as T;
  }

  /// Checks if a feature key is present.
  bool has<T>(HeadlessFeatureKey<T> key) => _values.containsKey(key.id);

  /// Creates a new features instance using a builder.
  static HeadlessRequestFeatures build(
    void Function(HeadlessRequestFeaturesBuilder b) build,
  ) {
    final b = HeadlessRequestFeaturesBuilder._();
    build(b);
    if (b._values.isEmpty) return empty;
    return HeadlessRequestFeatures._(Map<Symbol, Object>.unmodifiable(b._values));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HeadlessRequestFeatures && mapEquals(other._values, _values);
  }

  @override
  int get hashCode => Object.hashAllUnordered(
        _values.entries.map((e) => Object.hash(e.key, e.value)),
      );

  @override
  String toString() {
    if (isEmpty) return 'HeadlessRequestFeatures.empty';
    return 'HeadlessRequestFeatures($_values)';
  }
}

/// Builder for [HeadlessRequestFeatures].
final class HeadlessRequestFeaturesBuilder {
  HeadlessRequestFeaturesBuilder._();

  final Map<Symbol, Object> _values = <Symbol, Object>{};

  /// Sets a typed feature value.
  ///
  /// In debug mode, asserts if the key was already set with a different type.
  void set<T>(HeadlessFeatureKey<T> key, T value) {
    assert(
      !_values.containsKey(key.id) || _values[key.id] is T,
      'HeadlessRequestFeatures: key $key already set with '
      '${_values[key.id]!.runtimeType}, cannot set $T',
    );
    _values[key.id] = value as Object;
  }
}
