import 'package:headless_cupertino/headless_cupertino.dart';
import 'package:headless/headless.dart' show HeadlessTheme;
import 'package:headless_material/headless_material.dart';

/// Cupertino-тема для демо, которая дополняется Material-capabilities
/// для компонентов, у которых пока нет cupertino-рендереров.
class ExampleCupertinoHeadlessTheme extends HeadlessTheme {
  ExampleCupertinoHeadlessTheme({
    required CupertinoHeadlessTheme cupertino,
    required MaterialHeadlessTheme materialFallback,
  })  : _cupertino = cupertino,
        _materialFallback = materialFallback;

  factory ExampleCupertinoHeadlessTheme.light() {
    return ExampleCupertinoHeadlessTheme(
      cupertino: CupertinoHeadlessTheme.light(),
      materialFallback: MaterialHeadlessTheme.light(),
    );
  }

  factory ExampleCupertinoHeadlessTheme.dark() {
    return ExampleCupertinoHeadlessTheme(
      cupertino: CupertinoHeadlessTheme.dark(),
      materialFallback: MaterialHeadlessTheme.dark(),
    );
  }

  final CupertinoHeadlessTheme _cupertino;
  final MaterialHeadlessTheme _materialFallback;

  @override
  T? capability<T>() {
    return _cupertino.capability<T>() ?? _materialFallback.capability<T>();
  }
}
