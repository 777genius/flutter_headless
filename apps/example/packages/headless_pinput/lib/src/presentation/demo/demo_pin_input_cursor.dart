import 'package:flutter/material.dart';

import '../../contracts/r_pin_input_resolved_tokens.dart';

final class DemoPinInputCursor extends StatefulWidget {
  const DemoPinInputCursor({
    super.key,
    required this.tokens,
    required this.cellSize,
  });

  final RPinInputResolvedTokens tokens;
  final Size cellSize;

  @override
  State<DemoPinInputCursor> createState() => _DemoPinInputCursorState();
}

class _DemoPinInputCursorState extends State<DemoPinInputCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 720),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.cellSize.height * widget.tokens.cursorHeightFactor;
    final cursor = Container(
      width: widget.tokens.cursorWidth,
      height: height,
      decoration: BoxDecoration(
        color: widget.tokens.cursorColor,
        borderRadius: BorderRadius.circular(widget.tokens.cursorWidth),
      ),
    );

    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      child: switch (widget.tokens.cursorKind) {
        RPinInputCursorKind.bar => cursor,
        RPinInputCursorKind.bottomBar => Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: widget.tokens.cursorBottomInset),
              child: cursor,
            ),
          ),
      },
    );
  }
}
