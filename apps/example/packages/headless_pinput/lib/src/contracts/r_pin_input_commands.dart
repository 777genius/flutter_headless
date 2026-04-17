import 'package:flutter/foundation.dart';

@immutable
final class RPinInputCommands {
  const RPinInputCommands({
    required this.tapField,
    required this.requestKeyboard,
  });

  final VoidCallback tapField;
  final VoidCallback requestKeyboard;
}
