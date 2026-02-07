import 'dropdown_menu_intent.dart';

abstract interface class DropdownMenuKeyboardHost {
  bool get isDisposed;

  void closeMenu();
  void navigateUp();
  void navigateDown();
  void navigateToFirst();
  void navigateToLast();
  void selectHighlighted();
  void handleTypeahead(String char);
}

/// Controls keyboard interactions inside the dropdown menu.
///
/// Trigger keyboard behavior is handled by the shared pressable interaction layer.
final class DropdownMenuKeyboardController {
  DropdownMenuKeyboardController(this._host);

  final DropdownMenuKeyboardHost _host;

  bool handleIntent(DropdownMenuIntent intent) {
    if (_host.isDisposed) return false;

    switch (intent) {
      case CloseMenuIntent():
        _host.closeMenu();
        return true;
      case MoveHighlightDownIntent():
        _host.navigateDown();
        return true;
      case MoveHighlightUpIntent():
        _host.navigateUp();
        return true;
      case JumpToFirstIntent():
        _host.navigateToFirst();
        return true;
      case JumpToLastIntent():
        _host.navigateToLast();
        return true;
      case SelectHighlightedIntent():
        _host.selectHighlighted();
        return true;
      case TypeaheadIntent(:final char):
        _host.handleTypeahead(char);
        return true;
    }
  }
}
