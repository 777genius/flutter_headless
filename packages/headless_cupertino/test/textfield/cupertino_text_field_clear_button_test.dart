import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_cupertino/primitives.dart';

void main() {
  group('CupertinoTextFieldClearButton', () {
    group('visibility modes', () {
      testWidgets('never mode - never visible', (tester) async {
        await tester.pumpWidget(
          const CupertinoApp(
            home: CupertinoTextFieldClearButton(
              mode: RTextFieldOverlayVisibilityMode.never,
              hasText: true,
              isFocused: true,
              onClear: null,
            ),
          ),
        );

        expect(find.byIcon(CupertinoIcons.clear_thick_circled), findsNothing);
      });

      testWidgets('always mode - visible when has text', (tester) async {
        await tester.pumpWidget(
          const CupertinoApp(
            home: CupertinoTextFieldClearButton(
              mode: RTextFieldOverlayVisibilityMode.always,
              hasText: true,
              isFocused: false,
              onClear: null,
            ),
          ),
        );

        expect(find.byIcon(CupertinoIcons.clear_thick_circled), findsOneWidget);
      });

      testWidgets('always mode - hidden when no text', (tester) async {
        await tester.pumpWidget(
          const CupertinoApp(
            home: CupertinoTextFieldClearButton(
              mode: RTextFieldOverlayVisibilityMode.always,
              hasText: false,
              isFocused: true,
              onClear: null,
            ),
          ),
        );

        expect(find.byIcon(CupertinoIcons.clear_thick_circled), findsNothing);
      });

      testWidgets('whileEditing mode - visible when focused and has text',
          (tester) async {
        await tester.pumpWidget(
          const CupertinoApp(
            home: CupertinoTextFieldClearButton(
              mode: RTextFieldOverlayVisibilityMode.whileEditing,
              hasText: true,
              isFocused: true,
              onClear: null,
            ),
          ),
        );

        expect(find.byIcon(CupertinoIcons.clear_thick_circled), findsOneWidget);
      });

      testWidgets('whileEditing mode - hidden when not focused',
          (tester) async {
        await tester.pumpWidget(
          const CupertinoApp(
            home: CupertinoTextFieldClearButton(
              mode: RTextFieldOverlayVisibilityMode.whileEditing,
              hasText: true,
              isFocused: false,
              onClear: null,
            ),
          ),
        );

        expect(find.byIcon(CupertinoIcons.clear_thick_circled), findsNothing);
      });

      testWidgets('notEditing mode - visible when not focused and has text',
          (tester) async {
        await tester.pumpWidget(
          const CupertinoApp(
            home: CupertinoTextFieldClearButton(
              mode: RTextFieldOverlayVisibilityMode.notEditing,
              hasText: true,
              isFocused: false,
              onClear: null,
            ),
          ),
        );

        expect(find.byIcon(CupertinoIcons.clear_thick_circled), findsOneWidget);
      });

      testWidgets('notEditing mode - hidden when focused', (tester) async {
        await tester.pumpWidget(
          const CupertinoApp(
            home: CupertinoTextFieldClearButton(
              mode: RTextFieldOverlayVisibilityMode.notEditing,
              hasText: true,
              isFocused: true,
              onClear: null,
            ),
          ),
        );

        expect(find.byIcon(CupertinoIcons.clear_thick_circled), findsNothing);
      });

      testWidgets('hidden when disabled', (tester) async {
        await tester.pumpWidget(
          const CupertinoApp(
            home: CupertinoTextFieldClearButton(
              mode: RTextFieldOverlayVisibilityMode.always,
              hasText: true,
              isFocused: true,
              isDisabled: true,
              onClear: null,
            ),
          ),
        );

        expect(find.byIcon(CupertinoIcons.clear_thick_circled), findsNothing);
      });

      testWidgets('hidden when readOnly', (tester) async {
        await tester.pumpWidget(
          const CupertinoApp(
            home: CupertinoTextFieldClearButton(
              mode: RTextFieldOverlayVisibilityMode.always,
              hasText: true,
              isFocused: true,
              isReadOnly: true,
              onClear: null,
            ),
          ),
        );

        expect(find.byIcon(CupertinoIcons.clear_thick_circled), findsNothing);
      });
    });

    testWidgets('tap calls onClear', (tester) async {
      bool clearCalled = false;

      await tester.pumpWidget(
        CupertinoApp(
          home: CupertinoTextFieldClearButton(
            mode: RTextFieldOverlayVisibilityMode.always,
            hasText: true,
            isFocused: true,
            onClear: () => clearCalled = true,
          ),
        ),
      );

      await tester.tap(find.byIcon(CupertinoIcons.clear_thick_circled));
      await tester.pump();

      expect(clearCalled, isTrue);
    });

    testWidgets('has 6px horizontal padding (matching Flutter)', (tester) async {
      await tester.pumpWidget(
        const CupertinoApp(
          home: CupertinoTextFieldClearButton(
            mode: RTextFieldOverlayVisibilityMode.always,
            hasText: true,
            isFocused: true,
            onClear: null,
          ),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding).first);
      expect(padding.padding, const EdgeInsets.symmetric(horizontal: 6.0));
    });
  });
}
