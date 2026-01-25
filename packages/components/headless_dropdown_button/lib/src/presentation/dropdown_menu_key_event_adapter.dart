import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../logic/dropdown_menu_intent.dart';
import '../logic/dropdown_menu_keyboard_controller.dart';

DropdownMenuIntent? dropdownMenuIntentFromKeyEvent(KeyEvent event) {
  if (event is! KeyDownEvent) return null;

  if (event.logicalKey == LogicalKeyboardKey.escape) {
    return const CloseMenuIntent();
  }

  if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
    return const MoveHighlightDownIntent();
  }
  if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
    return const MoveHighlightUpIntent();
  }

  if (event.logicalKey == LogicalKeyboardKey.enter ||
      event.logicalKey == LogicalKeyboardKey.space) {
    return const SelectHighlightedIntent();
  }

  if (event.logicalKey == LogicalKeyboardKey.home) {
    return const JumpToFirstIntent();
  }
  if (event.logicalKey == LogicalKeyboardKey.end) {
    return const JumpToLastIntent();
  }

  final char = event.character;
  if (char != null &&
      char.length == 1 &&
      RegExp(r'[a-zA-Z0-9]').hasMatch(char)) {
    return TypeaheadIntent(char);
  }

  return null;
}

KeyEventResult handleDropdownMenuKeyEvent({
  required DropdownMenuKeyboardController controller,
  required FocusNode node,
  required KeyEvent event,
}) {
  final intent = dropdownMenuIntentFromKeyEvent(event);
  if (intent == null) return KeyEventResult.ignored;

  final handled = controller.handleIntent(intent);
  return handled ? KeyEventResult.handled : KeyEventResult.ignored;
}
