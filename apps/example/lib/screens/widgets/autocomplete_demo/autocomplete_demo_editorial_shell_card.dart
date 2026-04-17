import 'package:flutter/material.dart';
import 'package:headless/headless.dart';
import 'package:headless_autocomplete/r_autocomplete_style.dart';

import 'autocomplete_demo_countries.dart';
import 'autocomplete_demo_editorial_item.dart';
import 'autocomplete_demo_shell_card.dart';
import 'autocomplete_demo_scoped_theme.dart';

class AutocompleteDemoEditorialShellCard extends StatelessWidget {
  const AutocompleteDemoEditorialShellCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFA05A0A),
      brightness: Brightness.light,
    );

    return AutocompleteDemoShellCard(
      title: 'Editorial Minimal',
      caption: 'Sparse chrome with a narrow rhythm and cleaner typography.',
      kicker: 'Token-only',
      modeLabel: 'Minimal shell',
      colorScheme: scheme,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF4),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE6D3B6)),
      ),
      child: Container(
        padding: const EdgeInsets.only(bottom: 6),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFC38B49), width: 2),
          ),
        ),
        child: RAutocomplete<AutocompleteDemoCountry>(
          key: const ValueKey('autocomplete-shell-editorial'),
          source: RAutocompleteLocalSource(
            options: filterAutocompleteDemoCountries,
          ),
          itemAdapter: autocompleteDemoCountryRichAdapter,
          onSelected: (_) {},
          placeholder: 'Search press contact',
          semanticLabel: 'Editorial autocomplete',
          maxOptions: 5,
          fieldSlots: RTextFieldSlots(
            trailing: Text(
              'FRONT DESK',
              style: TextStyle(
                color: scheme.primary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
            ),
          ),
          style: RAutocompleteStyle(
            field: RAutocompleteFieldStyle(
              containerPadding: const EdgeInsets.symmetric(vertical: 8),
              containerBackgroundColor: Colors.transparent,
              containerBorderColor: Colors.transparent,
              containerBorderWidth: 0,
              containerRadius: 0,
              textStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
              ),
              placeholderColor: const Color(0xFF9B7A5B),
              minSize: const Size(0, 54),
            ),
            options: RAutocompleteOptionsStyle(
              optionsBackgroundColor: const Color(0xFFFFFCF8),
              optionsBorderColor: const Color(0xFFE1C49E),
              optionsElevation: 3,
              optionsRadius: 20,
              optionsMaxHeight: 280,
              optionsPadding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              optionPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 5,
              ),
              optionMinHeight: 56,
            ),
          ),
          menuSlots: RDropdownButtonSlots(
            menuSurface: Decorate((ctx, child) {
              return Theme(
                data: autocompleteDemoScopedTheme(context, scheme),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFCF8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE1C49E)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: child,
                ),
              );
            }),
            item: Decorate((ctx, child) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 1),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ctx.isHighlighted
                          ? const Color(0xFFC38B49)
                          : const Color(0x00000000),
                      width: 1.5,
                    ),
                  ),
                ),
                child: child,
              );
            }),
            itemContent: Replace((ctx) {
              return AutocompleteDemoEditorialItem(item: ctx.item);
            }),
          ),
        ),
      ),
    );
  }
}
