import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import 'package:headless_material/primitives.dart';
import 'material_dropdown_menu_close_contract.dart';
import 'material_dropdown_token_resolver.dart';
import 'material_dropdown_trigger.dart';
import 'material_menu_item_tap_region.dart';

/// Material 3 renderer for Dropdown components.
///
/// Implements [RDropdownButtonRenderer] with Material Design 3 visuals.
///
/// CRITICAL INVARIANTS:
/// 1. Must handle both [RDropdownRenderTarget.trigger] and [RDropdownRenderTarget.menu].
/// 2. Close contract: when [overlayPhase == closing], renderer MUST call
///    [commands.completeClose()] after exit animation completes.
/// 3. Slots can customize anchor, menu, item, menuSurface.
///
/// See `docs/V1_DECISIONS.md` → "0.2 Overlay" → "Close contract v1".
class MaterialDropdownRenderer implements RDropdownButtonRenderer {
  const MaterialDropdownRenderer();

  @override
  Widget render(RDropdownRenderRequest request) {
    return switch (request) {
      RDropdownTriggerRenderRequest() => _renderTrigger(request),
      RDropdownMenuRenderRequest() => _renderMenu(request),
    };
  }

  /// Render the trigger/anchor button.
  Widget _renderTrigger(RDropdownTriggerRenderRequest request) {
    final resolved = _resolveTokens(request);
    final tokens = resolved.trigger;
    final state = request.state;
    final spec = request.spec;
    final slots = request.slots;
    final motionTheme = HeadlessThemeProvider.of(request.context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.material;
    final menuMotion = resolved.menu.motion ?? motionTheme.dropdownMenu;

    // Get effective values
    final backgroundColor = tokens.backgroundColor;
    final foregroundColor = tokens.foregroundColor;
    final borderColor = tokens.borderColor;
    final borderRadius = tokens.borderRadius;
    final padding = tokens.padding;
    final textStyle = tokens.textStyle;
    final minSize = tokens.minSize;
    final iconColor = tokens.iconColor;
    final overlayColor = tokens.pressOverlayColor;
    final triggerBorder = borderColor == Colors.transparent
        ? null
        : Border.all(
            color: borderColor,
            width: state.isTriggerFocused ? 2 : 1,
          );

    // Get selected item for display
    final selectedItem = state.selectedIndex != null &&
            state.selectedIndex! < request.items.length
        ? request.items[state.selectedIndex!]
        : null;

    // Build display text
    final displayText = selectedItem?.primaryText ?? spec.placeholder ?? '';

    final defaultChevron = AnimatedRotation(
      turns: state.isOpen ? 0.5 : 0,
      duration: menuMotion.enterDuration,
      child: Icon(
        Icons.arrow_drop_down,
        color: iconColor,
        size: 24,
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

    // Check for anchor slot override
    if (slots?.anchor != null) {
      final anchorContext = RDropdownAnchorContext(
        spec: spec,
        state: state,
        selectedItem: selectedItem,
        commands: request.commands,
      );
      return slots!.anchor!.build(
        anchorContext,
        (_) => MaterialPressableOverlay(
          borderRadius: borderRadius,
          overlayColor: overlayColor,
          duration: menuMotion.enterDuration,
          isPressed: state.isTriggerPressed,
          isEnabled: !state.isDisabled,
          visualEffects: request.visualEffects,
          child: MaterialDropdownTrigger(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            border: triggerBorder,
          borderRadius: borderRadius,
          padding: padding,
          textStyle: textStyle,
          minSize: minSize,
          displayText: displayText,
          chevron: chevron,
            animationDuration: menuMotion.enterDuration,
          ),
        ),
      );
    }

    return MaterialPressableOverlay(
      borderRadius: borderRadius,
      overlayColor: overlayColor,
      duration: menuMotion.enterDuration,
      isPressed: state.isTriggerPressed,
      isEnabled: !state.isDisabled,
      visualEffects: request.visualEffects,
      child: MaterialDropdownTrigger(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        border: triggerBorder,
      borderRadius: borderRadius,
      padding: padding,
      textStyle: textStyle,
      minSize: minSize,
      displayText: displayText,
      chevron: chevron,
        animationDuration: menuMotion.enterDuration,
      ),
    );
  }

  /// Render the menu (in overlay).
  Widget _renderMenu(RDropdownMenuRenderRequest request) {
    final tokens = _resolveTokens(request);
    final state = request.state;
    final slots = request.slots;
    final commands = request.commands;

    // Menu tokens
    final menuTokens = tokens.menu;
    final motionTheme = HeadlessThemeProvider.of(request.context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.material;
    final menuMotion = menuTokens.motion ?? motionTheme.dropdownMenu;
    final backgroundColor = menuTokens.backgroundColor;
    final borderColor = menuTokens.borderColor;
    final borderRadius = menuTokens.borderRadius;
    final elevation = menuTokens.elevation;
    final menuPadding = menuTokens.padding;
    final maxHeight = menuTokens.maxHeight;
    final menuBorder = borderColor == Colors.transparent
        ? null
        : Border.all(
            color: borderColor,
          );

    // Build item list
    Widget buildItem(int index) {
      final item = request.items[index];
      final isHighlighted = state.highlightedIndex == index;
      final selectedItemsIndices = state.selectedItemsIndices;
      final isSelected = selectedItemsIndices != null
          ? selectedItemsIndices.contains(index)
          : state.selectedIndex == index;
      final isMultiSelect = selectedItemsIndices != null;
      final visualState = resolveDropdownItemVisualState(
        item: item,
        isHighlighted: isHighlighted,
        isSelected: isSelected,
      );

      final itemTokens = tokens.item;
      final textStyle = itemTokens.textStyle;
      final foregroundColor = switch (visualState) {
        HeadlessDropdownItemVisualState.disabled =>
          itemTokens.disabledForegroundColor,
        _ => itemTokens.foregroundColor,
      };
      final selectedMarkerColor = itemTokens.selectedMarkerColor;
      final backgroundColor = switch (visualState) {
        HeadlessDropdownItemVisualState.highlighted =>
          itemTokens.highlightBackgroundColor,
        HeadlessDropdownItemVisualState.selected =>
          itemTokens.selectedBackgroundColor,
        _ => itemTokens.backgroundColor,
      };
      final padding = itemTokens.padding;
      final minHeight = itemTokens.minHeight;

      final defaultContent = Row(
        children: [
          if (isMultiSelect)
            IgnorePointer(
              child: Checkbox(
                value: isSelected,
                // Keep checkbox visually enabled while making it non-interactive
                // (the whole row handles the tap).
                onChanged: (_) {},
              ),
            ),
          Expanded(
            child: Text(
              item.primaryText,
              style: textStyle.copyWith(color: foregroundColor),
            ),
          ),
          if (!isMultiSelect && isSelected)
            Icon(
              Icons.check,
              size: 20,
              color: selectedMarkerColor,
            ),
        ],
      );

      final content = slots?.itemContent != null
          ? slots!.itemContent!.build(
              RDropdownItemContentContext(
                item: item,
                index: index,
                isHighlighted: isHighlighted,
                isSelected: isSelected,
                commands: commands,
                child: defaultContent,
              ),
              (_) => defaultContent,
            )
          : defaultContent;

      final defaultItem = Semantics(
        selected: isSelected,
        enabled: !item.isDisabled,
        label: item.semanticsLabel ?? item.primaryText,
        child: MaterialMenuItemTapRegion(
          isDisabled: item.isDisabled,
          onTap: () => commands.selectIndex(index),
          child: MaterialMenuItem(
            minHeight: minHeight,
            padding: padding,
            backgroundColor: backgroundColor,
            child: content,
          ),
        ),
      );

      // Check for item slot override
      if (slots?.item != null) {
        final itemContext = RDropdownItemContext(
          item: item,
          index: index,
          isHighlighted: isHighlighted,
          isSelected: isSelected,
          commands: commands,
        );
        return slots!.item!.build(
          itemContext,
          (_) => defaultItem,
        );
      }

      return defaultItem;
    }

    Widget buildDefaultMenu(RDropdownMenuContext ctx) {
      // Mobile UX: always use a ScrollView so we don't risk layout overflows in
      // tight viewports (e.g. small iOS simulator heights, on-screen keyboard).
      if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android) {
        return ListView.builder(
          primary: false,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const ClampingScrollPhysics(),
          itemCount: ctx.items.length,
          itemBuilder: (context, index) => ctx.itemBuilder(index),
        );
      }

      // Desktop/web UX: always use ListView to avoid Column overflows.
      // When content doesn't exceed maxHeight we disable scrolling so wheel events
      // can bubble to the page.
      final estimatedItemExtent =
          tokens.item.minHeight + tokens.item.padding.vertical;
      final estimatedTotalHeight =
          menuPadding.vertical + (ctx.items.length * estimatedItemExtent);
      final needsScroll = estimatedTotalHeight > maxHeight;

      return ListView.builder(
        primary: false,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: needsScroll
            ? const ClampingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        itemCount: ctx.items.length,
        itemBuilder: (context, index) => ctx.itemBuilder(index),
      );
    }

    final menuContext = RDropdownMenuContext(
      spec: request.spec,
      state: state,
      items: request.items,
      commands: commands,
      itemBuilder: buildItem,
      features: request.features,
    );

    final menuInner = request.items.isEmpty && slots?.emptyState != null
        ? slots!.emptyState!.build(menuContext, (_) => const SizedBox.shrink())
        : slots?.menu != null
            ? slots!.menu!.build(menuContext, buildDefaultMenu)
            : buildDefaultMenu(menuContext);

    final menuContent = ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Padding(
        padding: menuPadding,
        child: menuInner,
      ),
    );

    // Check for menuSurface slot override
    Widget menuSurface;
    if (slots?.menuSurface != null) {
      final surfaceContext = RDropdownMenuSurfaceContext(
        spec: request.spec,
        state: state,
        child: menuContent,
        commands: commands,
        features: request.features,
      );
      menuSurface = slots!.menuSurface!.build(
        surfaceContext,
        (_) => MaterialMenuSurface(
          backgroundColor: backgroundColor,
          border: menuBorder,
          borderRadius: borderRadius,
          elevation: elevation,
          child: menuContent,
        ),
      );
    } else {
      menuSurface = MaterialMenuSurface(
        backgroundColor: backgroundColor,
        border: menuBorder,
        borderRadius: borderRadius,
        elevation: elevation,
        child: menuContent,
      );
    }

    return MaterialDropdownMenuCloseContract(
      overlayPhase: state.overlayPhase,
      onCompleteClose: commands.completeClose,
      child: menuSurface,
      motion: menuMotion,
    );
  }

  RDropdownResolvedTokens _resolveTokens(RDropdownRenderRequest request) {
    final policy = HeadlessThemeProvider.of(request.context)
        ?.capability<HeadlessRendererPolicy>();
    final requireTokens = policy?.requireResolvedTokens == true;
    final resolved = request.resolvedTokens;
    if (requireTokens && resolved == null) {
      throw StateError(
        '[Headless] MaterialDropdownRenderer требует resolvedTokens.\n'
        'Как исправить:\n'
        '- Используй preset: HeadlessMaterialApp(...)\n'
        '- Или предоставь RDropdownTokenResolver в HeadlessTheme\n'
        '- Или отключи strict: HeadlessMaterialApp(requireResolvedTokens: false, ...)',
      );
    }
    assert(
      !requireTokens || request.resolvedTokens != null,
      'MaterialDropdownRenderer requires resolvedTokens when '
      'HeadlessRendererPolicy.requireResolvedTokens is enabled.',
    );
    if (resolved != null) return resolved;

    return const MaterialDropdownTokenResolver().resolve(
      context: request.context,
      spec: request.spec,
      triggerStates: request.state.toTriggerWidgetStates(),
      overlayPhase: request.state.overlayPhase,
      constraints: request.constraints,
      overrides: request.overrides,
    );
  }

}
