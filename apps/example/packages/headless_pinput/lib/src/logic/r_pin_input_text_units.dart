import 'package:flutter/widgets.dart';

int pinTextLength(String value) => value.characters.length;

int pinTextCodeUnitLength(String value) => value.length;

String clampPinText(String value, int? maxLength) {
  if (maxLength == null) return value;
  if (pinTextLength(value) <= maxLength) return value;
  return value.characters.take(maxLength).toString();
}

String pinCharacterAt(String value, int index) {
  return value.characters.elementAt(index);
}

String removeLastPinCharacter(String value) {
  final units = value.characters;
  if (units.isEmpty) return value;
  return units.take(units.length - 1).toString();
}
