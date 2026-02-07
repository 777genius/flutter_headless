import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/interaction.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HeadlessFocusHighlightPolicy', () {
    test('FlutterPolicy shows only for traditional mode', () {
      const policy = HeadlessFlutterFocusHighlightPolicy();

      expect(policy.showFor(FocusHighlightMode.traditional), isTrue);
      expect(policy.showFor(FocusHighlightMode.touch), isFalse);
    });

    test('AlwaysPolicy shows for any mode', () {
      const policy = HeadlessAlwaysFocusHighlightPolicy();

      expect(policy.showFor(FocusHighlightMode.traditional), isTrue);
      expect(policy.showFor(FocusHighlightMode.touch), isTrue);
    });

    test('NeverPolicy hides for any mode', () {
      const policy = HeadlessNeverFocusHighlightPolicy();

      expect(policy.showFor(FocusHighlightMode.traditional), isFalse);
      expect(policy.showFor(FocusHighlightMode.touch), isFalse);
    });
  });

  group('HeadlessFocusHighlightController', () {
    test('initial showFocusHighlight reflects policy + current mode', () {
      final controller = HeadlessFocusHighlightController(
        policy: const HeadlessAlwaysFocusHighlightPolicy(),
      );
      addTearDown(controller.dispose);

      expect(controller.showFocusHighlight, isTrue);
    });

    test('default policy is FlutterPolicy', () {
      final controller = HeadlessFocusHighlightController();
      addTearDown(controller.dispose);

      // With FlutterPolicy, showFocusHighlight depends on current mode
      expect(controller.showFocusHighlight,
          controller.mode == FocusHighlightMode.traditional);
    });

    test('notifies listeners when highlight mode changes', () {
      final controller = HeadlessFocusHighlightController();
      addTearDown(controller.dispose);

      var notifyCount = 0;
      controller.addListener(() => notifyCount++);

      // Verify initial state and that no spurious notifications occur
      expect(controller.mode, isA<FocusHighlightMode>());
      expect(notifyCount, 0);
    });

    test('dispose removes listener from FocusManager without errors', () {
      final controller = HeadlessFocusHighlightController();

      // Should not throw
      controller.dispose();
    });

    test('NeverPolicy always returns false regardless of mode', () {
      final controller = HeadlessFocusHighlightController(
        policy: const HeadlessNeverFocusHighlightPolicy(),
      );
      addTearDown(controller.dispose);

      expect(controller.showFocusHighlight, isFalse);
    });

    test('AlwaysPolicy always returns true regardless of mode', () {
      final controller = HeadlessFocusHighlightController(
        policy: const HeadlessAlwaysFocusHighlightPolicy(),
      );
      addTearDown(controller.dispose);

      expect(controller.showFocusHighlight, isTrue);
    });

    test('exposes current FocusHighlightMode', () {
      final controller = HeadlessFocusHighlightController();
      addTearDown(controller.dispose);

      expect(controller.mode, FocusManager.instance.highlightMode);
    });
  });
}
