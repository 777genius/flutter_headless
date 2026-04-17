import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import 'package:headless_material/primitives.dart';
import 'material_dropdown_menu_close_contract.dart';
import 'material_menu_item_tap_region.dart';

final class MaterialDropdownMenuView extends StatelessWidget {
  const MaterialDropdownMenuView({
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
    final menuBorder = menuTokens.borderColor == Colors.transparent
        ? null
        : Border.all(color: menuTokens.borderColor);

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

    final menuContent = ConstrainedBox(
      constraints: BoxConstraints(maxHeight: menuTokens.maxHeight),
      child: Padding(
        padding: menuTokens.padding,
        child: _MaterialDropdownMenuIntrinsicWidth(child: menuInner),
      ),
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
            (_) => MaterialMenuSurface(
              backgroundColor: menuTokens.backgroundColor,
              border: menuBorder,
              borderRadius: menuTokens.borderRadius,
              elevation: menuTokens.elevation,
              child: menuContent,
            ),
          )
        : MaterialMenuSurface(
            backgroundColor: menuTokens.backgroundColor,
            border: menuBorder,
            borderRadius: menuTokens.borderRadius,
            elevation: menuTokens.elevation,
            child: menuContent,
          );

    return MaterialDropdownMenuCloseContract(
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
        if (isMultiSelect)
          IgnorePointer(child: Checkbox(value: isSelected, onChanged: (_) {})),
        Expanded(
          child: Text(
            item.primaryText,
            style: itemTokens.textStyle.copyWith(color: foregroundColor),
          ),
        ),
        if (!isMultiSelect && isSelected)
          Icon(Icons.check, size: 20, color: itemTokens.selectedMarkerColor),
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
      child: MaterialMenuItemTapRegion(
        isDisabled: item.isDisabled,
        onTap: () => request.commands.selectIndex(index),
        child: MaterialMenuItem(
          minHeight: itemTokens.minHeight,
          padding: itemTokens.padding,
          backgroundColor: backgroundColor,
          child: content,
        ),
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
    final estimatedItemExtent =
        tokens.item.minHeight + tokens.item.padding.vertical;
    final estimatedTotalHeight =
        tokens.menu.padding.vertical + (ctx.items.length * estimatedItemExtent);
    final needsScroll = estimatedTotalHeight > tokens.menu.maxHeight;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(ctx.items.length, ctx.itemBuilder),
    );

    return SingleChildScrollView(
      primary: false,
      physics: needsScroll
          ? const ClampingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      child: content,
    );
  }
}

final class _MaterialDropdownMenuIntrinsicWidth extends StatelessWidget {
  const _MaterialDropdownMenuIntrinsicWidth({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(child: child);
  }
}
