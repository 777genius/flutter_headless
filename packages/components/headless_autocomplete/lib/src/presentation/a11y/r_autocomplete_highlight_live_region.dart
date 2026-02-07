import 'package:flutter/widgets.dart';

/// Live region announcing the currently highlighted autocomplete option.
///
/// This is a pragmatic Flutter analogue to web's `aria-activedescendant`:
/// input focus stays on the text field, but screen readers get updates about
/// the active option.
final class RAutocompleteHighlightLiveRegion extends StatelessWidget {
  const RAutocompleteHighlightLiveRegion({
    required this.isActive,
    required this.label,
    super.key,
  });

  final bool isActive;
  final String? label;

  @override
  Widget build(BuildContext context) {
    if (!isActive) return const SizedBox.shrink();
    final value = label;
    if (value == null || value.trim().isEmpty) return const SizedBox.shrink();

    return IgnorePointer(
      child: Semantics(
        container: true,
        liveRegion: true,
        label: value,
        child: const SizedBox.shrink(),
      ),
    );
  }
}
