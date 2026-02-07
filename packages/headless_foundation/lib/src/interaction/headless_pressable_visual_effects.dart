import 'package:flutter/widgets.dart';

/// Visual-only events emitted by [HeadlessPressableRegion].
///
/// These events are intended for renderer-specific visual effects
/// (e.g., ripples, pressed highlights) without triggering activation.
@immutable
sealed class HeadlessPressableVisualEvent {
  const HeadlessPressableVisualEvent();
}

final class HeadlessPressableVisualPointerDown
    extends HeadlessPressableVisualEvent {
  const HeadlessPressableVisualPointerDown({
    required this.localPosition,
    required this.globalPosition,
  });

  final Offset localPosition;
  final Offset globalPosition;
}

final class HeadlessPressableVisualPointerUp
    extends HeadlessPressableVisualEvent {
  const HeadlessPressableVisualPointerUp({
    required this.localPosition,
    required this.globalPosition,
  });

  final Offset localPosition;
  final Offset globalPosition;
}

final class HeadlessPressableVisualPointerCancel
    extends HeadlessPressableVisualEvent {
  const HeadlessPressableVisualPointerCancel();
}

final class HeadlessPressableVisualHoverChange
    extends HeadlessPressableVisualEvent {
  const HeadlessPressableVisualHoverChange({
    required this.isHovered,
  });

  final bool isHovered;
}

final class HeadlessPressableVisualFocusChange
    extends HeadlessPressableVisualEvent {
  const HeadlessPressableVisualFocusChange({
    required this.isFocused,
  });

  final bool isFocused;
}

/// Controller that carries visual-only events to renderers.
///
/// Renderers can listen to this controller and drive animations
/// without owning activation logic.
final class HeadlessPressableVisualEffectsController extends ChangeNotifier {
  HeadlessPressableVisualEvent? _lastEvent;
  HeadlessPressableVisualEvent? get lastEvent => _lastEvent;

  void pointerDown({
    required Offset localPosition,
    required Offset globalPosition,
  }) {
    _emit(HeadlessPressableVisualPointerDown(
      localPosition: localPosition,
      globalPosition: globalPosition,
    ));
  }

  void pointerUp({
    required Offset localPosition,
    required Offset globalPosition,
  }) {
    _emit(HeadlessPressableVisualPointerUp(
      localPosition: localPosition,
      globalPosition: globalPosition,
    ));
  }

  void pointerCancel() {
    _emit(const HeadlessPressableVisualPointerCancel());
  }

  void hoverChanged(bool isHovered) {
    _emit(HeadlessPressableVisualHoverChange(isHovered: isHovered));
  }

  void focusChanged(bool isFocused) {
    _emit(HeadlessPressableVisualFocusChange(isFocused: isFocused));
  }

  void _emit(HeadlessPressableVisualEvent event) {
    _lastEvent = event;
    notifyListeners();
  }
}
