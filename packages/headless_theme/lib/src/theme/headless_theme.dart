import 'package:meta/meta.dart';

/// Root capability discovery contract (v1 skeleton).
///
/// In v1, capabilities are discovered by generic type.
@immutable
abstract class HeadlessTheme {
  const HeadlessTheme();

  T? capability<T>();
}
