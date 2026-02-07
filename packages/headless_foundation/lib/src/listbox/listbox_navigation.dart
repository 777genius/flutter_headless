import 'listbox_item.dart';
import 'listbox_item_id.dart';
import 'listbox_navigation_policy.dart';

int? findIndexById(List<ListboxItem> items, ListboxItemId? id) {
  if (id == null) return null;
  for (var i = 0; i < items.length; i++) {
    if (items[i].id == id) return i;
  }
  return null;
}

int? findFirstEnabledIndex(List<ListboxItem> items) {
  for (var i = 0; i < items.length; i++) {
    if (!items[i].isDisabled) return i;
  }
  return null;
}

int? findLastEnabledIndex(List<ListboxItem> items) {
  for (var i = items.length - 1; i >= 0; i--) {
    if (!items[i].isDisabled) return i;
  }
  return null;
}

int? findNextEnabledIndex(
  List<ListboxItem> items, {
  required int fromIndex,
  required ListboxNavigationPolicy policy,
}) {
  if (items.isEmpty) return null;

  for (var step = 1; step <= items.length; step++) {
    final idx = fromIndex + step;
    final wrapped = policy.looping ? (idx % items.length) : idx;
    if (wrapped < 0 || wrapped >= items.length) return null;
    if (!items[wrapped].isDisabled) return wrapped;
  }
  return null;
}

int? findPreviousEnabledIndex(
  List<ListboxItem> items, {
  required int fromIndex,
  required ListboxNavigationPolicy policy,
}) {
  if (items.isEmpty) return null;

  for (var step = 1; step <= items.length; step++) {
    final idx = fromIndex - step;
    final wrapped = policy.looping
        ? ((idx % items.length) + items.length) % items.length
        : idx;
    if (wrapped < 0 || wrapped >= items.length) return null;
    if (!items[wrapped].isDisabled) return wrapped;
  }
  return null;
}
