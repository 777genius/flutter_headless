import 'package:flutter/widgets.dart';

/// Placement of the checkbox relative to text content.
enum RCheckboxControlAffinity {
  leading,
  trailing,
  platform,
}

/// Checkbox list tile specification (static, from widget props).
@immutable
final class RCheckboxListTileSpec {
  const RCheckboxListTileSpec({
    required this.value,
    this.tristate = false,
    this.isError = false,
    this.semanticLabel,
    this.selected = false,
    this.selectedColor,
    this.contentPadding,
    this.controlAffinity = RCheckboxControlAffinity.platform,
    this.isThreeLine = false,
    this.dense = false,
    this.textDirection,
    this.hasSubtitle = false,
  })  : assert(
          tristate || value != null,
          'If tristate is false, value must be non-null.',
        ),
        assert(
          !isThreeLine || hasSubtitle,
          'If isThreeLine is true, subtitle must be provided.',
        );

  final bool? value;
  final bool tristate;
  final bool isError;
  final String? semanticLabel;
  final bool selected;
  final Color? selectedColor;
  final EdgeInsetsGeometry? contentPadding;
  final RCheckboxControlAffinity controlAffinity;
  final bool isThreeLine;
  final bool dense;
  final TextDirection? textDirection;
  final bool hasSubtitle;

  bool get isChecked => value == true;
  bool get isIndeterminate => tristate && value == null;
}
