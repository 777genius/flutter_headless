import 'package:flutter/widgets.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../contracts/r_phone_field_types.dart';
import '../logic/r_phone_field_country_data.dart';
import '../logic/r_phone_field_country_data_resolver.dart';

final class RPhoneFieldCountryButtonRequestFactory {
  const RPhoneFieldCountryButtonRequestFactory();

  RPhoneFieldCountryButtonRequest create({
    required BuildContext context,
    required RPhoneFieldCountryDataResolver resolver,
    required RPhoneFieldCountryData country,
    required List<IsoCode>? countries,
    required List<IsoCode>? favoriteCountries,
    required bool enabled,
    required RPhoneFieldCountryButtonStyle style,
    required String? noResultMessage,
    required bool searchAutofocus,
    required VoidCallback onPressed,
    required ValueChanged<IsoCode> onCountrySelected,
  }) {
    final availableCountries = _resolveCountries(
      context: context,
      resolver: resolver,
      isoCodes: countries ?? IsoCode.values,
    );
    if (!availableCountries.any((item) => item.isoCode == country.isoCode)) {
      availableCountries.insert(0, country);
    }
    final availableIds = availableCountries.map((item) => item.isoCode).toSet();
    final resolvedFavorites = _resolveCountries(
      context: context,
      resolver: resolver,
      isoCodes: favoriteCountries
              ?.where((item) => availableIds.contains(item))
              .toList() ??
          const [],
    );

    return RPhoneFieldCountryButtonRequest(
      country: country,
      countries: availableCountries,
      favoriteCountries: resolvedFavorites,
      enabled: enabled,
      style: style,
      noResultMessage: noResultMessage,
      searchAutofocus: searchAutofocus,
      onPressed: onPressed,
      onCountrySelected: onCountrySelected,
    );
  }

  List<RPhoneFieldCountryData> _resolveCountries({
    required BuildContext context,
    required RPhoneFieldCountryDataResolver resolver,
    required List<IsoCode> isoCodes,
  }) {
    final resolved = <RPhoneFieldCountryData>[];
    final seen = <IsoCode>{};
    for (final isoCode in isoCodes) {
      if (!seen.add(isoCode)) continue;
      resolved.add(resolver.resolve(context, isoCode));
    }
    return resolved;
  }
}
