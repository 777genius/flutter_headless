@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_material/textfield.dart';

/// Motion evidence tests: InputDecorator label animation progress.
///
/// InputDecorator uses `_kTransitionDuration = 167ms` for label float
/// and border transitions. These tests verify the animation is in progress
/// at intermediate frames and complete at 167ms.
void main() {
  const renderer = MaterialTextFieldRenderer();
  Widget buildAnimatedField({
    required RTextFieldState state,
    RTextFieldVariant variant = RTextFieldVariant.filled,
    String label = 'Animated Label',
    String? placeholder,
    String? helperText,
    String? errorText,
  }) {
    final controller = TextEditingController();
    final focusNode = FocusNode();

    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: Builder(
          builder: (context) {
            final style = Theme.of(context).textTheme.bodyLarge ??
                const TextStyle(fontSize: 16);

            return renderer.render(
              RTextFieldRenderRequest(
                context: context,
                input: EditableText(
                  controller: controller,
                  focusNode: focusNode,
                  style: style,
                  cursorColor: Theme.of(context).colorScheme.primary,
                  backgroundCursorColor:
                      Theme.of(context).colorScheme.onSurface,
                  showCursor: false,
                ),
                spec: RTextFieldSpec(
                  variant: variant,
                  label: label,
                  placeholder: placeholder,
                  helperText: helperText,
                  errorText: errorText,
                ),
                state: state,
              ),
            );
          },
        ),
      ),
    );
  }

  group('Golden motion evidence: filled', () {
    testWidgets('3 snapshots prove animation progression', (tester) async {
      await tester.pumpWidget(
        buildAnimatedField(state: const RTextFieldState()),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/motion_t0_unfocused.png'),
      );

      await tester.pumpWidget(
        buildAnimatedField(
          state: const RTextFieldState(isFocused: true),
        ),
      );

      await tester.pump(const Duration(milliseconds: 83));
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/motion_t83_mid.png'),
      );

      await tester.pump(const Duration(milliseconds: 84));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/motion_t167_focused.png'),
      );
    });
  });

  group('Golden motion evidence: outlined', () {
    testWidgets('3 snapshots prove animation progression', (tester) async {
      await tester.pumpWidget(
        buildAnimatedField(
          state: const RTextFieldState(),
          variant: RTextFieldVariant.outlined,
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/motion_outlined_t0_unfocused.png'),
      );

      await tester.pumpWidget(
        buildAnimatedField(
          state: const RTextFieldState(isFocused: true),
          variant: RTextFieldVariant.outlined,
        ),
      );

      await tester.pump(const Duration(milliseconds: 83));
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/motion_outlined_t83_mid.png'),
      );

      await tester.pump(const Duration(milliseconds: 84));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/motion_outlined_t167_focused.png'),
      );
    });
  });

  group('Golden motion evidence: underlined', () {
    testWidgets('3 snapshots prove animation progression', (tester) async {
      await tester.pumpWidget(
        buildAnimatedField(
          state: const RTextFieldState(),
          variant: RTextFieldVariant.underlined,
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/motion_underlined_t0_unfocused.png'),
      );

      await tester.pumpWidget(
        buildAnimatedField(
          state: const RTextFieldState(isFocused: true),
          variant: RTextFieldVariant.underlined,
        ),
      );

      await tester.pump(const Duration(milliseconds: 83));
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/motion_underlined_t83_mid.png'),
      );

      await tester.pump(const Duration(milliseconds: 84));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/motion_underlined_t167_focused.png'),
      );
    });
  });

  group('Golden motion evidence: helper→error transition', () {
    testWidgets('3 snapshots prove helper→error transition', (tester) async {
      await tester.pumpWidget(
        buildAnimatedField(
          state: const RTextFieldState(),
          helperText: 'Help text',
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/motion_helper_t0.png'),
      );

      await tester.pumpWidget(
        buildAnimatedField(
          state: const RTextFieldState(isError: true),
          errorText: 'Error text',
        ),
      );
      await tester.pump(const Duration(milliseconds: 83));
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/motion_helper_error_t83_mid.png'),
      );

      await tester.pump(const Duration(milliseconds: 84));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/motion_error_t167.png'),
      );
    });
  });

  group('Golden motion evidence: outlined with placeholder', () {
    testWidgets('3 snapshots prove outline gap animation', (tester) async {
      await tester.pumpWidget(
        buildAnimatedField(
          state: const RTextFieldState(),
          variant: RTextFieldVariant.outlined,
          label: 'Label',
          placeholder: 'Placeholder',
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/motion_outlined_placeholder_t0.png'),
      );

      await tester.pumpWidget(
        buildAnimatedField(
          state: const RTextFieldState(isFocused: true),
          variant: RTextFieldVariant.outlined,
          label: 'Label',
          placeholder: 'Placeholder',
        ),
      );

      await tester.pump(const Duration(milliseconds: 83));
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/motion_outlined_placeholder_t83_mid.png'),
      );

      await tester.pump(const Duration(milliseconds: 84));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile(
          'goldens/motion_outlined_placeholder_t167_focused.png',
        ),
      );
    });
  });

  group('Label float animation', () {
    testWidgets('animation duration matches InputDecorator 167ms',
        (tester) async {
      await tester.pumpWidget(
        buildAnimatedField(state: const RTextFieldState()),
      );
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        buildAnimatedField(
          state: const RTextFieldState(isFocused: true),
        ),
      );

      await tester.pump(const Duration(milliseconds: 166));
      await tester.pump(const Duration(milliseconds: 1));

      final framesAfterDuration = await tester.pumpAndSettle(
        const Duration(milliseconds: 1),
      );
      expect(framesAfterDuration, lessThanOrEqualTo(2));
    });
  });
}
