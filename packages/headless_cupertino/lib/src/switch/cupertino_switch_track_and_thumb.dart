import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';

/// Cupertino switch visuals: track + thumb with press/drag "stretch" parity.
///
/// Visual-only: no callbacks, no gesture recognition.
final class CupertinoSwitchTrackAndThumb extends StatefulWidget {
  const CupertinoSwitchTrackAndThumb({
    super.key,
    required this.tokens,
    required this.trackColor,
    required this.thumbColor,
    required this.thumbIcon,
    required this.thumbIconColor,
    required this.hasIcon,
    required this.isDragging,
    required this.isPressed,
    required this.isRtl,
    required this.positionT,
    required this.reactionDuration,
    required this.thumbSlideDuration,
    required this.slots,
    required this.spec,
    required this.state,
  });

  final RSwitchResolvedTokens tokens;
  final Color trackColor;
  final Color thumbColor;
  final Widget? thumbIcon;
  final Color thumbIconColor;
  final bool hasIcon;

  final bool isDragging;
  final bool isPressed;
  final bool isRtl;

  /// Current thumb position 0..1 (already accounts for drag vs toggle state).
  final double positionT;

  final Duration reactionDuration;
  final Duration thumbSlideDuration;

  final RSwitchSlots? slots;
  final RSwitchSpec spec;
  final RSwitchState state;

  @override
  State<CupertinoSwitchTrackAndThumb> createState() =>
      _CupertinoSwitchTrackAndThumbState();
}

final class _CupertinoSwitchTrackAndThumbState
    extends State<CupertinoSwitchTrackAndThumb>
    with TickerProviderStateMixin {
  static const _thumbExtensionFactor = 7.0; // Flutter: _kThumbExtensionFactor

  late final AnimationController _reactionController;
  late final AnimationController _positionController;

  double _fromT = 0.0;
  double _toT = 0.0;

  @override
  void initState() {
    super.initState();

    _reactionController = AnimationController(
      vsync: this,
      duration: widget.reactionDuration,
      reverseDuration: widget.reactionDuration,
    );

    _positionController = AnimationController(
      vsync: this,
      duration: widget.thumbSlideDuration,
    );

    _fromT = widget.positionT;
    _toT = widget.positionT;

    _syncReaction();
  }

  @override
  void didUpdateWidget(covariant CupertinoSwitchTrackAndThumb oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.reactionDuration != widget.reactionDuration) {
      _reactionController.duration = widget.reactionDuration;
      _reactionController.reverseDuration = widget.reactionDuration;
    }
    if (oldWidget.thumbSlideDuration != widget.thumbSlideDuration) {
      _positionController.duration = widget.thumbSlideDuration;
    }

    if (!widget.isDragging && widget.positionT != oldWidget.positionT) {
      _fromT = _currentPositionT();
      _toT = widget.positionT;
      _positionController.forward(from: 0);
    }

    _syncReaction();
  }

  void _syncReaction() {
    final wantsPressed = widget.isPressed || widget.isDragging;
    if (widget.isDragging) {
      _reactionController.value = 1.0;
      return;
    }
    if (wantsPressed) {
      _reactionController.forward();
    } else {
      _reactionController.reverse();
    }
  }

  double _currentPositionT() {
    if (widget.isDragging) return widget.positionT;
    if (_positionController.isAnimating) {
      return lerpDouble(_fromT, _toT, _positionController.value)!;
    }
    return widget.positionT;
  }

  @override
  void dispose() {
    _positionController.dispose();
    _reactionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = widget.tokens;

    return AnimatedBuilder(
      animation: Listenable.merge([_reactionController, _positionController]),
      builder: (context, _) {
        final t = _currentPositionT().clamp(0.0, 1.0);
        final visualPosition = widget.isRtl ? 1.0 - t : t;

        final thumbDiameter = tokens.thumbSizeSelected.width;
        final extension = _reactionController.value * _thumbExtensionFactor;
        final thumbSize = Size(thumbDiameter + extension, thumbDiameter);

        final trackRadius = tokens.trackSize.height / 2.0;
        final trackInnerLength = tokens.trackSize.width - trackRadius * 2;

        final additionalThumbRadius = thumbSize.height / 2 - trackRadius;
        final horizontalProgress =
            visualPosition * (trackInnerLength - extension);
        final thumbLeft = trackRadius +
            (extension / 2) -
            thumbSize.width / 2 +
            horizontalProgress;
        final thumbTop = -additionalThumbRadius;

        final defaultThumb = _CupertinoThumb(
          size: thumbSize,
          color: widget.thumbColor,
          icon: widget.thumbIcon,
          iconColor: widget.thumbIconColor,
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

        final defaultTrack = ClipRRect(
          borderRadius: tokens.trackBorderRadius,
          child: Container(
            width: tokens.trackSize.width,
            height: tokens.trackSize.height,
            decoration: BoxDecoration(
              color: widget.trackColor,
              borderRadius: tokens.trackBorderRadius,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(left: thumbLeft, top: thumbTop, child: thumb),
              ],
            ),
          ),
        );

        return widget.slots?.track != null
            ? widget.slots!.track!.build(
                RSwitchTrackContext(
                  spec: widget.spec,
                  state: widget.state,
                  child: defaultTrack,
                ),
                (_) => defaultTrack,
              )
            : defaultTrack;
      },
    );
  }
}

final class _CupertinoThumb extends StatelessWidget {
  const _CupertinoThumb({
    required this.size,
    required this.color,
    required this.icon,
    required this.iconColor,
  });

  final Size size;
  final Color color;
  final Widget? icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size.height / 2),
        boxShadow: const [
          // Flutter: _kSwitchBoxShadows
          BoxShadow(
            color: Color(0x26000000),
            offset: Offset(0, 3),
            blurRadius: 8.0,
          ),
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(0, 3),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: icon != null
          ? Center(
              child: IconTheme(
                data: IconThemeData(
                  color: iconColor,
                  size: math.min(16, size.height * 0.6),
                ),
                child: icon!,
              ),
            )
          : null,
    );
  }
}

