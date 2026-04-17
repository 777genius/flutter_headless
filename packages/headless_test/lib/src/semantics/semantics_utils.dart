import 'package:flutter/semantics.dart';

/// Helpers for working with [SemanticsNode] in tests.
class SemanticsUtils {
  const SemanticsUtils._();

  static SemanticsData dataOf(SemanticsNode node) => node.getSemanticsData();

  static bool hasFlag(SemanticsNode node, SemanticsFlag flag) {
    final flags = dataOf(node).flagsCollection;
    final dynamicFlags = flags as dynamic;

    return switch (flag) {
      SemanticsFlag.isButton => flags.isButton,
      SemanticsFlag.isTextField => flags.isTextField,
      SemanticsFlag.isReadOnly => flags.isReadOnly,
      SemanticsFlag.isEnabled =>
        _isSemanticTrue(_readValue(() => flags.isEnabled)),
      SemanticsFlag.isSelected =>
        _isSemanticTrue(_readValue(() => flags.isSelected)),
      SemanticsFlag.hasExpandedState =>
        _readBool(() => dynamicFlags.hasExpandedState as bool) ??
            _hasSemanticState(_readValue(() => flags.isExpanded)),
      SemanticsFlag.isExpanded =>
        _isSemanticTrue(_readValue(() => flags.isExpanded)),
      SemanticsFlag.isToggled =>
        _isSemanticTrue(_readValue(() => flags.isToggled)),
      SemanticsFlag.isChecked =>
        _isSemanticTrue(_readValue(() => flags.isChecked)),
      SemanticsFlag.hasCheckedState =>
        _readBool(() => dynamicFlags.hasCheckedState as bool) ??
            _hasSemanticState(_readValue(() => flags.isChecked)),
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

  static bool? _readBool(bool Function() read) {
    try {
      return read();
    } catch (_) {
      return null;
    }
  }

  static Object? _readValue(Object? Function() read) {
    try {
      return read();
    } catch (_) {
      return null;
    }
  }

  static bool _hasSemanticState(Object? value) {
    if (value == null) return false;
    if (value is bool) return true;
    if (value is Enum) return value.name != 'none';
    return !value.toString().endsWith('.none');
  }

  static bool _isSemanticTrue(Object? value) {
    if (value is bool) return value;
    if (value is Enum) return value.name == 'isTrue';
    return value?.toString().endsWith('.isTrue') ?? false;
  }
}
