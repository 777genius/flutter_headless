import 'package:flutter/foundation.dart';

import 'state_resolution_error.dart';
import 'state_resolution_policy.dart';
import 'widget_state_set.dart';

/// Map от [WidgetStateSet] к значению с precedence-based lookup.
@immutable
final class HeadlessWidgetStateMap<T> {
  HeadlessWidgetStateMap(
    Map<WidgetStateSet, T> entries, {
    T? defaultValue,
  })  : _entries = Map.unmodifiable(entries),
        _entriesByKey = Map.unmodifiable({
          for (final e in entries.entries) _keyFor(e.key): e.value,
        }),
        _defaultValue = defaultValue;

  /// NOTE: Нельзя полагаться на `Set` как на ключ Map напрямую:
  /// `Set<...>` в Dart не имеет value-equality по содержимому (как и List).
  /// Поэтому храним отдельный индекс по стабильному ключу.
  final Map<WidgetStateSet, T> _entries;
  final Map<String, T> _entriesByKey;
  final T? _defaultValue;

  Iterable<WidgetStateSet> get registeredStateSets => _entries.keys;

  T? resolve(WidgetStateSet states, StateResolutionPolicy policy) {
    final normalized = policy.normalize(states);
    final candidates = policy.precedence(normalized);

    for (final candidate in candidates) {
      final value = _entriesByKey[_keyFor(candidate)];
      if (value != null) return value;
    }
    return _defaultValue;
  }

  T resolveOrThrow(
    WidgetStateSet states,
    StateResolutionPolicy policy, {
    String? context,
  }) {
    final value = resolve(states, policy);
    if (value != null) return value;

    throw StateResolutionError(
      'Не удалось найти значение для states=$states'
      '${context != null ? ' (context: $context)' : ''}\n'
      'Registered: ${_entries.keys.toList(growable: false)}\n'
      'Default: $_defaultValue',
    );
  }
}

String _keyFor(WidgetStateSet states) {
  if (states.isEmpty) return '';
  final indices = states.map((s) => s.index).toList(growable: false)..sort();
  return indices.join(',');
}
