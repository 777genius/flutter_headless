import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_example/main.dart' show HeadlessExampleApp;
import 'package:headless_switch/headless_switch.dart';

void main() {
  testWidgets(
    'AppBar theme switch remains tappable while a TextField is focused',
    (tester) async {
      await tester.pumpWidget(const HeadlessExampleApp());
      await tester.pumpAndSettle();

      // Navigate to TextField demo.
      final textFieldTile = find.text('TextField Demo');
      await tester.scrollUntilVisible(
        textFieldTile,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(textFieldTile);
      await tester.pumpAndSettle();

      // Focus the first text field by tapping its EditableText.
      final editable = find.byType(EditableText).first;
      expect(editable, findsOneWidget);
      await tester.tap(editable);
      await tester.pumpAndSettle();

      // Ensure focus is active (keyboard connection in widget tests is limited,
      // but focusNode should still flip).
      final editableWidget = tester.widget<EditableText>(editable);
      expect(editableWidget.focusNode.hasFocus, isTrue);

      final switchFinder =
          find.bySemanticsLabel('Switch between Material and Cupertino theme');
      expect(switchFinder, findsOneWidget);

      final before = tester
          .widget<RSwitch>(
            find.byWidgetPredicate(
              (w) =>
                  w is RSwitch &&
                  w.semanticLabel ==
                      'Switch between Material and Cupertino theme',
            ),
          )
          .value;

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      final after = tester
          .widget<RSwitch>(
            find.byWidgetPredicate(
              (w) =>
                  w is RSwitch &&
                  w.semanticLabel ==
                      'Switch between Material and Cupertino theme',
            ),
          )
          .value;

      expect(after, isNot(equals(before)));
    },
  );
}
