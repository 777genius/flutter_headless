import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'r_dropdown_render_request_builder.dart';

final class RDropdownRequestComposer {
  const RDropdownRequestComposer();

  RDropdownTriggerRenderRequest createTriggerRequest({
    required BuildContext context,
    required RDropdownButtonSpec spec,
    required ROverlayPhase overlayPhase,
    required int? selectedIndex,
    required int? highlightedIndex,
    required bool isTriggerPressed,
    required bool isTriggerHovered,
    required bool isTriggerFocused,
    required bool isDisabled,
    required bool isExpanded,
    required List<HeadlessListItemModel> items,
    required RDropdownCommands commands,
    HeadlessPressableVisualEffectsController? visualEffects,
    RDropdownButtonSlots? slots,
    RenderOverrides? overrides,
  }) {
    const builder = RDropdownRenderRequestBuilder();

    return builder.createTrigger(
      context: context,
      spec: spec,
      overlayPhase: overlayPhase,
      selectedIndex: selectedIndex,
      highlightedIndex: highlightedIndex,
      isTriggerPressed: isTriggerPressed,
      isTriggerHovered: isTriggerHovered,
      isTriggerFocused: isTriggerFocused,
      isDisabled: isDisabled,
      isExpanded: isExpanded,
      items: items,
      commands: commands,
      visualEffects: visualEffects,
      slots: slots,
      overrides: overrides,
      baseConstraints: BoxConstraints(
        minWidth: WcagConstants.kMinTouchTargetSize.width,
        minHeight: WcagConstants.kMinTouchTargetSize.height,
      ),
      semanticLabel: spec.semanticLabel,
    );
  }

  RDropdownMenuRenderRequest createMenuRequest({
    required BuildContext context,
    required RDropdownButtonSpec spec,
    required ROverlayPhase overlayPhase,
    required int? selectedIndex,
    required int? highlightedIndex,
    required bool isTriggerPressed,
    required bool isTriggerHovered,
    required bool isTriggerFocused,
    required bool isDisabled,
    required bool isExpanded,
    required List<HeadlessListItemModel> items,
    required RDropdownCommands commands,
    RDropdownButtonSlots? slots,
    RenderOverrides? overrides,
  }) {
    const builder = RDropdownRenderRequestBuilder();

    return builder.createMenu(
      context: context,
      spec: spec,
      overlayPhase: overlayPhase,
      selectedIndex: selectedIndex,
      highlightedIndex: highlightedIndex,
      isTriggerPressed: isTriggerPressed,
      isTriggerHovered: isTriggerHovered,
      isTriggerFocused: isTriggerFocused,
      isDisabled: isDisabled,
      isExpanded: isExpanded,
      items: items,
      commands: commands,
      slots: slots,
      overrides: overrides,
      baseConstraints: BoxConstraints(
        minWidth: WcagConstants.kMinTouchTargetSize.width,
        minHeight: WcagConstants.kMinTouchTargetSize.height,
      ),
      semanticLabel: spec.semanticLabel,
    );
  }
}

