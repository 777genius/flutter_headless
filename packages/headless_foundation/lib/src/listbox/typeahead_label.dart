final class HeadlessTypeaheadLabel {
  static final RegExp _whitespace = RegExp(r'\s+');

  static String normalize(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return '';
    final collapsed = trimmed.replaceAll(_whitespace, ' ');
    return collapsed.toLowerCase();
  }
}
