import 'package:phone_numbers_parser/metadata.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

int? resolvePhoneFieldCountryMaxLength(IsoCode isoCode) {
  final maxMobileLength = metadataLenghtsByIsoCode[isoCode]?.mobile.last;
  final maxFixedLength = metadataLenghtsByIsoCode[isoCode]?.fixedLine.last;

  if (maxMobileLength == null && maxFixedLength == null) {
    return null;
  }
  if (maxMobileLength != null && maxMobileLength > (maxFixedLength ?? 0)) {
    return maxMobileLength;
  }
  return maxFixedLength;
}

PhoneNumber limitPhoneFieldLength(
  PhoneNumber value, {
  required int? maxDigits,
}) {
  if (maxDigits == null || value.nsn.length <= maxDigits) {
    return value;
  }
  return PhoneNumber(
    isoCode: value.isoCode,
    nsn: value.nsn.substring(0, maxDigits),
  );
}
