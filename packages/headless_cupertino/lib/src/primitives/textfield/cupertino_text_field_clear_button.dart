import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';

/// Cupertino-styled clear button for text fields.
///
/// Shows/hides based on [RTextFieldOverlayVisibilityMode] and field state.
/// Uses CupertinoIcons.clear_thick_circled with 6px horizontal padding
/// (matching Flutter's CupertinoTextField).
class CupertinoTextFieldClearButton extends StatelessWidget {
  const CupertinoTextFieldClearButton({
    super.key,
    required this.mode,
    required this.hasText,
    required this.isFocused,
    required this.onClear,
    this.isDisabled = false,
    this.isReadOnly = false,
    this.iconColor,
  });

  final RTextFieldOverlayVisibilityMode mode;
  final bool hasText;
  final bool isFocused;
  final bool isDisabled;
  final bool isReadOnly;
  final VoidCallback? onClear;
  final Color? iconColor;

  bool get _isVisible {
    // Per I34 docs: show only if hasText && !isDisabled && !isReadOnly
    if (!hasText || isDisabled || isReadOnly) return false;

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

    final effectiveColor =
        iconColor ?? CupertinoColors.placeholderText.resolveFrom(context);

    return GestureDetector(
      onTap: onClear,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Icon(
          CupertinoIcons.clear_thick_circled,
          size: 18.0,
          color: effectiveColor,
        ),
      ),
    );
  }
}
