import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'autocomplete_demo_country.dart';
import 'autocomplete_demo_country_item.dart';

class AutocompleteDemoRichField extends StatelessWidget {
  const AutocompleteDemoRichField({
    required this.onSelected,
    super.key,
  });

  final ValueChanged<AutocompleteDemoCountry> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor = theme.colorScheme.onSurfaceVariant;

    return RAutocomplete<AutocompleteDemoCountry>(
      source: RAutocompleteLocalSource(
        options: filterAutocompleteDemoCountries,
      ),
      itemAdapter: autocompleteDemoCountryRichAdapter,
      onSelected: onSelected,
      placeholder: 'Search by country or code',
      semanticLabel: 'Country and code search',
      maxOptions: 6,
      fieldSlots: RTextFieldSlots(
        leading: Icon(Icons.search, color: hintColor),
      ),
      menuSlots: RDropdownButtonSlots(
        itemContent: Replace(
          (ctx) => AutocompleteDemoCountryItem(
            item: ctx.item,
            isSelected: ctx.isSelected,
          ),
        ),
        emptyState: Replace(
          (_) => Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'No matches',
              style: theme.textTheme.bodySmall?.copyWith(color: hintColor),
            ),
          ),
        ),
      ),
    );
  }
}
