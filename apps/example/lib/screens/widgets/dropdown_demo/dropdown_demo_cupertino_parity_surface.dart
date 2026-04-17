import 'package:flutter/cupertino.dart';

class DropdownDemoCupertinoParitySurface extends StatelessWidget {
  const DropdownDemoCupertinoParitySurface({
    required this.label,
    required this.isOpen,
    super.key,
  });

  final String label;
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    final separator = CupertinoDynamicColor.resolve(
      CupertinoColors.separator,
      context,
    );
    final fill = CupertinoDynamicColor.resolve(
      CupertinoColors.tertiarySystemFill,
      context,
    );
    final textColor = CupertinoDynamicColor.resolve(
      CupertinoColors.label,
      context,
    );
    final textStyle = TextStyle(
      inherit: false,
      color: textColor,
      fontSize: 17,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none,
    );
    final width = _surfaceWidth(
      label: label,
      style: textStyle,
      textDirection: Directionality.of(context),
    );

    return SizedBox(
      width: width,
      height: 44,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: separator),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  label,
                  style: textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              AnimatedRotation(
                turns: isOpen ? 0.5 : 0,
                duration: const Duration(milliseconds: 160),
                child: Icon(
                  CupertinoIcons.chevron_down,
                  color: textColor,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _surfaceWidth({
    required String label,
    required TextStyle style,
    required TextDirection textDirection,
  }) {
    final painter = TextPainter(
      text: TextSpan(text: label, style: style),
      textDirection: textDirection,
      maxLines: 1,
    )..layout();
    return painter.width + 14 + 14 + 10 + 16 + 2;
  }
}

class DropdownDemoCupertinoNativeTrigger extends StatelessWidget {
  const DropdownDemoCupertinoNativeTrigger({
    required this.label,
    required this.onPressed,
    this.controlKey,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final Key? controlKey;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: DropdownDemoCupertinoParitySurface(
          key: controlKey,
          label: label,
          isOpen: false,
        ),
      ),
    );
  }
}

class DropdownDemoCupertinoHeadlessAnchor extends StatelessWidget {
  const DropdownDemoCupertinoHeadlessAnchor({
    required this.label,
    required this.isOpen,
    this.controlKey,
    super.key,
  });

  final String label;
  final bool isOpen;
  final Key? controlKey;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: DropdownDemoCupertinoParitySurface(
        key: controlKey,
        label: label,
        isOpen: isOpen,
      ),
    );
  }
}
