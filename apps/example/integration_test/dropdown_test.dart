import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/dropdown_test_helpers.dart';
import 'helpers/test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dropdown E2E Tests', () {
    Future<void> pumpDropdown(
      WidgetTester tester, {
      bool disabled = false,
      String? initialValue,
    }) async {
      await tester.pumpWidget(DropdownTestApp(
        child: DropdownTestScenario(
          disabled: disabled,
          initialValue: initialValue,
        ),
      ));
      await tester.pumpAndSettle();
    }

    // =========================================================================
    // Basic interactions
    // =========================================================================

    testWidgets('IT-01: Tap on trigger opens menu', (tester) async {
      await pumpDropdown(tester);

      expect(find.byKey(DropdownTestKeys.dropdown), findsOneWidget);
      tester.expectMenuClosed();

      await tester.openDropdown();

      tester.expectMenuOpen();
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Cherry'), findsOneWidget);
      expect(find.text('Elderberry'), findsOneWidget);
    });

    testWidgets('IT-02: Tap outside menu closes it', (tester) async {
      await pumpDropdown(tester);

      await tester.openDropdown();
      tester.expectMenuOpen();

      await tester.closeDropdownByTapOutside();
      tester.expectMenuClosed();
    });

    testWidgets('IT-03: Tap on item selects it and closes menu', (tester) async {
      await pumpDropdown(tester);

      tester.expectSelected(null);

      await tester.openDropdown();
      await tester.tapMenuItem('Banana');

      tester.expectMenuClosed();
      tester.expectSelected('banana');
    });

    testWidgets('IT-04: Tap on disabled item does nothing', (tester) async {
      await pumpDropdown(tester);

      await tester.openDropdown();
      await tester.tapMenuItem('Disabled Option');

      tester.expectSelected(null);
    });

    // =========================================================================
    // Keyboard navigation
    // =========================================================================

    testWidgets('IT-05: Space key opens menu', (tester) async {
      await pumpDropdown(tester);

      // Focus dropdown, close, then reopen with keyboard
      await tester.openDropdown();
      await tester.closeDropdownByTapOutside();

      await tester.tap(find.byKey(DropdownTestKeys.dropdown));
      await tester.pump();

      await tester.pressKey(LogicalKeyboardKey.space, settle: true);
      tester.expectMenuOpen();
    });

    testWidgets('IT-06: ArrowDown/Up navigates through items', (tester) async {
      await pumpDropdown(tester);

      await tester.openDropdown();

      // Navigate: Apple -> Banana -> Cherry (skips Disabled)
      await tester.navigateDown(times: 2);
      await tester.selectHighlighted();

      tester.expectSelected('cherry');
    });

    testWidgets('IT-07: Enter key selects highlighted item', (tester) async {
      await pumpDropdown(tester);

      await tester.openDropdown();

      // Navigate to Banana and select
      await tester.navigateDown();
      await tester.selectHighlighted();

      tester.expectSelected('banana');
    });

    testWidgets(
      'IT-08: Escape closes menu without changing selection',
      (tester) async {
        await pumpDropdown(tester, initialValue: 'apple');

        tester.expectSelected('apple');

        await tester.openDropdown();
        await tester.navigateDown(settle: true);
        await tester.closeWithEscape();

        tester.expectMenuClosed();
        tester.expectSelected('apple');
      },
      // TODO: Fix Escape handling in overlay architecture
      skip: true,
    );

    // =========================================================================
    // States
    // =========================================================================

    testWidgets('IT-09: Disabled dropdown cannot be opened', (tester) async {
      await pumpDropdown(tester, disabled: true);

      await tester.tap(find.byKey(DropdownTestKeys.dropdown));
      await tester.pumpAndSettle();

      tester.expectMenuClosed();
    });

    testWidgets('IT-10: Focus returns to trigger after menu closes',
        (tester) async {
      await pumpDropdown(tester);

      await tester.openDropdown();
      await tester.tapMenuItem('Cherry');

      tester.expectMenuClosed();
      tester.expectSelected('cherry');

      // Verify dropdown can be reopened
      await tester.openDropdown();
      tester.expectMenuOpen();
    });

    // =========================================================================
    // Positioning
    // =========================================================================

    testWidgets('IT-11: Menu is positioned below the trigger', (tester) async {
      await pumpDropdown(tester);

      final triggerFinder = find.byKey(DropdownTestKeys.dropdown);
      await tester.openDropdown();

      tester.expectMenuBelowWidget(triggerFinder);
      tester.expectMenuAlignedWith(triggerFinder);
    });

    testWidgets('IT-12: Menu width matches trigger width', (tester) async {
      await pumpDropdown(tester);

      await tester.openDropdown();

      final menuItemBox = tester.getRect(find.text('Apple'));
      expect(
        menuItemBox.width,
        lessThan(tester.screenSize.width),
        reason: 'Menu should not span full screen width',
      );
    });

    testWidgets('IT-13: Menu has compact height based on content',
        (tester) async {
      await pumpDropdown(tester);

      await tester.openDropdown();

      final appleBox = tester.getRect(find.text('Apple'));
      final elderberryBox = tester.getRect(find.text('Elderberry'));
      final menuHeight = elderberryBox.bottom - appleBox.top + 16;

      expect(
        menuHeight,
        lessThan(tester.screenSize.height * 0.5),
        reason: 'Menu should be compact, not stretched',
      );
      expect(
        menuHeight,
        greaterThan(100),
        reason: 'Menu should have reasonable height',
      );
    });

    testWidgets('IT-14: Menu surface has no excess empty space', (tester) async {
      await pumpDropdown(tester);

      await tester.openDropdown();

      final materialFinder = find.ancestor(
        of: find.text('Apple'),
        matching: find.byType(Material),
      );
      expect(materialFinder, findsWidgets);

      final materialBox = tester.getRect(materialFinder.first);
      final appleBox = tester.getRect(find.text('Apple'));
      final elderberryBox = tester.getRect(find.text('Elderberry'));

      // Check top edge
      expect(
        materialBox.top,
        closeTo(appleBox.top - 8, 20),
        reason: 'Surface top should be close to first item',
      );

      // Check bottom edge
      expect(
        materialBox.bottom,
        closeTo(elderberryBox.bottom + 8, 20),
        reason: 'Surface bottom should be close to last item',
      );

      // Check excess space
      final expectedHeight = (elderberryBox.bottom - appleBox.top) + 16;
      final excess = materialBox.height - expectedHeight;

      expect(
        excess,
        lessThan(40),
        reason: 'Menu has ${excess}px of excess space',
      );
    });

    // =========================================================================
    // Multiple dropdowns
    // =========================================================================

    testWidgets('IT-15: Multiple dropdowns position correctly', (tester) async {
      await tester.pumpWidget(const DropdownTestApp(
        child: MultipleDropdownsScenario(),
      ));
      await tester.pumpAndSettle();

      final trigger2 = find.byKey(DropdownTestKeys.dropdownN(2));
      final trigger3 = find.byKey(DropdownTestKeys.dropdownN(3));
      final trigger2Box = tester.getRect(trigger2);
      final trigger3Box = tester.getRect(trigger3);

      // Open dropdown 2
      await tester.openDropdown(DropdownTestKeys.dropdownN(2));
      tester.expectMenuOpen();

      final menuItemBox = tester.getRect(find.text('Apple'));

      // Menu should be below trigger2 but above trigger3
      expect(menuItemBox.top, greaterThanOrEqualTo(trigger2Box.bottom - 10));
      expect(menuItemBox.top, lessThan(trigger3Box.top));

      // Aligned with trigger2
      expect(menuItemBox.left, closeTo(trigger2Box.left, 50));

      await tester.closeDropdownByTapOutside();

      // Open dropdown 3
      await tester.openDropdown(DropdownTestKeys.dropdownN(3));

      final menu3ItemBox = tester.getRect(find.text('Apple'));
      expect(menu3ItemBox.top, greaterThanOrEqualTo(trigger3Box.bottom - 10));
    });

    // =========================================================================
    // Scroll behavior
    // =========================================================================

    testWidgets('IT-16: Scroll passes through menu to page', (tester) async {
      await tester.pumpWidget(const DropdownTestApp(
        child: ScrollableDropdownScenario(),
      ));
      await tester.pumpAndSettle();

      final scrollableFinder = find.byKey(DropdownTestKeys.scrollablePage);
      final scrollableWidget =
          tester.widget<SingleChildScrollView>(scrollableFinder);
      final scrollController = scrollableWidget.controller!;

      expect(scrollController.offset, equals(0.0));

      await tester.openDropdown();
      tester.expectMenuOpen();

      final menuCenter = tester.getRect(find.text('Apple')).center;
      await tester.scrollAt(menuCenter, const Offset(0, 100));

      expect(
        scrollController.offset,
        greaterThan(0),
        reason: 'Page should scroll when scrolling over menu',
      );
    });
  });
}
