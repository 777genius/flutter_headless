import 'package:flutter/foundation.dart';

/// Type-safe override bag for theme capabilities.
///
/// Important: this is NOT per-instance rendering overrides.
/// Use [RenderOverrides] for per-widget token/visual overrides.
///
/// This bag is intended for subtree-scoped capability replacement, e.g.
/// replacing `RDropdownButtonRenderer` on a specific screen.
@immutable
final class CapabilityOverrides {
  const CapabilityOverrides._(this._overrides);

  final Map<Type, Object> _overrides;

  /// Empty overrides.
  static const CapabilityOverrides empty =
      CapabilityOverrides._(<Type, Object>{});

  /// Convenience helper for the common case: one capability override.
  ///
  /// This is type-safe: key and value share the same generic type [T].
  static CapabilityOverrides only<T extends Object>(T value) {
    return CapabilityOverrides._(<Type, Object>{T: value});
  }

  /// Build overrides using a type-safe builder.
  ///
  /// This avoids exposing a `Map<Type, Object>` constructor, which would make
  /// it easy to accidentally store mismatched types and crash later on cast.
  static CapabilityOverrides build(
      void Function(CapabilityOverridesBuilder b) f) {
    final b = CapabilityOverridesBuilder._();
    f(b);
    return CapabilityOverrides._(Map<Type, Object>.unmodifiable(b._map));
  }

  /// Get override by type.
  ///
  /// Returns null if no override of this type is registered.
  T? get<T>() {
    final value = _overrides[T];
    if (value == null) return null;
    return value as T;
  }

  /// Check if an override of the given type exists.
  bool has<T>() => _overrides.containsKey(T);

  /// Create a new bag with additional overrides merged (the other wins).
  CapabilityOverrides merge(CapabilityOverrides other) {
    if (identical(this, other)) return this;
    if (_overrides.isEmpty) return other;
    if (other._overrides.isEmpty) return this;
    return CapabilityOverrides._(
      <Type, Object>{..._overrides, ...other._overrides},
    );
  }

  /// Create a new bag with one override added or replaced.
  CapabilityOverrides with_<T extends Object>(T value) {
    if (_overrides[T] == value) return this;
    return CapabilityOverrides._(<Type, Object>{..._overrides, T: value});
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CapabilityOverrides &&
        mapEquals(_overrides, other._overrides);
  }

  @override
  int get hashCode => Object.hashAll(_overrides.entries);
}

/// Builder for [CapabilityOverrides].
///
/// Kept minimal on purpose: only type-safe `set<T>(T value)`.
final class CapabilityOverridesBuilder {
  CapabilityOverridesBuilder._();

  final Map<Type, Object> _map = <Type, Object>{};

  void set<T extends Object>(T value) {
    _map[T] = value;
  }
}
