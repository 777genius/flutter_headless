import 'package:flutter/widgets.dart';

import '../contracts/r_pin_input_overrides.dart';

final class RPinInputStyle {
  const RPinInputStyle({
    this.cellWidth,
    this.cellHeight,
    this.cellGap,
    this.cellBorderRadius,
    this.cellBorderWidth,
    this.textStyle,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
    this.cursorColor,
    this.errorStyle,
    this.errorColor,
    this.errorTopSpacing,
  });

  final double? cellWidth;
  final double? cellHeight;
  final double? cellGap;
  final double? cellBorderRadius;
  final double? cellBorderWidth;
  final TextStyle? textStyle;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? cursorColor;
  final TextStyle? errorStyle;
  final Color? errorColor;
  final double? errorTopSpacing;

  RPinInputOverrides toOverrides() {
    return RPinInputOverrides.tokens(
      cellWidth: cellWidth,
      cellHeight: cellHeight,
      cellGap: cellGap,
      cellBorderRadius: cellBorderRadius,
      cellBorderWidth: cellBorderWidth,
      textStyle: textStyle,
      textColor: textColor,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      cursorColor: cursorColor,
      errorStyle: errorStyle,
      errorColor: errorColor,
      errorTopSpacing: errorTopSpacing,
    );
  }
}
