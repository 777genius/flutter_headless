import 'package:flutter/widgets.dart';

/// Простое позиционирование overlay относительно anchor rect с учетом viewport.
///
/// Цель: стабильное поведение и корректный hit-testing (в отличие от layer-based
/// follower), чтобы и в тестах, и в runtime позиция была одинаковой.
final class AnchoredOverlayPositionDelegate extends SingleChildLayoutDelegate {
  AnchoredOverlayPositionDelegate({
    required this.viewportRect,
    required this.anchorRect,
    required this.preferredWidth,
    this.padding = const EdgeInsets.all(8),
    this.minSpaceToPreferBelow = 150.0,
  });

  final Rect viewportRect;
  final Rect anchorRect;
  final double preferredWidth;
  final EdgeInsets padding;
  final double minSpaceToPreferBelow;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final leftBound = viewportRect.left + padding.left;
    final rightBound = viewportRect.right - padding.right;
    final topBound = viewportRect.top + padding.top;
    final bottomBound = viewportRect.bottom - padding.bottom;

    final maxWidth = (rightBound - leftBound).clamp(0.0, double.infinity);

    final spaceBelow =
        (bottomBound - anchorRect.bottom).clamp(0.0, double.infinity);
    final spaceAbove = (anchorRect.top - topBound).clamp(0.0, double.infinity);

    final shouldFlip =
        spaceBelow < minSpaceToPreferBelow && spaceAbove > spaceBelow;
    final maxHeight =
        (shouldFlip ? spaceAbove : spaceBelow).clamp(0.0, double.infinity);

    return BoxConstraints(
      minWidth: 0,
      maxWidth: maxWidth,
      minHeight: 0,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final leftBound = viewportRect.left + padding.left;
    final rightBound = viewportRect.right - padding.right;
    final topBound = viewportRect.top + padding.top;
    final bottomBound = viewportRect.bottom - padding.bottom;

    final width = childSize.width;
    final height = childSize.height;

    // Horizontal: align to anchor left, then shift into bounds.
    var dx = anchorRect.left;
    if (dx + width > rightBound) dx = rightBound - width;
    if (dx < leftBound) dx = leftBound;

    final spaceBelow =
        (bottomBound - anchorRect.bottom).clamp(0.0, double.infinity);
    final spaceAbove = (anchorRect.top - topBound).clamp(0.0, double.infinity);
    final shouldFlip =
        spaceBelow < minSpaceToPreferBelow && spaceAbove > spaceBelow;

    // Vertical: place below by default; flip above when needed; then clamp.
    var dy = shouldFlip ? (anchorRect.top - height) : anchorRect.bottom;
    if (dy + height > bottomBound) dy = bottomBound - height;
    if (dy < topBound) dy = topBound;

    return Offset(dx - viewportRect.left, dy - viewportRect.top);
  }

  @override
  bool shouldRelayout(covariant AnchoredOverlayPositionDelegate oldDelegate) {
    return oldDelegate.viewportRect != viewportRect ||
        oldDelegate.anchorRect != anchorRect ||
        oldDelegate.preferredWidth != preferredWidth ||
        oldDelegate.padding != padding ||
        oldDelegate.minSpaceToPreferBelow != minSpaceToPreferBelow;
  }
}
