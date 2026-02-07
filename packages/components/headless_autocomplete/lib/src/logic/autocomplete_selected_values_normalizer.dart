import 'package:headless_foundation/headless_foundation.dart';

List<T> normalizeSelectedValuesById<T>({
  required List<T> values,
  required HeadlessItemAdapter<T> adapter,
}) {
  if (values.isEmpty) return const [];
  final seen = <ListboxItemId>{};
  final result = <T>[];
  for (final v in values) {
    final id = adapter.id(v);
    if (!seen.add(id)) {
      continue;
    }
    result.add(v);
  }
  return result;
}
