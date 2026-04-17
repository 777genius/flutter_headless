import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_pinput/headless_pinput.dart';
import 'package:headless_theme/headless_theme.dart';

class _TestPinInputRenderer implements RPinInputRenderer {
  @override
  Widget render(RPinInputRenderRequest request) {
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

final class _FakeCodeRetriever implements RPinInputCodeRetriever {
  _FakeCodeRetriever();

  int disposeCalls = 0;

  @override
  bool get listenForMultipleCodes => false;

  @override
  Future<String?> getCode() async => null;

  @override
  Future<void> dispose() async {
    disposeCalls++;
  }
}

Widget testHarness(Widget child) {
  return MaterialApp(
    home: HeadlessThemeProvider(
      theme: _TestTheme(_TestPinInputRenderer()),
      child: Scaffold(
        body: Center(child: child),
      ),
    ),
  );
}

void main() {
  testWidgets('replaces and disposes old code retrievers', (tester) async {
    final firstRetriever = _FakeCodeRetriever();
    final secondRetriever = _FakeCodeRetriever();

    await tester.pumpWidget(testHarness(
      RPinInput(
        codeRetriever: firstRetriever,
        onChanged: (_) {},
      ),
    ));

    await tester.pumpWidget(testHarness(
      RPinInput(
        codeRetriever: secondRetriever,
        onChanged: (_) {},
      ),
    ));

    expect(firstRetriever.disposeCalls, 1);
    expect(secondRetriever.disposeCalls, 0);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    expect(secondRetriever.disposeCalls, 1);
  });
}
