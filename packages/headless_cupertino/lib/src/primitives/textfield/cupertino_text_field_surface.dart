import 'package:flutter/cupertino.dart';

/// Cupertino-styled container surface for text fields.
///
/// Provides animated decoration with background, border, and padding.
/// Follows iOS HIG for text field appearance.
class CupertinoTextFieldSurface extends StatelessWidget {
  const CupertinoTextFieldSurface({
    super.key,
    required this.child,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderRadius,
    required this.borderWidth,
    required this.padding,
    required this.animationDuration,
    this.onTap,
  });

  final Widget child;
  final Color backgroundColor;
  final Color borderColor;
  final BorderRadius borderRadius;
  final double borderWidth;
  final EdgeInsetsGeometry padding;
  final Duration animationDuration;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: animationDuration,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          border: borderColor != CupertinoColors.transparent
              ? Border.all(color: borderColor, width: borderWidth)
              : null,
        ),
        child: child,
      ),
    );
  }
}
