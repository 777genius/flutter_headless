import 'package:flutter/foundation.dart';

/// Per-instance override bag for renderers and token resolvers.
///
/// This is a type-safe container for per-instance customization without
/// polluting component APIs with preset-specific parameters.
///
/// Usage:
/// ```dart
/// RTextButton(
///   onPressed: save,
///   overrides: RenderOverrides({
///     RButtonOverrides: RButtonOverrides.tokens(/* ... */),
///   }),
///   child: const Text('Save'),
/// );
/// ```
///
/// See `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`.
@immutable
final class RenderOverrides {
  const RenderOverrides([this._overrides = const {}])
      : _debugTracker = null;

  RenderOverrides._(
    this._overrides, {
    RenderOverridesDebugTracker? debugTracker,
  }) : _debugTracker = debugTracker;

  final Map<Type, Object> _overrides;
  final RenderOverridesDebugTracker? _debugTracker;

  /// Convenience helper for the common case: one override contract.
  ///
  /// Usage:
  /// ```dart
  /// overrides: RenderOverrides.only(
  ///   const RTextFieldOverrides.tokens(containerBorderWidth: 2),
  /// ),
  /// ```
  ///
  /// (No `.asRenderOverrides()` needed.)
  static RenderOverrides only<T extends Object>(T value) {
    return RenderOverrides({T: value});
  }

  /// Get override by type.
  ///
  /// Returns null if no override of this type is registered.
  T? get<T>() {
    assert(() {
      _debugTracker?.consumed.add(T);
      return true;
    }());
    final value = _overrides[T];
    if (value == null) return null;
    return value as T;
  }

  /// Check if an override of the given type exists.
  bool has<T>() => _overrides.containsKey(T);

  /// Create a new RenderOverrides with additional overrides merged.
  RenderOverrides merge(RenderOverrides other) {
    return RenderOverrides({..._overrides, ...other._overrides});
  }

  /// Create a new RenderOverrides with one override added or replaced.
  RenderOverrides with_<T>(T value) {
    return RenderOverrides({..._overrides, T: value as Object});
  }

  /// Enable debug-only consumption tracking.
  ///
  /// In release this is a no-op and returns [base].
  static RenderOverrides debugTrack(
    RenderOverrides base,
    RenderOverridesDebugTracker tracker,
  ) {
    var tracked = base;
    assert(() {
      tracked = RenderOverrides._(
        base._overrides,
        debugTracker: tracker,
      );
      return true;
    }());
    return tracked;
  }

  /// Debug-only: returns the provided override types.
  ///
  /// In release this returns an empty set.
  Set<Type> debugProvidedTypes() {
    var types = const <Type>{};
    assert(() {
      types = _overrides.keys.toSet();
      return true;
    }());
    return types;
  }

  /// Debug-only: returns the consumed override types.
  ///
  /// In release this returns an empty set.
  Set<Type> debugConsumedTypes() {
    var types = const <Type>{};
    assert(() {
      types = _debugTracker?.consumed ?? const <Type>{};
      return true;
    }());
    return types;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RenderOverrides &&
        mapEquals(_overrides, other._overrides);
  }

  @override
  int get hashCode => Object.hashAll(_overrides.entries);
}

/// Debug-only tracker for consumed override types.
@immutable
final class RenderOverridesDebugTracker {
  RenderOverridesDebugTracker();

  final Set<Type> consumed = <Type>{};
}
