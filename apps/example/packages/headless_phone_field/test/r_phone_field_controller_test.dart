import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_phone_field/headless_phone_field.dart';

void main() {
  group('RPhoneFieldController', () {
    test('plus paste updates the detected country', () {
      final controller = RPhoneFieldController(
        initialValue: PhoneNumber.parse('+12025550148'),
      );

      controller.changeNationalNumber('+380671234567');

      expect(controller.value.isoCode, IsoCode.UA);
      expect(controller.value.nsn, isNotEmpty);
      expect(controller.textController.text, controller.value.formatNsn());
    });

    test('maxDigits trims parsed national number', () {
      final controller = RPhoneFieldController();

      controller.changeNationalNumber('123456789012345', maxDigits: 10);

      expect(controller.value.nsn.length, 10);
    });

    test('selectNationalNumber selects the whole formatted text', () {
      final controller = RPhoneFieldController(
        initialValue: PhoneNumber.parse('+380671234567'),
      );

      controller.selectNationalNumber();

      expect(controller.textController.selection.baseOffset, 0);
      expect(
        controller.textController.selection.extentOffset,
        controller.textController.text.length,
      );
    });

    test('collapseSelectionToEnd collapses selection at the formatted end', () {
      final controller = RPhoneFieldController(
        initialValue: PhoneNumber.parse('+380671234567'),
      );

      controller.selectNationalNumber();
      controller.collapseSelectionToEnd();

      expect(
        controller.textController.selection,
        TextSelection.collapsed(
          offset: controller.textController.text.length,
        ),
      );
    });
  });
}
