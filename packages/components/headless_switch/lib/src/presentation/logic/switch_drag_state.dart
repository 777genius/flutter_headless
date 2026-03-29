import 'switch_drag_decider.dart';

final class SwitchDragState {
  double? dragT;
  bool? dragVisualValue;
  double travelPx = 0;
  bool needsDrag = false;

  bool get isDragging => dragT != null;

  void begin({required bool value, required bool isRtl}) {
    dragT = initialDragT(value: value, isRtl: isRtl);
    dragVisualValue = value;
    needsDrag = true;
  }

  void update({required double deltaX, required bool isRtl}) {
    final nextT = updateDragT(
      currentT: dragT!,
      deltaX: deltaX,
      travelPx: travelPx,
      isRtl: isRtl,
    );
    dragT = nextT;
    dragVisualValue = computeDragVisualValue(dragT: nextT);
  }

  bool? resolveNextValue({required double velocity, required bool isRtl}) {
    final currentDragT = dragT;
    if (currentDragT == null) return null;
    return computeNextValue(
      dragT: currentDragT,
      velocity: velocity,
      isRtl: isRtl,
    );
  }

  bool clear() {
    if (dragT == null && !needsDrag) return false;
    dragT = null;
    dragVisualValue = null;
    needsDrag = false;
    return true;
  }
}
