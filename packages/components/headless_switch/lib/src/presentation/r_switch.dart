import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_theme/headless_theme.dart';

import '_debug_utils.dart';
import 'logic/switch_drag_decider.dart';
import 'r_switch_style.dart';

/// A headless switch component.
///
/// - State is controlled: the widget does NOT store value internally.
/// - Interaction (pointer/keyboard/focus/drag) is handled by this component.
/// - Visuals are delegated to [RSwitchRenderer] capability.
///
/// API is intentionally close to Flutter's Switch/CupertinoSwitch:
/// [value], [onChanged], [focusNode], [autofocus], [mouseCursor],
/// [semanticLabel], [thumbIcon], [dragStartBehavior].
class RSwitch extends StatefulWidget {
  const RSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.thumbIcon,
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor,
    this.semanticLabel,
    this.dragStartBehavior = DragStartBehavior.start,
    this.style,
    this.slots,
    this.overrides,
  });

  /// Whether this switch is on.
  final bool value;

  /// Called when the value should change.
  ///
  /// If null, the switch is disabled.
  final ValueChanged<bool>? onChanged;

  /// Optional icon displayed on the thumb.
  final WidgetStateProperty<Icon?>? thumbIcon;

  /// Optional focus node for external focus management.
  final FocusNode? focusNode;

  /// Whether the switch should be focused initially.
  final bool autofocus;

  /// Mouse cursor when enabled.
  final MouseCursor? mouseCursor;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  /// {@template flutter.cupertino.CupertinoSwitch.dragStartBehavior}
  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], the drag behavior used to move the
  /// switch from on to off will begin at the position where the drag gesture won
  /// the arena. If set to [DragStartBehavior.down] it will begin at the position
  /// where a down event was first detected.
  ///
  /// In general, setting this to [DragStartBehavior.start] will make drag
  /// animation smoother and setting it to [DragStartBehavior.down] will make
  /// drag behavior feel slightly more reactive.
  ///
  /// By default, the drag start behavior is [DragStartBehavior.start].
  /// {@endtemplate}
  final DragStartBehavior dragStartBehavior;

  /// Simple, Flutter-like styling sugar.
  ///
  /// Internally converted to `RenderOverrides.only(RSwitchOverrides.tokens(...))`.
  /// If [overrides] is provided, it takes precedence over this style.
  final RSwitchStyle? style;

  /// Optional visual slots for partial customization.
  final RSwitchSlots? slots;

  /// Per-instance override bag for preset customization.
  final RenderOverrides? overrides;

  bool get isDisabled => onChanged == null;

  @override
  State<RSwitch> createState() => _RSwitchState();
}

class _RSwitchState extends State<RSwitch> {
  late final HeadlessFocusNodeOwner _focusNodeOwner;
  late HeadlessPressableController _pressable;
  late final HeadlessPressableVisualEffectsController _visualEffects;

  double? _dragT;
  bool? _dragVisualValue;
  double _travelPx = 0;
  bool _needsDrag = false;

  @override
  void initState() {
    super.initState();
    _focusNodeOwner = HeadlessFocusNodeOwner(
      external: widget.focusNode,
      debugLabel: 'RSwitch',
    );
    _pressable = HeadlessPressableController(isDisabled: widget.isDisabled)
      ..addListener(_onPressableChanged);
    _visualEffects = HeadlessPressableVisualEffectsController();
  }

  void _onPressableChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(RSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.focusNode != oldWidget.focusNode) {
      _focusNodeOwner.update(widget.focusNode);
    }

    if (widget.isDisabled != oldWidget.isDisabled) {
      _pressable.setDisabled(widget.isDisabled);
      if (widget.isDisabled) {
        _cancelDrag();
      }
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
    if (widget.isDisabled) return;
    widget.onChanged?.call(!widget.value);
  }

  bool get _isDragging => _dragT != null;

  void _handleTapDown(TapDragDownDetails details) {
    if (widget.isDisabled) return;
    _pressable.handleTapDown();
    _visualEffects.pointerDown(
      localPosition: details.localPosition,
      globalPosition: details.globalPosition,
    );
  }

  void _handleTapUp(TapDragUpDetails details) {
    if (widget.isDisabled) return;
    _visualEffects.pointerUp(
      localPosition: details.localPosition,
      globalPosition: details.globalPosition,
    );
    _pressable.handleTapUp(onActivate: _activate);
  }

  void _handleCancel() {
    if (_isDragging) {
      _cancelDrag();
    } else {
      _pressable.handleTapCancel();
      _visualEffects.pointerCancel();
    }
  }

  void _handleDragStart(TapDragStartDetails details) {
    if (widget.isDisabled) return;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    setState(() {
      _dragT = initialDragT(value: widget.value, isRtl: isRtl);
      _dragVisualValue = widget.value;
      _needsDrag = true;
    });
    _pressable.handleTapDown();
    _visualEffects.pointerDown(
      localPosition: details.localPosition,
      globalPosition: details.globalPosition,
    );
  }

  void _handleDragUpdate(TapDragUpdateDetails details) {
    if (!_isDragging || widget.isDisabled) return;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final newT = updateDragT(
      currentT: _dragT!,
      deltaX: details.delta.dx,
      travelPx: _travelPx,
      isRtl: isRtl,
    );
    final newVisualValue = computeDragVisualValue(dragT: newT);
    setState(() {
      _dragT = newT;
      _dragVisualValue = newVisualValue;
    });
  }

  void _handleDragEnd(TapDragEndDetails details) {
    if (!_isDragging || widget.isDisabled) {
      _cancelDrag();
      return;
    }

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final velocity = details.velocity.pixelsPerSecond.dx;
    final nextValue = computeNextValue(
      dragT: _dragT!,
      velocity: velocity,
      isRtl: isRtl,
    );

    _cancelDrag();

    if (nextValue != widget.value) {
      widget.onChanged?.call(nextValue);
    }
  }

  void _cancelDrag() {
    if (_dragT == null && !_needsDrag) return;
    setState(() {
      _dragT = null;
      _dragVisualValue = null;
      _needsDrag = false;
    });
    _pressable.handleTapCancel();
    _visualEffects.pointerCancel();
  }

  @override
  Widget build(BuildContext context) {
    final renderer = HeadlessThemeProvider.maybeCapabilityOf<RSwitchRenderer>(
      context,
      componentName: 'RSwitch',
    );
    if (renderer == null) {
      final hasTheme = HeadlessThemeProvider.of(context) != null;
      final exception = hasTheme
          ? const MissingCapabilityException(
              capabilityType: 'RSwitchRenderer',
              componentName: 'RSwitch',
            )
          : const MissingThemeException();
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: StackTrace.current,
          library: 'headless_switch',
          context: ErrorDescription('while building RSwitch'),
        ),
      );
      return HeadlessMissingCapabilityWidget(
        componentName: 'RSwitch',
        message: headlessMissingCapabilityWidgetMessage(
          missingCapabilityType: 'RSwitchRenderer',
        ),
      );
    }

    final theme = HeadlessThemeProvider.themeOf(context);
    final tokenResolver = theme.capability<RSwitchTokenResolver>();
    final overrides = trackSwitchOverrides(_mergeStyleIntoOverrides());
    final spec = _createSpec();
    final state = _createState();
    final baseConstraints = _createBaseConstraints();

    final resolvedTokens = tokenResolver?.resolve(
      context: context,
      spec: spec,
      states: state.toWidgetStates(),
      constraints: baseConstraints,
      overrides: overrides,
    );

    if (resolvedTokens != null) {
      _travelPx = computeTravelPx(
        trackWidth: resolvedTokens.trackSize.width,
        trackHeight: resolvedTokens.trackSize.height,
      );
    }

    final constraints = _resolveConstraints(baseConstraints, resolvedTokens);

    final request = RSwitchRenderRequest(
      context: context,
      spec: spec,
      state: state,
      semantics: RSwitchSemantics(
        label: widget.semanticLabel,
        isEnabled: !widget.isDisabled,
        value: widget.value,
      ),
      slots: widget.slots,
      visualEffects: _visualEffects,
      resolvedTokens: resolvedTokens,
      constraints: constraints,
      overrides: overrides,
    );

    final content = renderer.render(request);
    reportUnconsumedSwitchOverrides('RSwitch', overrides);

    return Semantics(
      enabled: !widget.isDisabled,
      toggled: widget.value,
      label: widget.semanticLabel,
      excludeSemantics: widget.semanticLabel != null,
      child: RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          TapAndHorizontalDragGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<
                  TapAndHorizontalDragGestureRecognizer>(
            () => TapAndHorizontalDragGestureRecognizer(debugOwner: this),
            (TapAndHorizontalDragGestureRecognizer instance) {
              instance
                ..onTapDown = _handleTapDown
                ..onTapUp = _handleTapUp
                ..onCancel = _handleCancel
                ..onDragStart = _handleDragStart
                ..onDragUpdate = _handleDragUpdate
                ..onDragEnd = _handleDragEnd
                ..dragStartBehavior = widget.dragStartBehavior;
            },
          ),
        },
        child: Focus(
          focusNode: _focusNodeOwner.node,
          autofocus: widget.autofocus,
          canRequestFocus: !widget.isDisabled,
          skipTraversal: widget.isDisabled,
          onFocusChange: (focused) {
            _pressable.handleFocusChange(focused);
            _visualEffects.focusChanged(focused);
          },
          onKeyEvent: (node, event) {
            if (widget.isDisabled) return KeyEventResult.ignored;
            return handlePressableKeyEvent(
              controller: _pressable,
              event: event,
              onActivate: _activate,
            );
          },
          child: MouseRegion(
            onEnter: (_) {
              _pressable.handleMouseEnter();
              _visualEffects.hoverChanged(true);
            },
            onExit: (_) {
              _pressable.handleMouseExit();
              _visualEffects.hoverChanged(false);
            },
            cursor: widget.isDisabled
                ? SystemMouseCursors.forbidden
                : (widget.mouseCursor ?? SystemMouseCursors.click),
            child: content,
          ),
        ),
      ),
    );
  }

  RenderOverrides? _mergeStyleIntoOverrides() {
    return mergeOverridesWithFallbacks(
      base: widget.overrides,
      fallbacks: [
        if (widget.style != null)
          RenderOverrides.only(widget.style!.toOverrides()),
        if (widget.thumbIcon != null)
          RenderOverrides.only(
            RSwitchOverrides.tokens(thumbIcon: widget.thumbIcon),
          ),
      ],
    );
  }

  RSwitchSpec _createSpec() {
    return RSwitchSpec(
      value: widget.value,
      semanticLabel: widget.semanticLabel,
      dragStartBehavior: widget.dragStartBehavior,
    );
  }

  RSwitchState _createState() {
    final p = _pressable.state;
    return RSwitchState(
      isPressed: p.isPressed,
      isHovered: p.isHovered,
      isFocused: p.isFocused,
      isDisabled: widget.isDisabled,
      isSelected: widget.value,
      dragT: _dragT,
      dragVisualValue: _dragVisualValue,
    );
  }

  BoxConstraints _createBaseConstraints() {
    return BoxConstraints(
      minWidth: WcagConstants.kMinTouchTargetSize.width,
      minHeight: WcagConstants.kMinTouchTargetSize.height,
    );
  }

  BoxConstraints _resolveConstraints(
    BoxConstraints base,
    RSwitchResolvedTokens? tokens,
  ) {
    if (tokens == null) return base;
    return BoxConstraints(
      minWidth: math.max(base.minWidth, tokens.minTapTargetSize.width),
      minHeight: math.max(base.minHeight, tokens.minTapTargetSize.height),
    );
  }
}
