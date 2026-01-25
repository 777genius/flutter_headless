import 'package:flutter/foundation.dart';

@immutable
final class OverlayRepositionPolicy {
  const OverlayRepositionPolicy({
    required this.enabled,
  });

  static const OverlayRepositionPolicy anchored =
      OverlayRepositionPolicy(enabled: true);
  static const OverlayRepositionPolicy none =
      OverlayRepositionPolicy(enabled: false);

  final bool enabled;
}
