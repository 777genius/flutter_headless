import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_textfield/headless_textfield.dart';
import 'package:headless_test/headless_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

class _TestTextFieldTokenResolver implements RTextFieldTokenResolver {
  BoxConstraints? lastConstraints;
  RenderOverrides? lastOverrides;
  Set<WidgetState>? lastStates;

  @override
  RTextFieldResolvedTokens resolve({
    required BuildContext context,
    required RTextFieldSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    lastConstraints = constraints;
    lastOverrides = overrides;
    lastStates = states;
    final contractOverrides = overrides?.get<RTextFieldOverrides>();
    final containerBackground =
        contractOverrides?.containerBackgroundColor ?? const Color(0xFFFFFFFF);

    return RTextFieldResolvedTokens(
      containerPadding: const EdgeInsets.all(12),
      containerBackgroundColor: containerBackground,
      containerBorderColor: Color(0xFF000000),
      containerBorderRadius: BorderRadius.all(Radius.circular(4)),
      containerBorderWidth: 1.0,
      containerElevation: 0.0,
      containerAnimationDuration: Duration(milliseconds: 200),
      labelStyle: TextStyle(fontSize: 12),
      labelColor: Color(0xFF666666),
      helperStyle: TextStyle(fontSize: 12),
      helperColor: Color(0xFF666666),
      errorStyle: TextStyle(fontSize: 12),
      errorColor: Color(0xFFFF0000),
      messageSpacing: 4.0,
      textStyle: TextStyle(fontSize: 16),
      textColor: Color(0xFF000000),
      placeholderStyle: TextStyle(fontSize: 16),
      placeholderColor: Color(0xFF999999),
      cursorColor: Color(0xFF0000FF),
      selectionColor: Color(0x330000FF),
      disabledOpacity: 0.38,
      iconColor: Color(0xFF666666),
      iconSpacing: 12.0,
      minSize: Size(200, 48),
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
            color: request.state.isError
                ? const Color(0xFFFF0000)
                : request.state.isFocused
                    ? const Color(0xFF0000FF)
                    : const Color(0xFFCCCCCC),
            width: request.state.isFocused ? 2 : 1,
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
    if (T == RTextFieldRenderer) {
      return _renderer as T;
    }
    if (T == RTextFieldTokenResolver) {
      return tokenResolver as T?;
    }
    return null;
  }
}

class _EmptyTheme extends HeadlessTheme {
  const _EmptyTheme();

  @override
  T? capability<T>() => null;
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
  group('Controlled mode', () {
    testWidgets('value is displayed in the field', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          value: 'Hello',
        ),
      ));

      expect(renderer.lastRequest?.state.hasText, isTrue);
    });

    testWidgets('onChanged is called when text changes', (tester) async {
      final renderer = _TestTextFieldRenderer();
      String? lastValue;

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          value: '',
          onChanged: (v) => lastValue = v,
        ),
      ));

      await tester.enterText(find.byType(EditableText), 'Test');
      await tester.pump();

      expect(lastValue, 'Test');
    });

    testWidgets('value update syncs to controller', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          value: 'Initial',
        ),
      ));

      expect(renderer.lastRequest?.state.hasText, isTrue);

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          value: 'Updated',
        ),
      ));

      expect(renderer.lastRequest?.state.hasText, isTrue);
    });
  });

  group('Controller-driven mode', () {
    testWidgets('controller text is displayed', (tester) async {
      final renderer = _TestTextFieldRenderer();
      final controller = TextEditingController(text: 'Controller text');

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          controller: controller,
        ),
      ));

      expect(renderer.lastRequest?.state.hasText, isTrue);

      controller.dispose();
    });

    testWidgets('controller changes are reflected automatically',
        (tester) async {
      final renderer = _TestTextFieldRenderer();
      final controller = TextEditingController();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          controller: controller,
        ),
      ));

      expect(renderer.lastRequest?.state.hasText, isFalse);

      controller.text = 'New text';
      await tester.pump();

      // State SHOULD update automatically thanks to controller listener
      expect(renderer.lastRequest?.state.hasText, isTrue);

      controller.dispose();
    });
  });

  group('Focus', () {
    testWidgets('focus state is tracked', (tester) async {
      final renderer = _TestTextFieldRenderer();
      final focusNode = FocusNode();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          focusNode: focusNode,
        ),
      ));

      expect(renderer.lastRequest?.state.isFocused, isFalse);

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      expect(renderer.lastRequest?.state.isFocused, isTrue);

      focusNode.unfocus();
      await tester.pumpAndSettle();

      expect(renderer.lastRequest?.state.isFocused, isFalse);

      focusNode.dispose();
    });

    testWidgets('autofocus works', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          autofocus: true,
        ),
      ));

      await tester.pumpAndSettle();

      expect(renderer.lastRequest?.state.isFocused, isTrue);
    });

    testWidgets('tap on container focuses field', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(),
      ));

      expect(renderer.lastRequest?.state.isFocused, isFalse);

      await tester.tap(find.byType(RTextField));
      await tester.pumpAndSettle();

      expect(renderer.lastRequest?.state.isFocused, isTrue);
    });
  });

  group('Error state', () {
    testWidgets('errorText sets isError state', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          errorText: 'Error message',
        ),
      ));

      expect(renderer.lastRequest?.state.isError, isTrue);
      expect(renderer.lastRequest?.spec.errorText, 'Error message');
    });

    testWidgets('no errorText means no error state', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(),
      ));

      expect(renderer.lastRequest?.state.isError, isFalse);
    });
  });

  group('Disabled state', () {
    testWidgets('enabled=false sets isDisabled', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          enabled: false,
        ),
      ));

      expect(renderer.lastRequest?.state.isDisabled, isTrue);
    });

    testWidgets('disabled field cannot be focused', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          enabled: false,
        ),
      ));

      // Tap is blocked by IgnorePointer, so we try to focus directly
      // via FocusNode which should also fail due to canRequestFocus=false
      expect(renderer.lastRequest?.state.isFocused, isFalse);

      // Try tapping (will be blocked by IgnorePointer)
      await tester.tap(find.byType(RTextField), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Field should NOT gain focus when disabled
      expect(renderer.lastRequest?.state.isFocused, isFalse);
    });
  });

  group('ReadOnly state', () {
    testWidgets('readOnly=true sets isReadOnly', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          readOnly: true,
        ),
      ));

      expect(renderer.lastRequest?.state.isReadOnly, isTrue);
    });

    testWidgets('readOnly field CAN be focused (for selection/copy)',
        (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          readOnly: true,
        ),
      ));

      expect(renderer.lastRequest?.state.isFocused, isFalse);

      await tester.tap(find.byType(RTextField));
      await tester.pumpAndSettle();

      // ReadOnly SHOULD gain focus (unlike disabled)
      expect(renderer.lastRequest?.state.isFocused, isTrue);
    });
  });

  group('Obscured state', () {
    testWidgets('obscureText=true sets isObscured', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          obscureText: true,
        ),
      ));

      expect(renderer.lastRequest?.state.isObscured, isTrue);
    });
  });

  group('Spec', () {
    testWidgets('placeholder is passed to spec', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          placeholder: 'Enter text...',
        ),
      ));

      expect(renderer.lastRequest?.spec.placeholder, 'Enter text...');
    });

    testWidgets('label is passed to spec', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          label: 'Email',
        ),
      ));

      expect(renderer.lastRequest?.spec.label, 'Email');
    });

    testWidgets('helperText is passed to spec', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          helperText: 'Enter your email address',
        ),
      ));

      expect(renderer.lastRequest?.spec.helperText, 'Enter your email address');
    });

    testWidgets('maxLines/minLines are passed to spec', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          maxLines: 5,
          minLines: 2,
        ),
      ));

      expect(renderer.lastRequest?.spec.maxLines, 5);
      expect(renderer.lastRequest?.spec.minLines, 2);
      expect(renderer.lastRequest?.spec.isMultiline, isTrue);
    });
  });

  group('Token resolution', () {
    testWidgets('resolvedTokens are passed to renderer', (tester) async {
      final renderer = _TestTextFieldRenderer();
      final resolver = _TestTextFieldTokenResolver();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        tokenResolver: resolver,
        child: RTextField(),
      ));

      expect(renderer.lastRequest?.resolvedTokens, isNotNull);
    });

    testWidgets('states are passed to resolver', (tester) async {
      final renderer = _TestTextFieldRenderer();
      final resolver = _TestTextFieldTokenResolver();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        tokenResolver: resolver,
        child: RTextField(
          errorText: 'Error',
        ),
      ));

      expect(resolver.lastStates?.contains(WidgetState.error), isTrue);
    });

    testWidgets('overrides flow to resolver', (tester) async {
      final renderer = _TestTextFieldRenderer();
      final resolver = _TestTextFieldTokenResolver();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        tokenResolver: resolver,
        child: RTextField(
          overrides: RenderOverrides({
            RTextFieldOverrides: RTextFieldOverrides.tokens(
              containerBackgroundColor: Color(0xFFFF0000),
            ),
          }),
        ),
      ));

      expect(resolver.lastOverrides?.get<RTextFieldOverrides>(), isNotNull);
    });

    testWidgets('style sugar flows into resolver and affects resolvedTokens',
        (tester) async {
      final renderer = _TestTextFieldRenderer();
      final resolver = _TestTextFieldTokenResolver();

      const styleColor = Color(0xFF00FF99);

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        tokenResolver: resolver,
        child: RTextField(
          style: const RTextFieldStyle(
            containerBackgroundColor: styleColor,
          ),
        ),
      ));

      expect(resolver.lastOverrides?.get<RTextFieldOverrides>(), isNotNull);
      expect(
        renderer.lastRequest?.resolvedTokens?.containerBackgroundColor,
        styleColor,
      );
    });

    testWidgets('explicit overrides win over style sugar (POLA)',
        (tester) async {
      final renderer = _TestTextFieldRenderer();
      final resolver = _TestTextFieldTokenResolver();

      const styleColor = Color(0xFF00FF99);
      const overrideColor = Color(0xFFFF0099);

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        tokenResolver: resolver,
        child: RTextField(
          style: const RTextFieldStyle(
            containerBackgroundColor: styleColor,
          ),
          overrides: RenderOverrides({
            RTextFieldOverrides: RTextFieldOverrides.tokens(
              containerBackgroundColor: overrideColor,
            ),
          }),
        ),
      ));

      expect(
        renderer.lastRequest?.resolvedTokens?.containerBackgroundColor,
        overrideColor,
      );
    });
  });

  group('Semantics', () {
    testWidgets('textField semantic role', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(),
      ));

      final semantics = tester.getSemantics(find.byType(RTextField));
      expect(
          SemanticsUtils.hasFlag(semantics, SemanticsFlag.isTextField), isTrue);
    });

    testWidgets('label in semantics', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          label: 'Email',
        ),
      ));

      expect(renderer.lastRequest?.semantics?.label, 'Email');
    });

    testWidgets('obscured password does not expose value in semantics',
        (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          value: 'secret123',
          obscureText: true,
        ),
      ));

      expect(renderer.lastRequest?.semantics?.isObscured, isTrue);
    });

    testWidgets('errorText is included in semantics value', (tester) async {
      final renderer = _TestTextFieldRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          value: 'test',
          errorText: 'Invalid input',
        ),
      ));

      // Error should be in semantics for screen readers
      // Find the RTextField's Semantics (the outermost one wrapping our field)
      final semantics = tester.getSemantics(find.byType(RTextField));
      expect(semantics.value, contains('Error: Invalid input'));
    });
  });

  group('Missing capability', () {
    testWidgets('throws MissingCapabilityException when renderer not available',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: HeadlessThemeProvider(
          theme: const _EmptyTheme(),
          child: Scaffold(
            body: RTextField(),
          ),
        ),
      ));

      final exception = tester.takeException();
      expect(exception, isA<MissingCapabilityException>());

      final message = exception.toString();
      expect(message, contains('RTextFieldRenderer'));
      expect(message, contains('RTextField'));
    });

    testWidgets('throws MissingThemeException when no theme provider',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: RTextField(),
        ),
      ));

      expect(tester.takeException(), isA<MissingThemeException>());
    });
  });

  group('Input formatters', () {
    testWidgets('formatters are applied', (tester) async {
      final renderer = _TestTextFieldRenderer();
      String? lastValue;

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextField(
          value: '',
          onChanged: (v) => lastValue = v,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ));

      await tester.enterText(find.byType(EditableText), 'abc123');
      await tester.pump();

      expect(lastValue, '123');
    });
  });
}
