@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'helpers/parity_test_harness.dart';

/// Extended parity tests: helperText, error+focused, multiline, affix
/// visibility, hover.
///
/// Update goldens with:
/// ```bash
/// cd packages/headless_material && flutter test --update-goldens
/// ```
void main() {
  group('Golden parity: helperText', () {
    testWidgets('filled + helperText', (tester) async {
      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.filled,
              label: 'Label',
              helperText: 'Helper text',
            ),
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.filled,
            label: 'Label',
            helperText: 'Helper text',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/filled_helper.png'),
      );
    });

    testWidgets('outlined + helperText', (tester) async {
      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.outlined,
              label: 'Label',
              helperText: 'Helper text',
            ),
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.outlined,
            label: 'Label',
            helperText: 'Helper text',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/outlined_helper.png'),
      );
    });

    testWidgets('underlined + helperText', (tester) async {
      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.underlined,
              label: 'Label',
              helperText: 'Helper text',
            ),
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.underlined,
            label: 'Label',
            helperText: 'Helper text',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/underlined_helper.png'),
      );
    });
  });

  group('Golden parity: error + focused', () {
    testWidgets('filled error focused', (tester) async {
      final nativeFocusNode = FocusNode();
      final rendererFocusNode = FocusNode();

      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.filled,
              label: 'Label',
              errorText: 'Required field',
            ),
            state: const RTextFieldState(
              isError: true,
              isFocused: true,
            ),
            focusNode: rendererFocusNode,
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.filled,
            label: 'Label',
            errorText: 'Required field',
            focusNode: nativeFocusNode,
          ),
        ),
      );

      rendererFocusNode.requestFocus();
      nativeFocusNode.requestFocus();
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/filled_error_focused.png'),
      );

      rendererFocusNode.dispose();
      nativeFocusNode.dispose();
    });

    testWidgets('outlined error focused', (tester) async {
      final nativeFocusNode = FocusNode();
      final rendererFocusNode = FocusNode();

      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.outlined,
              label: 'Label',
              errorText: 'Invalid input',
            ),
            state: const RTextFieldState(
              isError: true,
              isFocused: true,
            ),
            focusNode: rendererFocusNode,
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.outlined,
            label: 'Label',
            errorText: 'Invalid input',
            focusNode: nativeFocusNode,
          ),
        ),
      );

      rendererFocusNode.requestFocus();
      nativeFocusNode.requestFocus();
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/outlined_error_focused.png'),
      );

      rendererFocusNode.dispose();
      nativeFocusNode.dispose();
    });

    testWidgets('underlined error focused', (tester) async {
      final nativeFocusNode = FocusNode();
      final rendererFocusNode = FocusNode();

      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.underlined,
              label: 'Label',
              errorText: 'Error',
            ),
            state: const RTextFieldState(
              isError: true,
              isFocused: true,
            ),
            focusNode: rendererFocusNode,
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.underlined,
            label: 'Label',
            errorText: 'Error',
            focusNode: nativeFocusNode,
          ),
        ),
      );

      rendererFocusNode.requestFocus();
      nativeFocusNode.requestFocus();
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/underlined_error_focused.png'),
      );

      rendererFocusNode.dispose();
      nativeFocusNode.dispose();
    });
  });

  group('Golden parity: multiline', () {
    testWidgets('filled, maxLines:3', (tester) async {
      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.filled,
              label: 'Description',
              maxLines: 3,
            ),
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.filled,
            label: 'Description',
            maxLines: 3,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/multiline_filled_maxlines3.png'),
      );
    });

    testWidgets('outlined, maxLines:3', (tester) async {
      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.outlined,
              label: 'Description',
              maxLines: 3,
            ),
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.outlined,
            label: 'Description',
            maxLines: 3,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/multiline_outlined_maxlines3.png'),
      );
    });

    testWidgets('underlined, maxLines:3', (tester) async {
      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.underlined,
              label: 'Description',
              maxLines: 3,
            ),
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.underlined,
            label: 'Description',
            maxLines: 3,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/multiline_underlined_maxlines3.png'),
      );
    });
  });

  group('Golden: affix visibility (renderer-only)', () {
    testWidgets('prefix whileEditing, focused', (tester) async {
      await tester.pumpWidget(
        buildRendererOnlyHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.outlined,
              label: 'Amount',
              prefixMode: RTextFieldOverlayVisibilityMode.whileEditing,
            ),
            state: const RTextFieldState(isFocused: true),
            slots: const RTextFieldSlots(
              prefix: Text('\$ '),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/prefix_whileediting_focused.png'),
      );
    });

    testWidgets('prefix whileEditing, unfocused', (tester) async {
      await tester.pumpWidget(
        buildRendererOnlyHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.outlined,
              label: 'Amount',
              prefixMode: RTextFieldOverlayVisibilityMode.whileEditing,
            ),
            state: const RTextFieldState(isFocused: false),
            slots: const RTextFieldSlots(
              prefix: Text('\$ '),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/prefix_whileediting_unfocused.png'),
      );
    });

    testWidgets('suffix whileEditing, focused', (tester) async {
      await tester.pumpWidget(
        buildRendererOnlyHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.outlined,
              label: 'Amount',
              suffixMode: RTextFieldOverlayVisibilityMode.whileEditing,
            ),
            state: const RTextFieldState(isFocused: true),
            slots: const RTextFieldSlots(
              suffix: Text('.00'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/suffix_whileediting_focused.png'),
      );
    });

    testWidgets('suffix whileEditing, unfocused', (tester) async {
      await tester.pumpWidget(
        buildRendererOnlyHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.outlined,
              label: 'Amount',
              suffixMode: RTextFieldOverlayVisibilityMode.whileEditing,
            ),
            state: const RTextFieldState(isFocused: false),
            slots: const RTextFieldSlots(
              suffix: Text('.00'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/suffix_whileediting_unfocused.png'),
      );
    });

    testWidgets('prefix notEditing, focused', (tester) async {
      await tester.pumpWidget(
        buildRendererOnlyHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.outlined,
              label: 'Amount',
              prefixMode: RTextFieldOverlayVisibilityMode.notEditing,
            ),
            state: const RTextFieldState(isFocused: true),
            slots: const RTextFieldSlots(
              prefix: Text('\$ '),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/prefix_notediting_focused.png'),
      );
    });

    testWidgets('prefix notEditing, unfocused', (tester) async {
      await tester.pumpWidget(
        buildRendererOnlyHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.outlined,
              label: 'Amount',
              prefixMode: RTextFieldOverlayVisibilityMode.notEditing,
            ),
            state: const RTextFieldState(isFocused: false),
            slots: const RTextFieldSlots(
              prefix: Text('\$ '),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/prefix_notediting_unfocused.png'),
      );
    });

    testWidgets('suffix notEditing, focused', (tester) async {
      await tester.pumpWidget(
        buildRendererOnlyHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.outlined,
              label: 'Amount',
              suffixMode: RTextFieldOverlayVisibilityMode.notEditing,
            ),
            state: const RTextFieldState(isFocused: true),
            slots: const RTextFieldSlots(
              suffix: Text('.00'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/suffix_notediting_focused.png'),
      );
    });

    testWidgets('suffix notEditing, unfocused', (tester) async {
      await tester.pumpWidget(
        buildRendererOnlyHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.outlined,
              label: 'Amount',
              suffixMode: RTextFieldOverlayVisibilityMode.notEditing,
            ),
            state: const RTextFieldState(isFocused: false),
            slots: const RTextFieldSlots(
              suffix: Text('.00'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/suffix_notediting_unfocused.png'),
      );
    });
  });

  group('Golden parity: hover (renderer-only)', () {
    testWidgets('filled, hovered, unfocused', (tester) async {
      await tester.pumpWidget(
        buildRendererOnlyHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.filled,
              label: 'Label',
              placeholder: 'Placeholder',
            ),
            state: const RTextFieldState(isHovered: true),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/filled_hovered_unfocused.png'),
      );
    });

    testWidgets('filled, hovered, focused', (tester) async {
      final rendererFocusNode = FocusNode();

      await tester.pumpWidget(
        buildRendererOnlyHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.filled,
              label: 'Label',
              placeholder: 'Placeholder',
            ),
            state: const RTextFieldState(
              isHovered: true,
              isFocused: true,
            ),
            focusNode: rendererFocusNode,
          ),
        ),
      );

      rendererFocusNode.requestFocus();
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/filled_hovered_focused.png'),
      );

      rendererFocusNode.dispose();
    });
  });
}
