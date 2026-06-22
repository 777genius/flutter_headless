enum AdaptiveInputCapability { touch, mouse, trackpad, keyboard }

enum AdaptivePlatform {
  android,
  fuchsia,
  ios,
  linux,
  macos,
  web,
  windows,
  unknown,
}

enum AdaptiveDisplayFeatureType { cutout, fold, hinge, unknown }

enum AdaptiveDisplayFeatureState { flat, halfOpened, unknown }

final class AdaptiveSize {
  const AdaptiveSize({required this.width, required this.height})
    : assert(width >= 0, 'width must be non-negative'),
      assert(height >= 0, 'height must be non-negative');

  final double width;
  final double height;

  double get shortestSide => width < height ? width : height;

  double get longestSide => width > height ? width : height;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AdaptiveSize && other.width == width && other.height == height;
  }

  @override
  int get hashCode => Object.hash(width, height);
}

final class AdaptiveEdgeInsets {
  const AdaptiveEdgeInsets({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  }) : assert(left >= 0, 'left must be non-negative'),
       assert(top >= 0, 'top must be non-negative'),
       assert(right >= 0, 'right must be non-negative'),
       assert(bottom >= 0, 'bottom must be non-negative');

  static const zero = AdaptiveEdgeInsets(left: 0, top: 0, right: 0, bottom: 0);

  final double left;
  final double top;
  final double right;
  final double bottom;

  double get horizontal => left + right;

  double get vertical => top + bottom;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AdaptiveEdgeInsets &&
            other.left == left &&
            other.top == top &&
            other.right == right &&
            other.bottom == bottom;
  }

  @override
  int get hashCode => Object.hash(left, top, right, bottom);
}

final class AdaptiveRect {
  const AdaptiveRect({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  }) : assert(width >= 0, 'width must be non-negative'),
       assert(height >= 0, 'height must be non-negative');

  final double left;
  final double top;
  final double width;
  final double height;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AdaptiveRect &&
            other.left == left &&
            other.top == top &&
            other.width == width &&
            other.height == height;
  }

  @override
  int get hashCode => Object.hash(left, top, width, height);
}

final class AdaptiveDisplayFeature {
  const AdaptiveDisplayFeature({
    required this.bounds,
    required this.type,
    required this.state,
  });

  final AdaptiveRect bounds;
  final AdaptiveDisplayFeatureType type;
  final AdaptiveDisplayFeatureState state;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AdaptiveDisplayFeature &&
            other.bounds == bounds &&
            other.type == type &&
            other.state == state;
  }

  @override
  int get hashCode => Object.hash(bounds, type, state);
}

final class AdaptiveEnvironment {
  AdaptiveEnvironment({
    required this.size,
    this.textScaleFactor = 1,
    this.viewPadding = AdaptiveEdgeInsets.zero,
    this.viewInsets = AdaptiveEdgeInsets.zero,
    Set<AdaptiveInputCapability> inputCapabilities = const {},
    List<AdaptiveDisplayFeature> displayFeatures = const [],
    this.platform = AdaptivePlatform.unknown,
  }) : inputCapabilities = Set.unmodifiable(inputCapabilities),
       displayFeatures = List.unmodifiable(displayFeatures),
       assert(textScaleFactor > 0, 'textScaleFactor must be positive');

  final AdaptiveSize size;
  final double textScaleFactor;
  final AdaptiveEdgeInsets viewPadding;
  final AdaptiveEdgeInsets viewInsets;
  final Set<AdaptiveInputCapability> inputCapabilities;
  final List<AdaptiveDisplayFeature> displayFeatures;
  final AdaptivePlatform platform;

  bool get hasTouch =>
      inputCapabilities.contains(AdaptiveInputCapability.touch);

  bool get hasPointer {
    return inputCapabilities.contains(AdaptiveInputCapability.mouse) ||
        inputCapabilities.contains(AdaptiveInputCapability.trackpad);
  }

  bool get hasKeyboard {
    return inputCapabilities.contains(AdaptiveInputCapability.keyboard);
  }

  void validate() {
    if (!size.width.isFinite || !size.height.isFinite) {
      throw StateError('AdaptiveEnvironment size must be finite.');
    }
    if (!textScaleFactor.isFinite || textScaleFactor <= 0) {
      throw StateError('AdaptiveEnvironment text scale must be positive.');
    }
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AdaptiveEnvironment &&
            other.size == size &&
            other.textScaleFactor == textScaleFactor &&
            other.viewPadding == viewPadding &&
            other.viewInsets == viewInsets &&
            _setEquals(other.inputCapabilities, inputCapabilities) &&
            _listEquals(other.displayFeatures, displayFeatures) &&
            other.platform == platform;
  }

  @override
  int get hashCode {
    return Object.hash(
      size,
      textScaleFactor,
      viewPadding,
      viewInsets,
      Object.hashAllUnordered(inputCapabilities),
      Object.hashAll(displayFeatures),
      platform,
    );
  }
}

bool _setEquals<T>(Set<T> left, Set<T> right) {
  if (identical(left, right)) {
    return true;
  }
  if (left.length != right.length) {
    return false;
  }
  for (final value in left) {
    if (!right.contains(value)) {
      return false;
    }
  }
  return true;
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
