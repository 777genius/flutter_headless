import 'package:flutter/cupertino.dart';

/// Paints the Cupertino-style focus ring around the switch track.
///
/// Flutter reference:
/// - `trackRRect.inflate(1.75)`
/// - `strokeWidth = 3.5`
final class CupertinoSwitchFocusRing extends StatelessWidget {
  const CupertinoSwitchFocusRing({
    super.key,
    required this.trackSize,
    required this.focusColor,
    required this.child,
  });

  final Size trackSize;
  final Color focusColor;
  final Widget child;

  static const double _inflate = 1.75;
  static const double _strokeWidth = 3.5;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: trackSize.width + _strokeWidth * 2,
      height: trackSize.height + _strokeWidth * 2,
      child: CustomPaint(
        painter: _CupertinoSwitchFocusRingPainter(
          trackSize: trackSize,
          focusColor: focusColor,
        ),
        child: Center(child: child),
      ),
    );
  }
}

final class _CupertinoSwitchFocusRingPainter extends CustomPainter {
  const _CupertinoSwitchFocusRingPainter({
    required this.trackSize,
    required this.focusColor,
  });

  final Size trackSize;
  final Color focusColor;

  @override
  void paint(Canvas canvas, Size size) {
    final trackOffset = Offset(
      (size.width - trackSize.width) / 2,
      (size.height - trackSize.height) / 2,
    );
    final trackRect = trackOffset & trackSize;

    final trackRadius = trackSize.height / 2.0;
    final trackRRect =
        RRect.fromRectAndRadius(trackRect, Radius.circular(trackRadius));

    final focusedOutline = trackRRect.inflate(CupertinoSwitchFocusRing._inflate);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = focusColor
      ..strokeWidth = CupertinoSwitchFocusRing._strokeWidth;
    canvas.drawRRect(focusedOutline, paint);
  }

  @override
  bool shouldRepaint(covariant _CupertinoSwitchFocusRingPainter oldDelegate) {
    return oldDelegate.trackSize != trackSize ||
        oldDelegate.focusColor != focusColor;
  }
}

