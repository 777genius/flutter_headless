import 'package:flutter/foundation.dart';

import 'listbox_item_id.dart';

@immutable
final class ListboxState {
  const ListboxState({
    this.highlightedId,
    this.selectedId,
  });

  final ListboxItemId? highlightedId;
  final ListboxItemId? selectedId;

  ListboxState copyWith({
    ListboxItemId? highlightedId,
    ListboxItemId? selectedId,
  }) {
    return ListboxState(
      highlightedId: highlightedId ?? this.highlightedId,
      selectedId: selectedId ?? this.selectedId,
    );
  }
}
