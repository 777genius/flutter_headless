enum AdaptiveScreenClass {
  compact,
  medium,
  expanded,
  wide,
  ultraWide;

  bool isAtLeast(AdaptiveScreenClass other) => index >= other.index;

  bool isBelow(AdaptiveScreenClass other) => index < other.index;

  bool get isCompact => this == AdaptiveScreenClass.compact;
}

final class AdaptiveBreakpoint {
  const AdaptiveBreakpoint({required this.screenClass, required this.minWidth})
    : assert(minWidth >= 0, 'minWidth must be non-negative');

  final AdaptiveScreenClass screenClass;
  final double minWidth;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AdaptiveBreakpoint &&
            other.screenClass == screenClass &&
            other.minWidth == minWidth;
  }

  @override
  int get hashCode => Object.hash(screenClass, minWidth);
}

final class AdaptiveBreakpointSet {
  const AdaptiveBreakpointSet(this.breakpoints);

  static const materialLike = AdaptiveBreakpointSet([
    AdaptiveBreakpoint(screenClass: AdaptiveScreenClass.compact, minWidth: 0),
    AdaptiveBreakpoint(screenClass: AdaptiveScreenClass.medium, minWidth: 600),
    AdaptiveBreakpoint(
      screenClass: AdaptiveScreenClass.expanded,
      minWidth: 840,
    ),
    AdaptiveBreakpoint(screenClass: AdaptiveScreenClass.wide, minWidth: 1200),
    AdaptiveBreakpoint(
      screenClass: AdaptiveScreenClass.ultraWide,
      minWidth: 1600,
    ),
  ]);

  final List<AdaptiveBreakpoint> breakpoints;

  AdaptiveScreenClass resolve(double width) {
    if (!width.isFinite || width < 0) {
      throw ArgumentError.value(
        width,
        'width',
        'Width must be finite and non-negative.',
      );
    }
    if (breakpoints.isEmpty) {
      throw StateError('AdaptiveBreakpointSet must contain breakpoints.');
    }

    _validateSorted();

    var selected = breakpoints.first.screenClass;
    for (final breakpoint in breakpoints) {
      if (width < breakpoint.minWidth) {
        break;
      }
      selected = breakpoint.screenClass;
    }
    return selected;
  }

  void _validateSorted() {
    var previous = -1.0;
    final seen = <AdaptiveScreenClass>{};

    for (var index = 0; index < breakpoints.length; index++) {
      final breakpoint = breakpoints[index];
      if (!breakpoint.minWidth.isFinite) {
        throw StateError('Adaptive breakpoint minWidth must be finite.');
      }
      if (index == 0 && breakpoint.minWidth != 0) {
        throw StateError('The first adaptive breakpoint must start at 0.');
      }
      if (breakpoint.minWidth < previous) {
        throw StateError('Adaptive breakpoints must be sorted by minWidth.');
      }
      if (!seen.add(breakpoint.screenClass)) {
        throw StateError('Adaptive breakpoints must not repeat screen class.');
      }
      previous = breakpoint.minWidth;
    }
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AdaptiveBreakpointSet &&
            _listEquals(other.breakpoints, breakpoints);
  }

  @override
  int get hashCode => Object.hashAll(breakpoints);
}

bool _listEquals<T>(List<T> left, List<T> right) {
  if (identical(left, right)) {
    return true;
  }
  if (left.length != right.length) {
    return false;
  }
  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) {
      return false;
    }
  }
  return true;
}
