import 'package:flutter/foundation.dart';

@immutable
final class StateResolutionError extends Error {
  StateResolutionError(this.message);

  final String message;

  @override
  String toString() => 'StateResolutionError: $message';
}
