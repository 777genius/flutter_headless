import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_cupertino/headless_cupertino.dart';
import 'package:headless_theme/headless_theme.dart';

void main() {
  group('CupertinoTapTargetPolicy', () {
    testWidgets('returns Size(44, 44) for button', (tester) async {
      const policy = CupertinoTapTargetPolicy();
      Size? result;

      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              result = policy.minTapTargetSize(
                context: context,
                component: HeadlessTapTargetComponent.button,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(result, const Size(44, 44));
    });
  });
}
