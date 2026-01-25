/// Cross-platform glassmorphism effect inspired by iOS materials.
///
/// Uses [BackdropFilter] for blur + tint effects.
/// Works on all platforms (web, mobile, desktop).
///
/// **Important:** This is NOT a pixel-perfect copy of iOS materials.
/// Apple materials use complex layer blending, tonemapping, noise/dithering,
/// and vibrancy that cannot be replicated with [BackdropFilter].
///
/// ## Usage
///
/// ```dart
/// import 'package:liquid_glass_apple/liquid_glass_apple.dart';
///
/// GlassContainer(
///   style: GlassStyle.regular,
///   child: Text('Hello Glass!'),
/// )
/// ```
///
/// ## Performance
///
/// - Avoid [GlassContainer] in [ListView] or scrolling containers
/// - [BackdropFilter] is expensive — prefer 1-3 instances per screen
/// - Use [GlassStyle.ultraThin] or [GlassStyle.thin] for lighter effects
library;

export 'package:liquid_glass_apple/src/glass_border.dart';
export 'package:liquid_glass_apple/src/glass_container.dart';
export 'package:liquid_glass_apple/src/glass_style.dart';
