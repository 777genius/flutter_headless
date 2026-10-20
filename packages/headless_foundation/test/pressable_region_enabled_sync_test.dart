import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/headless_foundation.dart';

void main() {
  testWidgets('enabled flip synchronizes the pressable controller', (
    tester,
  ) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    final hostKey = GlobalKey<_PressableHostState>();

    await tester.pumpWidget(
      _wrap(
        key: hostKey,
        focusNode: focusNode,
        enabled: false,
      ),
    );
    expect(hostKey.currentState!.controller.state.isDisabled, isTrue);

    await tester.pumpWidget(
      _wrap(
        key: hostKey,
        focusNode: focusNode,
        enabled: true,
      ),
    );
    expect(hostKey.currentState!.controller.state.isDisabled, isFalse);

    await tester.pumpWidget(
      _wrap(
        key: hostKey,
        focusNode: focusNode,
        enabled: false,
      ),
    );
    expect(hostKey.currentState!.controller.state.isDisabled, isTrue);
  });

  testWidgets(
    'rebuild with flipped enabled does not notify listeners during build',
    (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      final hostKey = GlobalKey<_PressableHostState>();

      await tester.pumpWidget(
        _wrap(
          key: hostKey,
          focusNode: focusNode,
          enabled: false,
        ),
      );

      // Mirrors a component whose surface re-enables on parent rebuild
      // (e.g. a button whose onPressed returns after a busy state).
      await tester.pumpWidget(
        _wrap(
          key: hostKey,
          focusNode: focusNode,
          enabled: true,
        ),
      );

      expect(tester.takeException(), isNull);
    },
  );
}

Widget _wrap({
  required GlobalKey<_PressableHostState> key,
  required FocusNode focusNode,
  required bool enabled,
}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: _PressableHost(
      key: key,
      focusNode: focusNode,
      enabled: enabled,
    ),
  );
}

class _PressableHost extends StatefulWidget {
  const _PressableHost({
    required this.focusNode,
    required this.enabled,
    super.key,
  });

  final FocusNode focusNode;
  final bool enabled;

  @override
  State<_PressableHost> createState() => _PressableHostState();
}

class _PressableHostState extends State<_PressableHost> {
  late final HeadlessPressableController controller;

  @override
  void initState() {
    super.initState();
    controller = HeadlessPressableController(isDisabled: !widget.enabled)
      ..addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller
      ..removeListener(_onControllerChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HeadlessPressableRegion(
      controller: controller,
      focusNode: widget.focusNode,
      autofocus: false,
      enabled: widget.enabled,
      onActivate: () {},
      child: const SizedBox(width: 100, height: 40),
    );
  }
}
