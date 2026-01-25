import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless/headless.dart';

void main() {
  testWidgets(
      'Desktop: page scrolls (wheel) while autocomplete menu is open (cursor outside menu)',
      (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    try {
      final overlayController = OverlayController();
      addTearDown(overlayController.dispose);

      final scrollController = ScrollController();
      addTearDown(scrollController.dispose);

      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        HeadlessThemeProvider(
          theme: MaterialHeadlessTheme(),
          child: MaterialApp(
            home: AnchoredOverlayEngineHost(
              controller: overlayController,
              child: Scaffold(
                body: ListView.builder(
                  controller: scrollController,
                  itemCount: 60,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: RAutocomplete<String>(
                          focusNode: focusNode,
                          source: RAutocompleteLocalSource(
                            options: (_) => const ['Alpha', 'Beta', 'Gamma'],
                          ),
                          itemAdapter: HeadlessItemAdapter<String>(
                            id: (v) => ListboxItemId(v),
                            primaryText: (v) => v,
                            searchText: (v) => v,
                          ),
                          onSelected: (_) {},
                          openOnFocus: false,
                          openOnTap: true,
                          openOnInput: false,
                          initialValue: const TextEditingValue(text: ''),
                        ),
                      );
                    }
                    return SizedBox(
                      height: 60,
                      child: Center(child: Text('Row $index')),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open the menu.
      await tester.tap(find.byType(EditableText));
      await tester.pumpAndSettle();
      expect(find.text('Alpha'), findsOneWidget);

      final beforeWithMenu = scrollController.offset;

      // Wheel-scroll the page while menu is open (desktop expectation: page stays scrollable).
      final pageList = find.byWidgetPredicate(
        (w) => w is ListView && w.controller == scrollController,
      );
      expect(pageList, findsOneWidget);
      final listRect = tester.getRect(pageList);
      final outsideMenuPosition = Offset(listRect.left + 8, listRect.bottom - 8);
      await tester.sendEventToBinding(
        PointerScrollEvent(
          position: outsideMenuPosition,
          scrollDelta: const Offset(0, 220),
        ),
      );
      await tester.pumpAndSettle();

      expect(scrollController.offset, greaterThan(beforeWithMenu));
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}

