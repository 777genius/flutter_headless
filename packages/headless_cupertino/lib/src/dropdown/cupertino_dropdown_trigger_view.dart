import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';

import '../primitives/cupertino_pressable_opacity.dart';
import 'cupertino_dropdown_trigger.dart';

final class CupertinoDropdownTriggerView extends StatelessWidget {
  const CupertinoDropdownTriggerView({
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

    final selectedItem = state.selectedIndex != null &&
            state.selectedIndex! < request.items.length
        ? request.items[state.selectedIndex!]
        : null;
    final displayText = selectedItem?.primaryText ?? spec.placeholder ?? '';

    final defaultChevron = AnimatedRotation(
      turns: state.isOpen ? 0.5 : 0,
      duration: menuMotion.enterDuration,
      child: Icon(
        CupertinoIcons.chevron_down,
        color: tokens.iconColor,
        size: 16,
      ),
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
            (_) => _wrapTrigger(displayText, chevron),
          )
        : _wrapTrigger(displayText, chevron);
  }

  Widget _wrapTrigger(String displayText, Widget chevron) {
    return CupertinoPressableOpacity(
      duration: menuMotion.enterDuration,
      pressedOpacity: tokens.pressOpacity,
      isPressed: request.state.isTriggerPressed,
      isEnabled: !request.state.isDisabled,
      visualEffects: request.visualEffects,
      child: CupertinoDropdownTrigger(
        backgroundColor: tokens.backgroundColor,
        foregroundColor: tokens.foregroundColor,
        borderColor: tokens.borderColor,
        borderRadius: tokens.borderRadius,
        padding: tokens.padding,
        textStyle: tokens.textStyle,
        minSize: tokens.minSize,
        displayText: displayText,
        chevron: chevron,
        animationDuration: menuMotion.enterDuration,
        isFocused: request.state.isTriggerFocused,
      ),
    );
  }
}
