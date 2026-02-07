import 'package:flutter/widgets.dart';

/// Commands for dropdown interactions (internal component API).
///
/// These are NOT "user callbacks". They are imperative commands that the
/// renderer may invoke to delegate behavior back to the component.
///
/// Uses indices instead of generic values — the component handles the mapping.
@immutable
final class RDropdownCommands {
  const RDropdownCommands({
    required this.open,
    required this.close,
    required this.selectIndex,
    required this.highlight,
    required this.completeClose,
  });

  /// Open the menu.
  final VoidCallback open;

  /// Start closing animation (phase -> closing).
  final VoidCallback close;

  /// Select an item by index.
  ///
  /// The component maps this index back to the generic value.
  final void Function(int index) selectIndex;

  /// Highlight an item by index (keyboard navigation).
  final void Function(int index) highlight;

  /// Complete close after exit animation (removes overlay).
  final VoidCallback completeClose;
}
