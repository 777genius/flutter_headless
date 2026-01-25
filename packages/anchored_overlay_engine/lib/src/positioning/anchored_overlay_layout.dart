import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Vertical placement of an anchored overlay relative to its anchor.
enum AnchoredOverlayPlacement {
  below,
  above,
}

@immutable
final class AnchoredOverlayLayout {
  const AnchoredOverlayLayout({
    required this.placement,
    required this.targetAnchor,
    required this.followerAnchor,
    required this.width,
    required this.offset,
    required this.maxHeight,
    required this.viewportRect,
  });

  final AnchoredOverlayPlacement placement;
  final Alignment targetAnchor;
  final Alignment followerAnchor;

  /// Final width for the overlay surface (clamped to viewport width).
  final double width;

  /// Offset applied to the follower to keep it within the viewport.
  final Offset offset;

  /// Maximum allowed height in the chosen placement direction.
  ///
  /// Renderers are expected to become scrollable under tight constraints.
  final double? maxHeight;

  /// The effective viewport rect used for calculations (safe area + keyboard + padding).
  final Rect viewportRect;
}

/// Computes anchored overlay layout using a small collision pipeline:
/// - choose placement (below/above) with flip
/// - shift horizontally to stay inside viewport
/// - compute maxHeight based on available vertical space
final class AnchoredOverlayLayoutCalculator {
  const AnchoredOverlayLayoutCalculator({
    this.minSpaceToPreferBelow = 150.0,
    this.edgePadding = 8.0,
  });

  /// Minimum space needed below anchor to keep placement "below".
  final double minSpaceToPreferBelow;

  /// Safety padding to keep overlay away from the viewport edge.
  final double edgePadding;

  AnchoredOverlayLayout calculate({
    required Rect viewportRect,
    required Rect anchorRect,
    required double desiredWidth,
  }) {
    final width = desiredWidth.clamp(0.0, viewportRect.width);

    final spaceBelow = viewportRect.bottom - anchorRect.bottom;
    final spaceAbove = anchorRect.top - viewportRect.top;

    final shouldFlip =
        spaceBelow < minSpaceToPreferBelow && spaceAbove > spaceBelow;
    final placement = shouldFlip
        ? AnchoredOverlayPlacement.above
        : AnchoredOverlayPlacement.below;

    final targetAnchor = shouldFlip ? Alignment.topLeft : Alignment.bottomLeft;
    final followerAnchor =
        shouldFlip ? Alignment.bottomLeft : Alignment.topLeft;

    final availableHeight = shouldFlip ? spaceAbove : spaceBelow;
    final maxHeight = availableHeight <= 0.0 ? null : availableHeight;

    // Shift horizontally to keep inside viewport.
    final desiredLeft = anchorRect.left;
    final shiftedLeft = desiredLeft.clamp(
      viewportRect.left,
      math.max(viewportRect.left, viewportRect.right - width),
    );

    return AnchoredOverlayLayout(
      placement: placement,
      targetAnchor: targetAnchor,
      followerAnchor: followerAnchor,
      width: width,
      offset: Offset(shiftedLeft - desiredLeft, 0),
      maxHeight: maxHeight,
      viewportRect: viewportRect,
    );
  }
}

/// Computes the effective viewport rect for overlay collision.
///
/// Accounts for safe area (padding) and keyboard (viewInsets.bottom).
Rect computeOverlayViewportRect(
  MediaQueryData mq, {
  double edgePadding = 8.0,
}) {
  final size = mq.size;
  final padding = mq.padding;
  final viewInsets = mq.viewInsets;

  final bottomInset = math.max(padding.bottom, viewInsets.bottom);

  final left = padding.left + edgePadding;
  final top = padding.top + edgePadding;
  final right = size.width - padding.right - edgePadding;
  final bottom = size.height - bottomInset - edgePadding;

  return Rect.fromLTRB(left, top, right, bottom);
}
