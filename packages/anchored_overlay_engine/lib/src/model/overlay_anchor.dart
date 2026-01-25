import 'package:flutter/widgets.dart';

@immutable
final class OverlayAnchor {
  const OverlayAnchor({
    required this.rect,
  });

  final Rect Function() rect;
}
