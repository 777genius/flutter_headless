import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'package:liquid_glass_apple/src/glass_style.dart';
import 'package:liquid_glass_apple/src/glass_tint.dart';

/// A glassmorphism container with blur effect.
///
/// Provides an iOS-inspired glass effect using [BackdropFilter].
/// Works on all platforms (web, mobile, desktop).
///
/// **Performance note:** Avoid using in [ListView] or scrolling containers.
/// [BackdropFilter] is expensive — prefer 1-3 instances per screen.
///
/// **Important:** This is NOT a pixel-perfect copy of iOS materials.
/// Apple materials use complex layer blending, tonemapping, noise/dithering,
/// and vibrancy that cannot be replicated with [BackdropFilter].
///
/// {@tool snippet}
/// Basic usage:
/// ```dart
/// GlassContainer(
///   style: GlassStyle.regular,
///   child: Padding(
///     padding: EdgeInsets.all(16),
///     child: Text('Hello Glass!'),
///   ),
/// )
/// ```
/// {@end-tool}
class GlassContainer extends StatelessWidget {
  /// Creates a glassmorphism container.
  ///
  /// The [child] is required and displayed on top of the glass effect.
  /// Use [style] to choose a preset, or override with [tintColor]/[blurSigma].
  const GlassContainer({
    super.key,
    required this.child,
    this.style = GlassStyle.regular,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.tintColor,
    this.blurSigma,
    this.padding,
  });

  /// The content to display on top of the glass effect.
  final Widget child;

  /// The glass style preset to use.
  ///
  /// Defaults to [GlassStyle.regular].
  /// Can be overridden with [tintColor] and [blurSigma].
  final GlassStyle style;

  /// Border radius for the glass container.
  ///
  /// Defaults to 16.0 on all corners.
  final BorderRadius borderRadius;

  /// Custom tint color, overrides the style's default.
  ///
  /// If null, uses the color from [style].
  final Color? tintColor;

  /// Custom blur sigma, overrides the style's default.
  ///
  /// If null, uses the sigma from [style].
  /// Recommended range: 8-20. Higher values are expensive.
  final double? blurSigma;

  /// Optional padding inside the glass container.
  ///
  /// If null, no padding is applied.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final params = style.params;
    final sigma = blurSigma ?? params.blurSigma;
    final tint = tintColor ?? params.tintColor;

    Widget content = child;
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: GlassTint(
            tintColor: tint,
            tintOpacity: params.tintOpacity,
            borderRadius: borderRadius,
            highlightOpacity: params.highlightOpacity,
            shadowOpacity: params.shadowOpacity,
            child: content,
          ),
        ),
      ),
    );
  }
}
