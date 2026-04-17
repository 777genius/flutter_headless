import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_pinput/headless_pinput.dart';

void main() {
  test('controller extensions keep grapheme clusters intact', () {
    final controller = TextEditingController();

    controller.setPin('1👨‍👩‍👧‍👦2', maxLength: 2);
    expect(controller.text, '1👨‍👩‍👧‍👦');
    expect(controller.selection.baseOffset, controller.text.length);

    controller.deletePin();
    expect(controller.text, '1');
    expect(controller.selection.baseOffset, controller.text.length);

    controller.appendPin('🔥', maxLength: 4);
    expect(controller.text, '1🔥');
    expect(controller.selection.baseOffset, controller.text.length);

    controller.dispose();
  });
}
