import 'package:flutter/material.dart';

import '../../contracts/r_pin_input_renderer.dart';
import '../../contracts/r_pin_input_resolved_tokens.dart';
import '../../contracts/r_pin_input_types.dart';
import 'demo_pin_input_cursor.dart';
import 'demo_pin_input_transition.dart';

final class DemoPinInputCellView extends StatelessWidget {
  const DemoPinInputCellView({
    super.key,
    required this.spec,
    required this.cell,
    required this.resolvedTokens,
    required this.tokens,
  });

  final RPinInputSpec spec;
  final RPinInputCell cell;
  final RPinInputResolvedTokens resolvedTokens;
  final RPinInputCellResolvedTokens tokens;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: spec.animationDuration,
      curve: spec.animationCurve,
      width: tokens.size.width,
      height: tokens.size.height,
      padding: tokens.padding,
      decoration: _decoration(),
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: spec.animationDuration,
        switchInCurve: spec.animationCurve,
        switchOutCurve: spec.animationCurve,
        transitionBuilder: (child, animation) {
          return buildDemoPinInputTransition(
            spec: spec,
            animation: animation,
            child: child,
          );
        },
        child: _child(),
      ),
    );
  }

  Decoration _decoration() {
    switch (tokens.chromeKind) {
      case RPinInputCellChromeKind.box:
        return BoxDecoration(
          color: tokens.backgroundColor,
          borderRadius: tokens.borderRadius,
          border: Border.all(
            color: tokens.borderColor,
            width: tokens.borderWidth,
          ),
          boxShadow: tokens.boxShadows,
        );
      case RPinInputCellChromeKind.underline:
        return BoxDecoration(
          color: tokens.backgroundColor,
          border: Border(
            bottom: BorderSide(
              color: tokens.borderColor,
              width: tokens.borderWidth,
            ),
          ),
        );
    }
  }

  Widget _child() {
    if (cell.showCursor) {
      return DemoPinInputCursor(
        key: ValueKey('cursor-${cell.index}-${cell.state.name}'),
        tokens: resolvedTokens,
        cellSize: tokens.size,
      );
    }

    return Text(
      cell.displayText,
      key: ValueKey('${cell.index}-${cell.displayText}-${cell.state.name}'),
      style: tokens.textStyle.copyWith(color: tokens.textColor),
      textAlign: TextAlign.center,
    );
  }
}
