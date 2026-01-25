import 'package:flutter/widgets.dart';

/// Placement of the switch relative to text content.
enum RSwitchControlAffinity {
  leading,
  trailing,
  platform,
}

/// Switch list tile specification (static, from widget props).
@immutable
final class RSwitchListTileSpec {
  const RSwitchListTileSpec({
    required this.value,
    this.semanticLabel,
    this.selected = false,
    this.selectedColor,
    this.contentPadding,
    this.controlAffinity = RSwitchControlAffinity.platform,
    this.isThreeLine = false,
    this.dense = false,
    this.hasSubtitle = false,
  }) : assert(
          !isThreeLine || hasSubtitle,
          'If isThreeLine is true, subtitle must be provided.',
        );

  final bool value;
  final String? semanticLabel;
  final bool selected;
  final Color? selectedColor;
  final EdgeInsetsGeometry? contentPadding;
  final RSwitchControlAffinity controlAffinity;
  final bool isThreeLine;
  final bool dense;
  final bool hasSubtitle;
}
