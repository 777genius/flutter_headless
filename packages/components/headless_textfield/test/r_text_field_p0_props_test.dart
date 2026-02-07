import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_textfield/headless_textfield.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

class _TestTextFieldTokenResolver implements RTextFieldTokenResolver {
  @override
  RTextFieldResolvedTokens resolve({
    required BuildContext context,
    required RTextFieldSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    return RTextFieldResolvedTokens(
      containerPadding: const EdgeInsets.all(12),
      containerBackgroundColor: const Color(0xFFFFFFFF),
      containerBorderColor: const Color(0xFF000000),
      containerBorderRadius: const BorderRadius.all(Radius.circular(4)),
      containerBorderWidth: 1.0,
      containerElevation: 0.0,
      containerAnimationDuration: const Duration(milliseconds: 200),
      labelStyle: const TextStyle(fontSize: 12),
      labelColor: const Color(0xFF666666),
      helperStyle: const TextStyle(fontSize: 12),
      helperColor: const Color(0xFF666666),
      errorStyle: const TextStyle(fontSize: 12),
      errorColor: const Color(0xFFFF0000),
      messageSpacing: 4.0,
      textStyle: const TextStyle(fontSize: 16),
      textColor: const Color(0xFF000000),
      placeholderStyle: const TextStyle(fontSize: 16),
      placeholderColor: const Color(0xFF999999),
      cursorColor: const Color(0xFF0000FF),
      selectionColor: const Color(0x330000FF),
      disabledOpacity: 0.38,
      iconColor: const Color(0xFF666666),
      iconSpacing: 12.0,
      minSize: const Size(200, 48),
    );
  }
}

class _TestTextFieldRenderer implements RTextFieldRenderer {
  RTextFieldRenderRequest? lastRequest;
  int renderCount = 0;

  @override
  Widget render(RTextFieldRenderRequest request) {
    lastRequest = request;
    renderCount++;

    return GestureDetector(
      onTap: request.commands?.tapContainer,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: request.state.isFocused
              ? const Color(0xFFEEEEFF)
              : const Color(0xFFFFFFFF),
          border: Border.all(
            color: const Color(0xFFCCCCCC),
          ),
        ),
        child: request.input,
      ),
    );
  }
}

class _TestTheme extends HeadlessTheme {
  _TestTheme(this._renderer, {this.tokenResolver});

  final _TestTextFieldRenderer _renderer;
  final _TestTextFieldTokenResolver? tokenResolver;

  @override
  T? capability<T>() {
    if (T == RTextFieldRenderer) return _renderer as T;
    if (T == RTextFieldTokenResolver) return tokenResolver as T?;
    return null;
  }
}

Widget _buildTestWidget({
  required _TestTextFieldRenderer renderer,
  required Widget child,
  _TestTextFieldTokenResolver? tokenResolver,
}) {
  return MaterialApp(
    home: HeadlessThemeProvider(
      theme: _TestTheme(renderer, tokenResolver: tokenResolver),
      child: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  group('clearText command', () {
    testWidgets('clears text and calls onChanged with empty string',
        (tester) async {
      final renderer = _TestTextFieldRenderer();
      String? lastChangedValue;

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          value: 'Hello World',
          onChanged: (v) => lastChangedValue = v,
        ),
      ));

      expect(renderer.lastRequest?.state.hasText, isTrue);

      // Invoke clearText command
      renderer.lastRequest?.commands?.clearText?.call();
      await tester.pump();

      expect(lastChangedValue, '');
      expect(renderer.lastRequest?.state.hasText, isFalse);
    });

    testWidgets('keeps focus after clearing', (tester) async {
      final renderer = _TestTextFieldRenderer();
      final focusNode = FocusNode();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          value: 'Test',
          focusNode: focusNode,
          onChanged: (_) {},
        ),
      ));

      // Focus the field first
      focusNode.requestFocus();
      await tester.pumpAndSettle();
      expect(renderer.lastRequest?.state.isFocused, isTrue);

      // Clear text
      renderer.lastRequest?.commands?.clearText?.call();
      await tester.pump();

      // Focus should be preserved
      expect(renderer.lastRequest?.state.isFocused, isTrue);

      focusNode.dispose();
    });

    testWidgets('does nothing when disabled', (tester) async {
      final renderer = _TestTextFieldRenderer();
      String? lastChangedValue;
      final controller = TextEditingController(text: 'Initial');

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          controller: controller,
          enabled: false,
          onChanged: (v) => lastChangedValue = v,
        ),
      ));

      expect(renderer.lastRequest?.state.hasText, isTrue);

      // Try to clear - should be blocked
      renderer.lastRequest?.commands?.clearText?.call();
      await tester.pump();

      // Text should not change
      expect(controller.text, 'Initial');
      expect(lastChangedValue, isNull);

      controller.dispose();
    });

    testWidgets('resets selection to collapsed at start', (tester) async {
      final renderer = _TestTextFieldRenderer();
      final controller = TextEditingController(text: 'Hello World');

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          controller: controller,
          onChanged: (_) {},
        ),
      ));

      // Set some selection
      controller.selection =
          const TextSelection(baseOffset: 0, extentOffset: 5);
      await tester.pump();

      // Clear text
      renderer.lastRequest?.commands?.clearText?.call();
      await tester.pump();

      // Selection should be collapsed at 0
      expect(controller.selection.baseOffset, 0);
      expect(controller.selection.extentOffset, 0);
      expect(controller.selection.isCollapsed, isTrue);

      controller.dispose();
    });
  });

  group('maxLength', () {
    testWidgets('adds LengthLimitingTextInputFormatter when maxLength set',
        (tester) async {
      final renderer = _TestTextFieldRenderer();
      String? lastValue;

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          value: '',
          maxLength: 5,
          onChanged: (v) => lastValue = v,
        ),
      ));

      await tester.enterText(find.byType(EditableText), 'HelloWorld');
      await tester.pump();

      // Should be truncated to 5 characters
      expect(lastValue, 'Hello');
    });

    testWidgets('does not add duplicate limiter if user provides one',
        (tester) async {
      final renderer = _TestTextFieldRenderer();
      String? lastValue;

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          value: '',
          maxLength: 10, // This should be ignored
          inputFormatters: [
            LengthLimitingTextInputFormatter(
                3), // User's limiter takes priority
          ],
          onChanged: (v) => lastValue = v,
        ),
      ));

      await tester.enterText(find.byType(EditableText), 'HelloWorld');
      await tester.pump();

      // User's 3-char limiter should win
      expect(lastValue, 'Hel');
    });

    testWidgets('no limiter when maxLength is null', (tester) async {
      final renderer = _TestTextFieldRenderer();
      String? lastValue;

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          value: '',
          onChanged: (v) => lastValue = v,
        ),
      ));

      await tester.enterText(
          find.byType(EditableText), 'HelloWorldThisIsALongText');
      await tester.pump();

      // No truncation
      expect(lastValue, 'HelloWorldThisIsALongText');
    });
  });

  group('overlay visibility modes in spec', () {
    testWidgets('clearButtonMode is passed to spec', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          clearButtonMode: RTextFieldOverlayVisibilityMode.whileEditing,
        ),
      ));

      expect(
        renderer.lastRequest?.spec.clearButtonMode,
        RTextFieldOverlayVisibilityMode.whileEditing,
      );
    });

    testWidgets('prefixMode is passed to spec', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          prefixMode: RTextFieldOverlayVisibilityMode.notEditing,
        ),
      ));

      expect(
        renderer.lastRequest?.spec.prefixMode,
        RTextFieldOverlayVisibilityMode.notEditing,
      );
    });

    testWidgets('suffixMode is passed to spec', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          suffixMode: RTextFieldOverlayVisibilityMode.never,
        ),
      ));

      expect(
        renderer.lastRequest?.spec.suffixMode,
        RTextFieldOverlayVisibilityMode.never,
      );
    });

    testWidgets('default modes are correct', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(),
      ));

      expect(
        renderer.lastRequest?.spec.clearButtonMode,
        RTextFieldOverlayVisibilityMode.never,
      );
      expect(
        renderer.lastRequest?.spec.prefixMode,
        RTextFieldOverlayVisibilityMode.always,
      );
      expect(
        renderer.lastRequest?.spec.suffixMode,
        RTextFieldOverlayVisibilityMode.always,
      );
    });
  });

  group('variant in spec', () {
    testWidgets('variant is passed to spec', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          variant: RTextFieldVariant.outlined,
        ),
      ));

      expect(renderer.lastRequest?.spec.variant, RTextFieldVariant.outlined);
    });

    testWidgets('default variant is filled', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(),
      ));

      expect(renderer.lastRequest?.spec.variant, RTextFieldVariant.filled);
    });
  });

  group('new P0 props pass through to EditableText', () {
    testWidgets('textCapitalization is applied', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          textCapitalization: TextCapitalization.words,
        ),
      ));

      final editableText =
          tester.widget<EditableText>(find.byType(EditableText));
      expect(editableText.textCapitalization, TextCapitalization.words);
    });

    testWidgets('autocorrect is applied', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          autocorrect: false,
        ),
      ));

      final editableText =
          tester.widget<EditableText>(find.byType(EditableText));
      expect(editableText.autocorrect, false);
    });

    testWidgets('enableSuggestions is applied', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          enableSuggestions: false,
        ),
      ));

      final editableText =
          tester.widget<EditableText>(find.byType(EditableText));
      expect(editableText.enableSuggestions, false);
    });

    testWidgets('showCursor is applied', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          showCursor: false,
        ),
      ));

      final editableText =
          tester.widget<EditableText>(find.byType(EditableText));
      expect(editableText.showCursor, false);
    });

    testWidgets('keyboardAppearance is applied', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          keyboardAppearance: Brightness.dark,
        ),
      ));

      final editableText =
          tester.widget<EditableText>(find.byType(EditableText));
      expect(editableText.keyboardAppearance, Brightness.dark);
    });

    testWidgets('onEditingComplete is called', (tester) async {
      final renderer = _TestTextFieldRenderer();
      bool editingCompleteCalled = false;

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          onEditingComplete: () => editingCompleteCalled = true,
        ),
      ));

      // Focus and submit
      await tester.tap(find.byType(RTextField));
      await tester.pumpAndSettle();
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(editingCompleteCalled, isTrue);
    });

    testWidgets('onTapOutside is called when tapping outside focused field',
        (tester) async {
      final renderer = _TestTextFieldRenderer();
      bool tapOutsideCalled = false;
      final focusNode = FocusNode();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: Column(
          children: [
            RTextField(
              focusNode: focusNode,
              onTapOutside: (_) => tapOutsideCalled = true,
            ),
            const SizedBox(height: 100),
            const Text('Outside area'),
          ],
        ),
      ));

      // Focus the field
      focusNode.requestFocus();
      await tester.pumpAndSettle();
      expect(focusNode.hasFocus, isTrue);

      // Tap outside the text field
      await tester.tap(find.text('Outside area'));
      await tester.pump();

      expect(tapOutsideCalled, isTrue);

      focusNode.dispose();
    });
  });
}
