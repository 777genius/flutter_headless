import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'autocomplete_menu_overlay_controller.dart';

final class AutocompleteMenuHostDelegate
    implements AutocompleteMenuOverlayHost {
  AutocompleteMenuHostDelegate({
    required BuildContext Function() contextGetter,
    required bool Function() isDisposedGetter,
    required Rect Function() anchorRectGetter,
    required FocusNode Function() anchorFocusNodeGetter,
    required int? Function() highlightedIndexGetter,
    required RDropdownMenuRenderRequest Function(BuildContext)
        menuRequestBuilder,
    required VoidCallback notifyStateChanged,
  })  : _contextGetter = contextGetter,
        _isDisposedGetter = isDisposedGetter,
        _anchorRectGetter = anchorRectGetter,
        _anchorFocusNodeGetter = anchorFocusNodeGetter,
        _highlightedIndexGetter = highlightedIndexGetter,
        _menuRequestBuilder = menuRequestBuilder,
        _notifyStateChanged = notifyStateChanged;

  final BuildContext Function() _contextGetter;
  final bool Function() _isDisposedGetter;
  final Rect Function() _anchorRectGetter;
  final FocusNode Function() _anchorFocusNodeGetter;
  final int? Function() _highlightedIndexGetter;
  final RDropdownMenuRenderRequest Function(BuildContext) _menuRequestBuilder;
  final VoidCallback _notifyStateChanged;

  @override
  BuildContext get context => _contextGetter();

  @override
  bool get isDisposed => _isDisposedGetter();

  @override
  Rect Function() get anchorRectGetter => _anchorRectGetter;

  @override
  FocusNode get anchorFocusNode => _anchorFocusNodeGetter();

  @override
  int? get highlightedIndex => _highlightedIndexGetter();

  @override
  RDropdownMenuRenderRequest Function(BuildContext) get menuRequestBuilder =>
      _menuRequestBuilder;

  @override
  void notifyStateChanged() => _notifyStateChanged();
}
