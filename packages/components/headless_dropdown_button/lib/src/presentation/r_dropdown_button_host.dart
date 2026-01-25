import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';

import '../logic/dropdown_menu_keyboard_controller.dart';
import 'dropdown_overlay_controller.dart';
import 'dropdown_selection_controller.dart';
import 'r_dropdown_option.dart';

final class RDropdownButtonHost<T>
    implements
        DropdownOverlayHost,
        DropdownSelectionHost<T>,
        DropdownMenuKeyboardHost {
  RDropdownButtonHost({
    required BuildContext Function() contextGetter,
    required BuildContext? Function() triggerContextGetter,
    required FocusNode Function() triggerFocusNodeGetter,
    required Rect Function() anchorRectGetter,
    required bool Function() isDisposedGetter,
    required List<RDropdownOption<T>> Function() optionsGetter,
    required ListboxItemId? Function() selectedIdGetter,
    required T? Function() selectedValueGetter,
    required ValueChanged<T>? onChanged,
    required RDropdownMenuRenderRequest Function(BuildContext)
        menuRequestBuilder,
    required KeyEventResult Function(FocusNode, KeyEvent) menuKeyHandler,
    required VoidCallback notifyStateChanged,
  })  : _contextGetter = contextGetter,
        _triggerContextGetter = triggerContextGetter,
        _triggerFocusNodeGetter = triggerFocusNodeGetter,
        _anchorRectGetter = anchorRectGetter,
        _isDisposedGetter = isDisposedGetter,
        _optionsGetter = optionsGetter,
        _selectedIdGetter = selectedIdGetter,
        _selectedValueGetter = selectedValueGetter,
        _onChanged = onChanged,
        _menuRequestBuilder = menuRequestBuilder,
        _menuKeyHandler = menuKeyHandler,
        _notifyStateChanged = notifyStateChanged;

  final BuildContext Function() _contextGetter;
  final BuildContext? Function() _triggerContextGetter;
  final FocusNode Function() _triggerFocusNodeGetter;
  final Rect Function() _anchorRectGetter;
  final bool Function() _isDisposedGetter;
  final List<RDropdownOption<T>> Function() _optionsGetter;
  final ListboxItemId? Function() _selectedIdGetter;
  final T? Function() _selectedValueGetter;
  final ValueChanged<T>? _onChanged;
  final RDropdownMenuRenderRequest Function(BuildContext) _menuRequestBuilder;
  final KeyEventResult Function(FocusNode, KeyEvent) _menuKeyHandler;
  final VoidCallback _notifyStateChanged;

  late DropdownOverlayController _overlay;
  late DropdownSelectionController<T> _selection;

  void bind({
    required DropdownOverlayController overlay,
    required DropdownSelectionController<T> selection,
  }) {
    _overlay = overlay;
    _selection = selection;
  }

  @override
  BuildContext get context => _contextGetter();

  @override
  BuildContext? get triggerContext => _triggerContextGetter();

  @override
  bool get isDisposed => _isDisposedGetter();

  @override
  FocusNode get triggerFocusNode => _triggerFocusNodeGetter();

  @override
  Rect Function() get anchorRectGetter => _anchorRectGetter;

  @override
  int? findSelectedIndex() {
    final selectedId = this.selectedId;
    if (selectedId == null) return null;
    final options = _optionsGetter();
    for (var i = 0; i < options.length; i++) {
      if (options[i].item.id == selectedId) return i;
    }
    return null;
  }

  @override
  int? findFirstEnabledIndex() {
    final options = _optionsGetter();
    for (var i = 0; i < options.length; i++) {
      if (!options[i].item.isDisabled) return i;
    }
    return null;
  }

  @override
  bool isItemDisabled(int index) => _optionsGetter()[index].item.isDisabled;

  @override
  RDropdownMenuRenderRequest Function(BuildContext) get menuRequestBuilder =>
      _menuRequestBuilder;

  @override
  KeyEventResult Function(FocusNode, KeyEvent) get menuKeyHandler =>
      _menuKeyHandler;

  @override
  void notifyStateChanged() => _notifyStateChanged();

  @override
  List<RDropdownOption<T>> get options => _optionsGetter();

  @override
  ListboxItemId? get selectedId => _selectedIdGetter();

  @override
  T? get selectedValue => _selectedValueGetter();

  @override
  int? get highlightedIndex => _overlay.highlightedIndex;

  @override
  void updateHighlight(int? index) => _overlay.updateHighlight(index);

  @override
  void onValueSelected(T value) => _onChanged?.call(value);

  @override
  void closeMenu() {
    _selection.resetTypeahead();
    _overlay.closeMenu();
  }

  @override
  void navigateUp() => _selection.navigateUp();

  @override
  void navigateDown() => _selection.navigateDown();

  @override
  void navigateToFirst() => _selection.navigateToFirst();

  @override
  void navigateToLast() => _selection.navigateToLast();

  @override
  void selectHighlighted() => _selection.selectHighlighted();

  @override
  void handleTypeahead(String char) => _selection.handleTypeahead(char);
}
