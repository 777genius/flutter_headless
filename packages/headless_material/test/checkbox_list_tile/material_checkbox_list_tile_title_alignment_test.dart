import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_material/headless_material.dart';

void main() {
  testWidgets('MaterialListTileOverrides.titleAlignment is applied to ListTile',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              final renderer = MaterialCheckboxListTileRenderer();
              const tokens = RCheckboxListTileResolvedTokens(
                contentPadding: EdgeInsetsDirectional.only(start: 16, end: 24),
                minHeight: 56,
                horizontalGap: 16,
                verticalGap: 2,
                titleStyle: TextStyle(fontSize: 16),
                subtitleStyle: TextStyle(fontSize: 14),
                disabledOpacity: 1.0,
                pressOverlayColor: Color(0x1F000000),
                pressOpacity: 1.0,
                motion: RCheckboxListTileMotionTokens(
                  stateChangeDuration: Duration(milliseconds: 120),
                ),
              );

              final widget = renderer.render(
                RCheckboxListTileRenderRequest(
                  context: context,
                  spec: const RCheckboxListTileSpec(
                    value: false,
                    tristate: false,
                    isError: false,
                    selected: false,
                    hasSubtitle: true,
                    isThreeLine: false,
                    dense: false,
                    controlAffinity: RCheckboxControlAffinity.leading,
                    textDirection: TextDirection.ltr,
                  ),
                  state: const RCheckboxListTileState(),
                  checkbox: const SizedBox(width: 18, height: 18),
                  title: const Text('Title'),
                  subtitle: const Text('Subtitle'),
                  resolvedTokens: tokens,
                  overrides: RenderOverrides.only(
                    const MaterialListTileOverrides(
                      titleAlignment: ListTileTitleAlignment.threeLine,
                    ),
                  ),
                ),
              );

              return widget;
            },
          ),
        ),
      ),
    );

    final listTile = tester.widget<ListTile>(find.byType(ListTile));
    expect(listTile.titleAlignment, ListTileTitleAlignment.threeLine);
  });
}
