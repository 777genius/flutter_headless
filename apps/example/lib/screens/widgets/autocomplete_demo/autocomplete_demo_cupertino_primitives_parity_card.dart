import 'package:flutter/cupertino.dart';
import 'package:headless/headless.dart';

import '../cupertino_demo_parity_card.dart';
import 'autocomplete_demo_countries.dart';

class AutocompleteDemoCupertinoPrimitivesParityCard extends StatefulWidget {
  const AutocompleteDemoCupertinoPrimitivesParityCard({super.key});

  @override
  State<AutocompleteDemoCupertinoPrimitivesParityCard> createState() =>
      _AutocompleteDemoCupertinoPrimitivesParityCardState();
}

class _AutocompleteDemoCupertinoPrimitivesParityCardState
    extends State<AutocompleteDemoCupertinoPrimitivesParityCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Iterable<AutocompleteDemoCountry> get _results {
    final query = _controller.text.trim().toLowerCase();
    if (query.isEmpty) {
      return autocompleteDemoCountries.take(4);
    }
    return autocompleteDemoCountries.where((country) {
      return country.matchesQuery(query);
    }).take(4);
  }

  @override
  Widget build(BuildContext context) {
    final secondary = CupertinoDynamicColor.resolve(
      CupertinoColors.secondaryLabel,
      context,
    );
    final separator = CupertinoDynamicColor.resolve(
      CupertinoColors.separator,
      context,
    );
    final fill = CupertinoDynamicColor.resolve(
      CupertinoColors.secondarySystemGroupedBackground,
      context,
    );

    return CupertinoDemoParityCard(
      title: 'Cupertino primitives',
      caption:
          'Flutter has no single Cupertino autocomplete widget. The native path is search field plus a filtered result list.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CupertinoDemoParityLabel('Flutter Native Composition'),
          const SizedBox(height: 12),
          SizedBox(
            width: 360,
            child: CupertinoSearchTextField(
              controller: _controller,
              placeholder: 'Search country or dial code',
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 360,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: separator),
            ),
            child: Column(
              children: [
                for (final country in _results)
                  _CupertinoCountryRow(country: country),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const CupertinoDemoParityLabel('RAutocomplete<T>'),
          const SizedBox(height: 12),
          SizedBox(
            width: 360,
            child: RAutocomplete<AutocompleteDemoCountry>(
              key: const Key('autocomplete-parity-field'),
              source: RAutocompleteLocalSource(
                options: filterAutocompleteDemoCountries,
              ),
              itemAdapter: autocompleteDemoCountryRichAdapter,
              onSelected: (_) {},
              placeholder: 'Search country or dial code',
              semanticLabel: 'Cupertino parity autocomplete',
              maxOptions: 4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This is our RAutocomplete widget on the active header preset. The native Cupertino side needs manual search field plus result list orchestration.',
            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  color: secondary,
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }
}

class _CupertinoCountryRow extends StatelessWidget {
  const _CupertinoCountryRow({required this.country});

  final AutocompleteDemoCountry country;

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoDynamicColor.resolve(
      CupertinoColors.label,
      context,
    );
    final secondary = CupertinoDynamicColor.resolve(
      CupertinoColors.secondaryLabel,
      context,
    );
    final separator = CupertinoDynamicColor.resolve(
      CupertinoColors.separator,
      context,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: separator),
        ),
      ),
      child: Row(
        children: [
          Text(
            country.flagEmoji,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              country.name,
              style: TextStyle(
                color: labelColor,
                fontSize: 17,
              ),
            ),
          ),
          Text(
            country.dialCode,
            style: TextStyle(
              color: secondary,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
