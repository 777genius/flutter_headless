import 'package:flutter/widgets.dart';

sealed class HeadlessContent {
  const HeadlessContent();

  const factory HeadlessContent.text(String text) = HeadlessTextContent;
  const factory HeadlessContent.emoji(String emoji) = HeadlessEmojiContent;
  const factory HeadlessContent.icon(IconData icon) = HeadlessIconContent;
}

final class HeadlessTextContent extends HeadlessContent {
  const HeadlessTextContent(this.text);

  final String text;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeadlessTextContent && other.text == text;

  @override
  int get hashCode => text.hashCode;
}

final class HeadlessEmojiContent extends HeadlessContent {
  const HeadlessEmojiContent(this.emoji);

  final String emoji;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeadlessEmojiContent && other.emoji == emoji;

  @override
  int get hashCode => emoji.hashCode;
}

final class HeadlessIconContent extends HeadlessContent {
  const HeadlessIconContent(this.icon);

  final IconData icon;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeadlessIconContent && other.icon == icon;

  @override
  int get hashCode => icon.hashCode;
}
