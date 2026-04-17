import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../contracts/r_phone_field_types.dart';

final class RPhoneFieldValidator {
  const RPhoneFieldValidator._();

  static RPhoneNumberValidator compose(
    List<RPhoneNumberValidator> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }

  static RPhoneNumberValidator required({
    String errorText = 'Enter a phone number',
  }) {
    return (value) => value.nsn.trim().isEmpty ? errorText : null;
  }

  static RPhoneNumberValidator valid({
    String errorText = 'Enter a valid phone number',
  }) {
    return (value) {
      if (value.nsn.trim().isEmpty || value.isValid()) return null;
      return errorText;
    };
  }

  static RPhoneNumberValidator validMobile({
    String errorText = 'Enter a valid mobile phone number',
  }) {
    return (value) {
      if (value.nsn.trim().isEmpty ||
          value.isValid(type: PhoneNumberType.mobile)) {
        return null;
      }
      return errorText;
    };
  }

  static RPhoneNumberValidator validFixedLine({
    String errorText = 'Enter a valid fixed line phone number',
  }) {
    return (value) {
      if (value.nsn.trim().isEmpty ||
          value.isValid(type: PhoneNumberType.fixedLine)) {
        return null;
      }
      return errorText;
    };
  }

  static RPhoneNumberValidator validCountry(
    List<IsoCode> countries, {
    String errorText = 'Selected country is not allowed',
  }) {
    return (value) => countries.contains(value.isoCode) ? null : errorText;
  }
}
