import 'package:flutter/material.dart';

import '../../contracts/r_pin_input_renderer.dart';
import '../../contracts/r_pin_input_types.dart';

Widget buildDemoPinInputTransition({
  required RPinInputSpec spec,
  required Animation<double> animation,
  required Widget child,
}) {
  switch (spec.animationType) {
    case RPinInputAnimationType.none:
      return child;
    case RPinInputAnimationType.scale:
      return ScaleTransition(scale: animation, child: child);
    case RPinInputAnimationType.fade:
      return FadeTransition(opacity: animation, child: child);
    case RPinInputAnimationType.slide:
      return SlideTransition(
        position: Tween<Offset>(
          begin: spec.slideTransitionBeginOffset,
          end: Offset.zero,
        ).animate(animation),
        child: FadeTransition(opacity: animation, child: child),
      );
    case RPinInputAnimationType.rotation:
      return RotationTransition(
        turns: Tween<double>(begin: 0.85, end: 1.0).animate(animation),
        child: FadeTransition(opacity: animation, child: child),
      );
  }
}
