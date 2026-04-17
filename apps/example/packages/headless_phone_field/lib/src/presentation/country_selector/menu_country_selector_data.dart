import 'package:flutter/widgets.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../contracts/r_phone_field_country_selector_navigator.dart';
import '../../logic/r_phone_field_country_data.dart';
import '../../logic/r_phone_field_country_data_resolver.dart';

typedef PhoneFieldCountryMenuSections = ({
  List<RPhoneFieldCountryData> countries,
  List<RPhoneFieldCountryData> favorites,
});

PhoneFieldCountryMenuSections resolvePhoneFieldCountryMenuSections({
  required BuildContext context,
  required RPhoneFieldCountrySelectorRequest request,
  required RPhoneFieldCountryDataResolver resolver,
}) {
  final countries = _resolveCountries(
    context: context,
    resolver: resolver,
    isoCodes: request.countries ?? IsoCode.values,
  );
  if (!countries.any((item) => item.isoCode == request.selectedCountry)) {
    countries.insert(0, resolver.resolve(context, request.selectedCountry));
  }

  final availableIds = countries.map((item) => item.isoCode).toSet();
  final favorites = _resolveCountries(
    context: context,
    resolver: resolver,
    isoCodes: request.favoriteCountries
            ?.where((item) => availableIds.contains(item))
            .toList() ??
        const [],
  );

  return (
    countries: countries,
    favorites: favorites,
  );
}

List<RPhoneFieldCountryData> filterPhoneFieldCountryMenuCountries({
  required Iterable<RPhoneFieldCountryData> countries,
  required String query,
}) {
  final normalizedQuery = query.trim().toLowerCase();
  if (normalizedQuery.isEmpty) {
    return countries.toList();
  }

  return countries
      .where((item) => _matchesPhoneCountry(item, normalizedQuery))
      .toList();
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

bool _matchesPhoneCountry(
  RPhoneFieldCountryData country,
  String normalizedQuery,
) {
  final haystacks = [
    country.countryName,
    country.isoCode.name,
    country.dialCode,
    country.formattedDialCode,
  ];
  return haystacks.any(
    (item) => item.toLowerCase().contains(normalizedQuery),
  );
}
