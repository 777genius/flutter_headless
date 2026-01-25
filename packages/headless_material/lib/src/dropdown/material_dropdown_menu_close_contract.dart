import 'package:flutter/material.dart';
import 'package:anchored_overlay_engine/anchored_overlay_engine.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

class MaterialDropdownMenuCloseContract extends StatefulWidget {
  const MaterialDropdownMenuCloseContract({
    super.key,
    required this.overlayPhase,
    required this.onCompleteClose,
    required this.child,
    this.motion,
  });

  final ROverlayPhase overlayPhase;
  final VoidCallback onCompleteClose;
  final Widget child;
  final RDropdownMenuMotionTokens? motion;

  @override
  State<MaterialDropdownMenuCloseContract> createState() =>
      _MaterialDropdownMenuCloseContractState();
}

class _MaterialDropdownMenuCloseContractState
    extends State<MaterialDropdownMenuCloseContract>
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
    final motion = widget.motion ?? HeadlessMotionTheme.material.dropdownMenu;
    _controller = AnimationController(
      duration: motion.enterDuration,
      reverseDuration: motion.exitDuration,
      vsync: this,
    );
    final curved = CurvedAnimation(
      parent: _controller,
      curve: motion.enterCurve,
      reverseCurve: motion.exitCurve,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(curved);
    _scaleAnimation = Tween<double>(
      begin: motion.scaleBegin,
      end: 1,
    ).animate(curved);

    if (widget.overlayPhase == ROverlayPhase.opening ||
        widget.overlayPhase == ROverlayPhase.open) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant MaterialDropdownMenuCloseContract oldWidget) {
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
