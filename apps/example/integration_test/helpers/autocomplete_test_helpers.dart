import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless/headless.dart';

abstract final class AutocompleteTestKeys {
  static const field = Key('autocomplete_field');
  static const selectionLabel = Key('autocomplete_selection_label');
  static const multiSelectionLabel = Key('autocomplete_multi_selection_label');
  static const multiCountLabel = Key('autocomplete_multi_count_label');
  static Key richItem(int index) => Key('autocomplete_rich_item_$index');
}

abstract final class AutocompleteTestItems {
  static const List<String> countries = [
    'Finland',
    'Fiji',
    'France',
    'Germany',
  ];

  static final HeadlessItemAdapter<String> adapter = HeadlessItemAdapter(
    id: (value) => ListboxItemId(value),
    primaryText: (value) => value,
    searchText: (value) => value,
  );

  static Iterable<String> filter(TextEditingValue value) {
    final query = value.text.trim().toLowerCase();
    if (query.isEmpty) return const <String>[];
    return countries.where((country) {
      return country.toLowerCase().contains(query);
    });
  }
}

@immutable
final class AutocompleteTestCountry {
  const AutocompleteTestCountry({
    required this.name,
    required this.dialCode,
    required this.isoCode,
    required this.flagLabel,
  });

  final String name;
  final String dialCode;
  final String isoCode;
  final String flagLabel;

  String get searchLabel => '$name $dialCode $isoCode';

  bool matches(String query) {
    return searchLabel.toLowerCase().contains(query);
  }
}

abstract final class AutocompleteRichTestItems {
  static const List<AutocompleteTestCountry> countries = [
    AutocompleteTestCountry(
      name: 'Finland',
      dialCode: '+358',
      isoCode: 'FI',
      flagLabel: 'FI',
    ),
    AutocompleteTestCountry(
      name: 'France',
      dialCode: '+33',
      isoCode: 'FR',
      flagLabel: 'FR',
    ),
    AutocompleteTestCountry(
      name: 'Germany',
      dialCode: '+49',
      isoCode: 'DE',
      flagLabel: 'DE',
    ),
  ];

  static final HeadlessItemAdapter<AutocompleteTestCountry> adapter =
      HeadlessItemAdapter(
    id: (country) => ListboxItemId(country.isoCode),
    primaryText: (country) => country.name,
    searchText: (country) => country.searchLabel,
    leading: (country) => HeadlessContent.text(country.flagLabel),
    subtitle: (country) => HeadlessContent.text(country.dialCode),
    trailing: (country) => HeadlessContent.text(country.isoCode),
  );

  static Iterable<AutocompleteTestCountry> filter(TextEditingValue value) {
    final query = value.text.trim().toLowerCase();
    if (query.isEmpty) return const <AutocompleteTestCountry>[];
    return countries.where((country) => country.matches(query));
  }
}

extension AutocompleteTesterExtensions on WidgetTester {
  Future<void> tapAutocompleteField() async {
    await tap(find.byKey(AutocompleteTestKeys.field));
    await pumpAndSettle();
  }

  Future<void> enterAutocompleteText(String text) async {
    await enterText(find.byType(EditableText), text);
    await pumpAndSettle();
  }

  Future<void> setAutocompleteEditingValue(TextEditingValue value) async {
    final editable = widget<EditableText>(find.byType(EditableText));
    editable.controller.value = value;
    await pumpAndSettle();
  }

  Future<void> pressKey(LogicalKeyboardKey key, {bool settle = false}) async {
    await sendKeyEvent(key);
    if (settle) {
      await pumpAndSettle();
    } else {
      await pump();
    }
  }

  Future<void> closeAutocompleteByTapOutside() async {
    await tapAt(const Offset(10, 10));
    await pumpAndSettle();
  }

  Future<void> scrollAt(Offset position, Offset delta) async {
    final pointer = TestPointer(1, PointerDeviceKind.mouse);
    await sendEventToBinding(pointer.hover(position));
    await sendEventToBinding(pointer.scroll(delta));
    await pumpAndSettle();
  }
}

extension AutocompleteExpects on WidgetTester {
  Finder _menuSurface() {
    // MaterialHeadlessTheme renders dropdown menus inside a custom surface widget.
    // Depending on whether the menu needs scrolling, the inner content can be a
    // Column (non-scroll) or a ListView (scroll). So we anchor expectations to
    // the menu surface instead of assuming a ListView.
    return find.byWidgetPredicate(
      (w) => w.runtimeType.toString() == 'MaterialMenuSurface',
    );
  }

  void expectMenuOpen({String expectedText = 'Finland'}) {
    final surface = _menuSurface();
    if (surface.evaluate().isNotEmpty) {
      expect(
        find.descendant(of: surface, matching: find.text(expectedText)),
        findsOneWidget,
      );
      return;
    }

    // Fallback (older renderers / scroll menus).
    expect(
      find.descendant(of: find.byType(ListView), matching: find.text(expectedText)),
      findsOneWidget,
    );
  }

  void expectMenuClosed({String expectedText = 'Finland'}) {
    final surface = _menuSurface();
    if (surface.evaluate().isNotEmpty) {
      expect(
        find.descendant(of: surface, matching: find.text(expectedText)),
        findsNothing,
      );
      return;
    }

    expect(
      find.descendant(of: find.byType(ListView), matching: find.text(expectedText)),
      findsNothing,
    );
  }

  void expectSelected(String? value) {
    final label = value ?? 'none';
    expect(find.text('Selected: $label'), findsOneWidget);
  }

  void expectMultiSelected(List<String> values) {
    final label = values.join(', ');
    expect(find.text('Selected: $label'), findsOneWidget);
    expect(find.byKey(AutocompleteTestKeys.multiSelectionLabel), findsOneWidget);
  }

  void expectMultiCount(int count) {
    expect(find.text('Count: $count'), findsOneWidget);
    expect(find.byKey(AutocompleteTestKeys.multiCountLabel), findsOneWidget);
  }
}
