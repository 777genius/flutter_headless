import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_cupertino/headless_cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';

void main() {
  group('CupertinoTextFieldTokenResolver', () {
    testWidgets('resolves light mode colors correctly', (tester) async {
      late RTextFieldResolvedTokens tokens;

      await tester.pumpWidget(
        CupertinoApp(
          theme: const CupertinoThemeData(brightness: Brightness.light),
          home: Builder(
            builder: (context) {
              final resolver = CupertinoTextFieldTokenResolver(
                brightness: Brightness.light,
              );
              tokens = resolver.resolve(
                context: context,
                spec: const RTextFieldSpec(),
                states: {},
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(tokens.containerBackgroundColor, CupertinoColors.white);
      expect(tokens.textColor, CupertinoColors.black);
    });

    testWidgets('resolves dark mode colors correctly', (tester) async {
      late RTextFieldResolvedTokens tokens;

      await tester.pumpWidget(
        CupertinoApp(
          theme: const CupertinoThemeData(brightness: Brightness.dark),
          home: Builder(
            builder: (context) {
              final resolver = CupertinoTextFieldTokenResolver(
                brightness: Brightness.dark,
              );
              tokens = resolver.resolve(
                context: context,
                spec: const RTextFieldSpec(),
                states: {},
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(tokens.containerBackgroundColor, CupertinoColors.darkBackgroundGray);
      expect(tokens.textColor, CupertinoColors.white);
    });

    testWidgets('focused state changes border color to primary', (tester) async {
      late RTextFieldResolvedTokens unfocusedTokens;
      late RTextFieldResolvedTokens focusedTokens;

      await tester.pumpWidget(
        CupertinoApp(
          theme: const CupertinoThemeData(brightness: Brightness.light),
          home: Builder(
            builder: (context) {
              final resolver = CupertinoTextFieldTokenResolver();
              unfocusedTokens = resolver.resolve(
                context: context,
                spec: const RTextFieldSpec(),
                states: {},
              );
              focusedTokens = resolver.resolve(
                context: context,
                spec: const RTextFieldSpec(),
                states: {WidgetState.focused},
              );
              return const SizedBox();
            },
          ),
        ),
      );

      // Unfocused should have gray border
      expect(
        unfocusedTokens.containerBorderColor,
        const Color(0xFFC6C6C8),
      );

      // Focused should have blue border
      expect(
        focusedTokens.containerBorderColor,
        CupertinoColors.activeBlue,
      );
    });

    testWidgets('error state changes border color to red', (tester) async {
      late RTextFieldResolvedTokens tokens;

      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final resolver = CupertinoTextFieldTokenResolver();
              tokens = resolver.resolve(
                context: context,
                spec: const RTextFieldSpec(),
                states: {WidgetState.error},
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(tokens.containerBorderColor, CupertinoColors.systemRed);
    });

    testWidgets('borderless mode sets transparent border', (tester) async {
      late RTextFieldResolvedTokens tokens;

      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final resolver = CupertinoTextFieldTokenResolver();
              tokens = resolver.resolve(
                context: context,
                spec: const RTextFieldSpec(),
                states: {},
                overrides: RenderOverrides({
                  CupertinoTextFieldOverrides:
                      const CupertinoTextFieldOverrides(isBorderless: true),
                }),
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(tokens.containerBorderColor, CupertinoColors.transparent);
    });

    testWidgets('custom padding from overrides', (tester) async {
      late RTextFieldResolvedTokens tokens;

      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final resolver = CupertinoTextFieldTokenResolver();
              tokens = resolver.resolve(
                context: context,
                spec: const RTextFieldSpec(),
                states: {},
                overrides: RenderOverrides({
                  CupertinoTextFieldOverrides:
                      const CupertinoTextFieldOverrides(
                    padding: EdgeInsets.all(16),
                  ),
                }),
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(tokens.containerPadding, const EdgeInsets.all(16));
    });

    testWidgets('default padding is 7', (tester) async {
      late RTextFieldResolvedTokens tokens;

      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final resolver = CupertinoTextFieldTokenResolver();
              tokens = resolver.resolve(
                context: context,
                spec: const RTextFieldSpec(),
                states: {},
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(tokens.containerPadding, const EdgeInsets.all(7.0));
    });

    testWidgets('default border radius is 5', (tester) async {
      late RTextFieldResolvedTokens tokens;

      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final resolver = CupertinoTextFieldTokenResolver();
              tokens = resolver.resolve(
                context: context,
                spec: const RTextFieldSpec(),
                states: {},
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(
        tokens.containerBorderRadius,
        const BorderRadius.all(Radius.circular(5.0)),
      );
    });
  });
}
