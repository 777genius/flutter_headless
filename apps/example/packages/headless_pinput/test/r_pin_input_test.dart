import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_pinput/headless_pinput.dart';
import 'package:headless_theme/headless_theme.dart';

class _TestPinInputRenderer implements RPinInputRenderer {
  RPinInputRenderRequest? lastRequest;
  int renderCount = 0;

  @override
  Widget render(RPinInputRenderRequest request) {
    lastRequest = request;
    renderCount++;
    return SizedBox(
      width: 320,
      child: request.hiddenInput,
    );
  }
}

class _TestTheme extends HeadlessTheme {
  const _TestTheme(this.renderer);

  final _TestPinInputRenderer renderer;

  @override
  T? capability<T>() {
    if (T == RPinInputRenderer) return renderer as T;
    return null;
  }
}

class _DemoTheme extends HeadlessTheme {
  const _DemoTheme();

  @override
  T? capability<T>() {
    if (T == RPinInputRenderer) return const DemoPinInputRenderer() as T;
    return null;
  }
}

Widget _testHarness({
  required _TestPinInputRenderer renderer,
  required Widget child,
}) {
  return MaterialApp(
    home: HeadlessThemeProvider(
      theme: _TestTheme(renderer),
      child: Scaffold(
        body: Center(child: child),
      ),
    ),
  );
}

void main() {
  group('Controlled mode', () {
    testWidgets('onChanged is called when editable text changes',
        (tester) async {
      final renderer = _TestPinInputRenderer();
      String? lastValue;

      await tester.pumpWidget(_testHarness(
        renderer: renderer,
        child: RPinInput(
          value: '',
          onChanged: (value) => lastValue = value,
        ),
      ));

      await tester.enterText(find.byType(EditableText), '123');
      await tester.pump();

      expect(lastValue, '123');
    });

    testWidgets('obscureText maps cell display text', (tester) async {
      final renderer = _TestPinInputRenderer();

      await tester.pumpWidget(_testHarness(
        renderer: renderer,
        child: RPinInput(
          value: '12',
          obscureText: true,
          obscuringCharacter: '*',
          onChanged: (_) {},
        ),
      ));

      expect(renderer.lastRequest?.cells.first.displayText, '*');
      expect(renderer.lastRequest?.cells[1].displayText, '*');
      expect(renderer.lastRequest?.state.currentLength, 2);
    });

    testWidgets('useNativeKeyboard=false keeps visual focus until complete',
        (tester) async {
      final renderer = _TestPinInputRenderer();

      await tester.pumpWidget(_testHarness(
        renderer: renderer,
        child: RPinInput(
          value: '12',
          useNativeKeyboard: false,
          onChanged: (_) {},
        ),
      ));

      expect(renderer.lastRequest?.state.isFocused, isTrue);

      await tester.pumpWidget(_testHarness(
        renderer: renderer,
        child: RPinInput(
          value: '123456',
          useNativeKeyboard: false,
          onChanged: (_) {},
        ),
      ));

      expect(renderer.lastRequest?.state.isFocused, isFalse);
      expect(renderer.lastRequest?.state.isCompleted, isTrue);
    });

    testWidgets('hidden editable disables autocorrect and smart punctuation',
        (tester) async {
      final renderer = _TestPinInputRenderer();

      await tester.pumpWidget(_testHarness(
        renderer: renderer,
        child: RPinInput(
          value: '',
          onChanged: (_) {},
        ),
      ));

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.autocorrect, isFalse);
      expect(editable.smartDashesType, SmartDashesType.disabled);
      expect(editable.smartQuotesType, SmartQuotesType.disabled);
    });
  });

  group('Controller-driven mode', () {
    testWidgets('controller updates are reflected in render request',
        (tester) async {
      final renderer = _TestPinInputRenderer();
      final controller = TextEditingController(text: '42');

      await tester.pumpWidget(_testHarness(
        renderer: renderer,
        child: RPinInput(
          controller: controller,
          onChanged: (_) {},
        ),
      ));

      expect(renderer.lastRequest?.state.currentLength, 2);
      expect(renderer.lastRequest?.cells.first.rawValue, '4');
      expect(renderer.lastRequest?.cells[1].rawValue, '2');

      controller.text = '4207';
      await tester.pump();

      expect(renderer.lastRequest?.state.currentLength, 4);
      expect(renderer.lastRequest?.cells[3].rawValue, '7');

      await tester.pumpWidget(_testHarness(
        renderer: renderer,
        child: RPinInput(
          controller: controller,
          length: 2,
          onChanged: (_) {},
        ),
      ));
      await tester.pump();

      expect(controller.text, '42');
      expect(renderer.lastRequest?.state.currentLength, 2);

      controller.dispose();
    });

    testWidgets('onCompleted fires once when target length is reached',
        (tester) async {
      final renderer = _TestPinInputRenderer();
      final controller = TextEditingController();
      var completedCount = 0;
      String? completedValue;

      await tester.pumpWidget(_testHarness(
        renderer: renderer,
        child: RPinInput(
          controller: controller,
          onChanged: (_) {},
          onCompleted: (value) {
            completedCount++;
            completedValue = value;
          },
        ),
      ));

      controller.text = '12345';
      await tester.pump();
      expect(completedCount, 0);

      controller.text = '123456';
      await tester.pump();
      expect(completedCount, 1);
      expect(completedValue, '123456');

      controller.text = '123456';
      await tester.pump();
      expect(completedCount, 1);

      controller.dispose();
    });
  });

  testWidgets('underlined demo renderer does not throw while showing cursor',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HeadlessThemeProvider(
        theme: const _DemoTheme(),
        child: Scaffold(
          body: Center(
            child: RPinInput(
              value: '42',
              useNativeKeyboard: false,
              variant: RPinInputVariant.underlined,
            ),
          ),
        ),
      ),
    ));

    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('underlined demo tokens keep empty cells transparent',
      (tester) async {
    late RPinInputResolvedTokens tokens;
    final resolver = DemoPinInputTokenResolver();

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          tokens = resolver.resolve(
            context: context,
            spec: const RPinInputSpec(
              length: 6,
              variant: RPinInputVariant.underlined,
              animationType: RPinInputAnimationType.scale,
              animationCurve: Curves.easeIn,
              animationDuration: Duration(milliseconds: 180),
              slideTransitionBeginOffset: Offset(0.8, 0),
              obscureText: false,
              obscuringCharacter: '•',
              showCursor: true,
            ),
            state: const RPinInputState(
              isFocused: true,
              isHovered: false,
              isDisabled: false,
              isReadOnly: false,
              hasError: false,
              isCompleted: false,
              useNativeKeyboard: false,
              currentLength: 2,
            ),
          );
          return const SizedBox.shrink();
        },
      ),
    ));

    expect(tokens.followingCell.backgroundColor, Colors.transparent);
    expect(tokens.disabledCell.backgroundColor, Colors.transparent);
    expect(tokens.errorCell.backgroundColor, Colors.transparent);
  });
}
