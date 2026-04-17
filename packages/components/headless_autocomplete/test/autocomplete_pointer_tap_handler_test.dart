import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_autocomplete/src/presentation/autocomplete_pointer_tap_handler.dart';

void main() {
  group('AutocompletePointerTapHandler', () {
    testWidgets('ignores pointer up without matching down', (tester) async {
      final focusNode = FocusNode();
      var taps = 0;

      await tester.pumpWidget(
        _TestHarness(
          focusNode: focusNode,
          onTap: () => taps++,
        ),
      );

      final center = tester.getCenter(find.byKey(_fieldKey));
      tester.binding.handlePointerEvent(
        PointerHoverEvent(
          pointer: 1,
          kind: PointerDeviceKind.mouse,
          position: center,
        ),
      );
      tester.binding.handlePointerEvent(
        PointerUpEvent(
          pointer: 1,
          kind: PointerDeviceKind.mouse,
          position: center,
        ),
      );
      await tester.pump();

      expect(taps, 0);
      focusNode.dispose();
    });

    testWidgets('fires tap after matching down and up', (tester) async {
      final focusNode = FocusNode();
      var taps = 0;

      await tester.pumpWidget(
        _TestHarness(
          focusNode: focusNode,
          onTap: () => taps++,
        ),
      );

      final center = tester.getCenter(find.byKey(_fieldKey));
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: center);
      await gesture.down(center);
      await tester.pump();
      await gesture.up();
      await tester.pump();

      expect(taps, 1);
      expect(focusNode.hasFocus, isTrue);
      focusNode.dispose();
    });
  });
}

const _fieldKey = Key('autocomplete-pointer-field');

class _TestHarness extends StatelessWidget {
  const _TestHarness({
    required this.focusNode,
    required this.onTap,
  });

  final FocusNode focusNode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            key: _fieldKey,
            width: 160,
            height: 48,
            child: Focus(
              focusNode: focusNode,
              child: AutocompletePointerTapHandler(
                focusNode: focusNode,
                onTap: onTap,
                child: const ColoredBox(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
