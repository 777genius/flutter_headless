import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_theme/headless_theme.dart';

import '_debug_utils.dart';
import 'logic/switch_drag_state.dart';
import 'missing_switch_renderer_widget.dart';
import 'r_switch_interaction_shell.dart';
import 'r_switch_request_factory.dart';
import 'r_switch_style.dart';

/// A headless switch component.
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

  /// Determines when horizontal drag tracking starts.
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
  final SwitchDragState _drag = SwitchDragState();

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
    if (_drag.isDragging) {
      _cancelDrag();
    } else {
      _pressable.handleTapCancel();
      _visualEffects.pointerCancel();
    }
  }

  void _handleDragStart(TapDragStartDetails details) {
    if (widget.isDisabled) return;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    setState(() => _drag.begin(value: widget.value, isRtl: isRtl));
    _pressable.handleTapDown();
    _visualEffects.pointerDown(
      localPosition: details.localPosition,
      globalPosition: details.globalPosition,
    );
  }

  void _handleDragUpdate(TapDragUpdateDetails details) {
    if (!_drag.isDragging || widget.isDisabled) return;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    setState(() => _drag.update(deltaX: details.delta.dx, isRtl: isRtl));
  }

  void _handleDragEnd(TapDragEndDetails details) {
    if (!_drag.isDragging || widget.isDisabled) {
      _cancelDrag();
      return;
    }

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final nextValue = _drag.resolveNextValue(
      velocity: details.velocity.pixelsPerSecond.dx,
      isRtl: isRtl,
    );

    _cancelDrag();

    if (nextValue != null && nextValue != widget.value) {
      widget.onChanged?.call(nextValue);
    }
  }

  void _cancelDrag() {
    if (!_drag.clear()) return;
    setState(() {});
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
      return buildMissingSwitchRenderer(
        context: context,
        capabilityType: 'RSwitchRenderer',
        componentName: 'RSwitch',
      );
    }

    final pressableState = _pressable.state;
    final renderData = resolveSwitchRenderData(
      context: context,
      value: widget.value,
      isDisabled: widget.isDisabled,
      semanticLabel: widget.semanticLabel,
      dragStartBehavior: widget.dragStartBehavior,
      style: widget.style,
      overrides: widget.overrides,
      thumbIcon: widget.thumbIcon,
      slots: widget.slots,
      visualEffects: _visualEffects,
      isPressed: pressableState.isPressed,
      isHovered: pressableState.isHovered,
      isFocused: pressableState.isFocused,
      dragT: _drag.dragT,
      dragVisualValue: _drag.dragVisualValue,
    );
    _drag.travelPx = renderData.travelPx;

    final content = renderer.render(renderData.request);
    reportUnconsumedSwitchOverrides('RSwitch', renderData.overrides);

    return RSwitchInteractionShell(
      isDisabled: widget.isDisabled,
      value: widget.value,
      semanticLabel: widget.semanticLabel,
      dragStartBehavior: widget.dragStartBehavior,
      controller: _pressable,
      focusNode: _focusNodeOwner.node,
      autofocus: widget.autofocus,
      mouseCursor: widget.mouseCursor,
      onActivate: _activate,
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
      onMouseEnter: (_) {
        _pressable.handleMouseEnter();
        _visualEffects.hoverChanged(true);
      },
      onMouseExit: (_) {
        _pressable.handleMouseExit();
        _visualEffects.hoverChanged(false);
      },
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onCancel: _handleCancel,
      onDragStart: _handleDragStart,
      onDragUpdate: _handleDragUpdate,
      onDragEnd: _handleDragEnd,
      child: content,
    );
  }
}
