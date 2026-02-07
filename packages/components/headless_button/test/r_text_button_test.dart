import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_button/headless_button.dart';
import 'package:headless_test/headless_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

class _TestButtonTokenResolver implements RButtonTokenResolver {
  _TestButtonTokenResolver({required this.defaultBackgroundColor});

  final Color defaultBackgroundColor;
  BoxConstraints? lastConstraints;
  RenderOverrides? lastOverrides;
  Set<WidgetState>? lastStates;

  @override
  RButtonResolvedTokens resolve({
    required BuildContext context,
    required RButtonSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    lastConstraints = constraints;
    lastOverrides = overrides;
    lastStates = states;

    final contractOverrides = overrides?.get<RButtonOverrides>();
    final bg = contractOverrides?.backgroundColor ??
        (states.contains(WidgetState.pressed)
            ? const Color(0xFF123456)
            : defaultBackgroundColor);

    return RButtonResolvedTokens(
      textStyle: const TextStyle(fontSize: 14),
      foregroundColor: const Color(0xFF000000),
      backgroundColor: bg,
      borderColor: const Color(0xFF111111),
      padding: const EdgeInsets.all(8),
      minSize: const Size(44, 44),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      disabledOpacity: 0.38,
      pressOverlayColor: const Color(0x1F000000),
      pressOpacity: 1.0,
    );
  }
}

/// Renderer that declares token-mode (usesResolvedTokens = false).
class _TokenModeRenderer implements RButtonRenderer, RButtonRendererTokenMode {
  RButtonRenderRequest? lastRequest;

  @override
  bool get usesResolvedTokens => false;

  @override
  Widget render(RButtonRenderRequest request) {
    lastRequest = request;
    return Container(child: request.content);
  }
}

/// Token resolver that counts how many times resolve() is called.
class _CountingTokenResolver implements RButtonTokenResolver {
  int callCount = 0;

  @override
  RButtonResolvedTokens resolve({
    required BuildContext context,
    required RButtonSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    callCount++;
    return const RButtonResolvedTokens(
      textStyle: TextStyle(fontSize: 14),
      foregroundColor: Color(0xFF000000),
      backgroundColor: Color(0xFFCCCCCC),
      borderColor: Color(0xFF111111),
      padding: EdgeInsets.all(8),
      minSize: Size(44, 44),
      borderRadius: BorderRadius.all(Radius.circular(12)),
      disabledOpacity: 0.38,
      pressOverlayColor: Color(0x1F000000),
      pressOpacity: 1.0,
    );
  }
}

// Test renderer that captures requests and renders a simple container
class _TestButtonRenderer implements RButtonRenderer {
  RButtonRenderRequest? lastRequest;
  int renderCount = 0;

  @override
  Widget render(RButtonRenderRequest request) {
    lastRequest = request;
    renderCount++;

    // Simple visual representation for testing
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: request.state.isPressed
            ? const Color(0xFF0000FF)
            : request.state.isHovered
                ? const Color(0xFF00FF00)
                : const Color(0xFFCCCCCC),
        border: request.state.isFocused
            ? Border.all(color: const Color(0xFFFF0000), width: 2)
            : null,
      ),
      child: request.content,
    );
  }
}

// Test theme that provides the test renderer
class _TestTheme extends HeadlessTheme {
  _TestTheme(this._renderer, {this.tokenResolver});

  final RButtonRenderer _renderer;
  final RButtonTokenResolver? tokenResolver;

  @override
  T? capability<T>() {
    if (T == RButtonRenderer) {
      return _renderer as T;
    }
    if (T == RButtonTokenResolver) {
      return tokenResolver as T?;
    }
    return null;
  }
}

// Theme without button renderer
class _EmptyTheme extends HeadlessTheme {
  const _EmptyTheme();

  @override
  T? capability<T>() => null;
}

// Helper to build widget tree with theme
Widget _buildTestWidget({
  required RButtonRenderer renderer,
  required Widget child,
  RButtonTokenResolver? tokenResolver,
}) {
  return MaterialApp(
    home: HeadlessThemeProvider(
      theme: _TestTheme(renderer, tokenResolver: tokenResolver),
      child: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  group('Semantics / Accessibility', () {
    testWidgets('button has button semantic role', (tester) async {
      final renderer = _TestButtonRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextButton(
          onPressed: () {},
          child: const Text('Test'),
        ),
      ));

      final semantics = tester.getSemantics(find.byType(RTextButton));
      expect(SemanticsUtils.hasFlag(semantics, SemanticsFlag.isButton), isTrue);
    });

    testWidgets('disabled button shows disabled state in semantics',
        (tester) async {
      final renderer = _TestButtonRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: const RTextButton(
          onPressed: null,
          child: Text('Test'),
        ),
      ));

      final semantics = tester.getSemantics(find.byType(RTextButton));
      expect(SemanticsUtils.hasFlag(semantics, SemanticsFlag.isButton), isTrue);
      // Disabled buttons don't have "enabled" flag
      expect(
          SemanticsUtils.hasFlag(semantics, SemanticsFlag.isEnabled), isFalse);
    });

    testWidgets('semantic label is applied when provided', (tester) async {
      final renderer = _TestButtonRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextButton(
          onPressed: () {},
          semanticLabel: 'Custom label',
          child: const Text('Test'),
        ),
      ));

      final semantics = tester.getSemantics(find.byType(RTextButton));
      // Label contains both semantic label and child text (merged by Flutter)
      expect(semantics.label, contains('Custom label'));
    });

    testWidgets('SemanticsAction.tap activates exactly once', (tester) async {
      final renderer = _TestButtonRenderer();
      var pressCount = 0;

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextButton(
          onPressed: () => pressCount++,
          child: const Text('Test'),
        ),
      ));

      final semanticsHandle = tester.ensureSemantics();
      try {
        await tester.pumpAndSettle();

        final semanticsFinder = find
            .descendant(
                of: find.byType(RTextButton), matching: find.byType(Semantics))
            .first;
        final node = tester.getSemantics(semanticsFinder);
        expect(SemanticsUtils.hasAction(node, SemanticsAction.tap), isTrue);

        // ignore: deprecated_member_use
        final owner = tester.binding.pipelineOwner.semanticsOwner!;
        owner.performAction(node.id, SemanticsAction.tap);
        await tester.pumpAndSettle();

        expect(pressCount, 1);
      } finally {
        semanticsHandle.dispose();
      }
    });
  });

  group('Keyboard', () {
    testWidgets('Space triggers onPressed on key up', (tester) async {
      final renderer = _TestButtonRenderer();
      var pressCount = 0;

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextButton(
          autofocus: true,
          onPressed: () => pressCount++,
          child: const Text('Test'),
        ),
      ));

      await tester.pump();

      // Simulate Space key down
      await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
      await tester.pump();

      // Should be pressed but not activated yet
      expect(renderer.lastRequest?.state.isPressed, isTrue);
      expect(pressCount, 0);

      // Simulate Space key up
      await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
      await tester.pump();

      // Now should be activated
      expect(renderer.lastRequest?.state.isPressed, isFalse);
      expect(pressCount, 1);
    });

    testWidgets('Enter triggers onPressed immediately', (tester) async {
      final renderer = _TestButtonRenderer();
      var pressCount = 0;

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextButton(
          autofocus: true,
          onPressed: () => pressCount++,
          child: const Text('Test'),
        ),
      ));

      await tester.pump();

      // Simulate Enter key down
      await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      // Should be activated on key down
      expect(pressCount, 1);
    });

    testWidgets('Space/Enter do not trigger when disabled', (tester) async {
      final renderer = _TestButtonRenderer();
      var pressCount = 0;

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextButton(
          autofocus: true,
          disabled: true,
          onPressed: () => pressCount++,
          child: const Text('Test'),
        ),
      ));

      await tester.pump();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
      await tester.pump();

      expect(pressCount, 0);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(pressCount, 0);
    });

    testWidgets('Space held does not repeat activation', (tester) async {
      final renderer = _TestButtonRenderer();
      var pressCount = 0;

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextButton(
          autofocus: true,
          onPressed: () => pressCount++,
          child: const Text('Test'),
        ),
      ));

      await tester.pump();

      // Single key down starts press, but no activation yet
      await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
      await tester.pump();

      expect(pressCount, 0);
      expect(renderer.lastRequest?.state.isPressed, isTrue);

      // Use key repeat events (simulated with pump delays)
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      // Still no activation from holding
      expect(pressCount, 0);

      // Single key up triggers activation once
      await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
      await tester.pump();

      expect(pressCount, 1);
    });

    testWidgets('Enter held does not repeat activation', (tester) async {
      final renderer = _TestButtonRenderer();
      var pressCount = 0;

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextButton(
          autofocus: true,
          onPressed: () => pressCount++,
          child: const Text('Test'),
        ),
      ));

      await tester.pump();

      // First key down triggers activation
      await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(pressCount, 1);

      // Holding the key (simulated with pump delays) should not repeat
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      // Still only 1 activation
      expect(pressCount, 1);

      // Key up should not trigger another activation
      await tester.sendKeyUpEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(pressCount, 1);
    });
  });

  group('Controlled / Uncontrolled', () {
    testWidgets('onPressed == null makes button disabled', (tester) async {
      final renderer = _TestButtonRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: const RTextButton(
          onPressed: null,
          child: Text('Test'),
        ),
      ));

      expect(renderer.lastRequest?.state.isDisabled, isTrue);
    });

    testWidgets('disabled == true makes button disabled even with onPressed',
        (tester) async {
      final renderer = _TestButtonRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextButton(
          onPressed: () {},
          disabled: true,
          child: const Text('Test'),
        ),
      ));

      expect(renderer.lastRequest?.state.isDisabled, isTrue);
    });

    testWidgets('changing disabled clears pressed state', (tester) async {
      final renderer = _TestButtonRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextButton(
          autofocus: true,
          onPressed: () {},
          child: const Text('Test'),
        ),
      ));

      await tester.pump();

      // Press Space to set pressed state
      await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
      await tester.pump();

      expect(renderer.lastRequest?.state.isPressed, isTrue);

      // Now disable the button
      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextButton(
          autofocus: true,
          onPressed: () {},
          disabled: true,
          child: const Text('Test'),
        ),
      ));

      // Pressed state should be cleared (POLA invariant)
      expect(renderer.lastRequest?.state.isPressed, isFalse);
      expect(renderer.lastRequest?.state.isDisabled, isTrue);
    });

    testWidgets('tap on disabled button does not trigger onPressed',
        (tester) async {
      final renderer = _TestButtonRenderer();
      var pressCount = 0;

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextButton(
          onPressed: () => pressCount++,
          disabled: true,
          child: const Text('Test'),
        ),
      ));

      await tester.tap(find.byType(RTextButton));
      await tester.pump();

      expect(pressCount, 0);
    });

    testWidgets('setting onPressed=null during pressed clears state',
        (tester) async {
      final renderer = _TestButtonRenderer();
      var pressCount = 0;

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextButton(
          autofocus: true,
          onPressed: () => pressCount++,
          child: const Text('Test'),
        ),
      ));

      await tester.pumpAndSettle();

      // Press Space to start press
      await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
      await tester.pump();

      expect(renderer.lastRequest?.state.isPressed, isTrue);
      expect(renderer.lastRequest?.state.isDisabled, isFalse);

      // Now set onPressed to null (making it effectively disabled)
      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: const RTextButton(
          onPressed: null,
          child: Text('Test'),
        ),
      ));

      // Pressed state should be cleared and disabled should be true
      expect(renderer.lastRequest?.state.isPressed, isFalse);
      expect(renderer.lastRequest?.state.isDisabled, isTrue);

      // Key up should not trigger activation
      await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
      await tester.pump();

      expect(pressCount, 0);
    });
  });

  group('Pointer interaction', () {
    testWidgets('tap triggers onPressed', (tester) async {
      final renderer = _TestButtonRenderer();
      var pressCount = 0;

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextButton(
          onPressed: () => pressCount++,
          child: const Text('Test'),
        ),
      ));

      await tester.tap(find.byType(RTextButton));
      await tester.pump();

      expect(pressCount, 1);
    });

    testWidgets('hover updates state', (tester) async {
      final renderer = _TestButtonRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextButton(
          onPressed: () {},
          child: const Text('Test'),
        ),
      ));

      expect(renderer.lastRequest?.state.isHovered, isFalse);

      // Create a mouse gesture for hover testing
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(gesture.removePointer);

      // Move to the button center
      await gesture.addPointer(
          location: tester.getCenter(find.byType(RTextButton)));
      await tester.pumpAndSettle();

      expect(renderer.lastRequest?.state.isHovered, isTrue);

      // Move away from the button
      await gesture.moveTo(const Offset(0, 0));
      await tester.pumpAndSettle();

      expect(renderer.lastRequest?.state.isHovered, isFalse);
    });
  });

  group('Focus', () {
    testWidgets('focus state is tracked', (tester) async {
      final renderer = _TestButtonRenderer();
      final focusNode = FocusNode();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextButton(
          onPressed: () {},
          focusNode: focusNode,
          child: const Text('Test'),
        ),
      ));

      expect(renderer.lastRequest?.state.isFocused, isFalse);

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      expect(renderer.lastRequest?.state.isFocused, isTrue);

      focusNode.unfocus();
      await tester.pumpAndSettle();

      expect(renderer.lastRequest?.state.isFocused, isFalse);
    });

    testWidgets('autofocus works', (tester) async {
      final renderer = _TestButtonRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextButton(
          onPressed: () {},
          autofocus: true,
          child: const Text('Test'),
        ),
      ));

      await tester.pump();

      expect(renderer.lastRequest?.state.isFocused, isTrue);
    });

    testWidgets('focus loss clears pressed state', (tester) async {
      final renderer = _TestButtonRenderer();
      final focusNode = FocusNode();
      final otherFocusNode = FocusNode();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: Column(
          children: [
            RTextButton(
              onPressed: () {},
              focusNode: focusNode,
              autofocus: true,
              child: const Text('Button 1'),
            ),
            Focus(
              focusNode: otherFocusNode,
              child: Container(width: 100, height: 100),
            ),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      // Press Space to start press
      await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
      await tester.pump();

      expect(renderer.lastRequest?.state.isPressed, isTrue);

      // Move focus to another widget to trigger focus loss
      otherFocusNode.requestFocus();
      await tester.pumpAndSettle();

      // Pressed state should be cleared on focus loss
      expect(renderer.lastRequest?.state.isPressed, isFalse);
    });
  });

  group('Renderer', () {
    testWidgets('spec is passed correctly to renderer', (tester) async {
      final renderer = _TestButtonRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextButton(
          onPressed: () {},
          variant: RButtonVariant.filled,
          size: RButtonSize.large,
          semanticLabel: 'Test label',
          child: const Text('Test'),
        ),
      ));

      expect(renderer.lastRequest?.spec.variant, RButtonVariant.filled);
      expect(renderer.lastRequest?.spec.size, RButtonSize.large);
      expect(renderer.lastRequest?.spec.semanticLabel, 'Test label');
    });

    testWidgets('child is passed in render request', (tester) async {
      final renderer = _TestButtonRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RTextButton(
          onPressed: () {},
          child: const Text('Button Label'),
        ),
      ));

      expect(renderer.lastRequest?.content, isA<Text>());
    });
  });

  group('Token resolution (I08 flow)', () {
    testWidgets(
        'resolvedTokens are passed to renderer when token resolver is provided',
        (tester) async {
      final renderer = _TestButtonRenderer();
      final resolver = _TestButtonTokenResolver(
        defaultBackgroundColor: const Color(0xFFAAAAAA),
      );

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        tokenResolver: resolver,
        child: RTextButton(
          onPressed: () {},
          child: const Text('Test'),
        ),
      ));

      expect(renderer.lastRequest?.resolvedTokens, isNotNull);
    });

    testWidgets(
        'per-instance overrides flow into resolver and affect resolvedTokens',
        (tester) async {
      final renderer = _TestButtonRenderer();
      final resolver = _TestButtonTokenResolver(
        defaultBackgroundColor: const Color(0xFFAAAAAA),
      );

      const overrideBg = Color(0xFF00FF99);

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        tokenResolver: resolver,
        child: RTextButton(
          onPressed: () {},
          overrides: const RenderOverrides({
            RButtonOverrides: RButtonOverrides.tokens(
              backgroundColor: overrideBg,
            ),
          }),
          child: const Text('Test'),
        ),
      ));

      expect(resolver.lastOverrides?.get<RButtonOverrides>(), isNotNull);
      expect(renderer.lastRequest?.resolvedTokens?.backgroundColor, overrideBg);
    });

    testWidgets('style sugar flows into resolver and affects resolvedTokens',
        (tester) async {
      final renderer = _TestButtonRenderer();
      final resolver = _TestButtonTokenResolver(
        defaultBackgroundColor: const Color(0xFFAAAAAA),
      );

      const styleBg = Color(0xFF00FF99);

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        tokenResolver: resolver,
        child: RTextButton(
          onPressed: () {},
          style: const RButtonStyle(
            backgroundColor: styleBg,
          ),
          child: const Text('Test'),
        ),
      ));

      expect(resolver.lastOverrides?.get<RButtonOverrides>(), isNotNull);
      expect(renderer.lastRequest?.resolvedTokens?.backgroundColor, styleBg);
    });

    testWidgets('explicit overrides win over style sugar (POLA)',
        (tester) async {
      final renderer = _TestButtonRenderer();
      final resolver = _TestButtonTokenResolver(
        defaultBackgroundColor: const Color(0xFFAAAAAA),
      );

      const styleBg = Color(0xFF00FF99);
      const overrideBg = Color(0xFFFF0099);

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        tokenResolver: resolver,
        child: RTextButton(
          onPressed: () {},
          style: const RButtonStyle(
            backgroundColor: styleBg,
          ),
          overrides: const RenderOverrides({
            RButtonOverrides: RButtonOverrides.tokens(
              backgroundColor: overrideBg,
            ),
          }),
          child: const Text('Test'),
        ),
      ));

      expect(renderer.lastRequest?.resolvedTokens?.backgroundColor, overrideBg);
    });

    testWidgets('pressed state affects resolvedTokens (state → tokens)',
        (tester) async {
      final renderer = _TestButtonRenderer();
      final resolver = _TestButtonTokenResolver(
        defaultBackgroundColor: const Color(0xFFAAAAAA),
      );

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        tokenResolver: resolver,
        child: RTextButton(
          onPressed: () {},
          child: const Text('Test'),
        ),
      ));

      final before = renderer.lastRequest?.resolvedTokens?.backgroundColor;

      final gesture =
          await tester.startGesture(tester.getCenter(find.byType(RTextButton)));
      await tester.pump();

      final during = renderer.lastRequest?.resolvedTokens?.backgroundColor;
      expect(during, isNot(equals(before)));

      await gesture.up();
      await tester.pump();
    });
  });

  group('Token-mode', () {
    testWidgets(
      'resolver is NOT called when renderer declares usesResolvedTokens=false',
      (tester) async {
        final renderer = _TokenModeRenderer();
        final resolver = _CountingTokenResolver();

        await tester.pumpWidget(_buildTestWidget(
          renderer: renderer,
          tokenResolver: resolver,
          child: RTextButton(
            onPressed: () {},
            child: const Text('Test'),
          ),
        ));

        expect(resolver.callCount, 0);
        expect(renderer.lastRequest?.resolvedTokens, isNull);
      },
    );

    testWidgets(
      'resolver IS called when renderer does not implement RButtonRendererTokenMode',
      (tester) async {
        final renderer = _TestButtonRenderer();
        final resolver = _CountingTokenResolver();

        await tester.pumpWidget(_buildTestWidget(
          renderer: renderer,
          tokenResolver: resolver,
          child: RTextButton(
            onPressed: () {},
            child: const Text('Test'),
          ),
        ));

        expect(resolver.callCount, 1);
        expect(renderer.lastRequest?.resolvedTokens, isNotNull);
      },
    );
  });

  group('Missing capability', () {
    testWidgets('throws MissingCapabilityException when renderer not available',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: HeadlessThemeProvider(
          theme: const _EmptyTheme(),
          child: Scaffold(
            body: RTextButton(
              onPressed: () {},
              child: const Text('Test'),
            ),
          ),
        ),
      ));

      // The exception should be thrown with proper format
      final exception = tester.takeException();
      expect(exception, isA<MissingCapabilityException>());

      final message = exception.toString();
      expect(message, startsWith('[Headless] Missing required capability:'));
      expect(message, contains('RButtonRenderer'));
      expect(message, contains('Component: RTextButton'));
    });

    testWidgets('throws MissingThemeException when no theme provider',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: RTextButton(
            onPressed: () {},
            child: const Text('Test'),
          ),
        ),
      ));

      expect(tester.takeException(), isA<MissingThemeException>());
    });
  });
}
