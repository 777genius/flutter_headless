import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_theme/headless_theme.dart';

import '_debug_utils.dart';
import 'logic/switch_drag_state.dart';
import 'missing_switch_renderer_widget.dart';
import 'r_switch_indicator.dart';
import 'r_switch_list_tile_request_factory.dart';
import 'r_switch_list_tile_switch_shell.dart';
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
  final SwitchDragState _drag = SwitchDragState();

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

  void _handleDragStart(DragStartDetails details) {
    if (widget.isDisabled) return;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    setState(() {
      _drag.begin(value: widget.value, isRtl: isRtl);
      _switchPressed = true;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_drag.isDragging || widget.isDisabled) return;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    setState(() => _drag.update(deltaX: details.delta.dx, isRtl: isRtl));
  }

  void _handleDragEnd(DragEndDetails details) {
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
    setState(() {
      _switchPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final renderer =
        HeadlessThemeProvider.maybeCapabilityOf<RSwitchListTileRenderer>(
      context,
      componentName: 'RSwitchListTile',
    );
    if (renderer == null) {
      return buildMissingSwitchRenderer(
        context: context,
        capabilityType: 'RSwitchListTileRenderer',
        componentName: 'RSwitchListTile',
      );
    }

    final pressableState = _pressable.state;
    final renderData = resolveSwitchListTileRenderData(
      context: context,
      value: widget.value,
      isDisabled: widget.isDisabled,
      subtitle: widget.subtitle,
      controlAffinity: widget.controlAffinity,
      dense: widget.dense,
      isThreeLine: widget.isThreeLine,
      selected: widget.selected,
      selectedColor: widget.selectedColor,
      contentPadding: widget.contentPadding,
      semanticLabel: widget.semanticLabel,
      style: widget.style,
      overrides: widget.overrides,
      isPressed: pressableState.isPressed,
      isHovered: pressableState.isHovered,
      isFocused: pressableState.isFocused,
      switchHovered: _switchHovered,
      switchPressed: _switchPressed,
      dragT: _drag.dragT,
      dragVisualValue: _drag.dragVisualValue,
    );
    _drag.travelPx = renderData.travelPx;

    final switchWidget = RSwitchListTileSwitchShell(
      isDisabled: widget.isDisabled,
      mouseCursor: widget.mouseCursor,
      onHoverChanged: (hovered) {
        if (!mounted) return;
        setState(() => _switchHovered = hovered);
      },
      onPressedChanged: (pressed) {
        if (!mounted) return;
        setState(() => _switchPressed = pressed);
      },
      onDragStart: _handleDragStart,
      onDragUpdate: _handleDragUpdate,
      onDragEnd: _handleDragEnd,
      child: RSwitchIndicator(
        spec: renderData.switchSpec,
        state: renderData.switchState,
        overrides: renderData.overrides,
      ),
    );

    final request = RSwitchListTileRenderRequest(
      context: context,
      spec: renderData.spec,
      state: renderData.state,
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
      resolvedTokens: renderData.resolvedTokens,
      constraints: renderData.constraints,
      overrides: renderData.overrides,
    );

    final content = renderer.render(request);
    reportUnconsumedSwitchOverrides('RSwitchListTile', renderData.overrides);

    final pressableSurfaceFactory = HeadlessThemeProvider.themeOf(context)
        .capability<HeadlessPressableSurfaceFactory>();

    Widget interactiveContent;
    if (pressableSurfaceFactory != null) {
      interactiveContent = pressableSurfaceFactory.wrap(
        context: context,
        controller: _pressable,
        enabled: !widget.isDisabled,
        onActivate: _activate,
        overrides: renderData.overrides,
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
}
