import 'dart:ui' show CheckedState, Tristate;

import 'package:flutter/semantics.dart';

/// Helpers for working with [SemanticsNode] in tests.
class SemanticsUtils {
  const SemanticsUtils._();

  static SemanticsData dataOf(SemanticsNode node) => node.getSemanticsData();

  static bool hasFlag(SemanticsNode node, SemanticsFlag flag) {
    final flags = dataOf(node).flagsCollection;

    return switch (flag) {
      SemanticsFlag.isButton => flags.isButton,
      SemanticsFlag.isTextField => flags.isTextField,
      SemanticsFlag.isReadOnly => flags.isReadOnly,
      SemanticsFlag.isEnabled => flags.isEnabled == Tristate.isTrue,
      SemanticsFlag.isSelected => flags.isSelected == Tristate.isTrue,
      SemanticsFlag.hasExpandedState => flags.isExpanded != Tristate.none,
      SemanticsFlag.isExpanded => flags.isExpanded == Tristate.isTrue,
      SemanticsFlag.isToggled => flags.isToggled == Tristate.isTrue,
      SemanticsFlag.isChecked => flags.isChecked == CheckedState.isTrue,
      _ => throw UnsupportedError(
          'SemanticsUtils.hasFlag does not support $flag yet',
        ),
    };
  }

  static bool hasAction(SemanticsNode node, SemanticsAction action) {
    final data = dataOf(node);
    // In Flutter (dart:ui), SemanticsAction.index is already a bitmask value
    // (not an ordinal index), so actions are checked via bitwise AND directly.
    return (data.actions & action.index) != 0;
  }
}
