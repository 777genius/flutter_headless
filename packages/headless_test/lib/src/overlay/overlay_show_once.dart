import 'package:anchored_overlay_engine/anchored_overlay_engine.dart';
import 'package:flutter/widgets.dart';

final class OverlayShowOnce extends StatefulWidget {
  const OverlayShowOnce({
    super.key,
    required this.controller,
    required this.onHandle,
    required this.builder,
    this.dismissPolicy = DismissPolicy.modal,
    this.focusPolicy = const NonModalFocusPolicy(),
    this.restoreFocus,
  });

  final OverlayController controller;
  final ValueChanged<OverlayHandle> onHandle;
  final WidgetBuilder builder;
  final DismissPolicy dismissPolicy;
  final FocusPolicy focusPolicy;
  final FocusNode? restoreFocus;

  @override
  State<OverlayShowOnce> createState() => _OverlayShowOnceState();
}

class _OverlayShowOnceState extends State<OverlayShowOnce> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final handle = widget.controller.show(
        OverlayRequest(
          overlayBuilder: widget.builder,
          dismiss: widget.dismissPolicy,
          focus: widget.focusPolicy,
          restoreFocus: widget.restoreFocus,
        ),
      );
      widget.onHandle(handle);
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
