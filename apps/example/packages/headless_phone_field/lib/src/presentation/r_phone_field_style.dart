import 'package:flutter/material.dart';
import 'package:headless_textfield/headless_textfield.dart';

import '../contracts/r_phone_field_types.dart';

@immutable
final class RPhoneFieldStyle {
  const RPhoneFieldStyle({
    this.fieldStyle,
    this.countryButtonStyle = const RPhoneFieldCountryButtonStyle(),
    this.countryButtonPlacement = RPhoneFieldCountryButtonPlacement.leading,
  });

  final RTextFieldStyle? fieldStyle;
  final RPhoneFieldCountryButtonStyle countryButtonStyle;
  final RPhoneFieldCountryButtonPlacement countryButtonPlacement;

  RPhoneFieldStyle copyWith({
    RTextFieldStyle? fieldStyle,
    RPhoneFieldCountryButtonStyle? countryButtonStyle,
    RPhoneFieldCountryButtonPlacement? countryButtonPlacement,
  }) {
    return RPhoneFieldStyle(
      fieldStyle: fieldStyle ?? this.fieldStyle,
      countryButtonStyle: countryButtonStyle ?? this.countryButtonStyle,
      countryButtonPlacement:
          countryButtonPlacement ?? this.countryButtonPlacement,
    );
  }
}
