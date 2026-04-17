import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../contracts/r_phone_field_country_selector_navigator.dart';
import '../../logic/r_phone_field_country_data_resolver.dart';
import 'menu_country_selector_data.dart';
import 'menu_country_selector_results.dart';
import 'menu_country_selector_search_field.dart';
import 'menu_country_selector_theme.dart';

final class RPhoneFieldCountryMenuPanel extends StatefulWidget {
  const RPhoneFieldCountryMenuPanel({
    required this.request,
    required this.searchFocusNode,
    required this.onCountrySelected,
    super.key,
  });

  final RPhoneFieldCountrySelectorRequest request;
  final FocusNode searchFocusNode;
  final ValueChanged<IsoCode> onCountrySelected;

  @override
  State<RPhoneFieldCountryMenuPanel> createState() =>
      _RPhoneFieldCountryMenuPanelState();
}

class _RPhoneFieldCountryMenuPanelState extends State<RPhoneFieldCountryMenuPanel> {
  late final TextEditingController _controller;
  final _resolver = const RPhoneFieldCountryDataResolver();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_handleChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleChanged)
      ..dispose();
    super.dispose();
  }

  void _handleChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final sections = resolvePhoneFieldCountryMenuSections(
      context: context,
      request: widget.request,
      resolver: _resolver,
    );
    final query = _controller.text;
    final favoriteIds = sections.favorites.map((item) => item.isoCode).toSet();
    final favorites = filterPhoneFieldCountryMenuCountries(
      countries: sections.favorites,
      query: query,
    );
    final others = filterPhoneFieldCountryMenuCountries(
      countries: sections.countries.where(
        (item) => !favoriteIds.contains(item.isoCode),
      ),
      query: query,
    );
    final showSections = query.trim().isEmpty && favorites.isNotEmpty;
    final hasResults = favorites.isNotEmpty || others.isNotEmpty;
    final theme = resolvePhoneFieldCountryMenuTheme(context, widget.request);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RPhoneFieldCountryMenuSearchField(
          controller: _controller,
          focusNode: widget.searchFocusNode,
          theme: theme,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: hasResults
              ? RPhoneFieldCountryMenuResults(
                  favorites: favorites,
                  others: others,
                  showSections: showSections,
                  selectedCountry: widget.request.selectedCountry,
                  onCountrySelected: widget.onCountrySelected,
                  theme: theme,
                )
              : _PhoneFieldCountryMenuEmptyState(
                  message: widget.request.noResultMessage ??
                      'No matching country found.',
                  theme: theme,
                ),
        ),
      ],
    );
  }
}

final class _PhoneFieldCountryMenuEmptyState extends StatelessWidget {
  const _PhoneFieldCountryMenuEmptyState({
    required this.message,
    required this.theme,
  });

  final String message;
  final RPhoneFieldCountryMenuTheme theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: theme.secondaryTextStyle,
      ),
    );
  }
}
