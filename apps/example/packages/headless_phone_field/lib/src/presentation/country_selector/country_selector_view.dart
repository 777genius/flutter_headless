import 'package:flutter/material.dart';
import 'package:flutter_country_selector/flutter_country_selector.dart';

import '../../contracts/r_phone_field_country_selector_navigator.dart';

Widget buildPhoneFieldCountrySelectorView({
  required BuildContext context,
  required RPhoneFieldCountrySelectorRequest request,
  required ValueChanged<IsoCode> onCountrySelected,
}) {
  return Localizations.override(
    context: context,
    locale: Localizations.maybeLocaleOf(context),
    child: CountrySelector.sheet(
      countries: request.countries ?? IsoCode.values,
      favoriteCountries: request.favoriteCountries ?? const [],
      onCountrySelected: onCountrySelected,
      showDialCode: request.showDialCode,
      noResultMessage: request.noResultMessage,
      searchAutofocus: request.searchAutofocus,
      subtitleStyle: request.subtitleStyle,
      titleStyle: request.titleStyle,
      searchBoxDecoration: request.searchBoxDecoration,
      searchBoxTextStyle: request.searchBoxTextStyle,
      searchBoxIconColor: request.searchBoxIconColor,
      scrollPhysics: request.scrollPhysics,
      flagSize: request.flagSize,
    ),
  );
}
