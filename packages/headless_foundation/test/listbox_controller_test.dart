import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/headless_foundation.dart';

void main() {
  List<ListboxItem> items() => const [
        ListboxItem(id: ListboxItemId('a'), label: 'Apple'),
        ListboxItem(id: ListboxItemId('b'), label: 'Banana'),
        ListboxItem(id: ListboxItemId('c'), label: 'Cherry', isDisabled: true),
        ListboxItem(id: ListboxItemId('d'), label: 'Date'),
      ];

  test('highlightNext skips disabled and loops by default', () {
    final c = ListboxController();
    c.setItems(items());

    c.highlightFirst(); // Apple
    expect(c.state.highlightedId, const ListboxItemId('a'));

    c.highlightNext(); // Banana
    expect(c.state.highlightedId, const ListboxItemId('b'));

    c.highlightNext(); // skip Cherry (disabled) -> Date
    expect(c.state.highlightedId, const ListboxItemId('d'));

    c.highlightNext(); // loop -> Apple
    expect(c.state.highlightedId, const ListboxItemId('a'));
  });

  test('home/end semantics via highlightFirst/highlightLast', () {
    final c = ListboxController();
    c.setItems(items());

    c.highlightLast();
    expect(c.state.highlightedId, const ListboxItemId('d'));

    c.highlightFirst();
    expect(c.state.highlightedId, const ListboxItemId('a'));
  });

  test('selectHighlighted does not select disabled', () {
    final c = ListboxController();
    c.setItems(items());

    c.setHighlightedId(const ListboxItemId('c')); // disabled, should be ignored
    expect(c.state.highlightedId, isNull);

    c.highlightFirst();
    c.selectHighlighted();
    expect(c.state.selectedId, const ListboxItemId('a'));
  });

  test('typeahead matches from next position and wraps', () {
    var now = DateTime(2020);
    final c = ListboxController(
      now: () => now,
    );
    c.setItems(items());

    c.highlightFirst(); // Apple

    // "d" should match Date (wrap search from next)
    c.handleTypeahead('d');
    expect(c.state.highlightedId, const ListboxItemId('d'));

    // Next "b" within timeout extends the buffer to "db" and should not match.
    c.handleTypeahead('b');
    expect(c.state.highlightedId, const ListboxItemId('d'));

    // Buffer timeout -> new query
    now = now.add(const Duration(seconds: 1));
    c.handleTypeahead('b');
    expect(c.state.highlightedId, const ListboxItemId('b'));
  });
}

