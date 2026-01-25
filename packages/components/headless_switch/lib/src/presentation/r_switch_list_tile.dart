import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_theme/headless_theme.dart';

import '_debug_utils.dart';
import 'logic/switch_drag_decider.dart';
import 'r_switch_indicator.dart';
import 'r_switch_list_tile_style.dart';

/// A headless switch list tile component.
///
/// Single activation source: the whole row handles input and toggles value.
class RSwitchListTile extends StatefulWidget {
  const RSwitchListTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.secondary,
    this.controlAffinity = RSwitchControlAffinity.platform,
    this.dense = false,
    this.isThreeLine = false,
    this.selected = false,
    this.selectedColor,
    this.contentPadding,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor,
    this.style,
    this.slots,
    this.overrides,
  }) : assert(
          !isThreeLine || subtitle != null,
          'If isThreeLine is true, subtitle must be provided.',
        );

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget title;
  final Widget? subtitle;
  final Widget? secondary;
  final RSwitchControlAffinity controlAffinity;
  final bool dense;
  final bool isThreeLine;
  final bool selected;
  final Color? selectedColor;
  final EdgeInsetsGeometry? contentPadding;
  final String? semanticLabel;
  final FocusNode? focusNode;
  final bool autofocus;
  final MouseCursor? mouseCursor;

  /// Simple, Flutter-like styling sugar.
  ///
  /// Internally converted to
  /// `RenderOverrides.only(RSwitchListTileOverrides.tokens(...))`.
  /// If [overrides] is provided, it takes precedence over this style.
  final RSwitchListTileStyle? style;
  final RSwitchListTileSlots? slots;
  final RenderOverrides? overrides;

  bool get isDisabled => onChanged == null;

  @override
  State<RSwitchListTile> createState() => _RSwitchListTileState();
}

class _RSwitchListTileState extends State<RSwitchListTile> {
  late final HeadlessFocusNodeOwner _focusNodeOwner;
  late HeadlessPressableController _pressable;
  late final HeadlessPressableVisualEffectsController _visualEffects;

  double? _dragT;
  bool? _dragVisualValue;
  double _travelPx = 0;
  bool _needsDrag = false;

  bool _switchHovered = false;
  bool _switchPressed = false;

  @override
  void initState() {
    super.initState();
    _focusNodeOwner = HeadlessFocusNodeOwner(
      external: widget.focusNode,
      debugLabel: 'RSwitchListTile',
    );
    _pressable = HeadlessPressableController(isDisabled: widget.isDisabled)
      ..addListener(_onPressableChanged);
    _visualEffects = HeadlessPressableVisualEffectsController();
  }

  void _onPressableChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(RSwitchListTile oldWidget) {
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

  void _handleDragStart(DragStartDetails details) {
    if (widget.isDisabled) return;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    setState(() {
      _dragT = initialDragT(value: widget.value, isRtl: isRtl);
      _dragVisualValue = widget.value;
      _needsDrag = true;
      _switchPressed = true;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
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

  void _handleDragEnd(DragEndDetails details) {
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
      _switchPressed = false;
    });
  }

  void _onSwitchPointerDown(PointerDownEvent _) {
    if (widget.isDisabled) return;
    if (mounted) setState(() => _switchPressed = true);
  }

  void _onSwitchPointerUp(PointerUpEvent _) {
    if (mounted) setState(() => _switchPressed = false);
  }

  void _onSwitchPointerCancel(PointerCancelEvent _) {
    if (mounted) setState(() => _switchPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final renderer =
        HeadlessThemeProvider.maybeCapabilityOf<RSwitchListTileRenderer>(
      context,
      componentName: 'RSwitchListTile',
    );
    if (renderer == null) {
      final hasTheme = HeadlessThemeProvider.of(context) != null;
      final exception = hasTheme
          ? const MissingCapabilityException(
              capabilityType: 'RSwitchListTileRenderer',
              componentName: 'RSwitchListTile',
            )
          : const MissingThemeException();
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: StackTrace.current,
          library: 'headless_switch',
          context: ErrorDescription('while building RSwitchListTile'),
        ),
      );
      return HeadlessMissingCapabilityWidget(
        componentName: 'RSwitchListTile',
        message: headlessMissingCapabilityWidgetMessage(
          missingCapabilityType: 'RSwitchListTileRenderer',
        ),
      );
    }

    final overrides = trackSwitchOverrides(mergeStyleIntoOverrides(
      style: widget.style,
      overrides: widget.overrides,
      toOverride: (s) => s.toOverrides(),
    ));
    final spec = _createSpec();
    final state = _createState(spec: spec);
    final baseConstraints = _createBaseConstraints();

    final theme = HeadlessThemeProvider.themeOf(context);
    final tokenResolver = theme.capability<RSwitchListTileTokenResolver>();
    final resolvedTokens = tokenResolver?.resolve(
      context: context,
      spec: spec,
      states: state.toWidgetStates(),
      constraints: baseConstraints,
      overrides: overrides,
    );

    final constraints = _resolveConstraints(baseConstraints, resolvedTokens);

    final switchState = RSwitchState(
      // IMPORTANT: ListTile hover/press should not make the switch indicator
      // look hovered/pressed. Flutter's SwitchListTile highlights the tile,
      // while the Switch reacts to hover only when the pointer is over it.
      //
      // We still forward focus so Tab navigation shows the correct focus visuals.
      isFocused: _pressable.state.isFocused,
      isHovered: _switchHovered,
      isPressed: _switchPressed,
      isDisabled: widget.isDisabled,
      isSelected: widget.value,
      dragT: _dragT,
      dragVisualValue: _dragVisualValue,
    );

    final switchTokenResolver = theme.capability<RSwitchTokenResolver>();
    final switchTokens = switchTokenResolver?.resolve(
      context: context,
      spec: RSwitchSpec(value: widget.value, semanticLabel: widget.semanticLabel),
      states: switchState.toWidgetStates(),
      constraints: BoxConstraints(
        minWidth: WcagConstants.kMinTouchTargetSize.width,
        minHeight: WcagConstants.kMinTouchTargetSize.height,
      ),
      overrides: overrides,
    );

    if (switchTokens != null) {
      _travelPx = computeTravelPx(
        trackWidth: switchTokens.trackSize.width,
        trackHeight: switchTokens.trackSize.height,
      );
    }

    final indicator = RSwitchIndicator(
      spec: RSwitchSpec(
        value: widget.value,
        semanticLabel: widget.semanticLabel,
      ),
      state: switchState,
      overrides: overrides,
    );

    final switchWidget = MouseRegion(
      onEnter: (_) {
        if (mounted) setState(() => _switchHovered = true);
      },
      onExit: (_) {
        if (mounted) setState(() {
          _switchHovered = false;
          _switchPressed = false;
        });
      },
      cursor: widget.isDisabled
          ? SystemMouseCursors.forbidden
          : (widget.mouseCursor ?? SystemMouseCursors.click),
      child: Listener(
        onPointerDown: _onSwitchPointerDown,
        onPointerUp: _onSwitchPointerUp,
        onPointerCancel: _onSwitchPointerCancel,
        child: RawGestureDetector(
          behavior: HitTestBehavior.opaque,
          gestures: <Type, GestureRecognizerFactory>{
            HorizontalDragGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<
                    HorizontalDragGestureRecognizer>(
              () => HorizontalDragGestureRecognizer(debugOwner: this),
              (HorizontalDragGestureRecognizer instance) {
                instance
                  ..onStart = _handleDragStart
                  ..onUpdate = _handleDragUpdate
                  ..onEnd = _handleDragEnd;
              },
            ),
          },
          child: indicator,
        ),
      ),
    );

    final request = RSwitchListTileRenderRequest(
      context: context,
      spec: spec,
      state: state,
      switchWidget: switchWidget,
      title: widget.title,
      subtitle: widget.subtitle,
      secondary: widget.secondary,
      semantics: RSwitchListTileSemantics(
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
    reportUnconsumedSwitchOverrides('RSwitchListTile', overrides);

    final pressableSurfaceFactory =
        theme.capability<HeadlessPressableSurfaceFactory>();

    Widget interactiveContent;
    if (pressableSurfaceFactory != null) {
      interactiveContent = pressableSurfaceFactory.wrap(
        context: context,
        controller: _pressable,
        enabled: !widget.isDisabled,
        onActivate: _activate,
        overrides: overrides,
        visualEffects: _visualEffects,
        focusNode: _focusNodeOwner.node,
        autofocus: widget.autofocus,
        cursorWhenEnabled: widget.mouseCursor ?? SystemMouseCursors.click,
        cursorWhenDisabled: SystemMouseCursors.forbidden,
        child: content,
      );
    } else {
      interactiveContent = HeadlessPressableRegion(
        controller: _pressable,
        focusNode: _focusNodeOwner.node,
        autofocus: widget.autofocus,
        enabled: !widget.isDisabled,
        cursorWhenEnabled: widget.mouseCursor ?? SystemMouseCursors.click,
        cursorWhenDisabled: SystemMouseCursors.forbidden,
        onActivate: _activate,
        visualEffects: _visualEffects,
        child: content,
      );
    }

    return Semantics(
      enabled: !widget.isDisabled,
      toggled: widget.value,
      label: widget.semanticLabel,
      excludeSemantics: widget.semanticLabel != null,
      child: interactiveContent,
    );
  }

  RSwitchListTileSpec _createSpec() {
    return RSwitchListTileSpec(
      value: widget.value,
      semanticLabel: widget.semanticLabel,
      selected: widget.selected,
      selectedColor: widget.selectedColor,
      contentPadding: widget.contentPadding,
      controlAffinity: widget.controlAffinity,
      isThreeLine: widget.isThreeLine,
      dense: widget.dense,
      hasSubtitle: widget.subtitle != null,
    );
  }

  RSwitchListTileState _createState({required RSwitchListTileSpec spec}) {
    final p = _pressable.state;
    final isSelected = spec.selected;
    return RSwitchListTileState(
      isPressed: p.isPressed,
      isHovered: p.isHovered,
      isFocused: p.isFocused,
      isDisabled: widget.isDisabled,
      isSelected: isSelected,
    );
  }

  BoxConstraints _createBaseConstraints() {
    return BoxConstraints(
      minHeight: WcagConstants.kMinTouchTargetSize.height,
    );
  }

  BoxConstraints _resolveConstraints(
    BoxConstraints base,
    RSwitchListTileResolvedTokens? tokens,
  ) {
    if (tokens == null) return base;
    return BoxConstraints(
      minHeight: math.max(base.minHeight, tokens.minHeight),
    );
  }
}
