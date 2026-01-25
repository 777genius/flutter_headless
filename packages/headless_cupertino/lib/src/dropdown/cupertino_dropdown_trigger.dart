import 'package:flutter/cupertino.dart';

class CupertinoDropdownTrigger extends StatelessWidget {
  const CupertinoDropdownTrigger({
    super.key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.borderRadius,
    required this.padding,
    required this.textStyle,
    required this.minSize,
    required this.displayText,
    required this.chevron,
    required this.animationDuration,
    required this.isFocused,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  final Size minSize;
  final String displayText;
  final Widget chevron;
  final Duration animationDuration;
  final bool isFocused;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minSize.width,
        minHeight: minSize.height,
      ),
      child: AnimatedContainer(
        duration: animationDuration,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          border: Border.all(
            color: borderColor,
            width: isFocused ? 2 : 1,
          ),
        ),
        padding: padding,
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

