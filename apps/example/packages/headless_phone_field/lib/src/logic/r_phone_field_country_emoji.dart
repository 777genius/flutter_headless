String countryFlagEmoji(String isoCode) {
  final upper = isoCode.toUpperCase();
  if (upper.length != 2) return '';

  final first = upper.codeUnitAt(0) - 0x41 + 0x1F1E6;
  final second = upper.codeUnitAt(1) - 0x41 + 0x1F1E6;
  return String.fromCharCodes([first, second]);
}
