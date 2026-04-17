import 'package:flutter/material.dart';
import 'package:headless/headless.dart';
import 'package:headless_autocomplete/r_autocomplete_style.dart';

import 'autocomplete_demo_countries.dart';
import 'autocomplete_demo_shell_card.dart';
import 'autocomplete_demo_scoped_theme.dart';
import 'autocomplete_demo_team_filter_item.dart';

class AutocompleteDemoTeamFilterShellCard extends StatefulWidget {
  const AutocompleteDemoTeamFilterShellCard({super.key});

  @override
  State<AutocompleteDemoTeamFilterShellCard> createState() =>
      _AutocompleteDemoTeamFilterShellCardState();
}

class _AutocompleteDemoTeamFilterShellCardState
    extends State<AutocompleteDemoTeamFilterShellCard> {
  List<AutocompleteDemoCountry> _selected = [
    autocompleteDemoCountries[1],
    autocompleteDemoCountries[2],
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF7C5CFF),
      brightness: Brightness.light,
    );

    return AutocompleteDemoShellCard(
      title: 'Team Filter',
      caption:
          'Multi-select chips with pinned markets and compact filter flow.',
      kicker: 'Selected values',
      modeLabel: 'Multi-select',
      colorScheme: scheme,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF9F5FF), Color(0xFFF5EEFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFDCCCF9)),
      ),
      child: RAutocomplete<AutocompleteDemoCountry>.multiple(
        key: const ValueKey('autocomplete-shell-team-filter'),
        source: RAutocompleteLocalSource(
          options: filterAutocompleteDemoCountries,
        ),
        itemAdapter: autocompleteDemoCountryRichAdapter,
        selectedValues: _selected,
        onSelectionChanged: (values) => setState(() => _selected = values),
        placeholder: 'Filter launch markets',
        semanticLabel: 'Team filter autocomplete',
        maxOptions: 6,
        pinSelectedOptions: true,
        selectedValuesPresentation:
            RAutocompleteSelectedValuesPresentation.chips,
        fieldSlots: RTextFieldSlots(
          leading: Icon(Icons.filter_list_rounded, color: scheme.primary),
        ),
        style: RAutocompleteStyle(
          field: RAutocompleteFieldStyle(
            containerPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            containerBackgroundColor: Colors.white.withValues(alpha: 0.92),
            containerBorderColor: const Color(0xFFDCCCF9),
            containerBorderWidth: 1.4,
            containerRadius: 24,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            placeholderColor: const Color(0xFF7B689C),
            minSize: const Size(0, 58),
          ),
          options: RAutocompleteOptionsStyle(
            optionsBackgroundColor: const Color(0xFFFFFDFF),
            optionsBorderColor: const Color(0xFFE2D8F6),
            optionsElevation: 8,
            optionsRadius: 22,
            optionsMaxHeight: 300,
            optionsPadding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
            optionPadding: EdgeInsets.zero,
            optionMinHeight: 0,
          ),
        ),
        menuSlots: RDropdownButtonSlots(
          menuSurface: Decorate((ctx, child) {
            return Theme(
              data: autocompleteDemoScopedTheme(context, scheme),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDFF),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE2D8F6)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x147C5CFF),
                      blurRadius: 24,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: child,
              ),
            );
          }),
          item: Decorate((ctx, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              child: child,
            );
          }),
          itemContent: Replace((ctx) {
            return AutocompleteDemoTeamFilterItem(
              item: ctx.item,
              colorScheme: scheme,
              isSelected: ctx.isSelected,
              isHighlighted: ctx.isHighlighted,
            );
          }),
        ),
      ),
    );
  }
}
