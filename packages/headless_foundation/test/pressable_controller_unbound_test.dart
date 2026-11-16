import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/headless_foundation.dart';

void main() {
  // Uses a plain Dart test (not testWidgets) and never initializes a Flutter
  // scheduler binding. The controller must work for non-widget consumers.
  test('disabled state notifies when no binding was initialized', () {
    final controller = HeadlessPressableController();
    addTearDown(controller.dispose);

    var notifications = 0;
    controller.addListener(() => notifications++);

    controller.setDisabled(true);
    expect(controller.state.isDisabled, isTrue);
    expect(notifications, 1);

    controller.setDisabled(false);
    expect(controller.state.isDisabled, isFalse);
    expect(notifications, 2);

    controller.setDisabled(false);
    expect(notifications, 2);
  });
}
