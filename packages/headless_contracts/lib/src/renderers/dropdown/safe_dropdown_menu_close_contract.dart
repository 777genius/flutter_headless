import 'package:anchored_overlay_engine/anchored_overlay_engine.dart';
import 'package:flutter/widgets.dart';

import 'r_dropdown_menu_motion_tokens.dart';
import 'r_dropdown_state.dart';

@immutable
final class SafeDropdownMenuCloseContract extends StatefulWidget {
  const SafeDropdownMenuCloseContract({
    super.key,
    required this.overlayPhase,
    required this.onCompleteClose,
    required this.child,
    required this.motion,
  });

  final ROverlayPhase overlayPhase;
  final VoidCallback onCompleteClose;
  final Widget child;
  final RDropdownMenuMotionTokens motion;

  @override
  State<SafeDropdownMenuCloseContract> createState() =>
      _SafeDropdownMenuCloseContractState();
}

class _SafeDropdownMenuCloseContractState
    extends State<SafeDropdownMenuCloseContract>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final CloseContractRunner _closeContract;

  @override
  void initState() {
    super.initState();
    _closeContract = CloseContractRunner(
      onCompleteClose: widget.onCompleteClose,
    );
    _controller = AnimationController(
      duration: widget.motion.enterDuration,
      reverseDuration: widget.motion.exitDuration,
      vsync: this,
    );
    final curved = CurvedAnimation(
      parent: _controller,
      curve: widget.motion.enterCurve,
      reverseCurve: widget.motion.exitCurve,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(curved);
    _scaleAnimation = Tween<double>(
      begin: widget.motion.scaleBegin,
      end: 1,
    ).animate(curved);

    if (widget.overlayPhase == ROverlayPhase.opening ||
        widget.overlayPhase == ROverlayPhase.open) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant SafeDropdownMenuCloseContract oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.overlayPhase == ROverlayPhase.closing &&
        oldWidget.overlayPhase != ROverlayPhase.closing) {
      _closeContract.startClosing(runExitAnimation: _controller.reverse);
    } else if (widget.overlayPhase == ROverlayPhase.opening &&
        oldWidget.overlayPhase == ROverlayPhase.closed) {
      _controller.forward();
    } else if ((widget.overlayPhase == ROverlayPhase.opening ||
            widget.overlayPhase == ROverlayPhase.open) &&
        oldWidget.overlayPhase == ROverlayPhase.closing) {
      _closeContract.cancelClosing();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _closeContract.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        alignment: Alignment.topCenter,
        child: widget.child,
      ),
    );
  }
}

const safeDropdownDefaultMenuMotion = RDropdownMenuMotionTokens(
  enterDuration: Duration(milliseconds: 140),
  exitDuration: Duration(milliseconds: 100),
  enterCurve: Curves.easeOutCubic,
  exitCurve: Curves.easeInCubic,
  scaleBegin: 0.98,
);
