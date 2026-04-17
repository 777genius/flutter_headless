import 'package:flutter/widgets.dart';

import 'r_pin_input_types.dart';

enum RPinInputCellChromeKind {
  box,
  underline,
}

enum RPinInputCursorKind {
  bar,
  bottomBar,
}

@immutable
final class RPinInputCellResolvedTokens {
  const RPinInputCellResolvedTokens({
    required this.chromeKind,
    required this.size,
    required this.padding,
    required this.textStyle,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.boxShadows,
  });

  final RPinInputCellChromeKind chromeKind;
  final Size size;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;
  final List<BoxShadow> boxShadows;
}

@immutable
final class RPinInputResolvedTokens {
  const RPinInputResolvedTokens({
    required this.defaultCell,
    required this.focusedCell,
    required this.submittedCell,
    required this.followingCell,
    required this.disabledCell,
    required this.errorCell,
    required this.cellGap,
    required this.cursorColor,
    required this.cursorKind,
    required this.cursorWidth,
    required this.cursorHeightFactor,
    required this.cursorBottomInset,
    required this.errorStyle,
    required this.errorColor,
    required this.errorTopSpacing,
  });

  final RPinInputCellResolvedTokens defaultCell;
  final RPinInputCellResolvedTokens focusedCell;
  final RPinInputCellResolvedTokens submittedCell;
  final RPinInputCellResolvedTokens followingCell;
  final RPinInputCellResolvedTokens disabledCell;
  final RPinInputCellResolvedTokens errorCell;
  final double cellGap;
  final Color cursorColor;
  final RPinInputCursorKind cursorKind;
  final double cursorWidth;
  final double cursorHeightFactor;
  final double cursorBottomInset;
  final TextStyle errorStyle;
  final Color errorColor;
  final double errorTopSpacing;

  RPinInputCellResolvedTokens cellTokensFor(RPinInputCellStateType state) {
    switch (state) {
      case RPinInputCellStateType.focused:
        return focusedCell;
      case RPinInputCellStateType.submitted:
        return submittedCell;
      case RPinInputCellStateType.following:
        return followingCell;
      case RPinInputCellStateType.disabled:
        return disabledCell;
      case RPinInputCellStateType.error:
        return errorCell;
    }
  }
}
