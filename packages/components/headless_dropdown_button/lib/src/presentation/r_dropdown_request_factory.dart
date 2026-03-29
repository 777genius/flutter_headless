import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';

import '../render_request/r_dropdown_request_composer.dart';

final class RDropdownButtonStateSnapshot {
  const RDropdownButtonStateSnapshot({
    required this.overlayPhase,
    required this.isMenuOpen,
    required this.selectedIndex,
    required this.highlightedIndex,
    required this.isTriggerPressed,
    required this.isTriggerHovered,
    required this.isTriggerFocused,
  });

  final ROverlayPhase overlayPhase;
  final bool isMenuOpen;
  final int? selectedIndex;
  final int? highlightedIndex;
  final bool isTriggerPressed;
  final bool isTriggerHovered;
  final bool isTriggerFocused;
}

RDropdownCommands createDropdownCommands({
  required VoidCallback openMenu,
  required VoidCallback closeMenu,
  required ValueChanged<int> selectIndex,
  required ValueChanged<int> highlight,
  required VoidCallback completeClose,
}) {
  return RDropdownCommands(
    open: openMenu,
    close: closeMenu,
    selectIndex: selectIndex,
    highlight: highlight,
    completeClose: completeClose,
  );
}

RDropdownTriggerRenderRequest createDropdownTriggerRequest({
  required RDropdownRequestComposer composer,
  required BuildContext context,
  required RDropdownButtonSpec spec,
  required RDropdownButtonStateSnapshot state,
  required bool isDisabled,
  required List<HeadlessListItemModel> items,
  required RDropdownCommands commands,
  required HeadlessPressableVisualEffectsController visualEffects,
  required RDropdownButtonSlots? slots,
  required RenderOverrides? overrides,
}) {
  return composer.createTriggerRequest(
    context: context,
    spec: spec,
    overlayPhase: state.overlayPhase,
    selectedIndex: state.selectedIndex,
    highlightedIndex: state.highlightedIndex,
    isTriggerPressed: state.isTriggerPressed,
    isTriggerHovered: state.isTriggerHovered,
    isTriggerFocused: state.isTriggerFocused,
    isDisabled: isDisabled,
    isExpanded: state.isMenuOpen,
    items: items,
    commands: commands,
    visualEffects: visualEffects,
    slots: slots,
    overrides: overrides,
  );
}

RDropdownMenuRenderRequest createDropdownMenuRequest({
  required RDropdownRequestComposer composer,
  required BuildContext context,
  required RDropdownButtonSpec spec,
  required RDropdownButtonStateSnapshot state,
  required bool isDisabled,
  required List<HeadlessListItemModel> items,
  required RDropdownCommands commands,
  required RDropdownButtonSlots? slots,
  required RenderOverrides? overrides,
}) {
  return composer.createMenuRequest(
    context: context,
    spec: spec,
    overlayPhase: state.overlayPhase,
    selectedIndex: state.selectedIndex,
    highlightedIndex: state.highlightedIndex,
    isTriggerPressed: state.isTriggerPressed,
    isTriggerHovered: state.isTriggerHovered,
    isTriggerFocused: state.isTriggerFocused,
    isDisabled: isDisabled,
    isExpanded: state.isMenuOpen,
    items: items,
    commands: commands,
    slots: slots,
    overrides: overrides,
  );
}
