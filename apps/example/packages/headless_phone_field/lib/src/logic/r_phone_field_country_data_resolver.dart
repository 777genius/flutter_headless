import 'package:flutter/widgets.dart';
import 'package:flutter_country_selector/flutter_country_selector.dart';

import 'r_phone_field_country_data.dart';
import 'r_phone_field_country_emoji.dart';

final class RPhoneFieldCountryDataResolver {
  const RPhoneFieldCountryDataResolver();

  RPhoneFieldCountryData resolve(BuildContext context, IsoCode isoCode) {
    final localization = CountrySelectorLocalization.of(context) ??
        CountrySelectorLocalizationEn();
    return RPhoneFieldCountryData(
      isoCode: isoCode,
      countryName: localization.countryName(isoCode),
      dialCode: localization.countryDialCode(isoCode),
      flagEmoji: countryFlagEmoji(isoCode.name),
    );
  }
}
