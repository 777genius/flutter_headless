import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import 'r_button_style.dart';

/// A headless text button component.
///
/// This widget handles all button behavior (focus, keyboard, pointer input)
/// but delegates visual rendering to a [RButtonRenderer] capability.
///
/// The renderer is obtained from [HeadlessThemeProvider]. If no renderer
/// is available, a [MissingCapabilityException] is thrown with clear
/// instructions on how to fix it.
///
/// ## Controlled/Uncontrolled
///
/// The button follows Flutter's standard patterns:
/// - `onPressed == null` or `disabled == true` → button is disabled
/// - Disabled state is reflected in semantics and prevents all interaction
///
/// ## Keyboard
///
/// - Space: triggers onPressed on key up (standard button behavior)
/// - Enter: triggers onPressed immediately (activation)
///
/// ## Activation Source (v1 policy)
///
/// The button has a single activation source: [GestureDetector] for pointer
/// and [Focus.onKeyEvent] for keyboard.
///
/// Accessibility activation is component-owned as well:
/// the widget exposes `SemanticsAction.tap` and maps it to [onPressed].
///
/// ## Example
///
/// ```dart
/// RTextButton(
///   onPressed: () => print('Pressed!'),
///   child: Text('Click me'),
/// )
/// ```
class RTextButton extends StatefulWidget {
  const RTextButton({
    super.key,
    required this.child,
    this.onPressed,
    this.disabled = false,
    this.variant = RButtonVariant.outlined,
    this.size = RButtonSize.medium,
    this.style,
    this.semanticLabel,
    this.autofocus = false,
    this.focusNode,
    this.slots,
    this.overrides,
  });

  /// The button's content (typically a Text widget).
  final Widget child;

  /// Called when the button is activated.
  ///
  /// If null, the button is considered disabled.
  final VoidCallback? onPressed;

  /// Whether the button is explicitly disabled.
  ///
  /// When true, the button will not respond to input even if [onPressed]
  /// is provided.
  final bool disabled;

  /// Visual variant of the button.
  final RButtonVariant variant;

  /// Size variant of the button.
  final RButtonSize size;

  /// Simple, Flutter-like styling sugar.
  ///
  /// Internally converted to `RenderOverrides.only(RButtonOverrides.tokens(...))`.
  /// If [overrides] is provided, it takes precedence over this style.
  final RButtonStyle? style;

  /// Semantic label for accessibility.
  ///
  /// If not provided, the button's child text content is used.
  final String? semanticLabel;

  /// Whether the button should be focused initially.
  final bool autofocus;

  /// Optional focus node for external focus management.
  final FocusNode? focusNode;

  /// Optional visual slots for partial customization.
  final RButtonSlots? slots;

  /// Per-instance override bag for preset customization.
  ///
  /// Allows "style on this specific button" without API pollution.
  /// See `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`.
  final RenderOverrides? overrides;

  /// Whether the button is effectively disabled.
  ///
  /// A button is disabled if [disabled] is true OR [onPressed] is null.
  bool get isDisabled => disabled || onPressed == null;

  @override
  State<RTextButton> createState() => _RTextButtonState();
}

class _RTextButtonState extends State<RTextButton> {
  late final HeadlessFocusNodeOwner _focusNodeOwner;
  late HeadlessPressableController _pressable;
  late final HeadlessPressableVisualEffectsController _visualEffects;

  @override
  void initState() {
    super.initState();
    _focusNodeOwner = HeadlessFocusNodeOwner(
      external: widget.focusNode,
      debugLabel: 'RTextButton',
    );
    _pressable = HeadlessPressableController(isDisabled: widget.isDisabled)
      ..addListener(_onPressableChanged);
    _visualEffects = HeadlessPressableVisualEffectsController();
  }

  void _onPressableChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(RTextButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle focus node changes
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNodeOwner.update(widget.focusNode);
    }

    // Clear pressed state if disabled changes (POLA invariant)
    // Use setState to ensure rebuild even if parent doesn't trigger one
    // (handles mid-gesture disable edge case)
    if (widget.isDisabled && !oldWidget.isDisabled) {
      _pressable.setDisabled(true);
    }
  }

  @override
  void dispose() {
    _pressable.removeListener(_onPressableChanged);
    _pressable.dispose();
    _visualEffects.dispose();
    _focusNodeOwner.dispose();
    super.dispose();
  }

  void _activate() {
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final renderer = HeadlessThemeProvider.maybeCapabilityOf<RButtonRenderer>(
      context,
      componentName: 'RTextButton',
    );
    if (renderer == null) {
      final hasTheme = HeadlessThemeProvider.of(context) != null;
      final exception = hasTheme
          ? const MissingCapabilityException(
              capabilityType: 'RButtonRenderer',
              componentName: 'RTextButton',
            )
          : const MissingThemeException();
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: StackTrace.current,
          library: 'headless_button',
          context: ErrorDescription('while building RTextButton'),
        ),
      );
      return HeadlessMissingCapabilityWidget(
        componentName: 'RTextButton',
        message: headlessMissingCapabilityWidgetMessage(
          missingCapabilityType: 'RButtonRenderer',
        ),
      );
    }

    final theme = HeadlessThemeProvider.themeOf(context);
    final bool usesResolvedTokens;
    if (renderer is RButtonRendererTokenMode) {
      usesResolvedTokens =
          (renderer as RButtonRendererTokenMode).usesResolvedTokens;
    } else {
      usesResolvedTokens = true;
    }
    final tokenResolver =
        usesResolvedTokens ? theme.capability<RButtonTokenResolver>() : null;
    final overrides = _trackOverrides(mergeStyleIntoOverrides(
      style: widget.style,
      overrides: widget.overrides,
      toOverride: (s) => s.toOverrides(),
    ));

    final spec = _createSpec();
    final state = _createState(
      showFocusHighlight: HeadlessFocusHighlightScope.showOf(context),
    );

    final resolvedTokens = usesResolvedTokens
        ? tokenResolver?.resolve(
            context: context,
            spec: spec,
            states: state.toWidgetStates(),
            overrides: overrides,
          )
        : null;

    final request = RButtonRenderRequest(
      context: context,
      spec: spec,
      state: state,
      content: widget.child,
      leadingIcon: null,
      trailingIcon: null,
      spinner: null,
      semantics: RButtonSemantics(
        label: widget.semanticLabel,
        isEnabled: !widget.isDisabled,
      ),
      slots: widget.slots,
      visualEffects: _visualEffects,
      resolvedTokens: resolvedTokens,
      overrides: overrides,
    );

    final rendererOutput = renderer.render(request);
    _reportUnconsumedOverrides('RTextButton', overrides);
    return _wrapWithInteraction(context: context, child: rendererOutput);
  }

  RButtonSpec _createSpec() {
    return RButtonSpec(
      variant: widget.variant,
      size: widget.size,
      semanticLabel: widget.semanticLabel,
    );
  }

  RButtonState _createState({
    required bool showFocusHighlight,
  }) {
    final p = _pressable.state;
    return RButtonState(
      isPressed: p.isPressed,
      isHovered: p.isHovered,
      isFocused: p.isFocused,
      showFocusHighlight: showFocusHighlight,
      isDisabled: widget.isDisabled,
    );
  }

  Size _resolveTapTargetSize(BuildContext context) {
    final policy = HeadlessThemeProvider.of(context)
        ?.capability<HeadlessTapTargetPolicy>();
    if (policy != null) {
      return policy.minTapTargetSize(
        context: context,
        component: HeadlessTapTargetComponent.button,
      );
    }
    return WcagConstants.kMinTouchTargetSize;
  }

  Widget _wrapWithInteraction({
    required BuildContext context,
    required Widget child,
  }) {
    final tapTargetSize = _resolveTapTargetSize(context);

    return Semantics(
      button: true,
      enabled: !widget.isDisabled,
      label: widget.semanticLabel,
      onTap: widget.isDisabled ? null : _activate,
      child: HeadlessPressableRegion(
        controller: _pressable,
        focusNode: _focusNodeOwner.node,
        autofocus: widget.autofocus,
        enabled: !widget.isDisabled,
        cursorWhenEnabled: SystemMouseCursors.click,
        cursorWhenDisabled: SystemMouseCursors.forbidden,
        onActivate: _activate,
        visualEffects: _visualEffects,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: tapTargetSize.width,
            minHeight: tapTargetSize.height,
          ),
          child: Center(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: child,
          ),
        ),
      ),
    );
  }
}

RenderOverrides? _trackOverrides(RenderOverrides? overrides) {
  if (overrides == null) return null;
  final tracker = RenderOverridesDebugTracker();
  return RenderOverrides.debugTrack(overrides, tracker);
}

void _reportUnconsumedOverrides(
  String componentName,
  RenderOverrides? overrides,
) {
  assert(() {
    if (overrides == null) return true;
    final provided = overrides.debugProvidedTypes();
    if (provided.isEmpty) return true;
    final consumed = overrides.debugConsumedTypes();
    final unconsumed = provided.difference(consumed);
    if (unconsumed.isEmpty) return true;

    final message = StringBuffer()
      ..writeln('[Headless] Unconsumed RenderOverrides detected')
      ..writeln('Component: $componentName')
      ..writeln('Provided: ${provided.join(', ')}')
      ..writeln('Consumed: ${consumed.join(', ')}')
      ..writeln('Unconsumed: ${unconsumed.join(', ')}')
      ..write(
          'Hint: Your preset may not support these overrides for this component.');

    debugPrint(message.toString());
    return true;
  }());
}
