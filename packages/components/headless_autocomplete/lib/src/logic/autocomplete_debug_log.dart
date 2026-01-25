import 'package:flutter/foundation.dart';

const bool _kDisableAutocompleteDebugLog =
    bool.fromEnvironment('HEADLESS_AUTOCOMPLETE_DEBUG_OFF', defaultValue: false);

void autocompleteDebugLog(String message) {
  assert(() {
    if (_kDisableAutocompleteDebugLog) return true;
    debugPrint('[headless_autocomplete] $message');
    return true;
  }());
}

