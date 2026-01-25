import 'package:flutter/foundation.dart';

import 'listbox_item_id.dart';

@immutable
final class ListboxItem {
  const ListboxItem({
    required this.id,
    required this.label,
    this.isDisabled = false,
  });

  final ListboxItemId id;
  final String label;
  final bool isDisabled;
}

