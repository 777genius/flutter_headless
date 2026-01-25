import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Track for Material switch: fill + optional inset outline (Flutter-like).
final class MaterialSwitchTrack extends StatelessWidget {
  const MaterialSwitchTrack({
    super.key,
    required this.size,
    required this.borderRadius,
    required this.trackColor,
    required this.outlineColor,
    required this.outlineWidth,
    required this.isDragging,
    required this.animationDuration,
    required this.child,
  });

  final Size size;
  final BorderRadius borderRadius;
  final Color trackColor;
  final Color outlineColor;
  final double outlineWidth;
  final bool isDragging;
  final Duration animationDuration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final fillDecoration = BoxDecoration(
      color: trackColor,
      borderRadius: borderRadius,
    );

    if (isDragging) {
      return Container(
        width: size.width,
        height: size.height,
        decoration: fillDecoration,
        child: _TrackForegroundOutline(
          trackHeight: size.height,
          outlineColor: outlineColor,
          outlineWidth: outlineWidth,
          isDragging: true,
          animationDuration: animationDuration,
          child: child,
        ),
      );
    }

    return AnimatedContainer(
      duration: animationDuration,
      width: size.width,
      height: size.height,
      decoration: fillDecoration,
      child: _TrackForegroundOutline(
        trackHeight: size.height,
        outlineColor: outlineColor,
        outlineWidth: outlineWidth,
        isDragging: false,
        animationDuration: animationDuration,
        child: child,
      ),
    );
  }
}

final class _TrackForegroundOutline extends StatelessWidget {
  const _TrackForegroundOutline({
    required this.trackHeight,
    required this.outlineColor,
    required this.outlineWidth,
    required this.isDragging,
    required this.animationDuration,
    required this.child,
  });

  final double trackHeight;
  final Color outlineColor;
  final double outlineWidth;
  final bool isDragging;
  final Duration animationDuration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Flutter M3 paints the track outline inside the track bounds:
    // inset rect by 1px, and stroke on that inset rect.
    const outlineInset = 1.0;
    final trackRadius = trackHeight / 2.0;
    final outlineRadius = math.max(0.0, trackRadius - outlineInset);

    final outlineDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(outlineRadius),
      border: Border.all(color: outlineColor, width: outlineWidth),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (outlineWidth > 0)
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(outlineInset),
              child: isDragging
                  ? DecoratedBox(decoration: outlineDecoration)
                  : AnimatedContainer(
                      duration: animationDuration,
                      decoration: outlineDecoration,
                    ),
            ),
          ),
      ],
    );
  }
}

