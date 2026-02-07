import 'package:flutter/material.dart';

import 'package:headless_material/primitives.dart';

class MaterialDropdownTrigger extends StatelessWidget {
  const MaterialDropdownTrigger({
    super.key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.border,
    required this.borderRadius,
    required this.padding,
    required this.textStyle,
    required this.minSize,
    required this.displayText,
    required this.chevron,
    required this.animationDuration,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final BoxBorder? border;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  final Size minSize;
  final String displayText;
  final Widget chevron;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minSize.width,
        minHeight: minSize.height,
      ),
      child: MaterialSurface(
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        border: border,
        padding: padding,
        animationDuration: animationDuration,
        child: Row(
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                displayText,
                style: textStyle.copyWith(color: foregroundColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            chevron,
          ],
        ),
      ),
    );
  }
}
