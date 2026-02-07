import 'package:flutter/foundation.dart';

import 'listbox_item_id.dart';

/// Метаданные элемента listbox для навигации/тайпахеда.
@immutable
final class ListboxItemMeta {
  const ListboxItemMeta({
    required this.id,
    required this.isDisabled,
    required this.typeaheadLabel,
  });

  final ListboxItemId id;
  final bool isDisabled;

  /// Строка для typeahead matching (обычно label в lower-case).
  final String typeaheadLabel;
}
