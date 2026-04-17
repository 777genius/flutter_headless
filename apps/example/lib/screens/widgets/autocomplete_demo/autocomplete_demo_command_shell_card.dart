import 'package:flutter/material.dart';
import 'package:headless/headless.dart';
import 'package:headless_autocomplete/r_autocomplete_style.dart';

import 'autocomplete_demo_command_item.dart';
import 'autocomplete_demo_countries.dart';
import 'autocomplete_demo_shell_card.dart';
import 'autocomplete_demo_scoped_theme.dart';

class AutocompleteDemoCommandShellCard extends StatelessWidget {
  const AutocompleteDemoCommandShellCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF74F08A),
      brightness: Brightness.dark,
    );

    return AutocompleteDemoShellCard(
      title: 'Command Palette',
      caption: 'Dark operational search with stronger highlighting and badges.',
      kicker: 'Slots + surface',
      modeLabel: 'Dark shell',
      colorScheme: scheme,
      decoration: BoxDecoration(
        color: const Color(0xFF0F1713),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF2D4635)),
      ),
      child: RAutocomplete<AutocompleteDemoCountry>(
        key: const ValueKey('autocomplete-shell-command'),
        source: RAutocompleteLocalSource(
          options: filterAutocompleteDemoCountries,
        ),
        itemAdapter: autocompleteDemoCountryRichAdapter,
        onSelected: (_) {},
        placeholder: 'Search operational market',
        semanticLabel: 'Command palette autocomplete',
        maxOptions: 5,
        fieldSlots: RTextFieldSlots(
          leading: Icon(Icons.terminal_rounded, color: scheme.primary),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'LIVE',
              style: TextStyle(
                color: scheme.primary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
        style: RAutocompleteStyle(
          field: RAutocompleteFieldStyle(
            containerPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
            containerBackgroundColor: const Color(0xFF111C16),
            containerBorderColor: const Color(0xFF2D4635),
            containerBorderWidth: 1.3,
            containerRadius: 20,
            textStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
            textColor: const Color(0xFFE7F8E4),
            placeholderColor: const Color(0xFF85A38E),
            minSize: const Size(0, 58),
          ),
          options: RAutocompleteOptionsStyle(
            optionsBackgroundColor: const Color(0xFF111C16),
            optionsBorderColor: const Color(0xFF2D4635),
            optionsElevation: 10,
            optionsRadius: 22,
            optionsMaxHeight: 280,
            optionsPadding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
            optionPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            optionMinHeight: 54,
          ),
        ),
        menuSlots: RDropdownButtonSlots(
          menuSurface: Decorate((ctx, child) {
            return Theme(
              data: autocompleteDemoScopedTheme(context, scheme),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF111C16),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFF2D4635)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 32,
                      offset: Offset(0, 18),
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
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: ctx.isHighlighted
                      ? const Color(0x1F74F08A)
                      : ctx.isSelected
                          ? const Color(0x1638C874)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ctx.isHighlighted
                        ? const Color(0x3374F08A)
                        : Colors.transparent,
                  ),
                ),
                child: child,
              ),
            );
          }),
          itemContent: Replace((ctx) {
            return AutocompleteDemoCommandItem(
              item: ctx.item,
              colorScheme: scheme,
            );
          }),
        ),
      ),
    );
  }
}
