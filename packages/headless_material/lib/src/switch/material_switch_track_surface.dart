import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'material_switch_track.dart';

final class MaterialSwitchTrackSurface extends StatelessWidget {
  const MaterialSwitchTrackSurface({
    super.key,
    required this.tokens,
    required this.trackColor,
    required this.outlineColor,
    required this.outlineWidth,
    required this.isDragging,
    required this.animationDuration,
    required this.child,
  });

  final RSwitchResolvedTokens tokens;
  final Color trackColor;
  final Color outlineColor;
  final double outlineWidth;
  final bool isDragging;
  final Duration animationDuration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialSwitchTrack(
      size: tokens.trackSize,
      borderRadius: tokens.trackBorderRadius,
      trackColor: trackColor,
      outlineColor: outlineColor,
      outlineWidth: outlineWidth,
      isDragging: isDragging,
      animationDuration: animationDuration,
      child: child,
    );
  }
}
