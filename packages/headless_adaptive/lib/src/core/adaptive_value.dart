import 'adaptive_breakpoint.dart';
import 'adaptive_decision.dart';

final class AdaptiveValue<T> {
  const AdaptiveValue({
    required this.compact,
    this.medium,
    this.expanded,
    this.wide,
    this.ultraWide,
  });

  const AdaptiveValue.all(T value)
    : compact = value,
      medium = value,
      expanded = value,
      wide = value,
      ultraWide = value;

  final T compact;
  final T? medium;
  final T? expanded;
  final T? wide;
  final T? ultraWide;

  T resolve(AdaptiveScreenClass screenClass) {
    return switch (screenClass) {
      AdaptiveScreenClass.compact => compact,
      AdaptiveScreenClass.medium => medium ?? compact,
      AdaptiveScreenClass.expanded => expanded ?? medium ?? compact,
      AdaptiveScreenClass.wide => wide ?? expanded ?? medium ?? compact,
      AdaptiveScreenClass.ultraWide =>
        ultraWide ?? wide ?? expanded ?? medium ?? compact,
    };
  }

  T resolveDecision(AdaptiveDecision decision) {
    return resolve(decision.screenClass);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AdaptiveValue<T> &&
            other.compact == compact &&
            other.medium == medium &&
            other.expanded == expanded &&
            other.wide == wide &&
            other.ultraWide == ultraWide;
  }

  @override
  int get hashCode {
    return Object.hash(compact, medium, expanded, wide, ultraWide);
  }
}
