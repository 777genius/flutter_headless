import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';

import 'r_autocomplete_menu_request_composer.dart';
import 'render_overrides_debug.dart';

final class AutocompleteMenuRequestFactory {
  AutocompleteMenuRequestFactory({
    required RAutocompleteMenuRequestComposer composer,
    required RDropdownCommands Function() commandsBuilder,
    required ROverlayPhase Function() overlayPhase,
    required bool Function() isMenuOpen,
    required bool Function() isDisabled,
    required HeadlessFocusHoverController Function() focusHover,
    required List<HeadlessListItemModel> Function() items,
    required int? Function() selectedIndex,
    required Set<int>? Function() selectedItemsIndices,
    required int? Function() highlightedIndex,
    required RDropdownButtonSlots? Function() menuSlots,
    required RenderOverrides? Function() menuOverrides,
    required String? Function() placeholder,
    required String? Function() semanticLabel,
    required HeadlessRequestFeatures Function() features,
  })  : _composer = composer,
        _commandsBuilder = commandsBuilder,
        _overlayPhase = overlayPhase,
        _isMenuOpen = isMenuOpen,
        _isDisabled = isDisabled,
        _focusHover = focusHover,
        _items = items,
        _selectedIndex = selectedIndex,
        _selectedItemsIndices = selectedItemsIndices,
        _highlightedIndex = highlightedIndex,
        _menuSlots = menuSlots,
        _menuOverrides = menuOverrides,
        _placeholder = placeholder,
        _semanticLabel = semanticLabel,
        _features = features;

  final RAutocompleteMenuRequestComposer _composer;
  final RDropdownCommands Function() _commandsBuilder;
  final ROverlayPhase Function() _overlayPhase;
  final bool Function() _isMenuOpen;
  final bool Function() _isDisabled;
  final HeadlessFocusHoverController Function() _focusHover;
  final List<HeadlessListItemModel> Function() _items;
  final int? Function() _selectedIndex;
  final Set<int>? Function() _selectedItemsIndices;
  final int? Function() _highlightedIndex;
  final RDropdownButtonSlots? Function() _menuSlots;
  final RenderOverrides? Function() _menuOverrides;
  final String? Function() _placeholder;
  final String? Function() _semanticLabel;
  final HeadlessRequestFeatures Function() _features;

  RDropdownMenuRenderRequest build(BuildContext context) {
    final trackedOverrides = trackRenderOverrides(_menuOverrides());
    return _composer.createMenuRequest(
      context: context,
      spec: RDropdownButtonSpec(
        placeholder: _placeholder(),
        semanticLabel: _semanticLabel(),
      ),
      overlayPhase: _overlayPhase(),
      selectedIndex: _selectedIndex(),
      selectedItemsIndices: _selectedItemsIndices(),
      highlightedIndex: _highlightedIndex(),
      isTriggerHovered: _focusHover().state.isHovered,
      isTriggerFocused: _focusHover().state.isFocused,
      isDisabled: _isDisabled(),
      isExpanded: _isMenuOpen(),
      items: _items(),
      commands: _commandsBuilder(),
      slots: _menuSlots(),
      overrides: trackedOverrides,
      semanticLabel: _semanticLabel(),
      features: _features(),
    );
  }
}
