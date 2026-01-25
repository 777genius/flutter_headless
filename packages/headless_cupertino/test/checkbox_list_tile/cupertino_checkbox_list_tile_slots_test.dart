import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_cupertino/headless_cupertino.dart';

void main() {
  testWidgets('CupertinoCheckboxListTileRenderer applies tile slot (Decorate)',
      (tester) async {
    const renderer = CupertinoCheckboxListTileRenderer();
    const tokens = RCheckboxListTileResolvedTokens(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      minHeight: 44,
      horizontalGap: 12,
      verticalGap: 4,
      titleStyle: TextStyle(fontSize: 16),
      subtitleStyle: TextStyle(fontSize: 13),
      disabledOpacity: 1.0,
      pressOverlayColor: Color(0x1F000000),
      pressOpacity: 0.4,
      motion: RCheckboxListTileMotionTokens(stateChangeDuration: Duration(milliseconds: 120)),
    );

    await tester.pumpWidget(
      CupertinoApp(
        home: CupertinoPageScaffold(
          child: Builder(
            builder: (context) {
              return renderer.render(
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
                  slots: RCheckboxListTileSlots(
                    tile: Decorate(
                      (ctx, child) => Container(
                        key: const ValueKey('tile-slot'),
                        child: child,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('tile-slot')), findsOneWidget);
    expect(find.byType(Row), findsOneWidget);
  });
}

