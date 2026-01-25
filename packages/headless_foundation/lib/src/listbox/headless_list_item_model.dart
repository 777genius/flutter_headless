import 'package:flutter/foundation.dart';

import 'headless_content.dart';
import 'headless_item_features.dart';
import 'listbox_item_id.dart';
import 'typeahead_label.dart';

@immutable
final class HeadlessListItemModel {
  HeadlessListItemModel({
    required this.id,
    required this.primaryText,
    required this.typeaheadLabel,
    this.isDisabled = false,
    this.semanticsLabel,
    HeadlessContent? title,
    this.leading,
    this.subtitle,
    this.trailing,
    HeadlessItemFeatures? features,
  })  : title = title ?? HeadlessContent.text(primaryText),
        features = features ?? HeadlessItemFeatures.empty,
        assert(primaryText.trim().isNotEmpty),
        assert(typeaheadLabel.trim().isNotEmpty),
        assert(
          HeadlessTypeaheadLabel.normalize(typeaheadLabel) == typeaheadLabel,
        );

  final ListboxItemId id;
  final String primaryText;
  final String typeaheadLabel;
  final bool isDisabled;
  final String? semanticsLabel;
  final HeadlessContent? leading;
  final HeadlessContent title;
  final HeadlessContent? subtitle;
  final HeadlessContent? trailing;
  final HeadlessItemFeatures features;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HeadlessListItemModel &&
        other.id == id &&
        other.primaryText == primaryText &&
        other.typeaheadLabel == typeaheadLabel &&
        other.isDisabled == isDisabled &&
        other.semanticsLabel == semanticsLabel &&
        other.leading == leading &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.trailing == trailing &&
        other.features == features;
  }

  @override
  int get hashCode => Object.hash(
        id,
        primaryText,
        typeaheadLabel,
        isDisabled,
        semanticsLabel,
        leading,
        title,
        subtitle,
        trailing,
        features,
      );
}
