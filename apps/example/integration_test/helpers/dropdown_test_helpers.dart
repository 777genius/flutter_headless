import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless/headless.dart';

/// Common test keys for dropdown testing.
abstract final class DropdownTestKeys {
  static const dropdown = Key('test_dropdown');
  static const scrollablePage = Key('scrollable_page');
  static const selectionLabel = Key('selection_label');
  static const selectionCount = Key('selection_count');

  static Key dropdownN(int n) => Key('dropdown_$n');
}

/// Common dropdown items for testing.
abstract final class DropdownTestItems {
  static const List<String> fruits = [
    'apple',
    'banana',
    'cherry',
    'disabled',
    'elderberry',
  ];

  static const List<String> fruitsShort = [
    'apple',
    'banana',
    'cherry',
  ];

  static final HeadlessItemAdapter<String> fruitAdapter =
      HeadlessItemAdapter<String>(
    id: (value) => ListboxItemId(value),
    primaryText: _labelForValue,
    isDisabled: (value) => value == 'disabled',
  );

  static String _labelForValue(String value) {
    return switch (value) {
      'apple' => 'Apple',
      'banana' => 'Banana',
      'cherry' => 'Cherry',
      'disabled' => 'Disabled Option',
      'elderberry' => 'Elderberry',
      _ => value,
    };
  }
}

/// Extension methods for WidgetTester to simplify dropdown testing.
extension DropdownTesterExtensions on WidgetTester {
  /// Opens the dropdown menu by tapping on it.
  Future<void> openDropdown([Key key = const Key('test_dropdown')]) async {
    await tap(find.byKey(key));
    await pumpAndSettle();
  }

  /// Closes menu by tapping outside (top-left corner).
  Future<void> closeDropdownByTapOutside() async {
    await tapAt(const Offset(10, 10));
    await pumpAndSettle();
  }

  /// Taps on a menu item by its label text.
  Future<void> tapMenuItem(String label) async {
    await tap(find.text(label));
    await pumpAndSettle();
  }

  /// Sends a keyboard key event and pumps.
  Future<void> pressKey(LogicalKeyboardKey key, {bool settle = false}) async {
    await sendKeyEvent(key);
    if (settle) {
      await pumpAndSettle();
    } else {
      await pump();
    }
  }

  /// Navigates down in menu using ArrowDown key.
  Future<void> navigateDown({int times = 1, bool settle = false}) async {
    for (var i = 0; i < times; i++) {
      await pressKey(LogicalKeyboardKey.arrowDown, settle: settle);
    }
  }

  /// Navigates up in menu using ArrowUp key.
  Future<void> navigateUp({int times = 1}) async {
    for (var i = 0; i < times; i++) {
      await pressKey(LogicalKeyboardKey.arrowUp);
    }
  }

  /// Selects currently highlighted item with Enter.
  Future<void> selectHighlighted() async {
    await pressKey(LogicalKeyboardKey.enter, settle: true);
  }

  /// Closes menu with Escape key.
  Future<void> closeWithEscape() async {
    await pressKey(LogicalKeyboardKey.escape, settle: true);
  }

  /// Sends scroll event at specified position.
  Future<void> scrollAt(Offset position, Offset delta) async {
    final pointer = TestPointer(1, PointerDeviceKind.mouse);
    await sendEventToBinding(pointer.hover(position));
    await sendEventToBinding(pointer.scroll(delta));
    await pumpAndSettle();
  }

  /// Gets screen dimensions.
  Size get screenSize => view.physicalSize / view.devicePixelRatio;
}

/// Matchers for dropdown menu assertions.
extension DropdownMatchers on CommonFinders {
  /// Finds the dropdown trigger by key.
  Finder get dropdown => byKey(DropdownTestKeys.dropdown);

  /// Checks if menu is open by looking for first item.
  Finder get menuFirstItem => text('Apple');

  /// Finds selection label.
  Finder get selectionLabel => byKey(DropdownTestKeys.selectionLabel);
}

/// Expectation helpers.
extension DropdownExpects on WidgetTester {
  /// Asserts that menu is open.
  void expectMenuOpen() {
    expect(find.text('Apple'), findsOneWidget);
  }

  /// Asserts that menu is closed.
  void expectMenuClosed() {
    expect(find.text('Apple'), findsNothing);
  }

  /// Asserts selected value.
  void expectSelected(String? value) {
    final displayValue = value ?? 'None';
    expect(find.text('Selected: $displayValue'), findsOneWidget);
  }

  /// Asserts menu is positioned below widget.
  void expectMenuBelowWidget(Finder widgetFinder, {double tolerance = 20}) {
    final widgetBox = getRect(widgetFinder);
    final menuItemBox = getRect(find.text('Apple'));

    expect(
      menuItemBox.top,
      greaterThanOrEqualTo(widgetBox.bottom - tolerance),
      reason: 'Menu should be below widget. '
          'Menu top: ${menuItemBox.top}, Widget bottom: ${widgetBox.bottom}',
    );
  }

  /// Asserts menu is horizontally aligned with widget.
  void expectMenuAlignedWith(Finder widgetFinder, {double tolerance = 50}) {
    final widgetBox = getRect(widgetFinder);
    final menuItemBox = getRect(find.text('Apple'));

    expect(
      menuItemBox.left,
      closeTo(widgetBox.left, tolerance),
      reason: 'Menu should be aligned with widget. '
          'Menu left: ${menuItemBox.left}, Widget left: ${widgetBox.left}',
    );
  }
}
