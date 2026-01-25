import 'package:flutter/material.dart';

class MaterialMenuItem extends StatelessWidget {
  const MaterialMenuItem({
    super.key,
    required this.minHeight,
    required this.padding,
    required this.backgroundColor,
    required this.child,
  });

  final double minHeight;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Ink(
        color: backgroundColor,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
