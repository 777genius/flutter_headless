@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'helpers/parity_test_harness.dart';

/// Golden parity tests: MaterialTextFieldRenderer vs Flutter TextField.
///
/// Each test renders the renderer output (left) and a native Flutter TextField
/// (right) side by side with identical configuration, then captures a golden.
///
/// Update goldens with:
/// ```bash
/// cd packages/headless_material && flutter test --update-goldens
/// ```
void main() {
  group('Golden parity: filled variant', () {
    testWidgets('empty, unfocused', (tester) async {
      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.filled,
              label: 'Label',
              placeholder: 'Placeholder',
            ),
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.filled,
            label: 'Label',
            placeholder: 'Placeholder',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/filled_empty_unfocused.png'),
      );
    });

    testWidgets('empty, focused', (tester) async {
      final nativeFocusNode = FocusNode();
      final rendererFocusNode = FocusNode();

      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.filled,
              label: 'Label',
              placeholder: 'Placeholder',
            ),
            state: const RTextFieldState(isFocused: true),
            focusNode: rendererFocusNode,
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.filled,
            label: 'Label',
            placeholder: 'Placeholder',
            focusNode: nativeFocusNode,
          ),
        ),
      );

      rendererFocusNode.requestFocus();
      nativeFocusNode.requestFocus();
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/filled_empty_focused.png'),
      );

      rendererFocusNode.dispose();
      nativeFocusNode.dispose();
    });

    testWidgets('hasText, unfocused', (tester) async {
      final rendererController = TextEditingController(text: 'Hello');
      final nativeController = TextEditingController(text: 'Hello');

      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.filled,
              label: 'Label',
            ),
            state: const RTextFieldState(hasText: true),
            controller: rendererController,
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.filled,
            label: 'Label',
            controller: nativeController,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/filled_hastext_unfocused.png'),
      );

      rendererController.dispose();
      nativeController.dispose();
    });

    testWidgets('error state', (tester) async {
      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.filled,
              label: 'Label',
              errorText: 'Required field',
            ),
            state: const RTextFieldState(isError: true),
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.filled,
            label: 'Label',
            errorText: 'Required field',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/filled_error.png'),
      );
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.filled,
              label: 'Label',
            ),
            state: const RTextFieldState(isDisabled: true),
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.filled,
            label: 'Label',
            enabled: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/filled_disabled.png'),
      );
    });
  });

  group('Golden parity: outlined variant', () {
    testWidgets('empty, focused', (tester) async {
      final nativeFocusNode = FocusNode();
      final rendererFocusNode = FocusNode();

      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.outlined,
              label: 'Label',
              placeholder: 'Placeholder',
            ),
            state: const RTextFieldState(isFocused: true),
            focusNode: rendererFocusNode,
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.outlined,
            label: 'Label',
            placeholder: 'Placeholder',
            focusNode: nativeFocusNode,
          ),
        ),
      );

      rendererFocusNode.requestFocus();
      nativeFocusNode.requestFocus();
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/outlined_empty_focused.png'),
      );

      rendererFocusNode.dispose();
      nativeFocusNode.dispose();
    });

    testWidgets('hasText, unfocused', (tester) async {
      final rendererController = TextEditingController(text: 'Hello');
      final nativeController = TextEditingController(text: 'Hello');

      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.outlined,
              label: 'Label',
            ),
            state: const RTextFieldState(hasText: true),
            controller: rendererController,
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.outlined,
            label: 'Label',
            controller: nativeController,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/outlined_hastext_unfocused.png'),
      );

      rendererController.dispose();
      nativeController.dispose();
    });

    testWidgets('hasText, focused', (tester) async {
      final rendererController = TextEditingController(text: 'Hello');
      final nativeController = TextEditingController(text: 'Hello');
      final nativeFocusNode = FocusNode();
      final rendererFocusNode = FocusNode();

      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.outlined,
              label: 'Label',
            ),
            state: const RTextFieldState(
              hasText: true,
              isFocused: true,
            ),
            controller: rendererController,
            focusNode: rendererFocusNode,
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.outlined,
            label: 'Label',
            controller: nativeController,
            focusNode: nativeFocusNode,
          ),
        ),
      );

      rendererFocusNode.requestFocus();
      nativeFocusNode.requestFocus();
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/outlined_hastext_focused.png'),
      );

      rendererController.dispose();
      nativeController.dispose();
      rendererFocusNode.dispose();
      nativeFocusNode.dispose();
    });

    testWidgets('empty, unfocused', (tester) async {
      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.outlined,
              label: 'Label',
              placeholder: 'Placeholder',
            ),
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.outlined,
            label: 'Label',
            placeholder: 'Placeholder',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/outlined_empty_unfocused.png'),
      );
    });

    testWidgets('error state', (tester) async {
      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.outlined,
              label: 'Label',
              errorText: 'Invalid input',
            ),
            state: const RTextFieldState(isError: true),
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.outlined,
            label: 'Label',
            errorText: 'Invalid input',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/outlined_error.png'),
      );
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.outlined,
              label: 'Label',
            ),
            state: const RTextFieldState(isDisabled: true),
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.outlined,
            label: 'Label',
            enabled: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/outlined_disabled.png'),
      );
    });
  });

  group('Golden parity: underlined variant', () {
    testWidgets('empty, focused', (tester) async {
      final nativeFocusNode = FocusNode();
      final rendererFocusNode = FocusNode();

      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.underlined,
              label: 'Label',
              placeholder: 'Placeholder',
            ),
            state: const RTextFieldState(isFocused: true),
            focusNode: rendererFocusNode,
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.underlined,
            label: 'Label',
            placeholder: 'Placeholder',
            focusNode: nativeFocusNode,
          ),
        ),
      );

      rendererFocusNode.requestFocus();
      nativeFocusNode.requestFocus();
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/underlined_empty_focused.png'),
      );

      rendererFocusNode.dispose();
      nativeFocusNode.dispose();
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.underlined,
              label: 'Label',
            ),
            state: const RTextFieldState(isDisabled: true),
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.underlined,
            label: 'Label',
            enabled: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/underlined_disabled.png'),
      );
    });

    testWidgets('hasText, unfocused', (tester) async {
      final rendererController = TextEditingController(text: 'Hello');
      final nativeController = TextEditingController(text: 'Hello');

      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.underlined,
              label: 'Label',
            ),
            state: const RTextFieldState(hasText: true),
            controller: rendererController,
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.underlined,
            label: 'Label',
            controller: nativeController,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/underlined_hastext_unfocused.png'),
      );

      rendererController.dispose();
      nativeController.dispose();
    });

    testWidgets('empty, unfocused', (tester) async {
      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.underlined,
              label: 'Label',
              placeholder: 'Placeholder',
            ),
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.underlined,
            label: 'Label',
            placeholder: 'Placeholder',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/underlined_empty_unfocused.png'),
      );
    });

    testWidgets('error state', (tester) async {
      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.underlined,
              label: 'Label',
              errorText: 'Error',
            ),
            state: const RTextFieldState(isError: true),
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.underlined,
            label: 'Label',
            errorText: 'Error',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/underlined_error.png'),
      );
    });
  });

  group('Golden parity: slots', () {
    testWidgets('prefixIcon and suffixIcon', (tester) async {
      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.outlined,
              label: 'Search',
            ),
            slots: const RTextFieldSlots(
              leading: Icon(Icons.search),
              trailing: Icon(Icons.clear),
            ),
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.outlined,
            label: 'Search',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: const Icon(Icons.clear),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/slots_prefix_suffix_icon.png'),
      );
    });

    testWidgets('prefix and suffix widgets', (tester) async {
      final nativeFocusNode = FocusNode();
      final rendererFocusNode = FocusNode();

      await tester.pumpWidget(
        buildParityHarness(
          rendererBuilder: (context) => buildRendererField(
            context,
            spec: const RTextFieldSpec(
              variant: RTextFieldVariant.outlined,
              label: 'Amount',
            ),
            state: const RTextFieldState(isFocused: true),
            slots: const RTextFieldSlots(
              prefix: Text('\$ '),
              suffix: Text('.00'),
            ),
            focusNode: rendererFocusNode,
          ),
          nativeField: buildNativeTextField(
            variant: RTextFieldVariant.outlined,
            label: 'Amount',
            prefix: const Text('\$ '),
            suffix: const Text('.00'),
            focusNode: nativeFocusNode,
          ),
        ),
      );

      rendererFocusNode.requestFocus();
      nativeFocusNode.requestFocus();
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/slots_prefix_suffix_widget.png'),
      );

      rendererFocusNode.dispose();
      nativeFocusNode.dispose();
    });
  });
}
