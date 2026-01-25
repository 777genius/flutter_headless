import 'package:flutter/cupertino.dart';

class CupertinoMenuItem extends StatelessWidget {
  const CupertinoMenuItem({
    super.key,
    required this.isDisabled,
    required this.minHeight,
    required this.padding,
    required this.backgroundColor,
    required this.onTap,
    required this.child,
  });

  final bool isDisabled;
  final double minHeight;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        color: backgroundColor,
        padding: padding,
        child: child,
      ),
    );
  }
}

