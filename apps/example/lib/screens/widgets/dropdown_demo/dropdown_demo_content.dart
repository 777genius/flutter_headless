import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

class DropdownDemoContent extends StatelessWidget {
  const DropdownDemoContent({
    required this.content,
    this.style,
    this.iconColor,
    super.key,
  });

  final HeadlessContent? content;
  final TextStyle? style;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final content = this.content;
    if (content == null) return const SizedBox.shrink();

    return switch (content) {
      HeadlessTextContent(:final text) => Text(text, style: style),
      HeadlessEmojiContent(:final emoji) => Text(emoji, style: style),
      HeadlessIconContent(:final icon) => Icon(
          icon,
          size: style?.fontSize,
          color: iconColor ?? style?.color,
        ),
    };
  }
}
