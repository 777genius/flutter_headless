import 'dart:ui';

import 'package:flutter/cupertino.dart';

class CupertinoPopoverSurface extends StatelessWidget {
  const CupertinoPopoverSurface({
    super.key,
    required this.backgroundColor,
    required this.backgroundOpacity,
    required this.borderRadius,
    required this.backdropBlurSigma,
    required this.shadowColor,
    required this.shadowBlurRadius,
    required this.shadowOffset,
    required this.child,
  });

  final Color backgroundColor;
  final double backgroundOpacity;
  final BorderRadius borderRadius;
  final double backdropBlurSigma;
  final Color shadowColor;
  final double shadowBlurRadius;
  final Offset shadowOffset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final resolvedBackground = CupertinoDynamicColor.resolve(
      backgroundColor,
      context,
    );
    final resolvedShadow = CupertinoDynamicColor.resolve(shadowColor, context);
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: backdropBlurSigma,
          sigmaY: backdropBlurSigma,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: resolvedBackground.withValues(alpha: backgroundOpacity),
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: resolvedShadow,
                blurRadius: shadowBlurRadius,
                offset: shadowOffset,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
