import 'adaptive_breakpoint.dart';
import 'adaptive_environment.dart';
import 'adaptive_layout.dart';

final class AdaptiveDecision {
  AdaptiveDecision({
    required this.environment,
    required this.screenClass,
    required this.navigationPattern,
    required Iterable<AdaptivePaneRole> visiblePanes,
    required this.primaryPane,
    required this.detailPresentation,
    required this.maxContentWidth,
  }) : visiblePanes = List.unmodifiable(visiblePanes);

  final AdaptiveEnvironment environment;
  final AdaptiveScreenClass screenClass;
  final AdaptiveNavigationPattern navigationPattern;
  final List<AdaptivePaneRole> visiblePanes;
  final AdaptivePaneRole primaryPane;
  final AdaptiveDetailPresentation detailPresentation;
  final double maxContentWidth;

  bool isPaneVisible(AdaptivePaneRole role) => visiblePanes.contains(role);

  bool get isSinglePane => visiblePanes.length == 1;

  bool get usesCompactNavigation {
    return navigationPattern == AdaptiveNavigationPattern.bottom ||
        navigationPattern == AdaptiveNavigationPattern.drawer;
  }

  AdaptivePaneVisibility paneVisibilityFor(AdaptivePaneRole role) {
    if (!visiblePanes.contains(role)) {
      return AdaptivePaneVisibility.hidden;
    }
    return isSinglePane
        ? AdaptivePaneVisibility.single
        : AdaptivePaneVisibility.inline;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AdaptiveDecision &&
            other.environment == environment &&
            other.screenClass == screenClass &&
            other.navigationPattern == navigationPattern &&
            _listEquals(other.visiblePanes, visiblePanes) &&
            other.primaryPane == primaryPane &&
            other.detailPresentation == detailPresentation &&
            other.maxContentWidth == maxContentWidth;
  }

  @override
  int get hashCode {
    return Object.hash(
      environment,
      screenClass,
      navigationPattern,
      Object.hashAll(visiblePanes),
      primaryPane,
      detailPresentation,
      maxContentWidth,
    );
  }
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
