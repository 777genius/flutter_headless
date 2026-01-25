import 'package:flutter/material.dart';

class MaterialMenuSurface extends StatelessWidget {
  const MaterialMenuSurface({
    super.key,
    required this.backgroundColor,
    required this.border,
    required this.borderRadius,
    required this.elevation,
    required this.child,
  });

  final Color backgroundColor;
  final BoxBorder? border;
  final BorderRadius borderRadius;
  final double elevation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      elevation: elevation,
      borderRadius: borderRadius,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: border,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: child,
        ),
      ),
    );
  }
}
