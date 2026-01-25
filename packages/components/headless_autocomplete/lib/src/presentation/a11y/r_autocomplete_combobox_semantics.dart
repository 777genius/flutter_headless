import 'package:flutter/widgets.dart';

import 'r_autocomplete_highlight_live_region.dart';

/// Combobox semantics wrapper for `RAutocomplete`.
///
/// Keeps the `textField + expanded` semantics on the root, but also exposes the
/// currently highlighted option via a live region (so screen readers can
/// announce highlight changes).
final class RAutocompleteComboboxSemantics extends StatelessWidget {
  const RAutocompleteComboboxSemantics({
    required this.enabled,
    required this.readOnly,
    required this.expanded,
    required this.label,
    required this.activeDescendantLabel,
    required this.child,
    super.key,
  });

  final bool enabled;
  final bool readOnly;
  final bool expanded;
  final String? label;
  final String? activeDescendantLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      enabled: enabled,
      readOnly: readOnly,
      expanded: expanded,
      label: label,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          child,
          RAutocompleteHighlightLiveRegion(
            isActive: expanded,
            label: activeDescendantLabel,
          ),
        ],
      ),
    );
  }
}

