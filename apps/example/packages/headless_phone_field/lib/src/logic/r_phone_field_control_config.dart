import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'r_phone_field_controller.dart';

void validatePhoneFieldControlConfig({
  required PhoneNumber? value,
  required RPhoneFieldController? controller,
  required PhoneNumber? initialValue,
}) {
  assert(
    value == null || controller == null,
    'Provide either value or controller, not both.',
  );
  assert(
    initialValue == null || (value == null && controller == null),
    'initialValue is only supported when value and controller are null.',
  );
}
