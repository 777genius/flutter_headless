import 'package:flutter/foundation.dart';

import 'headless_content.dart';
import 'headless_item_features.dart';
import 'headless_list_item_model.dart';
import 'listbox_item_id.dart';
import 'typeahead_label.dart';

@immutable
final class HeadlessItemAdapter<T> {
  const HeadlessItemAdapter({
    required this.id,
    required this.primaryText,
    this.isDisabled,
    this.semanticsLabel,
    this.searchText,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.features,
  });

  final ListboxItemId Function(T value) id;
  final String Function(T value) primaryText;
  final bool Function(T value)? isDisabled;
  final String Function(T value)? semanticsLabel;
  final String Function(T value)? searchText;
  final HeadlessContent Function(T value)? leading;
  final HeadlessContent Function(T value)? title;
  final HeadlessContent Function(T value)? subtitle;
  final HeadlessContent Function(T value)? trailing;
  final HeadlessItemFeatures Function(T value)? features;

  HeadlessListItemModel build(T value) {
    final text = primaryText(value);
    assert(text.trim().isNotEmpty);
    final source = searchText?.call(value) ?? text;
    final normalizedText = HeadlessTypeaheadLabel.normalize(text);
    final normalizedSource = HeadlessTypeaheadLabel.normalize(source);
    final typeaheadLabel =
        normalizedSource.isEmpty ? normalizedText : normalizedSource;

    return HeadlessListItemModel(
      id: id(value),
      primaryText: text,
      typeaheadLabel: typeaheadLabel,
      isDisabled: isDisabled?.call(value) ?? false,
      semanticsLabel: semanticsLabel?.call(value),
      leading: leading?.call(value),
      title: title?.call(value),
      subtitle: subtitle?.call(value),
      trailing: trailing?.call(value),
      features: features?.call(value),
    );
  }

  factory HeadlessItemAdapter.simple({
    required ListboxItemId Function(T value) id,
    required String Function(T value) titleText,
    String Function(T value)? subtitleText,
    String Function(T value)? leadingEmoji,
    String Function(T value)? semanticsLabel,
    String Function(T value)? searchText,
    bool Function(T value)? isDisabled,
    HeadlessItemFeatures Function(T value)? features,
  }) {
    return HeadlessItemAdapter(
      id: id,
      primaryText: titleText,
      semanticsLabel: semanticsLabel,
      searchText: searchText,
      isDisabled: isDisabled,
      leading: leadingEmoji == null
          ? null
          : (value) => HeadlessContent.emoji(leadingEmoji(value)),
      subtitle: subtitleText == null
          ? null
          : (value) => HeadlessContent.text(subtitleText(value)),
      features: features,
    );
  }
}
