import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_material/headless_material.dart';
import 'package:headless_theme/headless_theme.dart';

final class _EmptyTheme extends HeadlessTheme {
  const _EmptyTheme();

  @override
  T? capability<T>() => null;
}

void main() {
  group('Strict tokens policy (preset)', () {
    testWidgets(
      'MaterialFlutterParityButtonRenderer does NOT throw with requireResolvedTokens: true and resolvedTokens: null',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: HeadlessThemeProvider(
              theme: const _EmptyTheme(),
              child: HeadlessThemeOverridesScope.only<HeadlessRendererPolicy>(
                capability: const HeadlessRendererPolicy(requireResolvedTokens: true),
                child: Builder(
                  builder: (context) {
                    return const MaterialFlutterParityButtonRenderer().render(
                      RButtonRenderRequest(
                        context: context,
                        spec: const RButtonSpec(),
                        state: const RButtonState(),
                        content: const Text('Tap'),
                        resolvedTokens: null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.text('Tap'), findsOneWidget);
      },
    );
  });
}

