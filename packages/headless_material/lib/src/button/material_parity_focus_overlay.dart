import 'package:flutter/widgets.dart';

/// Focus overlay that matches M3 InkWell focus highlight.
///
/// Painted when the headless component reports focus, since
/// the parity renderer's inert FocusNode prevents InkWell
/// from painting its own focus highlight.
final class MaterialParityFocusOverlay extends StatelessWidget {
  const MaterialParityFocusOverlay({
    super.key,
    required this.color,
    required this.shape,
    required this.child,
  });

  final Color color;
  final ShapeBorder shape;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: ShapeDecoration(color: color, shape: shape),
            ),
          ),
        ),
      ],
    );
  }
}
