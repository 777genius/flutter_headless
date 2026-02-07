import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';

/// Builds a [ButtonStyle] delta from [RButtonOverrides].
///
/// Maps contract-level overrides to Material's ButtonStyle properties:
/// - `textStyle` → `ButtonStyle.textStyle`
/// - `foregroundColor` → `ButtonStyle.foregroundColor`
/// - `backgroundColor` → `ButtonStyle.backgroundColor`
/// - `padding` → `ButtonStyle.padding`
/// - `minSize` → `ButtonStyle.minimumSize`
/// - `borderRadius` → `ButtonStyle.shape` (RoundedRectangleBorder)
/// - `borderColor` → `ButtonStyle.side` (OutlinedButton only)
abstract final class MaterialParityButtonStyleFactory {
  static ButtonStyle? fromOverrides(
    RenderOverrides? overrides, {
    required bool isOutlined,
  }) {
    if (overrides == null) return null;
    final buttonOverrides = overrides.get<RButtonOverrides>();
    if (buttonOverrides == null || !buttonOverrides.hasOverrides) return null;

    return ButtonStyle(
      textStyle: buttonOverrides.textStyle != null
          ? WidgetStatePropertyAll(buttonOverrides.textStyle)
          : null,
      foregroundColor: buttonOverrides.foregroundColor != null
          ? WidgetStatePropertyAll(buttonOverrides.foregroundColor!)
          : null,
      backgroundColor: buttonOverrides.backgroundColor != null
          ? WidgetStatePropertyAll(buttonOverrides.backgroundColor!)
          : null,
      padding: buttonOverrides.padding != null
          ? WidgetStatePropertyAll(buttonOverrides.padding!)
          : null,
      minimumSize: buttonOverrides.minSize != null
          ? WidgetStatePropertyAll(buttonOverrides.minSize!)
          : null,
      shape: buttonOverrides.borderRadius != null
          ? WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: buttonOverrides.borderRadius!,
              ),
            )
          : null,
      side: isOutlined && buttonOverrides.borderColor != null
          ? WidgetStatePropertyAll(
              BorderSide(color: buttonOverrides.borderColor!),
            )
          : null,
    );
  }
}
