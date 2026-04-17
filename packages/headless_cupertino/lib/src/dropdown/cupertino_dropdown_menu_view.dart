import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import '../primitives/cupertino_menu_item.dart';
import '../primitives/cupertino_popover_surface.dart';
import 'cupertino_dropdown_menu_close_contract.dart';

final class CupertinoDropdownMenuView extends StatelessWidget {
  const CupertinoDropdownMenuView({
    super.key,
    required this.request,
    required this.tokens,
    required this.menuMotion,
  });

  final RDropdownMenuRenderRequest request;
  final RDropdownResolvedTokens tokens;
  final RDropdownMenuMotionTokens menuMotion;

  @override
  Widget build(BuildContext context) {
    final state = request.state;
    final slots = request.slots;
    final menuTokens = tokens.menu;

    final menuContext = RDropdownMenuContext(
      spec: request.spec,
      state: state,
      items: request.items,
      commands: request.commands,
      itemBuilder: _item,
      features: request.features,
    );

    final menuInner = request.items.isEmpty && slots?.emptyState != null
        ? slots!.emptyState!.build(menuContext, (_) => const SizedBox.shrink())
        : slots?.menu != null
            ? slots!.menu!.build(menuContext, _defaultMenu)
            : _defaultMenu(menuContext);

    final paddedInner = Padding(
      padding: menuTokens.padding,
      child: slots?.menu != null
          ? menuInner
          : _CupertinoDropdownMenuIntrinsicWidth(child: menuInner),
    );
    final estimatedMinHeight = request.items.length * tokens.item.minHeight +
        menuTokens.padding.vertical;
    final menuContent = LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight.clamp(0.0, menuTokens.maxHeight)
            : menuTokens.maxHeight;
        final needsScroll = estimatedMinHeight > availableHeight;

        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: menuTokens.maxHeight),
          child: slots?.menu != null
              ? paddedInner
              : needsScroll
                  ? SingleChildScrollView(
                      primary: false,
                      physics: const BouncingScrollPhysics(),
                      child: paddedInner,
                    )
                  : paddedInner,
        );
      },
    );

    final menuSurface = slots?.menuSurface != null
        ? slots!.menuSurface!.build(
            RDropdownMenuSurfaceContext(
              spec: request.spec,
              state: state,
              child: menuContent,
              commands: request.commands,
              features: request.features,
            ),
            (_) => CupertinoPopoverSurface(
              backgroundColor: menuTokens.backgroundColor,
              backgroundOpacity: menuTokens.backgroundOpacity,
              borderRadius: menuTokens.borderRadius,
              backdropBlurSigma: menuTokens.backdropBlurSigma,
              shadowColor: menuTokens.shadowColor,
              shadowBlurRadius: menuTokens.shadowBlurRadius,
              shadowOffset: menuTokens.shadowOffset,
              child: menuContent,
            ),
          )
        : CupertinoPopoverSurface(
            backgroundColor: menuTokens.backgroundColor,
            backgroundOpacity: menuTokens.backgroundOpacity,
            borderRadius: menuTokens.borderRadius,
            backdropBlurSigma: menuTokens.backdropBlurSigma,
            shadowColor: menuTokens.shadowColor,
            shadowBlurRadius: menuTokens.shadowBlurRadius,
            shadowOffset: menuTokens.shadowOffset,
            child: menuContent,
          );

    return CupertinoDropdownMenuCloseContract(
      overlayPhase: state.overlayPhase,
      onCompleteClose: request.commands.completeClose,
      child: menuSurface,
      motion: menuMotion,
    );
  }

  Widget _item(int index) {
    final item = request.items[index];
    final state = request.state;
    final isHighlighted = state.highlightedIndex == index;
    final isSelected = state.selectedIndex == index;
    final visualState = resolveDropdownItemVisualState(
      item: item,
      isHighlighted: isHighlighted,
      isSelected: isSelected,
    );

    final itemTokens = tokens.item;
    final foregroundColor = switch (visualState) {
      HeadlessDropdownItemVisualState.disabled =>
        itemTokens.disabledForegroundColor,
      _ => itemTokens.foregroundColor,
    };
    final backgroundColor = switch (visualState) {
      HeadlessDropdownItemVisualState.highlighted =>
        itemTokens.highlightBackgroundColor,
      HeadlessDropdownItemVisualState.selected =>
        itemTokens.selectedBackgroundColor,
      _ => itemTokens.backgroundColor,
    };

    final defaultContent = Row(
      children: [
        Expanded(
          child: Text(
            item.primaryText,
            style: itemTokens.textStyle.copyWith(color: foregroundColor),
          ),
        ),
        if (isSelected)
          Icon(
            CupertinoIcons.checkmark,
            size: 18,
            color: itemTokens.selectedMarkerColor,
          ),
      ],
    );

    final content = request.slots?.itemContent != null
        ? request.slots!.itemContent!.build(
            RDropdownItemContentContext(
              item: item,
              index: index,
              isHighlighted: isHighlighted,
              isSelected: isSelected,
              commands: request.commands,
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
        minHeight: itemTokens.minHeight,
        padding: itemTokens.padding,
        backgroundColor: backgroundColor,
        onTap: () => request.commands.selectIndex(index),
        child: content,
      ),
    );

    return request.slots?.item != null
        ? request.slots!.item!.build(
            RDropdownItemContext(
              item: item,
              index: index,
              isHighlighted: isHighlighted,
              isSelected: isSelected,
              commands: request.commands,
            ),
            (_) => defaultItem,
          )
        : defaultItem;
  }

  Widget _defaultMenu(RDropdownMenuContext ctx) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(ctx.items.length, ctx.itemBuilder),
    );
  }
}

final class _CupertinoDropdownMenuIntrinsicWidth extends StatelessWidget {
  const _CupertinoDropdownMenuIntrinsicWidth({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(child: child);
  }
}
