import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';

import '../presentation/autocomplete_menu_host_delegate.dart';
import '../presentation/autocomplete_menu_overlay_controller.dart';
import '../presentation/autocomplete_menu_request_factory.dart';
import '../presentation/r_autocomplete_menu_request_composer.dart';

final class AutocompleteMenuCoordinator {
  AutocompleteMenuCoordinator({
    required BuildContext Function() contextGetter,
    required bool Function() isDisposedGetter,
    required Rect Function() anchorRectGetter,
    required FocusNode Function() anchorFocusNodeGetter,
    required int? Function() highlightedIndexGetter,
    required List<HeadlessListItemModel> Function() itemsGetter,
    required int? Function() selectedIndexGetter,
    required Set<int>? Function() selectedItemsIndicesGetter,
    required HeadlessFocusHoverController Function() focusHoverGetter,
    required bool Function() isDisabledGetter,
    required RDropdownButtonSlots? Function() menuSlotsGetter,
    required RenderOverrides? Function() menuOverridesGetter,
    required String? Function() placeholderGetter,
    required String? Function() semanticLabelGetter,
    required HeadlessRequestFeatures Function() featuresGetter,
    required VoidCallback notifyStateChanged,
    required ValueChanged<int> selectIndex,
    required ValueChanged<int> highlightIndex,
  })  : _itemsGetter = itemsGetter,
        _selectedIndexGetter = selectedIndexGetter,
        _selectedItemsIndicesGetter = selectedItemsIndicesGetter,
        _highlightedIndexGetter = highlightedIndexGetter,
        _focusHoverGetter = focusHoverGetter,
        _isDisabledGetter = isDisabledGetter,
        _menuSlotsGetter = menuSlotsGetter,
        _menuOverridesGetter = menuOverridesGetter,
        _placeholderGetter = placeholderGetter,
        _semanticLabelGetter = semanticLabelGetter,
        _featuresGetter = featuresGetter {
    _menuHost = _createMenuHost(
      contextGetter: contextGetter,
      isDisposedGetter: isDisposedGetter,
      anchorRectGetter: anchorRectGetter,
      anchorFocusNodeGetter: anchorFocusNodeGetter,
      highlightedIndexGetter: highlightedIndexGetter,
      notifyStateChanged: notifyStateChanged,
    );
    _menuController = AutocompleteMenuOverlayController(_menuHost);
    _commandsBuilder = _createCommandsBuilder(
      selectIndex: selectIndex,
      highlightIndex: highlightIndex,
    );
    _menuRequestFactory = _createRequestFactory();
  }

  final List<HeadlessListItemModel> Function() _itemsGetter;
  final int? Function() _selectedIndexGetter;
  final Set<int>? Function() _selectedItemsIndicesGetter;
  final int? Function() _highlightedIndexGetter;
  final HeadlessFocusHoverController Function() _focusHoverGetter;
  final bool Function() _isDisabledGetter;
  final RDropdownButtonSlots? Function() _menuSlotsGetter;
  final RenderOverrides? Function() _menuOverridesGetter;
  final String? Function() _placeholderGetter;
  final String? Function() _semanticLabelGetter;
  final HeadlessRequestFeatures Function() _featuresGetter;

  late final AutocompleteMenuHostDelegate _menuHost;
  late final AutocompleteMenuOverlayController _menuController;
  late final AutocompleteMenuRequestFactory _menuRequestFactory;
  late final RDropdownCommands Function() _commandsBuilder;

  bool get isMenuOpen => _menuController.isMenuOpen;
  bool get hasOverlay => _menuController.hasOverlay;
  bool get wasDismissed => _menuController.wasDismissed;
  ROverlayPhase get overlayPhase => _menuController.overlayPhase;

  void resetDismissed() => _menuController.resetDismissed();
  void refreshMenuState() => _menuController.refreshMenuState();
  void updateHighlight(int? index) => _menuController.updateHighlight(index);

  void openMenu() => _menuController.openMenu();

  void closeMenu({required bool programmatic}) {
    _menuController.closeMenu(programmatic: programmatic);
  }

  void dispose() => _menuController.dispose();

  RDropdownMenuRenderRequest _createMenuRequest(BuildContext context) =>
      _menuRequestFactory.build(context);

  AutocompleteMenuHostDelegate _createMenuHost({
    required BuildContext Function() contextGetter,
    required bool Function() isDisposedGetter,
    required Rect Function() anchorRectGetter,
    required FocusNode Function() anchorFocusNodeGetter,
    required int? Function() highlightedIndexGetter,
    required VoidCallback notifyStateChanged,
  }) {
    return AutocompleteMenuHostDelegate(
      contextGetter: contextGetter,
      isDisposedGetter: isDisposedGetter,
      anchorRectGetter: anchorRectGetter,
      anchorFocusNodeGetter: anchorFocusNodeGetter,
      highlightedIndexGetter: highlightedIndexGetter,
      menuRequestBuilder: _createMenuRequest,
      notifyStateChanged: notifyStateChanged,
    );
  }

  RDropdownCommands Function() _createCommandsBuilder({
    required ValueChanged<int> selectIndex,
    required ValueChanged<int> highlightIndex,
  }) {
    return () => RDropdownCommands(
          open: openMenu,
          close: () => closeMenu(programmatic: true),
          selectIndex: selectIndex,
          highlight: highlightIndex,
          completeClose: _menuController.completeClose,
        );
  }

  AutocompleteMenuRequestFactory _createRequestFactory() {
    return AutocompleteMenuRequestFactory(
      composer: const RAutocompleteMenuRequestComposer(),
      commandsBuilder: _commandsBuilder,
      overlayPhase: () => overlayPhase,
      isMenuOpen: () => isMenuOpen,
      isDisabled: _isDisabledGetter,
      focusHover: _focusHoverGetter,
      items: _itemsGetter,
      selectedIndex: _selectedIndexGetter,
      selectedItemsIndices: _selectedItemsIndicesGetter,
      highlightedIndex: _highlightedIndexGetter,
      menuSlots: _menuSlotsGetter,
      menuOverrides: _menuOverridesGetter,
      placeholder: _placeholderGetter,
      semanticLabel: _semanticLabelGetter,
      features: _featuresGetter,
    );
  }
}
