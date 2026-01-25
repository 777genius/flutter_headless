import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

class AutocompleteDemoContent extends StatelessWidget {
  const AutocompleteDemoContent({
    required this.content,
    this.style,
    super.key,
  });

  final HeadlessContent? content;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final content = this.content;
    if (content == null) return const SizedBox.shrink();
    return switch (content) {
      HeadlessTextContent(:final text) => Text(text, style: style),
      HeadlessEmojiContent(:final emoji) => Text(emoji, style: style),
      HeadlessIconContent(:final icon) => Icon(icon, size: style?.fontSize),
    };
  }
}
