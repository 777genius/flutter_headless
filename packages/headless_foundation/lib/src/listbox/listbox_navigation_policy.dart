import 'package:flutter/foundation.dart';

@immutable
final class ListboxNavigationPolicy {
  const ListboxNavigationPolicy({
    this.looping = true,
  });

  final bool looping;
}

