import 'package:headless_foundation/headless_foundation.dart';

/// Builds a [HeadlessListItemModel] from an item using the adapter.
///
/// If [additionalFeatures] is provided, it will be merged with the adapter's
/// features. Additional features take precedence on collision.
HeadlessListItemModel buildAutocompleteItemModel<T>({
  required HeadlessItemAdapter<T> adapter,
  required T value,
  required ListboxItemId id,
  HeadlessItemFeatures? additionalFeatures,
}) {
  final primaryText = adapter.primaryText(value);
  assert(primaryText.trim().isNotEmpty);

  final source = adapter.searchText?.call(value) ?? primaryText;
  final normalizedText = HeadlessTypeaheadLabel.normalize(primaryText);
  final normalizedSource = HeadlessTypeaheadLabel.normalize(source);
  final typeaheadLabel =
      normalizedSource.isEmpty ? normalizedText : normalizedSource;

  // Merge adapter features with additional features
  final adapterFeatures = adapter.features?.call(value);
  final features = _mergeFeatures(adapterFeatures, additionalFeatures);

  return HeadlessListItemModel(
    id: id,
    primaryText: primaryText,
    typeaheadLabel: typeaheadLabel,
    isDisabled: adapter.isDisabled?.call(value) ?? false,
    semanticsLabel: adapter.semanticsLabel?.call(value),
    leading: adapter.leading?.call(value),
    title: adapter.title?.call(value),
    subtitle: adapter.subtitle?.call(value),
    trailing: adapter.trailing?.call(value),
    features: features,
  );
}

/// Merges two feature sets, with [additional] taking precedence.
HeadlessItemFeatures? _mergeFeatures(
  HeadlessItemFeatures? base,
  HeadlessItemFeatures? additional,
) {
  if (additional == null) return base;
  if (base == null) return additional;
  return base.merge(additional);
}
