import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

/// Wrapper for prefix/suffix widgets with visibility mode support.
///
/// Shows/hides content based on [RTextFieldOverlayVisibilityMode] and focus state.
class CupertinoTextFieldAffix extends StatelessWidget {
  const CupertinoTextFieldAffix({
    super.key,
    required this.child,
    required this.mode,
    required this.isFocused,
  });

  final Widget? child;
  final RTextFieldOverlayVisibilityMode mode;
  final bool isFocused;

  bool get _isVisible {
    if (child == null) return false;

    switch (mode) {
      case RTextFieldOverlayVisibilityMode.never:
        return false;
      case RTextFieldOverlayVisibilityMode.always:
        return true;
      case RTextFieldOverlayVisibilityMode.whileEditing:
        return isFocused;
      case RTextFieldOverlayVisibilityMode.notEditing:
        return !isFocused;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();
    return child!;
  }
}
