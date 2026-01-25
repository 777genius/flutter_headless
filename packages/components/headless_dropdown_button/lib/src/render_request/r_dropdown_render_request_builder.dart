import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

/// Builds [RDropdownButtonRenderRequest] from primitive state + widget config.
///
/// Extracted to keep `RDropdownButton` focused on behavior orchestration.
final class RDropdownRenderRequestBuilder {
  const RDropdownRenderRequestBuilder();

  RDropdownTriggerRenderRequest createTrigger({
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
    required RDropdownButtonSlots? slots,
    required RenderOverrides? overrides,
    required BoxConstraints baseConstraints,
    required String? semanticLabel,
  }) {
    final theme = HeadlessThemeProvider.themeOf(context);
    final tokenResolver = theme.capability<RDropdownTokenResolver>();

    final state = RDropdownButtonState(
      overlayPhase: overlayPhase,
      selectedIndex: selectedIndex,
      highlightedIndex: highlightedIndex,
      isTriggerPressed: isTriggerPressed,
      isTriggerHovered: isTriggerHovered,
      isTriggerFocused: isTriggerFocused,
      isDisabled: isDisabled,
    );

    final semantics = RDropdownSemantics(
      label: semanticLabel,
      isExpanded: isExpanded,
      isEnabled: !isDisabled,
    );

    final resolvedTokens = tokenResolver?.resolve(
      context: context,
      spec: spec,
      triggerStates: state.toTriggerWidgetStates(),
      overlayPhase: overlayPhase,
      constraints: baseConstraints,
      overrides: overrides,
    );

    final constraints = resolvedTokens == null
        ? baseConstraints
        : BoxConstraints(
            minWidth: math.max(
              baseConstraints.minWidth,
              resolvedTokens.trigger.minSize.width,
            ),
            minHeight: math.max(
              baseConstraints.minHeight,
              resolvedTokens.trigger.minSize.height,
            ),
          );

    return RDropdownTriggerRenderRequest(
      context: context,
      spec: spec,
      state: state,
      items: items,
      commands: commands,
      semantics: semantics,
      slots: slots,
      visualEffects: visualEffects,
      resolvedTokens: resolvedTokens,
      constraints: constraints,
      overrides: overrides,
    );
  }

  RDropdownMenuRenderRequest createMenu({
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
    required RDropdownButtonSlots? slots,
    required RenderOverrides? overrides,
    required BoxConstraints baseConstraints,
    required String? semanticLabel,
  }) {
    final theme = HeadlessThemeProvider.themeOf(context);
    final tokenResolver = theme.capability<RDropdownTokenResolver>();

    final state = RDropdownButtonState(
      overlayPhase: overlayPhase,
      selectedIndex: selectedIndex,
      highlightedIndex: highlightedIndex,
      isTriggerPressed: isTriggerPressed,
      isTriggerHovered: isTriggerHovered,
      isTriggerFocused: isTriggerFocused,
      isDisabled: isDisabled,
    );

    final semantics = RDropdownSemantics(
      label: semanticLabel,
      isExpanded: isExpanded,
      isEnabled: !isDisabled,
    );

    final resolvedTokens = tokenResolver?.resolve(
      context: context,
      spec: spec,
      triggerStates: state.toTriggerWidgetStates(),
      overlayPhase: overlayPhase,
      constraints: baseConstraints,
      overrides: overrides,
    );

    final constraints = resolvedTokens == null
        ? baseConstraints
        : BoxConstraints(
            minWidth: math.max(
              baseConstraints.minWidth,
              resolvedTokens.trigger.minSize.width,
            ),
            minHeight: math.max(
              baseConstraints.minHeight,
              resolvedTokens.trigger.minSize.height,
            ),
          );

    return RDropdownMenuRenderRequest(
      context: context,
      spec: spec,
      state: state,
      items: items,
      commands: commands,
      semantics: semantics,
      slots: slots,
      resolvedTokens: resolvedTokens,
      constraints: constraints,
      overrides: overrides,
    );
  }
}

