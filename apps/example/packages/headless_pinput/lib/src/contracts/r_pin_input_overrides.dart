import 'package:flutter/widgets.dart';

@immutable
final class RPinInputOverrides {
  const RPinInputOverrides({
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

  const RPinInputOverrides.tokens({
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
}
