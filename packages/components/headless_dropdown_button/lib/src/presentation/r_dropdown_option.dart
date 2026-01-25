import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

@immutable
final class RDropdownOption<T> {
  const RDropdownOption({
    required this.value,
    required this.item,
  });

  final T value;
  final HeadlessListItemModel item;
}
