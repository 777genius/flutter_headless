import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';

/// Material renderer for selected values inside multi-select autocomplete field.
final class MaterialAutocompleteSelectedValuesRenderer
    implements RAutocompleteSelectedValuesRenderer {
  const MaterialAutocompleteSelectedValuesRenderer();

  @override
  Widget render(RAutocompleteSelectedValuesRenderRequest request) {
    final override = request.overrides?.get<RAutocompleteSelectedValuesOverrides>();
    final presentation =
        override?.presentation ?? RAutocompleteSelectedValuesPresentation.chips;

    final items = request.selectedItems;
    if (items.isEmpty) return const SizedBox.shrink();

    return switch (presentation) {
      RAutocompleteSelectedValuesPresentation.commaSeparated =>
        _CommaSeparatedSelectedValues(items: items),
      RAutocompleteSelectedValuesPresentation.chips => _ChipSelectedValues(
          items: items,
          onRemoveById: request.commands.removeById,
        ),
    };
  }
}

final class _CommaSeparatedSelectedValues extends StatelessWidget {
  const _CommaSeparatedSelectedValues({
    required this.items,
  });

  final List<HeadlessListItemModel> items;

  @override
  Widget build(BuildContext context) {
    final text = items.map((i) => i.primaryText).join(', ');
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Text(
        text.isEmpty ? '' : '$text, ',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

final class _ChipSelectedValues extends StatelessWidget {
  const _ChipSelectedValues({
    required this.items,
    required this.onRemoveById,
  });

  final List<HeadlessListItemModel> items;
  final void Function(ListboxItemId id) onRemoveById;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i != 0) const SizedBox(width: 6),
            ExcludeFocus(
              child: InputChip(
                label: Text(items[i].primaryText),
                onDeleted: () => onRemoveById(items[i].id),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

