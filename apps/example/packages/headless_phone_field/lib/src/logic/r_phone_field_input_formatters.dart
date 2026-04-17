import 'package:flutter/services.dart';

import 'allowed_characters.dart';

List<TextInputFormatter> buildPhoneFieldInputFormatters(
  List<TextInputFormatter>? inputFormatters,
) {
  return <TextInputFormatter>[
    ...?inputFormatters,
    FilteringTextInputFormatter.allow(
      RegExp(
        '[${AllowedPhoneFieldCharacters.plus}'
        '${AllowedPhoneFieldCharacters.digits}'
        '${AllowedPhoneFieldCharacters.punctuation}]',
      ),
    ),
  ];
}
