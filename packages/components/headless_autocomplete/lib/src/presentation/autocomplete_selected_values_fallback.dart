import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

/// Fallback selected-values rendering for multi-select.
///
/// Used when `RAutocompleteSelectedValuesRenderer` capability is missing.
final class AutocompleteSelectedValuesFallback extends StatelessWidget {
  const AutocompleteSelectedValuesFallback({
    required this.selectedItems,
    super.key,
  });

  final List<HeadlessListItemModel> selectedItems;

  @override
  Widget build(BuildContext context) {
    final text = selectedItems.map((i) => i.primaryText).join(', ');
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

