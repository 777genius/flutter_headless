import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

/// Maps [RButtonState] to Flutter's [WidgetState] set for Material widgets.
///
/// Table 4.2.1 mapping:
/// - `isPressed`  → `WidgetState.pressed`
/// - `isHovered`  → `WidgetState.hovered`
/// - `isFocused`  → `WidgetState.focused`
/// - `isDisabled` → `WidgetState.disabled`
abstract final class MaterialParityButtonStateAdapter {
  static Set<WidgetState> toWidgetStates(RButtonState state) {
    return <WidgetState>{
      if (state.isPressed) WidgetState.pressed,
      if (state.isHovered) WidgetState.hovered,
      if (state.isFocused) WidgetState.focused,
      if (state.isDisabled) WidgetState.disabled,
    };
  }
}
