import 'package:flutter/foundation.dart';

@immutable
final class ListboxTypeaheadConfig {
  const ListboxTypeaheadConfig({
    this.timeout = const Duration(milliseconds: 500),
  });

  final Duration timeout;
}

/// Typeahead buffer with timeout.
final class ListboxTypeaheadBuffer {
  ListboxTypeaheadBuffer({
    ListboxTypeaheadConfig config = const ListboxTypeaheadConfig(),
    DateTime Function()? now,
  })  : _config = config,
        _now = now ?? DateTime.now;

  final ListboxTypeaheadConfig _config;
  final DateTime Function() _now;

  String _buffer = '';
  DateTime? _lastInputAt;

  String get buffer => _buffer;

  void reset() {
    _buffer = '';
    _lastInputAt = null;
  }

  String push(String char) {
    final now = _now();
    final last = _lastInputAt;
    if (last == null || now.difference(last) > _config.timeout) {
      _buffer = char;
    } else {
      _buffer += char;
    }
    _lastInputAt = now;
    return _buffer;
  }
}
