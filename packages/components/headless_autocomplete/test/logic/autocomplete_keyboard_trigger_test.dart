import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_autocomplete/src/logic/autocomplete_keyboard_handler.dart';
import 'package:headless_autocomplete/src/sources/r_autocomplete_remote_query.dart';

void main() {
  group('AutocompleteKeyboardHandler: trigger semantics', () {
    test('ArrowDown syncOptions uses keyboard trigger', () {
      final receivedTriggers = <RAutocompleteRemoteTrigger>[];

      final handler = AutocompleteKeyboardHandler(
        isDisabled: () => false,
        isMenuOpen: () => false,
        hasOptions: () => false,
        isComposing: () => false,
        syncOptions: (t) => receivedTriggers.add(t),
        openMenu: () {},
        closeMenu: ({required bool programmatic}) {},
        resetDismissed: () {},
        refreshMenuState: () {},
        navigateUp: () {},
        navigateDown: () {},
        navigateToFirst: () {},
        navigateToLast: () {},
        resetTypeahead: () {},
        highlightedIndex: () => null,
        selectIndex: (_) {},
        isQueryEmpty: () => false,
        removeLastSelected: () => false,
      );

      final result = handler.handle(
        FocusNode(),
        KeyDownEvent(
          physicalKey: PhysicalKeyboardKey.arrowDown,
          logicalKey: LogicalKeyboardKey.arrowDown,
          timeStamp: Duration.zero,
        ),
      );

      expect(result, KeyEventResult.handled);
      expect(receivedTriggers, [RAutocompleteRemoteTrigger.keyboard]);
    });

    test('ArrowUp syncOptions uses keyboard trigger', () {
      final receivedTriggers = <RAutocompleteRemoteTrigger>[];

      final handler = AutocompleteKeyboardHandler(
        isDisabled: () => false,
        isMenuOpen: () => false,
        hasOptions: () => false,
        isComposing: () => false,
        syncOptions: (t) => receivedTriggers.add(t),
        openMenu: () {},
        closeMenu: ({required bool programmatic}) {},
        resetDismissed: () {},
        refreshMenuState: () {},
        navigateUp: () {},
        navigateDown: () {},
        navigateToFirst: () {},
        navigateToLast: () {},
        resetTypeahead: () {},
        highlightedIndex: () => null,
        selectIndex: (_) {},
        isQueryEmpty: () => false,
        removeLastSelected: () => false,
      );

      final result = handler.handle(
        FocusNode(),
        KeyDownEvent(
          physicalKey: PhysicalKeyboardKey.arrowUp,
          logicalKey: LogicalKeyboardKey.arrowUp,
          timeStamp: Duration.zero,
        ),
      );

      expect(result, KeyEventResult.handled);
      expect(receivedTriggers, [RAutocompleteRemoteTrigger.keyboard]);
    });
  });
}
