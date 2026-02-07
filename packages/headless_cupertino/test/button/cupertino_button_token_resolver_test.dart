import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_cupertino/headless_cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';

void main() {
  group('CupertinoButtonTokenResolver', () {
    late CupertinoButtonTokenResolver resolver;

    setUp(() {
      resolver = const CupertinoButtonTokenResolver();
    });

    testWidgets('resolves tokens for filled variant', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final tokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(variant: RButtonVariant.filled),
                states: {},
              );

              // Filled uses active blue background.
              expect(tokens.backgroundColor, isNot(CupertinoColors.transparent));
              expect(tokens.borderColor, CupertinoColors.transparent);
              expect(tokens.padding, isNotNull);
              expect(tokens.borderRadius, isNotNull);
              // Minimum visual size (tap target is handled by component policy)
              expect(tokens.minSize, const Size(32, 32));

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('resolves tokens for tonal variant', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final tokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(variant: RButtonVariant.tonal),
                states: {},
              );

              // Tonal uses translucent primary background (alpha < 1.0).
              expect(tokens.backgroundColor, isNot(CupertinoColors.transparent));
              expect(tokens.backgroundColor.a, lessThan(1.0));
              expect(tokens.borderColor, CupertinoColors.transparent);
              expect(tokens.foregroundColor, isNot(CupertinoColors.white));

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('resolves tokens for text variant', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final tokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(variant: RButtonVariant.text),
                states: {},
              );

              // Text uses transparent bg, transparent border, primary foreground.
              expect(tokens.backgroundColor, CupertinoColors.transparent);
              expect(tokens.borderColor, CupertinoColors.transparent);
              expect(tokens.foregroundColor, isNot(CupertinoColors.transparent));

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('resolves tokens for outlined variant', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final tokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(variant: RButtonVariant.outlined),
                states: {},
              );

              // Outlined uses transparent bg + non-transparent border.
              expect(tokens.backgroundColor, CupertinoColors.transparent);
              expect(tokens.borderColor, isNot(CupertinoColors.transparent));

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('applies disabled state modifiers', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final normalTokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(variant: RButtonVariant.filled),
                states: {},
              );

              final disabledTokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(variant: RButtonVariant.filled),
                states: {WidgetState.disabled},
              );

              // Disabled should have different foreground color (gray instead of white)
              // CupertinoColors.inactiveGray for disabled vs CupertinoColors.white for normal
              expect(
                disabledTokens.foregroundColor,
                isNot(normalTokens.foregroundColor),
              );

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('respects light brightness', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final lightResolver = const CupertinoButtonTokenResolver(
                brightness: Brightness.light,
              );

              final tokens = lightResolver.resolve(
                context: context,
                spec: const RButtonSpec(variant: RButtonVariant.outlined),
                states: {},
              );

              // Light mode should have dark foreground
              expect(tokens.foregroundColor, CupertinoColors.activeBlue);

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('respects dark brightness', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          theme: const CupertinoThemeData(brightness: Brightness.dark),
          home: Builder(
            builder: (context) {
              final darkResolver = const CupertinoButtonTokenResolver(
                brightness: Brightness.dark,
              );

              final tokens = darkResolver.resolve(
                context: context,
                spec: const RButtonSpec(variant: RButtonVariant.outlined),
                states: {},
              );

              // Dark mode should have blue foreground
              expect(tokens.foregroundColor, CupertinoColors.activeBlue);

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('cupertino overrides win over contract overrides', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final tokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(size: RButtonSize.medium),
                states: {},
                overrides: RenderOverrides({
                  RButtonOverrides: const RButtonOverrides.tokens(
                    padding: EdgeInsets.all(1),
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                  CupertinoButtonOverrides: const CupertinoButtonOverrides(
                    density: CupertinoComponentDensity.comfortable,
                    cornerStyle: CupertinoCornerStyle.pill,
                  ),
                }),
              );

              expect(
                tokens.padding,
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              );
              expect(
                tokens.borderRadius,
                const BorderRadius.all(Radius.circular(999)),
              );

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('resolves different sizes', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final smallTokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(size: RButtonSize.small),
                states: {},
              );

              final largeTokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(size: RButtonSize.large),
                states: {},
              );

              // Large should have bigger text
              expect(
                largeTokens.textStyle.fontSize,
                greaterThan(smallTokens.textStyle.fontSize ?? 0),
              );

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('applies per-instance overrides (priority 1)', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              const overrideColor = CupertinoColors.systemRed;
              final tokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(variant: RButtonVariant.filled),
                states: {},
                overrides: RenderOverrides({
                  RButtonOverrides: RButtonOverrides.tokens(
                    backgroundColor: overrideColor,
                  ),
                }),
              );

              // Override should win
              expect(tokens.backgroundColor, overrideColor);

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('respects constraints for minSize', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final tokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(),
                states: {},
                constraints: const BoxConstraints(minWidth: 100, minHeight: 60),
              );

              expect(tokens.minSize, const Size(100, 60));

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('deterministic: same inputs produce same outputs',
        (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              const spec = RButtonSpec(variant: RButtonVariant.filled);
              final states = {WidgetState.hovered};

              final tokens1 = resolver.resolve(
                context: context,
                spec: spec,
                states: states,
              );

              final tokens2 = resolver.resolve(
                context: context,
                spec: spec,
                states: states,
              );

              expect(tokens1, equals(tokens2));

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });
  });
}
