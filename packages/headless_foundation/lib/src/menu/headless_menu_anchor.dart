import 'package:flutter/widgets.dart';

/// Value object for anchoring a menu overlay.
@immutable
final class HeadlessMenuAnchor {
  const HeadlessMenuAnchor({
    required this.anchorRectGetter,
    required this.restoreFocus,
  });

  final Rect Function() anchorRectGetter;
  final FocusNode restoreFocus;
}
