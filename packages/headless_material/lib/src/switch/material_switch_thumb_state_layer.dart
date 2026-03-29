import 'package:flutter/widgets.dart';

final class MaterialSwitchThumbStateLayer extends StatelessWidget {
  const MaterialSwitchThumbStateLayer({
    super.key,
    required this.thumbCenterX,
    required this.thumbCenterY,
    required this.radius,
    required this.showStateLayer,
    required this.animationDuration,
    required this.stateLayerColor,
  });

  final double thumbCenterX;
  final double thumbCenterY;
  final double radius;
  final bool showStateLayer;
  final Duration animationDuration;
  final Color? stateLayerColor;

  @override
  Widget build(BuildContext context) {
    final diameter = radius * 2;
    return Positioned(
      left: thumbCenterX - radius,
      top: thumbCenterY - radius,
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: showStateLayer ? 1.0 : 0.0,
          duration: animationDuration,
          child: Container(
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: stateLayerColor,
            ),
          ),
        ),
      ),
    );
  }
}
