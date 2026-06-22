import 'package:flutter_test/flutter_test.dart';
import 'package:headless_adaptive/headless_adaptive.dart';

void main() {
  group('AdaptivePolicy', () {
    test('resolves material-like screen classes from available width', () {
      const policy = AdaptivePolicy();

      expect(
        policy.resolve(_environment(width: 390)).screenClass,
        AdaptiveScreenClass.compact,
      );
      expect(
        policy.resolve(_environment(width: 600)).screenClass,
        AdaptiveScreenClass.medium,
      );
      expect(
        policy.resolve(_environment(width: 840)).screenClass,
        AdaptiveScreenClass.expanded,
      );
      expect(
        policy.resolve(_environment(width: 1200)).screenClass,
        AdaptiveScreenClass.wide,
      );
      expect(
        policy.resolve(_environment(width: 1600)).screenClass,
        AdaptiveScreenClass.ultraWide,
      );
    });

    test('keeps navigation decisions unstyled and policy-driven', () {
      const policy = AdaptivePolicy();

      expect(
        policy.resolve(_environment(width: 390)).navigationPattern,
        AdaptiveNavigationPattern.drawer,
      );
      expect(
        policy.resolve(_environment(width: 720)).navigationPattern,
        AdaptiveNavigationPattern.rail,
      );
      expect(
        policy.resolve(_environment(width: 1200)).navigationPattern,
        AdaptiveNavigationPattern.sidebar,
      );
    });

    test('resolves canonical pane visibility without feature state', () {
      const policy = AdaptivePolicy();

      final compact = policy.resolve(_environment(width: 390));
      expect(compact.visiblePanes, [AdaptivePaneRole.primary]);
      expect(compact.detailPresentation, AdaptiveDetailPresentation.routed);

      final expanded = policy.resolve(_environment(width: 840));
      expect(expanded.visiblePanes, [
        AdaptivePaneRole.primary,
        AdaptivePaneRole.detail,
      ]);
      expect(expanded.detailPresentation, AdaptiveDetailPresentation.inline);

      final wide = policy.resolve(_environment(width: 1200));
      expect(wide.visiblePanes, [
        AdaptivePaneRole.primary,
        AdaptivePaneRole.detail,
        AdaptivePaneRole.supporting,
      ]);
      expect(
        wide.paneVisibilityFor(AdaptivePaneRole.primary),
        AdaptivePaneVisibility.inline,
      );
      expect(
        wide.paneVisibilityFor(AdaptivePaneRole.detail),
        AdaptivePaneVisibility.inline,
      );
      expect(
        wide.paneVisibilityFor(AdaptivePaneRole.supporting),
        AdaptivePaneVisibility.inline,
      );
    });

    test('exposes compact navigation convenience without Material widgets', () {
      const policy = AdaptivePolicy();

      expect(
        policy.resolve(_environment(width: 390)).usesCompactNavigation,
        isTrue,
      );
      expect(
        policy.resolve(_environment(width: 1200)).usesCompactNavigation,
        isFalse,
      );
    });

    test('compares policy and decisions by value', () {
      const policy = AdaptivePolicy();

      expect(policy, const AdaptivePolicy());
      expect(
        policy.resolve(_environment(width: 390)),
        const AdaptivePolicy().resolve(_environment(width: 390)),
      );
    });

    test('rejects pane policies where supporting appears before detail', () {
      const policy = AdaptivePolicy(
        panes: AdaptivePanePolicy(
          detailInlineFrom: AdaptiveScreenClass.wide,
          supportingInlineFrom: AdaptiveScreenClass.expanded,
        ),
      );

      expect(() => policy.resolve(_environment(width: 1200)), throwsStateError);
    });

    test('rejects unusable content max widths', () {
      const policy = AdaptivePolicy(
        content: AdaptiveContentPolicy(expandedMaxWidth: 0),
      );

      expect(() => policy.resolve(_environment(width: 840)), throwsStateError);
    });
  });

  group('AdaptiveBreakpointSet', () {
    test('rejects negative width instead of silently choosing compact', () {
      expect(
        () => AdaptiveBreakpointSet.materialLike.resolve(-1),
        throwsArgumentError,
      );
    });

    test('rejects infinite width instead of silently choosing ultra-wide', () {
      expect(
        () => AdaptiveBreakpointSet.materialLike.resolve(double.infinity),
        throwsArgumentError,
      );
    });

    test('rejects unsorted breakpoints', () {
      const breakpoints = AdaptiveBreakpointSet([
        AdaptiveBreakpoint(
          screenClass: AdaptiveScreenClass.medium,
          minWidth: 600,
        ),
        AdaptiveBreakpoint(
          screenClass: AdaptiveScreenClass.compact,
          minWidth: 0,
        ),
      ]);

      expect(() => breakpoints.resolve(320), throwsStateError);
    });

    test('rejects breakpoints that do not start at zero', () {
      const breakpoints = AdaptiveBreakpointSet([
        AdaptiveBreakpoint(
          screenClass: AdaptiveScreenClass.compact,
          minWidth: 320,
        ),
      ]);

      expect(() => breakpoints.resolve(320), throwsStateError);
    });
  });

  group('AdaptiveValue', () {
    test('falls back from wider classes to the closest configured value', () {
      const value = AdaptiveValue<int>(compact: 1, expanded: 3);

      expect(value.resolve(AdaptiveScreenClass.compact), 1);
      expect(value.resolve(AdaptiveScreenClass.medium), 1);
      expect(value.resolve(AdaptiveScreenClass.expanded), 3);
      expect(value.resolve(AdaptiveScreenClass.wide), 3);
      expect(value.resolve(AdaptiveScreenClass.ultraWide), 3);
      expect(
        value.resolveDecision(
          const AdaptivePolicy().resolve(_environment(width: 1200)),
        ),
        3,
      );
    });

    test('compares by configured breakpoint values', () {
      expect(
        const AdaptiveValue<int>(compact: 1, expanded: 3),
        const AdaptiveValue<int>(compact: 1, expanded: 3),
      );
    });
  });

  group('AdaptiveEnvironment', () {
    test('freezes collection inputs', () {
      final inputCapabilities = {AdaptiveInputCapability.touch};
      final displayFeatures = <AdaptiveDisplayFeature>[];
      final environment = AdaptiveEnvironment(
        size: const AdaptiveSize(width: 390, height: 800),
        inputCapabilities: inputCapabilities,
        displayFeatures: displayFeatures,
      );

      inputCapabilities.add(AdaptiveInputCapability.mouse);
      displayFeatures.add(
        const AdaptiveDisplayFeature(
          bounds: AdaptiveRect(left: 0, top: 0, width: 10, height: 10),
          type: AdaptiveDisplayFeatureType.cutout,
          state: AdaptiveDisplayFeatureState.flat,
        ),
      );

      expect(environment.hasTouch, isTrue);
      expect(environment.hasPointer, isFalse);
      expect(environment.displayFeatures, isEmpty);
      expect(
        () =>
            environment.inputCapabilities.add(AdaptiveInputCapability.keyboard),
        throwsUnsupportedError,
      );
    });
  });
}

AdaptiveEnvironment _environment({required double width}) {
  return AdaptiveEnvironment(size: AdaptiveSize(width: width, height: 800));
}
