import 'dart:ui';

/// Parameters for a glass style.
///
/// These values are cached and reused across widget builds.
/// Apple does not publish exact values — these are empirical approximations.
class GlassStyleParams {
  /// Creates glass style parameters.
  const GlassStyleParams({
    required this.blurSigma,
    required this.tintColor,
    required this.tintOpacity,
    required this.highlightOpacity,
    required this.shadowOpacity,
    required this.saturation,
  });

  /// Blur sigma for ImageFilter.blur.
  final double blurSigma;

  /// Base tint color (usually white for light, gray for dark).
  final Color tintColor;

  /// Opacity of the tint layer (0.0 - 1.0).
  final double tintOpacity;

  /// Opacity of the border highlight (top-left, lighter edge).
  final double highlightOpacity;

  /// Opacity of the border shadow (bottom-right, darker edge).
  final double shadowOpacity;

  /// Saturation multiplier (1.0 = normal, >1.0 = more saturated).
  final double saturation;
}

/// Glassmorphism styles inspired by iOS system materials.
///
/// Each style provides different levels of blur and tint intensity.
/// These are visual approximations — not pixel-perfect iOS copies.
///
/// **Important:** Apple materials use complex layer blending, tonemapping,
/// noise/dithering, and vibrancy that cannot be replicated with BackdropFilter.
enum GlassStyle {
  /// Lightest blur effect. Similar to iOS `.systemUltraThinMaterial`.
  ///
  /// Use for subtle overlays where content visibility is important.
  ultraThin,

  /// Light blur effect. Similar to iOS `.systemThinMaterial`.
  ///
  /// Use for secondary surfaces and subtle depth.
  thin,

  /// Standard blur effect. Similar to iOS `.systemMaterial`.
  ///
  /// Use for most glassmorphism surfaces.
  regular,

  /// Heavy blur effect. Similar to iOS `.systemThickMaterial`.
  ///
  /// Use for prominent overlays.
  thick,

  /// Maximum blur with high saturation. Similar to iOS `.systemChromeMaterial`.
  ///
  /// Use for navigation bars and prominent UI elements.
  chrome,
}

/// Extension providing cached parameters for each [GlassStyle].
extension GlassStyleExtension on GlassStyle {
  /// Returns cached parameters for this style.
  ///
  /// Parameters are compile-time constants — no allocation in build().
  GlassStyleParams get params => _styleParams[index];

  static const List<GlassStyleParams> _styleParams = [
    // ultraThin — lightest, most transparent
    GlassStyleParams(
      blurSigma: 10,
      tintColor: Color(0xFFFFFFFF),
      tintOpacity: 0.05,
      highlightOpacity: 0.35,
      shadowOpacity: 0.12,
      saturation: 1.1,
    ),
    // thin
    GlassStyleParams(
      blurSigma: 12,
      tintColor: Color(0xFFFFFFFF),
      tintOpacity: 0.08,
      highlightOpacity: 0.38,
      shadowOpacity: 0.14,
      saturation: 1.1,
    ),
    // regular — balanced blur and tint
    GlassStyleParams(
      blurSigma: 15,
      tintColor: Color(0xFFFFFFFF),
      tintOpacity: 0.12,
      highlightOpacity: 0.42,
      shadowOpacity: 0.16,
      saturation: 1.0,
    ),
    // thick — more prominent
    GlassStyleParams(
      blurSigma: 18,
      tintColor: Color(0xFFFFFFFF),
      tintOpacity: 0.15,
      highlightOpacity: 0.45,
      shadowOpacity: 0.18,
      saturation: 1.0,
    ),
    // chrome — maximum blur, for nav bars
    GlassStyleParams(
      blurSigma: 22,
      tintColor: Color(0xFFFFFFFF),
      tintOpacity: 0.18,
      highlightOpacity: 0.50,
      shadowOpacity: 0.20,
      saturation: 0.9,
    ),
  ];
}
