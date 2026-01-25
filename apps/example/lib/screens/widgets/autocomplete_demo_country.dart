import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

@immutable
final class AutocompleteDemoCountry {
  const AutocompleteDemoCountry({
    required this.name,
    required this.isoCode,
    required this.dialCode,
    required this.flagEmoji,
  });

  final String name;
  final String isoCode;
  final String dialCode;
  final String flagEmoji;

  String get searchLabel => '$name $dialCode $isoCode';

  bool matchesQuery(String query) {
    return searchLabel.toLowerCase().contains(query);
  }
}

const autocompleteDemoCountries = <AutocompleteDemoCountry>[
  AutocompleteDemoCountry(
    name: 'Finland',
    isoCode: 'FI',
    dialCode: '+358',
    flagEmoji: '🇫🇮',
  ),
  AutocompleteDemoCountry(
    name: 'France',
    isoCode: 'FR',
    dialCode: '+33',
    flagEmoji: '🇫🇷',
  ),
  AutocompleteDemoCountry(
    name: 'Germany',
    isoCode: 'DE',
    dialCode: '+49',
    flagEmoji: '🇩🇪',
  ),
  AutocompleteDemoCountry(
    name: 'Japan',
    isoCode: 'JP',
    dialCode: '+81',
    flagEmoji: '🇯🇵',
  ),
  AutocompleteDemoCountry(
    name: 'Norway',
    isoCode: 'NO',
    dialCode: '+47',
    flagEmoji: '🇳🇴',
  ),
  AutocompleteDemoCountry(
    name: 'United States',
    isoCode: 'US',
    dialCode: '+1',
    flagEmoji: '🇺🇸',
  ),
];

Iterable<AutocompleteDemoCountry> filterAutocompleteDemoCountries(
  TextEditingValue value,
) {
  final query = value.text.trim().toLowerCase();
  if (query.isEmpty) return autocompleteDemoCountries;
  return autocompleteDemoCountries.where((country) {
    return country.matchesQuery(query);
  });
}

final autocompleteDemoCountryAdapter =
    HeadlessItemAdapter<AutocompleteDemoCountry>.simple(
  id: (country) => ListboxItemId(country.isoCode),
  titleText: (country) => country.name,
  searchText: (country) => country.searchLabel,
);

final autocompleteDemoCountryRichAdapter =
    HeadlessItemAdapter<AutocompleteDemoCountry>(
  id: (country) => ListboxItemId(country.isoCode),
  primaryText: (country) => country.name,
  searchText: (country) => country.searchLabel,
  leading: (country) => HeadlessContent.emoji(country.flagEmoji),
  subtitle: (country) => HeadlessContent.text(country.dialCode),
  trailing: (country) => HeadlessContent.text(country.isoCode),
);
