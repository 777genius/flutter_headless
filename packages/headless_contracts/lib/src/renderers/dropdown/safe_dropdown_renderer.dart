import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import 'r_dropdown_button_renderer.dart';
import 'r_dropdown_menu_motion_tokens.dart';
import 'safe_dropdown_contexts.dart';
import 'safe_dropdown_menu_close_contract.dart';

/// Safe scaffold for full dropdown renderer customization.
///
/// Provides close-contract safety and baseline item semantics.
final class SafeDropdownRenderer implements RDropdownButtonRenderer {
  const SafeDropdownRenderer({
    required this.buildTrigger,
    required this.buildMenuSurface,
    required this.buildItem,
    this.buildItemContent,
    this.buildEmptyState,
    this.buildChevron,
    this.motion,
  });

  final SafeDropdownTriggerBuilder buildTrigger;
  final SafeDropdownMenuSurfaceBuilder buildMenuSurface;
  final SafeDropdownItemBuilder buildItem;
  final SafeDropdownItemContentBuilder? buildItemContent;
  final SafeDropdownEmptyStateBuilder? buildEmptyState;
  final SafeDropdownChevronBuilder? buildChevron;
  final RDropdownMenuMotionTokens? motion;

  @override
  Widget render(RDropdownRenderRequest request) {
    return switch (request) {
      RDropdownTriggerRenderRequest() => _renderTrigger(request),
      RDropdownMenuRenderRequest() => _renderMenu(request),
    };
  }

  Widget _renderTrigger(RDropdownTriggerRenderRequest request) {
    final selectedItem = _resolveSelectedItem(request);
    final displayText =
        selectedItem?.primaryText ?? request.spec.placeholder ?? '';
    final chevron = buildChevron?.call(
      SafeDropdownChevronContext(
        spec: request.spec,
        state: request.state,
        selectedItem: selectedItem,
        commands: request.commands,
      ),
    );
    final child = _defaultTriggerChild(displayText, chevron);
    return buildTrigger(
      SafeDropdownTriggerContext(
        spec: request.spec,
        state: request.state,
        selectedItem: selectedItem,
        displayText: displayText,
        commands: request.commands,
        child: child,
        chevron: chevron,
        visualEffects: request.visualEffects,
      ),
    );
  }

  Widget _renderMenu(RDropdownMenuRenderRequest request) {
    final items = request.items;
    final menuContent =
        items.isEmpty ? _renderEmptyState(request) : _renderMenuList(request);
    final constrained = _applyMenuConstraints(request, menuContent);
    final surface = buildMenuSurface(
      SafeDropdownMenuSurfaceContext(
        spec: request.spec,
        state: request.state,
        child: constrained,
        commands: request.commands,
        resolvedTokens: request.resolvedTokens,
      ),
    );
    final menuMotion = motion ??
        request.resolvedTokens?.menu.motion ??
        safeDropdownDefaultMenuMotion;
    return SafeDropdownMenuCloseContract(
      overlayPhase: request.state.overlayPhase,
      onCompleteClose: request.commands.completeClose,
      motion: menuMotion,
      child: surface,
    );
  }

  Widget _renderMenuList(RDropdownMenuRenderRequest request) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: request.items.length,
      itemBuilder: (context, index) => _renderMenuItem(request, index),
    );
  }

  Widget _renderMenuItem(RDropdownMenuRenderRequest request, int index) {
    final item = request.items[index];
    final isHighlighted = request.state.highlightedIndex == index;
    final selectedIndices = request.state.selectedItemsIndices;
    final isSelected = selectedIndices != null
        ? selectedIndices.contains(index)
        : request.state.selectedIndex == index;
    final defaultContent = Text(item.primaryText);
    final content = buildItemContent != null
        ? buildItemContent!(
            SafeDropdownItemContentContext(
              item: item,
              index: index,
              isHighlighted: isHighlighted,
              isSelected: isSelected,
              child: defaultContent,
            ),
          )
        : defaultContent;
    final row = buildItem(
      SafeDropdownItemContext(
        item: item,
        index: index,
        isHighlighted: isHighlighted,
        isSelected: isSelected,
        child: content,
      ),
    );
    return Semantics(
      selected: isSelected,
      enabled: !item.isDisabled,
      label: item.semanticsLabel ?? item.primaryText,
      child: GestureDetector(
        onTap: item.isDisabled ? null : () => request.commands.selectIndex(index),
        behavior: HitTestBehavior.opaque,
        child: row,
      ),
    );
  }

  Widget _renderEmptyState(RDropdownMenuRenderRequest request) {
    if (buildEmptyState == null) return const SizedBox.shrink();
    return buildEmptyState!(
      SafeDropdownEmptyStateContext(
        spec: request.spec,
        state: request.state,
        commands: request.commands,
      ),
    );
  }

  Widget _applyMenuConstraints(
    RDropdownMenuRenderRequest request,
    Widget child,
  ) {
    final maxHeight = request.resolvedTokens?.menu.maxHeight;
    if (maxHeight == null) return child;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: child,
    );
  }

  HeadlessListItemModel? _resolveSelectedItem(
    RDropdownTriggerRenderRequest request,
  ) {
    final selectedIndex = request.state.selectedIndex;
    if (selectedIndex == null || selectedIndex >= request.items.length) {
      return null;
    }
    return request.items[selectedIndex];
  }

  Widget _defaultTriggerChild(String displayText, Widget? chevron) {
    if (chevron == null) {
      return Text(displayText);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            displayText,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        chevron,
      ],
    );
  }
}
