import 'package:flutter/foundation.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

@immutable
final class RPhoneFieldCountryData {
  const RPhoneFieldCountryData({
    required this.isoCode,
    required this.countryName,
    required this.dialCode,
    required this.flagEmoji,
  });

  final IsoCode isoCode;
  final String countryName;
  final String dialCode;
  final String flagEmoji;

  String get formattedDialCode => dialCode.isEmpty ? '' : '+ $dialCode';
}
