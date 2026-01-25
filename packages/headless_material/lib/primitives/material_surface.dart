import 'package:flutter/material.dart';

class MaterialSurface extends StatelessWidget {
  const MaterialSurface({
    super.key,
    required this.backgroundColor,
    required this.borderRadius,
    required this.padding,
    required this.animationDuration,
    required this.child,
    this.border,
  });

  final Color backgroundColor;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final Duration animationDuration;
  final Widget child;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: animationDuration,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: border,
      ),
      padding: padding,
      child: child,
    );
  }
}
