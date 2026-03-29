import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'package:headless_material/primitives.dart';
import 'material_dropdown_trigger.dart';

final class MaterialDropdownTriggerView extends StatelessWidget {
  const MaterialDropdownTriggerView({
    super.key,
    required this.request,
    required this.tokens,
    required this.menuMotion,
  });

  final RDropdownTriggerRenderRequest request;
  final RDropdownTriggerTokens tokens;
  final RDropdownMenuMotionTokens menuMotion;

  @override
  Widget build(BuildContext context) {
    final state = request.state;
    final spec = request.spec;
    final slots = request.slots;

    final triggerBorder = tokens.borderColor == Colors.transparent
        ? null
        : Border.all(
            color: tokens.borderColor,
            width: state.isTriggerFocused ? 2 : 1,
          );

    final selectedItem = state.selectedIndex != null &&
            state.selectedIndex! < request.items.length
        ? request.items[state.selectedIndex!]
        : null;
    final displayText = selectedItem?.primaryText ?? spec.placeholder ?? '';

    final defaultChevron = AnimatedRotation(
      turns: state.isOpen ? 0.5 : 0,
      duration: menuMotion.enterDuration,
      child: Icon(Icons.arrow_drop_down, color: tokens.iconColor, size: 24),
    );
    final chevron = slots?.chevron != null
        ? slots!.chevron!.build(
            RDropdownChevronContext(
              spec: spec,
              state: state,
              selectedItem: selectedItem,
              commands: request.commands,
              child: defaultChevron,
            ),
            (_) => defaultChevron,
          )
        : defaultChevron;

    return slots?.anchor != null
        ? slots!.anchor!.build(
            RDropdownAnchorContext(
              spec: spec,
              state: state,
              selectedItem: selectedItem,
              commands: request.commands,
            ),
            (_) => _wrapTrigger(triggerBorder, displayText, chevron),
          )
        : _wrapTrigger(triggerBorder, displayText, chevron);
  }

  Widget _wrapTrigger(
    Border? triggerBorder,
    String displayText,
    Widget chevron,
  ) {
    return MaterialPressableOverlay(
      borderRadius: tokens.borderRadius,
      overlayColor: tokens.pressOverlayColor,
      duration: menuMotion.enterDuration,
      isPressed: request.state.isTriggerPressed,
      isEnabled: !request.state.isDisabled,
      visualEffects: request.visualEffects,
      child: MaterialDropdownTrigger(
        backgroundColor: tokens.backgroundColor,
        foregroundColor: tokens.foregroundColor,
        border: triggerBorder,
        borderRadius: tokens.borderRadius,
        padding: tokens.padding,
        textStyle: tokens.textStyle,
        minSize: tokens.minSize,
        displayText: displayText,
        chevron: chevron,
        animationDuration: menuMotion.enterDuration,
      ),
    );
  }
}
