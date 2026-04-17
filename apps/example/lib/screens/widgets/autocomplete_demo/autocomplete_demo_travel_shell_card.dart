import 'package:flutter/material.dart';
import 'package:headless/headless.dart';
import 'package:headless_autocomplete/r_autocomplete_style.dart';

import 'autocomplete_demo_countries.dart';
import 'autocomplete_demo_shell_card.dart';
import 'autocomplete_demo_scoped_theme.dart';
import 'autocomplete_demo_travel_item.dart';

class AutocompleteDemoTravelShellCard extends StatelessWidget {
  const AutocompleteDemoTravelShellCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1976D2),
      brightness: Brightness.light,
    );

    return AutocompleteDemoShellCard(
      title: 'Travel Desk',
      caption: 'Rich route rows with a lighter, concierge-style menu.',
      kicker: 'Scoped theme',
      modeLabel: 'Single select',
      colorScheme: scheme,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF4FBFF), Color(0xFFEAF5FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFC7DCF3)),
      ),
      child: RAutocomplete<AutocompleteDemoCountry>(
        key: const ValueKey('autocomplete-shell-travel'),
        source: RAutocompleteLocalSource(
          options: filterAutocompleteDemoCountries,
        ),
        itemAdapter: autocompleteDemoCountryRichAdapter,
        onSelected: (_) {},
        placeholder: 'Search airport pickup',
        semanticLabel: 'Travel desk autocomplete',
        maxOptions: 6,
        fieldSlots: RTextFieldSlots(
          leading: Icon(Icons.travel_explore_rounded, color: scheme.primary),
          trailing: Icon(Icons.keyboard_arrow_down, color: scheme.primary),
        ),
        style: RAutocompleteStyle(
          field: RAutocompleteFieldStyle(
            containerPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
            containerBackgroundColor: Colors.white.withValues(alpha: 0.94),
            containerBorderColor: const Color(0xFFC5D9EF),
            containerBorderWidth: 1.4,
            containerRadius: 26,
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
            placeholderColor: const Color(0xFF5C6D83),
            minSize: const Size(0, 60),
          ),
          options: RAutocompleteOptionsStyle(
            optionsBackgroundColor: const Color(0xFFFDFEFF),
            optionsBorderColor: const Color(0xFFD4E3F2),
            optionsElevation: 8,
            optionsRadius: 24,
            optionsMaxHeight: 300,
            optionsPadding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
            optionPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 7,
            ),
            optionMinHeight: 64,
          ),
        ),
        menuSlots: RDropdownButtonSlots(
          menuSurface: Decorate((ctx, child) {
            return Theme(
              data: autocompleteDemoScopedTheme(context, scheme),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFFFFF), Color(0xFFF3F9FF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFD4E3F2)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A4C7DB0),
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
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: ctx.isHighlighted
                      ? const Color(0xFFDDEEFF)
                      : ctx.isSelected
                          ? const Color(0xFFE9F4FF)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: child,
              ),
            );
          }),
          itemContent: Replace((ctx) {
            return AutocompleteDemoTravelItem(item: ctx.item);
          }),
        ),
      ),
    );
  }
}
