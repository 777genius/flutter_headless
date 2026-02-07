import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../lifecycle/overlay_phase.dart';
import '../policies/overlay_focus_policy.dart';
import '../policies/overlay_barrier_policy.dart';
import '../positioning/anchored_overlay_layout.dart';
import '../positioning/anchored_overlay_position_delegate.dart';
import 'overlay_hit_test_tag.dart';

/// Overlay content with optional barrier.
class OverlayContent extends StatefulWidget {
  const OverlayContent({
    required this.phase,
    required this.builder,
    required this.onBarrierTap,
    required this.focusPolicy,
    required this.focusScopeNode,
    required this.onFocusLoss,
    required this.barrierPolicy,
    this.onEscapePressed,
    this.anchorRectGetter,
    this.restoreFocus,
    super.key,
  });

  final OverlayPhase phase;
  final WidgetBuilder builder;
  final VoidCallback? onBarrierTap;
  final VoidCallback? onFocusLoss;
  final VoidCallback? onEscapePressed;
  final FocusPolicy focusPolicy;
  final FocusScopeNode focusScopeNode;
  final OverlayBarrierPolicy barrierPolicy;
  final Rect Function()? anchorRectGetter;
  final FocusNode? restoreFocus;

  @override
  State<OverlayContent> createState() => _OverlayContentState();
}

class _OverlayContentState extends State<OverlayContent> {
  bool _wasFocused = false;

  @override
  Widget build(BuildContext context) {
    final content = widget.builder(context);

    final trapped = switch (widget.focusPolicy) {
      ModalFocusPolicy(:final trap) => trap,
      NonModalFocusPolicy() => false,
    };
    final isModal = widget.focusPolicy is ModalFocusPolicy;
    final shouldAutofocus =
        isModal || (!isModal && widget.restoreFocus == null);

    final focusTraversalWrapped = trapped
        ? FocusTraversalGroup(
            policy: _LoopingTraversalPolicy(),
            child: content,
          )
        : content;

    final barrierEnabled = widget.barrierPolicy.enabled;
    final barrierDismissible =
        widget.barrierPolicy.dismissible && widget.onBarrierTap != null;

    // Mark overlay content in the hit-test tree so the host can detect
    // "outside taps" without fullscreen barriers.
    final Widget menuBody = MetaData(
      metaData: overlayHitTestTag,
      behavior: HitTestBehavior.deferToChild,
      child: focusTraversalWrapped,
    );

    final focusWrapped = FocusScope(
      node: widget.focusScopeNode,
      // Non-modal overlays must not steal focus from the trigger/anchor.
      // But overlays without a restoreFocus must still be keyboard-dismissible.
      autofocus: shouldAutofocus,
      // Keep focus participation enabled so children can receive focus and
      // focus-loss dismissal can work without stealing focus eagerly.
      canRequestFocus: true,
      skipTraversal: !isModal,
      onKeyEvent: widget.onEscapePressed != null
          ? (node, event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.escape) {
                widget.onEscapePressed!();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            }
          : null,
      onFocusChange: (hasFocus) {
        if (!mounted) return;

        if (hasFocus) {
          _wasFocused = true;
          return;
        }

        if (_wasFocused && widget.onFocusLoss != null) {
          widget.onFocusLoss!.call();
        }
      },
      child: menuBody,
    );

    final Widget contentBody;
    final anchorRect = widget.anchorRectGetter?.call();
    if (anchorRect == null) {
      contentBody = Center(child: focusWrapped);
    } else {
      final mq = MediaQuery.of(context);
      final viewportRectGlobal = computeOverlayViewportRect(mq);
      final preferredWidth = anchorRect.width;

      // Важно: Positioned нельзя заворачивать в Focus/Semantics, поэтому
      // используем Padding + local coords (без ParentDataWidget).
      final viewportPadding = EdgeInsets.fromLTRB(
        viewportRectGlobal.left,
        viewportRectGlobal.top,
        mq.size.width - viewportRectGlobal.right,
        mq.size.height - viewportRectGlobal.bottom,
      );

      final viewportRectLocal = Rect.fromLTWH(
        0,
        0,
        viewportRectGlobal.width,
        viewportRectGlobal.height,
      );
      final anchorRectLocal = anchorRect.shift(-viewportRectGlobal.topLeft);

      contentBody = Padding(
        padding: viewportPadding,
        child: CustomSingleChildLayout(
          delegate: AnchoredOverlayPositionDelegate(
            viewportRect: viewportRectLocal,
            anchorRect: anchorRectLocal,
            preferredWidth: preferredWidth,
            padding: EdgeInsets.zero,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: preferredWidth),
            child: focusWrapped,
          ),
        ),
      );
    }

    final useNonModalPassThroughBarrier =
        widget.focusPolicy is NonModalFocusPolicy;

    return Stack(
      fit: StackFit.loose,
      children: [
        if (barrierEnabled)
          Positioned.fill(
            child: useNonModalPassThroughBarrier
                ? const IgnorePointer(
                    child: ColoredBox(color: Color(0x00000000)),
                  )
                : ModalBarrier(
                    dismissible: barrierDismissible,
                    onDismiss: widget.onBarrierTap,
                  ),
          ),
        contentBody,
      ],
    );
  }
}

/// Traversal policy that loops внутри группы.
final class _LoopingTraversalPolicy extends WidgetOrderTraversalPolicy {
  @override
  bool next(FocusNode currentNode) {
    final moved = super.next(currentNode);
    if (moved) return true;

    final scope = currentNode.enclosingScope;
    if (scope == null) return false;

    final first = findFirstFocus(scope);
    if (first == null) return false;
    first.requestFocus();
    return true;
  }

  @override
  bool previous(FocusNode currentNode) {
    final moved = super.previous(currentNode);
    if (moved) return true;

    final scope = currentNode.enclosingScope;
    if (scope == null) return false;

    final last = findLastFocus(scope);
    last.requestFocus();
    return true;
  }
}
