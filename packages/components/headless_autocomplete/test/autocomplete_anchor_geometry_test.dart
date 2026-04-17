import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_autocomplete/src/presentation/autocomplete_widget_config_factory.dart';

void main() {
  testWidgets('anchor rect keeps width and adds vertical breathing room', (
    tester,
  ) async {
    final key = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(key: key, width: 240, height: 48),
          ),
        ),
      ),
    );

    final rawRect = tester.getRect(find.byKey(key));
    final anchorRect = resolveAutocompleteAnchorRect(key, null);

    expect(anchorRect.left, rawRect.left);
    expect(anchorRect.right, rawRect.right);
    expect(anchorRect.top, rawRect.top - 4);
    expect(anchorRect.bottom, rawRect.bottom + 4);
  });
}
