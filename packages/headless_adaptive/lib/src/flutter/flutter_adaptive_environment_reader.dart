import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/adaptive_environment.dart' as adaptive;

abstract final class FlutterAdaptiveEnvironmentReader {
  static adaptive.AdaptiveEnvironment fromContext(
    BuildContext context, {
    BoxConstraints? constraints,
    Set<adaptive.AdaptiveInputCapability>? inputCapabilities,
  }) {
    final mediaQuery = MediaQuery.maybeOf(context);
    final windowSize = mediaQuery?.size ?? Size.zero;
    final resolvedSize = _resolveSize(windowSize, constraints);

    return adaptive.AdaptiveEnvironment(
      size: adaptive.AdaptiveSize(
        width: resolvedSize.width,
        height: resolvedSize.height,
      ),
      textScaleFactor: mediaQuery?.textScaler.scale(1) ?? 1,
      viewPadding: _fromEdgeInsets(mediaQuery?.padding ?? EdgeInsets.zero),
      viewInsets: _fromEdgeInsets(mediaQuery?.viewInsets ?? EdgeInsets.zero),
      inputCapabilities: inputCapabilities ?? _defaultInputCapabilities(),
      displayFeatures: _fromDisplayFeatures(mediaQuery?.displayFeatures ?? []),
      platform: _platform(),
    );
  }

  static Size _resolveSize(Size windowSize, BoxConstraints? constraints) {
    final width = constraints != null &&
            constraints.hasBoundedWidth &&
            constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : windowSize.width;
    final height = constraints != null &&
            constraints.hasBoundedHeight &&
            constraints.maxHeight.isFinite
        ? constraints.maxHeight
        : windowSize.height;

    return Size(width, height);
  }

  static adaptive.AdaptiveEdgeInsets _fromEdgeInsets(EdgeInsets insets) {
    return adaptive.AdaptiveEdgeInsets(
      left: insets.left,
      top: insets.top,
      right: insets.right,
      bottom: insets.bottom,
    );
  }

  static List<adaptive.AdaptiveDisplayFeature> _fromDisplayFeatures(
    List<ui.DisplayFeature> features,
  ) {
    return [
      for (final feature in features)
        adaptive.AdaptiveDisplayFeature(
          bounds: adaptive.AdaptiveRect(
            left: feature.bounds.left,
            top: feature.bounds.top,
            width: feature.bounds.width,
            height: feature.bounds.height,
          ),
          type: switch (feature.type) {
            ui.DisplayFeatureType.cutout =>
              adaptive.AdaptiveDisplayFeatureType.cutout,
            ui.DisplayFeatureType.fold =>
              adaptive.AdaptiveDisplayFeatureType.fold,
            ui.DisplayFeatureType.hinge =>
              adaptive.AdaptiveDisplayFeatureType.hinge,
            ui.DisplayFeatureType.unknown =>
              adaptive.AdaptiveDisplayFeatureType.unknown,
          },
          state: switch (feature.state) {
            ui.DisplayFeatureState.postureFlat =>
              adaptive.AdaptiveDisplayFeatureState.flat,
            ui.DisplayFeatureState.postureHalfOpened =>
              adaptive.AdaptiveDisplayFeatureState.halfOpened,
            _ => adaptive.AdaptiveDisplayFeatureState.unknown,
          },
        ),
    ];
  }

  static Set<adaptive.AdaptiveInputCapability> _defaultInputCapabilities() {
    if (kIsWeb) {
      return const {
        adaptive.AdaptiveInputCapability.keyboard,
        adaptive.AdaptiveInputCapability.mouse,
        adaptive.AdaptiveInputCapability.touch,
      };
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.android ||
      TargetPlatform.fuchsia ||
      TargetPlatform.iOS =>
        const {adaptive.AdaptiveInputCapability.touch},
      TargetPlatform.linux ||
      TargetPlatform.macOS ||
      TargetPlatform.windows =>
        const {
          adaptive.AdaptiveInputCapability.keyboard,
          adaptive.AdaptiveInputCapability.mouse,
          adaptive.AdaptiveInputCapability.trackpad,
        },
    };
  }

  static adaptive.AdaptivePlatform _platform() {
    if (kIsWeb) {
      return adaptive.AdaptivePlatform.web;
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.android => adaptive.AdaptivePlatform.android,
      TargetPlatform.fuchsia => adaptive.AdaptivePlatform.fuchsia,
      TargetPlatform.iOS => adaptive.AdaptivePlatform.ios,
      TargetPlatform.linux => adaptive.AdaptivePlatform.linux,
      TargetPlatform.macOS => adaptive.AdaptivePlatform.macos,
      TargetPlatform.windows => adaptive.AdaptivePlatform.windows,
    };
  }
}
