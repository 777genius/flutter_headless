import 'package:flutter/widgets.dart';

Rect resolveDropdownAnchorRect({
  required GlobalKey triggerKey,
  required Rect? lastAnchorRect,
  required ValueChanged<Rect> cacheRect,
}) {
  final renderBox = triggerKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null || !renderBox.hasSize) {
    return lastAnchorRect ?? Rect.zero;
  }
  final rect = renderBox.localToGlobal(Offset.zero) & renderBox.size;
  cacheRect(rect);
  return rect;
}
