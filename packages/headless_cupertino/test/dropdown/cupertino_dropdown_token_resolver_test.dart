import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_cupertino/headless_cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';

void main() {
  group('CupertinoDropdownTokenResolver', () {
    late CupertinoDropdownTokenResolver resolver;

    setUp(() {
      resolver = const CupertinoDropdownTokenResolver();
    });

    testWidgets('resolves trigger tokens', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final tokens = resolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(),
                triggerStates: {},
                overlayPhase: ROverlayPhase.closed,
              );

              // iOS-style defaults
              expect(tokens.trigger.padding, isNotNull);
              expect(tokens.trigger.borderRadius, isNotNull);
              expect(tokens.trigger.minSize, const Size(44, 44));

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('resolves menu tokens', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final tokens = resolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(),
                triggerStates: {},
                overlayPhase: ROverlayPhase.open,
              );

              // iOS uses shadow, not elevation
              expect(tokens.menu.elevation, 0);
              expect(tokens.menu.maxHeight, 300);
              // Larger border radius for iOS popover
              expect(
                tokens.menu.borderRadius.topLeft.x,
                14,
              );

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('resolves item tokens', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final tokens = resolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(),
                triggerStates: {},
                overlayPhase: ROverlayPhase.open,
              );

              // iOS minimum touch target
              expect(tokens.item.minHeight, 44);
              expect(tokens.item.foregroundColor, isNotNull);
              expect(tokens.item.disabledForegroundColor, isNotNull);
              expect(tokens.item.highlightBackgroundColor, isNotNull);
              expect(tokens.item.selectedMarkerColor, isNotNull);

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('applies focused state to trigger', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final normalTokens = resolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(),
                triggerStates: {},
                overlayPhase: ROverlayPhase.closed,
              );

              final focusedTokens = resolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(),
                triggerStates: {WidgetState.focused},
                overlayPhase: ROverlayPhase.closed,
              );

              // Focused should have activeBlue border
              expect(
                focusedTokens.trigger.borderColor,
                isNot(normalTokens.trigger.borderColor),
              );

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('applies disabled state to trigger', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final normalTokens = resolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(),
                triggerStates: {},
                overlayPhase: ROverlayPhase.closed,
              );

              final disabledTokens = resolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(),
                triggerStates: {WidgetState.disabled},
                overlayPhase: ROverlayPhase.closed,
              );

              // Disabled should have inactive gray foreground
              expect(
                disabledTokens.trigger.foregroundColor,
                isNot(normalTokens.trigger.foregroundColor),
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
              final lightResolver = const CupertinoDropdownTokenResolver(
                brightness: Brightness.light,
              );

              final tokens = lightResolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(),
                triggerStates: {},
                overlayPhase: ROverlayPhase.closed,
              );

              // Light mode should have white background
              expect(tokens.menu.backgroundColor, CupertinoColors.white);
              expect(tokens.menu.backgroundOpacity, 0.85);

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
              final darkResolver = const CupertinoDropdownTokenResolver(
                brightness: Brightness.dark,
              );

              final tokens = darkResolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(),
                triggerStates: {},
                overlayPhase: ROverlayPhase.closed,
              );

              // Dark mode should use system background
              expect(
                tokens.menu.backgroundColor,
                CupertinoColors.tertiarySystemBackground,
              );
              expect(tokens.menu.backgroundOpacity, 0.85);

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('cupertino overrides win over contract overrides',
        (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final tokens = resolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(),
                triggerStates: {},
                overlayPhase: ROverlayPhase.closed,
                overrides: RenderOverrides({
                  RDropdownOverrides: const RDropdownOverrides.tokens(
                    triggerPadding: EdgeInsets.all(1),
                    triggerBorderRadius: BorderRadius.all(Radius.circular(20)),
                    itemMinHeight: 100,
                  ),
                  CupertinoDropdownOverrides: const CupertinoDropdownOverrides(
                    density: CupertinoComponentDensity.compact,
                    cornerStyle: CupertinoCornerStyle.sharp,
                  ),
                }),
              );

              expect(
                tokens.trigger.padding,
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              );
              expect(
                tokens.trigger.borderRadius,
                const BorderRadius.all(Radius.circular(4)),
              );
              expect(tokens.item.minHeight, 40);

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('applies per-instance overrides', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              const overrideColor = CupertinoColors.systemRed;
              final tokens = resolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(),
                triggerStates: {},
                overlayPhase: ROverlayPhase.closed,
                overrides: RenderOverrides({
                  RDropdownOverrides: RDropdownOverrides.tokens(
                    triggerBackgroundColor: overrideColor,
                    menuMaxHeight: 500,
                  ),
                }),
              );

              expect(tokens.trigger.backgroundColor, overrideColor);
              expect(tokens.menu.maxHeight, 500);

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
              const spec = RDropdownButtonSpec();
              const states = <WidgetState>{WidgetState.focused};
              const phase = ROverlayPhase.open;

              final tokens1 = resolver.resolve(
                context: context,
                spec: spec,
                triggerStates: states,
                overlayPhase: phase,
              );

              final tokens2 = resolver.resolve(
                context: context,
                spec: spec,
                triggerStates: states,
                overlayPhase: phase,
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
