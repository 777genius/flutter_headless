import 'package:flutter/widgets.dart';

import 'widget_state_set.dart';

/// Политика нормализации конфликтующих состояний и генерации precedence.
///
/// Цель: дать единый предсказуемый слой приоритетов состояний, чтобы токены
/// резолвились одинаково во всех компонентах/пресетах.
class StateResolutionPolicy {
  const StateResolutionPolicy();

  /// Нормализует конфликтующие состояния.
  ///
  /// Базовое правило v1: disabled подавляет интерактивные состояния.
  WidgetStateSet normalize(WidgetStateSet raw) {
    if (raw.contains(WidgetState.disabled)) {
      return raw.difference({
        WidgetState.pressed,
        WidgetState.hovered,
        WidgetState.dragged,
      });
    }
    return raw;
  }

  /// Возвращает список наборов состояний от наиболее специфичного к базовому.
  ///
  /// Пример: `{hovered, focused}` → `[{hovered, focused}, {hovered}, {focused}, {}]`.
  List<WidgetStateSet> precedence(WidgetStateSet normalized) {
    final states = normalized.toList(growable: false);
    final result = <WidgetStateSet>[];

    for (var size = states.length; size >= 0; size--) {
      result.addAll(_combinations(states, size));
    }
    return result;
  }

  List<WidgetStateSet> _combinations(List<WidgetState> states, int size) {
    if (size == 0) return [<WidgetState>{}];
    if (size == states.length) return [{...states}];

    final result = <WidgetStateSet>[];

    void combine(int start, List<WidgetState> current) {
      if (current.length == size) {
        result.add({...current});
        return;
      }
      for (var i = start; i < states.length; i++) {
        current.add(states[i]);
        combine(i + 1, current);
        current.removeLast();
      }
    }

    combine(0, <WidgetState>[]);
    return result;
  }
}

