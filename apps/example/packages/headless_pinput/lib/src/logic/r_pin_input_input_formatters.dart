import 'package:flutter/services.dart';

List<TextInputFormatter> buildPinInputFormatters({
  required List<TextInputFormatter> inputFormatters,
  required int length,
}) {
  return <TextInputFormatter>[
    ...inputFormatters,
    LengthLimitingTextInputFormatter(
      length,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
    ),
  ];
}
