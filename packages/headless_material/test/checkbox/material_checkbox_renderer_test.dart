import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_material/headless_material.dart';

void main() {
  testWidgets('MaterialCheckboxRenderer applies mark slot (Decorate)',
      (tester) async {
    final renderer = MaterialCheckboxRenderer();
    const tokens = RCheckboxResolvedTokens(
      boxSize: 18,
      borderRadius: BorderRadius.all(Radius.circular(2)),
      borderWidth: 2,
      borderColor: Colors.black,
      activeColor: Colors.blue,
      inactiveColor: Colors.transparent,
      checkColor: Colors.white,
      indeterminateColor: Colors.white,
      disabledOpacity: 0.38,
      pressOverlayColor: Color(0x1F000000),
      pressOpacity: 1.0,
      minTapTargetSize: Size(48, 48),
      motion: RCheckboxMotionTokens(stateChangeDuration: Duration(milliseconds: 120)),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return renderer.render(
                RCheckboxRenderRequest(
                  context: context,
                  spec: const RCheckboxSpec(value: true),
                  state: const RCheckboxState(isSelected: true),
                  resolvedTokens: tokens,
                  slots: RCheckboxSlots(
                    mark: Decorate(
                      (ctx, child) => KeyedSubtree(
                        key: const ValueKey('mark-slot'),
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

    expect(find.byKey(const ValueKey('mark-slot')), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });
}

