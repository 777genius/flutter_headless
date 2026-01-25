import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'material_switch_thumb_animation.dart';
import 'material_switch_track.dart';

/// Internal widget that renders the track + thumb (with animations) and provides
/// the thumb center for state-layer positioning.
final class MaterialSwitchTrackAndThumb extends StatefulWidget {
  const MaterialSwitchTrackAndThumb({
    super.key,
    required this.tokens,
    required this.trackColor,
    required this.outlineColor,
    required this.outlineWidth,
    required this.thumbColor,
    required this.thumbIcon,
    required this.thumbIconColor,
    required this.hasIcon,
    required this.isDragging,
    required this.isPressed,
    required this.isRtl,
    required this.visualValue,
    required this.dragT,
    required this.animationDuration,
    required this.thumbToggleDuration,
    required this.stateLayerColor,
    required this.showStateLayer,
    required this.slots,
    required this.spec,
    required this.state,
  });

  final RSwitchResolvedTokens tokens;

  final Color trackColor;
  final Color outlineColor;
  final double outlineWidth;

  final Color thumbColor;
  final Widget? thumbIcon;
  final Color thumbIconColor;
  final bool hasIcon;

  final bool isDragging;
  final bool isPressed;
  final bool isRtl;

  final bool visualValue;
  final double? dragT;

  final Duration animationDuration;
  final Duration thumbToggleDuration;

  final Color? stateLayerColor;
  final bool showStateLayer;

  final RSwitchSlots? slots;
  final RSwitchSpec spec;
  final RSwitchState state;

  @override
  State<MaterialSwitchTrackAndThumb> createState() =>
      _MaterialSwitchTrackAndThumbState();
}

final class _MaterialSwitchTrackAndThumbState
    extends State<MaterialSwitchTrackAndThumb>
    with TickerProviderStateMixin {
  late final AnimationController _pressController;
  late final AnimationController _toggleController;

  bool? _lastVisualValue;
  bool _toggleToSelected = false;

  @override
  void initState() {
    super.initState();
    _lastVisualValue = widget.visualValue;

    _pressController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      reverseDuration: widget.animationDuration,
    );

    _toggleController = AnimationController(
      vsync: this,
      duration: widget.thumbToggleDuration,
    );

    _syncPressAnimation();
  }

  @override
  void didUpdateWidget(covariant MaterialSwitchTrackAndThumb oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animationDuration != widget.animationDuration) {
      _pressController.duration = widget.animationDuration;
      _pressController.reverseDuration = widget.animationDuration;
    }

    if (oldWidget.thumbToggleDuration != widget.thumbToggleDuration) {
      _toggleController.duration = widget.thumbToggleDuration;
    }

    final last = _lastVisualValue;
    if (last != null &&
        last != widget.visualValue &&
        !widget.isDragging &&
        widget.dragT == null) {
      _toggleToSelected = widget.visualValue;
      _toggleController.forward(from: 0);
    }
    _lastVisualValue = widget.visualValue;

    _syncPressAnimation();
  }

  void _syncPressAnimation() {
    final wantsPressed = widget.isPressed || widget.isDragging;
    if (wantsPressed) {
      _pressController.forward();
    } else {
      _pressController.reverse();
    }
  }

  @override
  void dispose() {
    _toggleController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pressController, _toggleController]),
      builder: (context, _) {
        final positionValue = resolveMaterialSwitchPositionValue(
          isDragging: widget.isDragging,
          dragT: widget.dragT,
          visualValue: widget.visualValue,
          isToggleAnimating: _toggleController.isAnimating,
          toggleControllerValue: _toggleController.value,
          toggleToSelected: _toggleToSelected,
        );
        final effectivePosition =
            widget.isRtl ? 1 - positionValue : positionValue;

        final baseSize = resolveMaterialSwitchBaseThumbSize(
          tokens: widget.tokens,
          hasIcon: widget.hasIcon,
          isDragging: widget.isDragging,
          dragT: widget.dragT,
          visualValue: widget.visualValue,
          isToggleAnimating: _toggleController.isAnimating,
          toggleToSelected: _toggleToSelected,
          positionValue: positionValue,
        );
        final pressedSize = widget.tokens.thumbSizePressed;
        final thumbSize =
            Size.lerp(baseSize, pressedSize, _pressController.value)!;

        final trackRadius = widget.tokens.trackSize.height / 2.0;
        final trackInnerLength = widget.tokens.trackSize.width - trackRadius * 2;

        final trackCenterX = trackRadius + trackInnerLength * effectivePosition;
        final thumbLeft = trackCenterX - thumbSize.width / 2;
        final thumbTop =
            (widget.tokens.trackSize.height - thumbSize.height) / 2;

        // Flutter M3 uses the thumb's *height* to define the circular center
        // (important during transitional non-square sizes like 34×22).
        final thumbCircleCenterX = thumbLeft + thumbSize.height / 2;
        final thumbCircleCenterY = thumbTop + thumbSize.height / 2;

        final defaultThumb = SizedBox(
          width: thumbSize.width,
          height: thumbSize.height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: widget.thumbColor,
              shape: BoxShape.circle,
            ),
            child: widget.thumbIcon != null
                ? IconTheme(
                    data: IconThemeData(
                      size: 16,
                      color: widget.thumbIconColor,
                    ),
                    child: Center(child: widget.thumbIcon),
                  )
                : null,
          ),
        );

        final thumb = widget.slots?.thumb != null
            ? widget.slots!.thumb!.build(
                RSwitchThumbContext(
                  spec: widget.spec,
                  state: widget.state,
                  child: defaultThumb,
                ),
                (_) => defaultThumb,
              )
            : defaultThumb;

        final defaultTrack = _buildTrack(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _buildStateLayer(
                thumbCenterX: thumbCircleCenterX,
                thumbCenterY: thumbCircleCenterY,
              ),
              Positioned(left: thumbLeft, top: thumbTop, child: thumb),
            ],
          ),
        );

        final track = widget.slots?.track != null
            ? widget.slots!.track!.build(
                RSwitchTrackContext(
                  spec: widget.spec,
                  state: widget.state,
                  child: defaultTrack,
                ),
                (_) => defaultTrack,
              )
            : defaultTrack;

        return track;
      },
    );
  }

  Widget _buildTrack({required Widget child}) {
    return MaterialSwitchTrack(
      size: widget.tokens.trackSize,
      borderRadius: widget.tokens.trackBorderRadius,
      trackColor: widget.trackColor,
      outlineColor: widget.outlineColor,
      outlineWidth: widget.outlineWidth,
      isDragging: widget.isDragging,
      animationDuration: widget.animationDuration,
      child: child,
    );
  }

  Widget _buildStateLayer({
    required double thumbCenterX,
    required double thumbCenterY,
  }) {
    final radius = widget.tokens.stateLayerRadius;
    final diameter = radius * 2;

    return Positioned(
      left: thumbCenterX - radius,
      top: thumbCenterY - radius,
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: widget.showStateLayer ? 1.0 : 0.0,
          duration: widget.animationDuration,
          child: Container(
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.stateLayerColor,
            ),
          ),
        ),
      ),
    );
  }
}

