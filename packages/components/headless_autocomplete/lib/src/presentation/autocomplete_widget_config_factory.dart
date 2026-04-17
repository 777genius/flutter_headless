import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';

import '../logic/autocomplete_config.dart';
import '../logic/autocomplete_selection_mode.dart';
import '../sources/sources.dart';
import 'r_autocomplete_style.dart';

Iterable<T> Function(TextEditingValue) buildAutocompleteLocalOptionsBuilder<T>(
  RAutocompleteSource<T> source,
) {
  final local = switch (source) {
    RAutocompleteLocalSource<T>() => source,
    RAutocompleteHybridSource<T>(:final local) => local,
    _ => null,
  };
  if (local == null) return (_) => const Iterable.empty();

  return (query) {
    final normalizedText = local.policy.query.normalize(query.text);
    if (normalizedText == null) return const Iterable.empty();
    if (normalizedText == query.text) return local.options(query);

    final newLen = normalizedText.length;
    final base = query.selection.baseOffset.clamp(0, newLen);
    final extent = query.selection.extentOffset.clamp(0, newLen);
    final normalizedQuery = query.copyWith(
      text: normalizedText,
      selection: TextSelection(baseOffset: base, extentOffset: extent),
      composing: TextRange.empty,
    );
    return local.options(normalizedQuery);
  };
}

bool resolveAutocompleteLocalCacheEnabled<T>(RAutocompleteSource<T> source) {
  final local = switch (source) {
    RAutocompleteLocalSource<T>() => source,
    RAutocompleteHybridSource<T>(:final local) => local,
    _ => null,
  };
  return local?.policy.cache ?? true;
}

AutocompleteConfig<T> createAutocompleteConfig<T>({
  required RAutocompleteSource<T> source,
  required HeadlessItemAdapter<T> itemAdapter,
  required bool disabled,
  required AutocompleteSelectionMode<T> selectionMode,
  required bool openOnFocus,
  required bool openOnInput,
  required bool openOnTap,
  required bool closeOnSelected,
  required int? maxOptions,
  required String? placeholder,
  required String? semanticLabel,
  required RDropdownButtonSlots? menuSlots,
  required RenderOverrides? menuOverrides,
  required bool clearQueryOnSelection,
  required bool hideSelectedOptions,
  required bool pinSelectedOptions,
}) {
  return AutocompleteConfig(
    optionsBuilder: buildAutocompleteLocalOptionsBuilder(source),
    localCacheEnabled: resolveAutocompleteLocalCacheEnabled(source),
    itemAdapter: itemAdapter,
    disabled: disabled,
    selectionMode: selectionMode,
    openOnFocus: openOnFocus,
    openOnInput: openOnInput,
    openOnTap: openOnTap,
    closeOnSelected: closeOnSelected,
    maxOptions: maxOptions,
    placeholder: placeholder,
    semanticLabel: semanticLabel,
    menuSlots: menuSlots,
    menuOverrides: menuOverrides,
    clearQueryOnSelection:
        selectionMode.isMultiple ? clearQueryOnSelection : false,
    hideSelectedOptions: hideSelectedOptions,
    pinSelectedOptions: pinSelectedOptions,
    source: source,
  );
}

RenderOverrides? resolveAutocompleteFieldOverrides(
  RAutocompleteStyle? style,
  RenderOverrides? overrides,
) {
  return mergeStyleIntoOverrides(
    style: style?.field,
    overrides: overrides,
    toOverride: (s) => s.toOverrides(),
  );
}

RenderOverrides? resolveAutocompleteMenuOverrides(
  RAutocompleteStyle? style,
  RenderOverrides? overrides,
) {
  return mergeStyleIntoOverrides(
    style: style?.options,
    overrides: overrides,
    toOverride: (s) => s.toOverrides(),
  );
}

Rect resolveAutocompleteAnchorRect(GlobalKey fieldKey, Rect? lastAnchorRect) {
  final renderBox = fieldKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null || !renderBox.hasSize) {
    return lastAnchorRect ?? Rect.zero;
  }
  final topLeft = renderBox.localToGlobal(Offset.zero);
  final rawRect = topLeft & renderBox.size;
  const verticalGap = 4.0;
  return Rect.fromLTRB(
    rawRect.left,
    rawRect.top - verticalGap,
    rawRect.right,
    rawRect.bottom + verticalGap,
  );
}
