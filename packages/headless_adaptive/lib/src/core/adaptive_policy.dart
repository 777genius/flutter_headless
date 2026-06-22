import 'adaptive_breakpoint.dart';
import 'adaptive_decision.dart';
import 'adaptive_environment.dart';
import 'adaptive_layout.dart';

final class AdaptiveNavigationPolicy {
  const AdaptiveNavigationPolicy({
    this.compact = AdaptiveNavigationPattern.drawer,
    this.medium = AdaptiveNavigationPattern.rail,
    this.expanded = AdaptiveNavigationPattern.sidebar,
    this.wide = AdaptiveNavigationPattern.sidebar,
    this.ultraWide = AdaptiveNavigationPattern.sidebar,
  });

  final AdaptiveNavigationPattern compact;
  final AdaptiveNavigationPattern medium;
  final AdaptiveNavigationPattern expanded;
  final AdaptiveNavigationPattern wide;
  final AdaptiveNavigationPattern ultraWide;

  AdaptiveNavigationPattern resolve(AdaptiveScreenClass screenClass) {
    return switch (screenClass) {
      AdaptiveScreenClass.compact => compact,
      AdaptiveScreenClass.medium => medium,
      AdaptiveScreenClass.expanded => expanded,
      AdaptiveScreenClass.wide => wide,
      AdaptiveScreenClass.ultraWide => ultraWide,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AdaptiveNavigationPolicy &&
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

final class AdaptivePanePolicy {
  const AdaptivePanePolicy({
    this.detailInlineFrom = AdaptiveScreenClass.expanded,
    this.supportingInlineFrom = AdaptiveScreenClass.wide,
    this.singlePaneFallback = AdaptivePaneRole.primary,
    this.primaryFlex = 3,
    this.detailFlex = 5,
    this.supportingFlex = 2,
  }) : assert(primaryFlex > 0, 'primaryFlex must be positive'),
       assert(detailFlex > 0, 'detailFlex must be positive'),
       assert(supportingFlex > 0, 'supportingFlex must be positive');

  final AdaptiveScreenClass detailInlineFrom;
  final AdaptiveScreenClass supportingInlineFrom;
  final AdaptivePaneRole singlePaneFallback;
  final int primaryFlex;
  final int detailFlex;
  final int supportingFlex;

  List<AdaptivePaneRole> visiblePanesFor(AdaptiveScreenClass screenClass) {
    final panes = <AdaptivePaneRole>[AdaptivePaneRole.primary];

    if (screenClass.isAtLeast(detailInlineFrom)) {
      panes.add(AdaptivePaneRole.detail);
    }
    if (screenClass.isAtLeast(supportingInlineFrom)) {
      panes.add(AdaptivePaneRole.supporting);
    }

    return panes;
  }

  AdaptivePaneVisibility visibilityFor(
    AdaptiveScreenClass screenClass,
    AdaptivePaneRole role,
  ) {
    final visible = visiblePanesFor(screenClass);
    if (!visible.contains(role)) {
      return AdaptivePaneVisibility.hidden;
    }
    return visible.length == 1
        ? AdaptivePaneVisibility.single
        : AdaptivePaneVisibility.inline;
  }

  int flexFor(AdaptivePaneRole role) {
    return switch (role) {
      AdaptivePaneRole.primary => primaryFlex,
      AdaptivePaneRole.detail => detailFlex,
      AdaptivePaneRole.supporting => supportingFlex,
    };
  }

  void validate() {
    if (supportingInlineFrom.isBelow(detailInlineFrom)) {
      throw StateError(
        'supportingInlineFrom must not be below detailInlineFrom.',
      );
    }
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AdaptivePanePolicy &&
            other.detailInlineFrom == detailInlineFrom &&
            other.supportingInlineFrom == supportingInlineFrom &&
            other.singlePaneFallback == singlePaneFallback &&
            other.primaryFlex == primaryFlex &&
            other.detailFlex == detailFlex &&
            other.supportingFlex == supportingFlex;
  }

  @override
  int get hashCode {
    return Object.hash(
      detailInlineFrom,
      supportingInlineFrom,
      singlePaneFallback,
      primaryFlex,
      detailFlex,
      supportingFlex,
    );
  }
}

final class AdaptiveContentPolicy {
  const AdaptiveContentPolicy({
    this.compactMaxWidth = double.infinity,
    this.mediumMaxWidth = 840,
    this.expandedMaxWidth = 1180,
    this.wideMaxWidth = 1440,
    this.ultraWideMaxWidth = 1600,
  });

  final double compactMaxWidth;
  final double mediumMaxWidth;
  final double expandedMaxWidth;
  final double wideMaxWidth;
  final double ultraWideMaxWidth;

  double resolveMaxWidth(AdaptiveScreenClass screenClass) {
    validate();

    return switch (screenClass) {
      AdaptiveScreenClass.compact => compactMaxWidth,
      AdaptiveScreenClass.medium => mediumMaxWidth,
      AdaptiveScreenClass.expanded => expandedMaxWidth,
      AdaptiveScreenClass.wide => wideMaxWidth,
      AdaptiveScreenClass.ultraWide => ultraWideMaxWidth,
    };
  }

  void validate() {
    for (final width in [
      compactMaxWidth,
      mediumMaxWidth,
      expandedMaxWidth,
      wideMaxWidth,
      ultraWideMaxWidth,
    ]) {
      if (width.isNaN || width <= 0) {
        throw StateError('Adaptive content max widths must be positive.');
      }
    }
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AdaptiveContentPolicy &&
            other.compactMaxWidth == compactMaxWidth &&
            other.mediumMaxWidth == mediumMaxWidth &&
            other.expandedMaxWidth == expandedMaxWidth &&
            other.wideMaxWidth == wideMaxWidth &&
            other.ultraWideMaxWidth == ultraWideMaxWidth;
  }

  @override
  int get hashCode {
    return Object.hash(
      compactMaxWidth,
      mediumMaxWidth,
      expandedMaxWidth,
      wideMaxWidth,
      ultraWideMaxWidth,
    );
  }
}

final class AdaptivePolicy {
  const AdaptivePolicy({
    this.breakpoints = AdaptiveBreakpointSet.materialLike,
    this.navigation = const AdaptiveNavigationPolicy(),
    this.panes = const AdaptivePanePolicy(),
    this.content = const AdaptiveContentPolicy(),
  });

  final AdaptiveBreakpointSet breakpoints;
  final AdaptiveNavigationPolicy navigation;
  final AdaptivePanePolicy panes;
  final AdaptiveContentPolicy content;

  AdaptiveDecision resolve(AdaptiveEnvironment environment) {
    environment.validate();
    panes.validate();
    content.validate();

    final screenClass = breakpoints.resolve(environment.size.width);
    final visiblePanes = panes.visiblePanesFor(screenClass);
    final detailPresentation = visiblePanes.contains(AdaptivePaneRole.detail)
        ? AdaptiveDetailPresentation.inline
        : AdaptiveDetailPresentation.routed;

    return AdaptiveDecision(
      environment: environment,
      screenClass: screenClass,
      navigationPattern: navigation.resolve(screenClass),
      visiblePanes: visiblePanes,
      primaryPane: AdaptivePaneRole.primary,
      detailPresentation: detailPresentation,
      maxContentWidth: content.resolveMaxWidth(screenClass),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AdaptivePolicy &&
            other.breakpoints == breakpoints &&
            other.navigation == navigation &&
            other.panes == panes &&
            other.content == content;
  }

  @override
  int get hashCode => Object.hash(breakpoints, navigation, panes, content);
}
