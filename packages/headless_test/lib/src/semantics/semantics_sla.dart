import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

import 'semantics_utils.dart';

/// Minimal A11y/Semantics SLA assertions for Headless components.
///
/// Goal: prevent presets/renderers from silently breaking accessibility.
class SemanticsSla {
  const SemanticsSla._();

  static void expectButton({
    required SemanticsNode node,
    String? labelContains,
    required bool enabled,
  }) {
    expect(
      SemanticsUtils.hasFlag(node, SemanticsFlag.isButton),
      isTrue,
      reason: 'Expected SemanticsFlag.isButton',
    );

    expect(
      SemanticsUtils.hasFlag(node, SemanticsFlag.isEnabled),
      enabled ? isTrue : isFalse,
      reason: enabled ? 'Expected enabled semantics' : 'Expected disabled semantics',
    );

    if (labelContains != null) {
      expect(node.label, contains(labelContains));
    }
  }

  static void expectHasExpandedState({
    required SemanticsNode node,
    required bool expanded,
  }) {
    expect(
      SemanticsUtils.hasFlag(node, SemanticsFlag.hasExpandedState),
      isTrue,
      reason: 'Expected SemanticsFlag.hasExpandedState',
    );
    expect(
      SemanticsUtils.hasFlag(node, SemanticsFlag.isExpanded),
      expanded ? isTrue : isFalse,
      reason: expanded ? 'Expected expanded semantics' : 'Expected collapsed semantics',
    );
  }

  static void expectTextField({
    required SemanticsNode node,
    required bool enabled,
    required bool readOnly,
  }) {
    expect(
      SemanticsUtils.hasFlag(node, SemanticsFlag.isTextField),
      isTrue,
      reason: 'Expected SemanticsFlag.isTextField',
    );

    expect(
      SemanticsUtils.hasFlag(node, SemanticsFlag.isEnabled),
      enabled ? isTrue : isFalse,
      reason: enabled ? 'Expected enabled semantics' : 'Expected disabled semantics',
    );

    expect(
      SemanticsUtils.hasFlag(node, SemanticsFlag.isReadOnly),
      readOnly ? isTrue : isFalse,
      reason: readOnly ? 'Expected readOnly semantics' : 'Expected editable semantics',
    );
  }
}

