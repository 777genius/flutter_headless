import 'package:flutter/foundation.dart';

/// Type-safe key for accessing typed features in feature bags.
///
/// Used with both [HeadlessItemFeatures] (item-level) and
/// [HeadlessRequestFeatures] (request-level).
///
/// Example:
/// ```dart
/// const myFeatureKey = HeadlessFeatureKey<String>(#myFeature);
/// final features = HeadlessItemFeatures.build((b) {
///   b.set(myFeatureKey, 'value');
/// });
/// final value = features.get(myFeatureKey); // 'value'
/// ```
@immutable
final class HeadlessFeatureKey<T> {
  const HeadlessFeatureKey(this.id, {this.debugName});

  /// Unique identifier for this feature key.
  final Symbol id;

  /// Optional human-readable name for debugging.
  final String? debugName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is HeadlessFeatureKey && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => debugName ?? id.toString();
}
