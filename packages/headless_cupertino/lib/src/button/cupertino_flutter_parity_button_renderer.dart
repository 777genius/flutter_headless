import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'cupertino_button_parity_constants.dart';

/// Cupertino parity renderer — visual port of Flutter's [CupertinoButton].
///
/// Provides pixel-perfect iOS button visuals by reimplementing the visual
/// layer of CupertinoButton with asymmetric pressed animation.
///
/// Variant mapping:
/// - `filled` → CupertinoButton.filled (solid background, contrasting text)
/// - `tonal` → CupertinoButton.tinted (translucent background, primary text;
///   opacity: light 0.12, dark 0.26 — pinned constants from Flutter source)
/// - `outlined` → **design-system extension (NOT a native iOS control)**;
///   custom outline border derived from primary color
/// - `text` → CupertinoButton plain (transparent background, primary text)
///
/// Size mapping:
/// - `small` → 28dp min height
/// - `medium` → 32dp min height
/// - `large` → 44dp min height
///
/// The renderer wraps output in an inert guard
/// (`ExcludeSemantics` + `AbsorbPointer`) so activation stays in the
/// component layer.
class CupertinoFlutterParityButtonRenderer
    implements RButtonRenderer, RButtonRendererTokenMode {
  const CupertinoFlutterParityButtonRenderer();

  @override
  bool get usesResolvedTokens => false;

  @override
  Widget render(RButtonRenderRequest request) {
    return _CupertinoParityButtonShell(request: request);
  }
}

class _CupertinoParityButtonShell extends StatefulWidget {
  const _CupertinoParityButtonShell({required this.request});

  final RButtonRenderRequest request;

  @override
  State<_CupertinoParityButtonShell> createState() =>
      _CupertinoParityButtonShellState();
}

class _CupertinoParityButtonShellState
    extends State<_CupertinoParityButtonShell>
    with SingleTickerProviderStateMixin {
  final Tween<double> _opacityTween = Tween<double>(begin: 1.0);
  late final AnimationController _animationController;
  late final Animation<double> _opacityAnimation;

  bool _buttonHeldDown = false;

  @override
  void initState() {
    super.initState();
    _buttonHeldDown = widget.request.state.isPressed;
    _animationController = AnimationController(
      duration: CupertinoButtonParityConstants.kAnimationDuration,
      vsync: this,
      value: _buttonHeldDown ? 1.0 : 0.0,
    );
    _opacityAnimation = _animationController
        .drive(CurveTween(curve: Curves.decelerate))
        .drive(_opacityTween);
    _setTween();
  }

  @override
  void didUpdateWidget(_CupertinoParityButtonShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setTween();

    final heldDown = widget.request.state.isPressed;
    if (heldDown == _buttonHeldDown) return;
    _buttonHeldDown = heldDown;
    _animate();
  }

  void _setTween() {
    _opacityTween.end = _pressedOpacity;
  }

  double get _pressedOpacity =>
      widget.request.resolvedTokens?.pressOpacity ??
      CupertinoButtonParityConstants.kDefaultPressedOpacity;

  void _animate() {
    if (_animationController.isAnimating) return;

    final wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown
        ? _animationController.animateTo(
            1.0,
            duration: CupertinoButtonParityConstants.kFadeOutDuration,
            curve: Curves.easeInOutCubicEmphasized,
          )
        : _animationController.animateTo(
            0.0,
            duration: CupertinoButtonParityConstants.kFadeInDuration,
            curve: Curves.easeOutCubic,
          );

    ticker.then<void>((_) {
      if (!mounted) return;
      if (wasHeldDown != _buttonHeldDown) _animate();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    final overrides = request.overrides?.get<RButtonOverrides>();
    final enabled = !request.state.isDisabled;
    final variant = request.spec.variant;
    final isFilled = variant == RButtonVariant.filled;
    final isOutlined = variant == RButtonVariant.outlined;

    final sizeStyle = _mapSizeStyle(request.spec.size);
    final themeData = CupertinoTheme.of(context);
    final brightness = CupertinoTheme.brightnessOf(context);

    final double tintedAlpha = brightness == Brightness.light
        ? CupertinoButtonParityConstants.kTintedOpacityLight
        : CupertinoButtonParityConstants.kTintedOpacityDark;

    final Color? backgroundColor = overrides?.backgroundColor ??
        switch (variant) {
          RButtonVariant.filled => enabled
              ? themeData.primaryColor
              : CupertinoDynamicColor.resolve(
                  CupertinoColors.tertiarySystemFill,
                  context,
                ),
          RButtonVariant.tonal => enabled
              ? themeData.primaryColor.withValues(alpha: tintedAlpha)
              : CupertinoDynamicColor.resolve(
                  CupertinoColors.tertiarySystemFill,
                  context,
                ),
          // outlined: design-system extension, NOT a native iOS control
          RButtonVariant.outlined => null,
          RButtonVariant.text => null,
        };

    final Color foregroundColor = overrides?.foregroundColor ??
        (isFilled
            ? themeData.primaryContrastingColor
            : (enabled
                ? themeData.primaryColor
                : CupertinoDynamicColor.resolve(
                    CupertinoColors.tertiaryLabel,
                    context,
                  )));

    final BorderRadius borderRadius =
        overrides?.borderRadius ?? BorderRadius.circular(_borderRadius(sizeStyle));

    final Color outlinedBorderColor = overrides?.borderColor ??
        (enabled
            ? themeData.primaryColor
            : CupertinoDynamicColor.resolve(
                CupertinoColors.quaternarySystemFill,
                context,
              ));

    final Color effectiveFocusOutlineColor = HSLColor.fromColor(
      (backgroundColor ?? CupertinoColors.activeBlue).withValues(
        alpha: kCupertinoFocusColorOpacity,
      ),
    ).withLightness(kCupertinoFocusColorBrightness)
        .withSaturation(kCupertinoFocusColorSaturation)
        .toColor();

    final ShapeBorder shape = RoundedSuperellipseBorder(
      side: enabled && request.state.isFocused && request.state.showFocusHighlight
          ? BorderSide(
              color: effectiveFocusOutlineColor,
              width: 3.5,
              strokeAlign: BorderSide.strokeAlignOutside,
            )
          : isOutlined
              ? BorderSide(
                  color: outlinedBorderColor,
                  width: 1.0,
                  strokeAlign: BorderSide.strokeAlignInside,
                )
              : BorderSide.none,
      borderRadius: borderRadius,
    );

    final TextStyle baseTextStyle = sizeStyle == CupertinoButtonSize.small
        ? themeData.textTheme.actionSmallTextStyle
        : themeData.textTheme.actionTextStyle;
    final TextStyle textStyle =
        (overrides?.textStyle ?? baseTextStyle).copyWith(color: foregroundColor);

    final IconThemeData iconTheme = IconTheme.of(context).copyWith(
      color: foregroundColor,
      size: textStyle.fontSize != null
          ? textStyle.fontSize! * 1.2
          : kCupertinoButtonDefaultIconSize,
    );

    final EdgeInsetsGeometry padding =
        overrides?.padding ?? _padding(sizeStyle);

    final Size? minimumSizeOverride = overrides?.minSize;
    final double minH = minimumSizeOverride?.height ?? _minHeight(sizeStyle);

    final animated = FadeTransition(
      opacity: _opacityAnimation,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: shape,
          color: backgroundColor,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: minH,
          ),
          child: Padding(
            padding: padding,
            child: Align(
              alignment: Alignment.center,
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: DefaultTextStyle(
                style: textStyle,
                child: IconTheme(
                  data: iconTheme,
                  child: request.content,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return ExcludeSemantics(
      child: AbsorbPointer(
        absorbing: true,
        child: animated,
      ),
    );
  }
}

CupertinoButtonSize _mapSizeStyle(RButtonSize size) {
  switch (size) {
    case RButtonSize.small:
      return CupertinoButtonSize.small;
    case RButtonSize.medium:
      return CupertinoButtonSize.medium;
    case RButtonSize.large:
      return CupertinoButtonSize.large;
  }
}

double _minHeight(CupertinoButtonSize sizeStyle) {
  switch (sizeStyle) {
    case CupertinoButtonSize.small:
      return CupertinoButtonParityConstants.kSmallMinHeight;
    case CupertinoButtonSize.medium:
      return CupertinoButtonParityConstants.kMediumMinHeight;
    case CupertinoButtonSize.large:
      return CupertinoButtonParityConstants.kLargeMinHeight;
  }
}

EdgeInsetsGeometry _padding(CupertinoButtonSize sizeStyle) {
  switch (sizeStyle) {
    case CupertinoButtonSize.small:
      return CupertinoButtonParityConstants.kSmallPadding;
    case CupertinoButtonSize.medium:
      return CupertinoButtonParityConstants.kMediumPadding;
    case CupertinoButtonSize.large:
      return CupertinoButtonParityConstants.kLargePadding;
  }
}

double _borderRadius(CupertinoButtonSize sizeStyle) {
  switch (sizeStyle) {
    case CupertinoButtonSize.small:
      return CupertinoButtonParityConstants.kSmallBorderRadius;
    case CupertinoButtonSize.medium:
      return CupertinoButtonParityConstants.kMediumBorderRadius;
    case CupertinoButtonSize.large:
      return CupertinoButtonParityConstants.kLargeBorderRadius;
  }
}
