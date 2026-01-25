import 'package:flutter/material.dart';

/// Internal helper for Material dropdown menu items.
///
/// Keeps gesture ownership out of public primitives.
class MaterialMenuItemTapRegion extends StatelessWidget {
  const MaterialMenuItemTapRegion({
    super.key,
    required this.isDisabled,
    required this.onTap,
    required this.child,
  });

  final bool isDisabled;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08);
        }
        if (states.contains(WidgetState.hovered)) {
          return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.04);
        }
        if (states.contains(WidgetState.focused)) {
          return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06);
        }
        return null;
      }),
      child: child,
    );
  }
}

