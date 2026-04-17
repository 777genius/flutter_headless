import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../logic/r_phone_field_country_data.dart';
import 'menu_country_selector_theme.dart';

final class RPhoneFieldCountryMenuResults extends StatelessWidget {
  const RPhoneFieldCountryMenuResults({
    required this.favorites,
    required this.others,
    required this.showSections,
    required this.selectedCountry,
    required this.onCountrySelected,
    required this.theme,
    super.key,
  });

  final List<RPhoneFieldCountryData> favorites;
  final List<RPhoneFieldCountryData> others;
  final bool showSections;
  final IsoCode selectedCountry;
  final ValueChanged<IsoCode> onCountrySelected;
  final RPhoneFieldCountryMenuTheme theme;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if (showSections) ...[
          RPhoneFieldCountryMenuSectionLabel(
            label: 'Favorites',
            theme: theme,
          ),
          ...favorites.map(_tile),
          const SizedBox(height: 10),
          RPhoneFieldCountryMenuSectionLabel(
            label: 'All countries',
            theme: theme,
          ),
          ...others.map(_tile),
        ] else ...[
          ...favorites.map(_tile),
          ...others.map(_tile),
        ],
      ],
    );
  }

  Widget _tile(RPhoneFieldCountryData country) {
    return RPhoneFieldCountryMenuTile(
      country: country,
      isSelected: country.isoCode == selectedCountry,
      onTap: () => onCountrySelected(country.isoCode),
      theme: theme,
    );
  }
}

final class RPhoneFieldCountryMenuSectionLabel extends StatelessWidget {
  const RPhoneFieldCountryMenuSectionLabel({
    required this.label,
    required this.theme,
    super.key,
  });

  final String label;
  final RPhoneFieldCountryMenuTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: Text(label, style: theme.sectionLabelStyle),
    );
  }
}

final class RPhoneFieldCountryMenuTile extends StatelessWidget {
  const RPhoneFieldCountryMenuTile({
    required this.country,
    required this.isSelected,
    required this.onTap,
    required this.theme,
    super.key,
  });

  final RPhoneFieldCountryData country;
  final bool isSelected;
  final VoidCallback onTap;
  final RPhoneFieldCountryMenuTheme theme;

  @override
  Widget build(BuildContext context) {
    final background = isSelected ? theme.selectedTileColor : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          key: ValueKey('phone-country-option-${country.isoCode.name}'),
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: LayoutBuilder(
                builder: (context, constraints) => _PhoneFieldCountryMenuTileRow(
                  country: country,
                  isSelected: isSelected,
                  theme: theme,
                  maxWidth: constraints.maxWidth,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _PhoneFieldCountryMenuTileRow extends StatelessWidget {
  const _PhoneFieldCountryMenuTileRow({
    required this.country,
    required this.isSelected,
    required this.theme,
    required this.maxWidth,
  });

  final RPhoneFieldCountryData country;
  final bool isSelected;
  final RPhoneFieldCountryMenuTheme theme;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    if (maxWidth < 72) {
      return Center(
        child: Text(
          country.flagEmoji,
          style: theme.primaryTextStyle.copyWith(fontSize: 18),
        ),
      );
    }

    final compact = maxWidth < 180;

    return Row(
      children: [
        Text(
          country.flagEmoji,
          style: theme.primaryTextStyle.copyWith(fontSize: 18),
        ),
        SizedBox(width: compact ? 8 : 12),
        Expanded(
          child: compact
              ? Text(
                  '${country.isoCode.name} ${country.formattedDialCode}',
                  overflow: TextOverflow.ellipsis,
                  style: theme.primaryTextStyle,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      country.countryName,
                      overflow: TextOverflow.ellipsis,
                      style: theme.primaryTextStyle,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${country.isoCode.name} • ${country.formattedDialCode}',
                      overflow: TextOverflow.ellipsis,
                      style: theme.secondaryTextStyle,
                    ),
                  ],
                ),
        ),
        if (isSelected) ...[
          SizedBox(width: compact ? 6 : 10),
          Icon(
            Icons.check_rounded,
            size: 18,
            color: theme.accentColor,
          ),
        ],
      ],
    );
  }
}
