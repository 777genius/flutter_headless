import 'package:flutter_test/flutter_test.dart';

import 'package:headless_dropdown_button/src/logic/dropdown_menu_intent.dart';
import 'package:headless_dropdown_button/src/logic/dropdown_menu_keyboard_controller.dart';

void main() {
  test('DropdownMenuKeyboardController applies intents to host', () {
    final host = _Host();
    final c = DropdownMenuKeyboardController(host);

    expect(c.handleIntent(const MoveHighlightDownIntent()), isTrue);
    expect(host.calls, ['down']);

    expect(c.handleIntent(const MoveHighlightUpIntent()), isTrue);
    expect(host.calls, ['down', 'up']);

    expect(c.handleIntent(const JumpToFirstIntent()), isTrue);
    expect(host.calls, ['down', 'up', 'first']);

    expect(c.handleIntent(const JumpToLastIntent()), isTrue);
    expect(host.calls, ['down', 'up', 'first', 'last']);

    expect(c.handleIntent(const SelectHighlightedIntent()), isTrue);
    expect(host.calls, ['down', 'up', 'first', 'last', 'select']);

    expect(c.handleIntent(const TypeaheadIntent('a')), isTrue);
    expect(host.calls, ['down', 'up', 'first', 'last', 'select', 'type:a']);

    expect(c.handleIntent(const CloseMenuIntent()), isTrue);
    expect(
      host.calls,
      ['down', 'up', 'first', 'last', 'select', 'type:a', 'close'],
    );
  });

  test('DropdownMenuKeyboardController ignores intents when disposed', () {
    final host = _Host()..disposed = true;
    final c = DropdownMenuKeyboardController(host);
    expect(c.handleIntent(const CloseMenuIntent()), isFalse);
    expect(host.calls, isEmpty);
  });
}

class _Host implements DropdownMenuKeyboardHost {
  bool disposed = false;
  final List<String> calls = [];

  @override
  bool get isDisposed => disposed;

  @override
  void closeMenu() => calls.add('close');

  @override
  void navigateUp() => calls.add('up');

  @override
  void navigateDown() => calls.add('down');

  @override
  void navigateToFirst() => calls.add('first');

  @override
  void navigateToLast() => calls.add('last');

  @override
  void selectHighlighted() => calls.add('select');

  @override
  void handleTypeahead(String char) => calls.add('type:$char');
}
