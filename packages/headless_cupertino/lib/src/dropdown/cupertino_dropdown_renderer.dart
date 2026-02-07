import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import '../primitives/cupertino_menu_item.dart';
import '../primitives/cupertino_popover_surface.dart';
import '../primitives/cupertino_pressable_opacity.dart';
import 'cupertino_dropdown_menu_close_contract.dart';
import 'cupertino_dropdown_token_resolver.dart';
import 'cupertino_dropdown_trigger.dart';

/// Cupertino renderer for Dropdown components.
///
/// Implements [RDropdownButtonRenderer] (non-generic) with iOS styling.
///
/// CRITICAL INVARIANTS:
/// 1. Must handle both [RDropdownRenderTarget.trigger] and [RDropdownRenderTarget.menu].
/// 2. Close contract: when [overlayPhase == closing], renderer MUST call
///    [commands.completeClose()] after exit animation completes.
/// 3. Uses popover-style menu (not ActionSheet) per v1 spec.
///
/// See `docs/V1_DECISIONS.md` → "0.2 Overlay" → "Close contract v1".
class CupertinoDropdownRenderer implements RDropdownButtonRenderer {
  const CupertinoDropdownRenderer();

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
        HeadlessMotionTheme.cupertino;
    final menuMotion = resolved.menu.motion ?? motionTheme.dropdownMenu;
    final pressedOpacity = tokens.pressOpacity;

    // Get effective values
    final backgroundColor = tokens.backgroundColor;
    final foregroundColor = tokens.foregroundColor;
    final borderColor = tokens.borderColor;
    final borderRadius = tokens.borderRadius;
    final padding = tokens.padding;
    final textStyle = tokens.textStyle;
    final minSize = tokens.minSize;
    final iconColor = tokens.iconColor;

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
        CupertinoIcons.chevron_down,
        color: iconColor,
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
        (_) => CupertinoPressableOpacity(
          duration: menuMotion.enterDuration,
          pressedOpacity: pressedOpacity,
          isPressed: state.isTriggerPressed,
          isEnabled: !state.isDisabled,
          visualEffects: request.visualEffects,
          child: CupertinoDropdownTrigger(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            borderColor: borderColor,
            borderRadius: borderRadius,
            padding: padding,
            textStyle: textStyle,
            minSize: minSize,
            displayText: displayText,
            chevron: chevron,
            animationDuration: menuMotion.enterDuration,
            isFocused: state.isTriggerFocused,
          ),
        ),
      );
    }

    return CupertinoPressableOpacity(
      duration: menuMotion.enterDuration,
      pressedOpacity: pressedOpacity,
      isPressed: state.isTriggerPressed,
      isEnabled: !state.isDisabled,
      visualEffects: request.visualEffects,
      child: CupertinoDropdownTrigger(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        borderColor: borderColor,
        borderRadius: borderRadius,
        padding: padding,
        textStyle: textStyle,
        minSize: minSize,
        displayText: displayText,
        chevron: chevron,
        animationDuration: menuMotion.enterDuration,
        isFocused: state.isTriggerFocused,
      ),
    );
  }

  /// Render the menu (in overlay) - popover style.
  Widget _renderMenu(RDropdownMenuRenderRequest request) {
    final tokens = _resolveTokens(request);
    final state = request.state;
    final slots = request.slots;
    final commands = request.commands;

    // Menu tokens
    final menuTokens = tokens.menu;
    final motionTheme = HeadlessThemeProvider.of(request.context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.cupertino;
    final menuMotion = menuTokens.motion ?? motionTheme.dropdownMenu;
    final backgroundColor = menuTokens.backgroundColor;
    final backgroundOpacity = menuTokens.backgroundOpacity;
    final borderRadius = menuTokens.borderRadius;
    final maxHeight = menuTokens.maxHeight;
    final menuPadding = menuTokens.padding;
    final blurSigma = menuTokens.backdropBlurSigma;
    final shadowColor = menuTokens.shadowColor;
    final shadowBlurRadius = menuTokens.shadowBlurRadius;
    final shadowOffset = menuTokens.shadowOffset;

    // Build item list
    Widget buildItem(int index) {
      final item = request.items[index];
      final isHighlighted = state.highlightedIndex == index;
      final isSelected = state.selectedIndex == index;
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
          Expanded(
            child: Text(
              item.primaryText,
              style: textStyle.copyWith(color: foregroundColor),
            ),
          ),
          if (isSelected)
            Icon(
              CupertinoIcons.checkmark,
              size: 18,
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
        child: CupertinoMenuItem(
          isDisabled: item.isDisabled,
          minHeight: minHeight,
          padding: padding,
          backgroundColor: backgroundColor,
          onTap: () => commands.selectIndex(index),
          child: content,
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
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          ctx.items.length,
          ctx.itemBuilder,
        ),
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

    // Desktop/macOS UX: avoid wrapping the default menu in a ScrollView unless
    // it actually needs scrolling. Otherwise wheel events can be consumed by the
    // menu even when it can't scroll, making the underlying page feel stuck.
    final estimatedMinHeight =
        request.items.length * tokens.item.minHeight + menuPadding.vertical;
    final needsScroll = estimatedMinHeight > maxHeight;

    final menuContent = ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: slots?.menu != null
          ? Padding(
              padding: menuPadding,
              child: menuInner,
            )
          : needsScroll
              ? SingleChildScrollView(
                  child: Padding(
                    padding: menuPadding,
                    child: menuInner,
                  ),
                )
              : Padding(
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
        (_) => CupertinoPopoverSurface(
          backgroundColor: backgroundColor,
          backgroundOpacity: backgroundOpacity,
          borderRadius: borderRadius,
          backdropBlurSigma: blurSigma,
          shadowColor: shadowColor,
          shadowBlurRadius: shadowBlurRadius,
          shadowOffset: shadowOffset,
          child: menuContent,
        ),
      );
    } else {
      menuSurface = CupertinoPopoverSurface(
        backgroundColor: backgroundColor,
        backgroundOpacity: backgroundOpacity,
        borderRadius: borderRadius,
        backdropBlurSigma: blurSigma,
        shadowColor: shadowColor,
        shadowBlurRadius: shadowBlurRadius,
        shadowOffset: shadowOffset,
        child: menuContent,
      );
    }

    return CupertinoDropdownMenuCloseContract(
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
        '[Headless] CupertinoDropdownRenderer требует resolvedTokens.\n'
        'Как исправить:\n'
        '- Используй preset: HeadlessCupertinoApp(...)\n'
        '- Или предоставь RDropdownTokenResolver в HeadlessTheme\n'
        '- Или отключи strict: HeadlessCupertinoApp(requireResolvedTokens: false, ...)',
      );
    }
    assert(
      !requireTokens || request.resolvedTokens != null,
      'CupertinoDropdownRenderer requires resolvedTokens when '
      'HeadlessRendererPolicy.requireResolvedTokens is enabled.',
    );
    if (resolved != null) return resolved;

    return const CupertinoDropdownTokenResolver().resolve(
      context: request.context,
      spec: request.spec,
      triggerStates: request.state.toTriggerWidgetStates(),
      overlayPhase: request.state.overlayPhase,
      constraints: request.constraints,
      overrides: request.overrides,
    );
  }
}
