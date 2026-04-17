import 'package:flutter/widgets.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'allowed_characters.dart';
import 'r_phone_field_country_length.dart';

class RPhoneFieldController extends ChangeNotifier {
  RPhoneFieldController({
    this.initialValue = const PhoneNumber(isoCode: IsoCode.US, nsn: ''),
  })  : _value = initialValue,
        _textController = TextEditingController(
          text: initialValue.formatNsn(),
        );

  final PhoneNumber initialValue;
  final TextEditingController _textController;

  PhoneNumber _value;

  TextEditingController get textController => _textController;
  PhoneNumber get value => _value;

  set value(PhoneNumber phoneNumber) {
    _value = phoneNumber;
    final formatted = phoneNumber.formatNsn();
    if (_textController.text != formatted) {
      _changeFormattedNationalNumber(formatted);
    } else {
      notifyListeners();
    }
  }

  void changeCountry(
    IsoCode isoCode, {
    int? maxDigits,
  }) {
    _value = limitPhoneFieldLength(
      PhoneNumber.parse(
        _value.nsn,
        destinationCountry: isoCode,
      ),
      maxDigits: maxDigits,
    );
    _changeFormattedNationalNumber(_value.formatNsn());
    notifyListeners();
  }

  void changeNationalNumber(
    String? text, {
    int? maxDigits,
  }) {
    final input = text ?? '';
    final oldFormattedText = _value.formatNsn();
    var newFormattedText = input;
    var nextValue = _value;
    final isDeleting = input.length < oldFormattedText.length;
    final startsWithPlus = input.startsWith(
      RegExp('[${AllowedPhoneFieldCharacters.plus}]'),
    );

    if (startsWithPlus) {
      final parsed = _tryParseWithPlus(input);
      if (parsed != null) {
        nextValue = parsed;
        newFormattedText = parsed.formatNsn();
      }
    } else if (isDeleting && _isDeletingAreaCode(input)) {
      nextValue = PhoneNumber.parse(
        _digitsOnly(input),
        destinationCountry: _value.isoCode,
      );
    } else {
      nextValue = PhoneNumber.parse(
        input,
        destinationCountry: _value.isoCode,
      );
      newFormattedText = nextValue.formatNsn();
    }

    nextValue = limitPhoneFieldLength(nextValue, maxDigits: maxDigits);
    if (maxDigits != null && nextValue.nsn.length <= maxDigits) {
      newFormattedText =
          startsWithPlus ? nextValue.formatNsn() : newFormattedText;
    }

    _value = nextValue;
    _changeFormattedNationalNumber(newFormattedText);
    notifyListeners();
  }

  void selectNationalNumber() {
    _textController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _textController.value.text.length,
    );
    notifyListeners();
  }

  void collapseSelectionToEnd() {
    final offset = _textController.text.length;
    _textController.selection = TextSelection.collapsed(offset: offset);
    notifyListeners();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _changeFormattedNationalNumber(String newFormattedText) {
    if (newFormattedText == _textController.text) return;
    _textController.value = TextEditingValue(
      text: newFormattedText,
      selection: _computeSelection(_textController.text, newFormattedText),
    );
  }

  TextSelection _computeSelection(String originalText, String newText) {
    final currentOffset = _textController.selection.extentOffset;
    final isCursorAtEnd = currentOffset == originalText.length;
    var offset = currentOffset;
    if (isCursorAtEnd || currentOffset >= newText.length) {
      offset = newText.length;
    }
    return TextSelection.fromPosition(TextPosition(offset: offset));
  }

  PhoneNumber? _tryParseWithPlus(String text) {
    try {
      return PhoneNumber.parse(text);
    } on PhoneNumberException {
      return null;
    }
  }

  bool _isDeletingAreaCode(String text) {
    return text.startsWith(
      RegExp(
        '^\\([${AllowedPhoneFieldCharacters.digits}]+(?!.*\\))',
      ),
    );
  }

  String _digitsOnly(String text) {
    return text.replaceAll(
      RegExp('[^${AllowedPhoneFieldCharacters.digits}]'),
      '',
    );
  }
}
