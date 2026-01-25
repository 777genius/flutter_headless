import 'package:headless_foundation/headless_foundation.dart';

/// Canonical “dominant” visual state for a dropdown menu item.
///
/// v1 precedence (high → low):
/// - disabled
/// - highlighted (keyboard/pointer active item)
/// - selected
/// - none
enum HeadlessDropdownItemVisualState {
  disabled,
  highlighted,
  selected,
  none,
}

HeadlessDropdownItemVisualState resolveDropdownItemVisualState({
  required HeadlessListItemModel item,
  required bool isHighlighted,
  required bool isSelected,
}) {
  if (item.isDisabled) return HeadlessDropdownItemVisualState.disabled;
  if (isHighlighted) return HeadlessDropdownItemVisualState.highlighted;
  if (isSelected) return HeadlessDropdownItemVisualState.selected;
  return HeadlessDropdownItemVisualState.none;
}

