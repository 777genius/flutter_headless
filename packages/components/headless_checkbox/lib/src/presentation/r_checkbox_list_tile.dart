import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_theme/headless_theme.dart';

import 'r_checkbox_indicator.dart';
import 'r_checkbox_list_tile_style.dart';

/// A headless checkbox list tile component.
///
/// Single activation source: the whole row handles input and toggles value.
class RCheckboxListTile extends StatefulWidget {
  const RCheckboxListTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.secondary,
    this.tristate = false,
    this.controlAffinity = RCheckboxControlAffinity.platform,
    this.dense = false,
    this.isThreeLine = false,
    this.selected = false,
    this.selectedColor,
    this.contentPadding,
    this.semanticLabel,
    this.isError = false,
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor,
    this.textDirection,
    this.style,
    this.slots,
    this.overrides,
  }) : assert(
          tristate || value != null,
          'If tristate is false, value must be non-null.',
        ),
       assert(
          !isThreeLine || subtitle != null,
          'If isThreeLine is true, subtitle must be provided.',
        );

  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final Widget title;
  final Widget? subtitle;
  final Widget? secondary;
  final bool tristate;
  final RCheckboxControlAffinity controlAffinity;
  final bool dense;
  final bool isThreeLine;
  final bool selected;
  final Color? selectedColor;
  final EdgeInsetsGeometry? contentPadding;
  final String? semanticLabel;
  final bool isError;
  final FocusNode? focusNode;
  final bool autofocus;
  final MouseCursor? mouseCursor;
  final TextDirection? textDirection;

  /// Simple, Flutter-like styling sugar.
  ///
  /// Internally converted to
  /// `RenderOverrides.only(RCheckboxListTileOverrides.tokens(...))`.
  /// If [overrides] is provided, it takes precedence over this style.
  final RCheckboxListTileStyle? style;
  final RCheckboxListTileSlots? slots;
  final RenderOverrides? overrides;

  bool get isDisabled => onChanged == null;

  @override
  State<RCheckboxListTile> createState() => _RCheckboxListTileState();
}

class _RCheckboxListTileState extends State<RCheckboxListTile> {
  late final HeadlessFocusNodeOwner _focusNodeOwner;
  late HeadlessPressableController _pressable;
  late final HeadlessPressableVisualEffectsController _visualEffects;

  @override
  void initState() {
    super.initState();
    _focusNodeOwner = HeadlessFocusNodeOwner(
      external: widget.focusNode,
      debugLabel: 'RCheckboxListTile',
    );
    _pressable = HeadlessPressableController(isDisabled: widget.isDisabled)
      ..addListener(_onPressableChanged);
    _visualEffects = HeadlessPressableVisualEffectsController();
  }

  void _onPressableChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(RCheckboxListTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.focusNode != oldWidget.focusNode) {
      _focusNodeOwner.update(widget.focusNode);
    }

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

  bool? _nextValue() {
    final current = widget.value;
    if (!widget.tristate) {
      return !(current ?? false);
    }
    return switch (current) {
      false => true,
      true => null,
      null => false,
    };
  }

  void _activate() {
    if (widget.isDisabled) return;
    widget.onChanged?.call(_nextValue());
  }

  @override
  Widget build(BuildContext context) {
    final renderer =
        HeadlessThemeProvider.maybeCapabilityOf<RCheckboxListTileRenderer>(
      context,
      componentName: 'RCheckboxListTile',
    );
    if (renderer == null) {
      final hasTheme = HeadlessThemeProvider.of(context) != null;
      final exception = hasTheme
          ? const MissingCapabilityException(
              capabilityType: 'RCheckboxListTileRenderer',
              componentName: 'RCheckboxListTile',
            )
          : const MissingThemeException();
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: StackTrace.current,
          library: 'headless_checkbox',
          context: ErrorDescription('while building RCheckboxListTile'),
        ),
      );
      return HeadlessMissingCapabilityWidget(
        componentName: 'RCheckboxListTile',
        message: headlessMissingCapabilityWidgetMessage(
          missingCapabilityType: 'RCheckboxListTileRenderer',
        ),
      );
    }

    final overrides = _trackOverrides(mergeStyleIntoOverrides(
      style: widget.style,
      overrides: widget.overrides,
      toOverride: (s) => s.toOverrides(),
    ));
    final spec = _createSpec(context);
    final state = _createState(spec: spec);
    final baseConstraints = _createBaseConstraints();

    final theme = HeadlessThemeProvider.themeOf(context);
    final tokenResolver = theme.capability<RCheckboxListTileTokenResolver>();
    final resolvedTokens = tokenResolver?.resolve(
      context: context,
      spec: spec,
      states: state.toWidgetStates(),
      constraints: baseConstraints,
      overrides: overrides,
    );

    final constraints = _resolveConstraints(baseConstraints, resolvedTokens);

    final indicator = RCheckboxIndicator(
      spec: RCheckboxSpec(
        value: widget.value,
        tristate: widget.tristate,
        isError: widget.isError,
        semanticLabel: widget.semanticLabel,
      ),
      state: RCheckboxState(
        isDisabled: widget.isDisabled,
        isSelected:
            widget.tristate ? widget.value != false : widget.value == true,
        isError: widget.isError,
      ),
      overrides: overrides,
    );

    final request = RCheckboxListTileRenderRequest(
      context: context,
      spec: spec,
      state: state,
      checkbox: indicator,
      title: widget.title,
      subtitle: widget.subtitle,
      secondary: widget.secondary,
      semantics: RCheckboxListTileSemantics(
        label: widget.semanticLabel,
        isEnabled: !widget.isDisabled,
        value: widget.value,
        isTristate: widget.tristate,
      ),
      slots: widget.slots,
      visualEffects: _visualEffects,
      resolvedTokens: resolvedTokens,
      constraints: constraints,
      overrides: overrides,
    );

    final content = renderer.render(request);
    _reportUnconsumedOverrides('RCheckboxListTile', overrides);

    final checked = widget.value == true;
    final mixed = widget.tristate && widget.value == null;

    return Semantics(
      enabled: !widget.isDisabled,
      checked: checked,
      mixed: mixed,
      label: widget.semanticLabel,
      child: HeadlessPressableRegion(
        controller: _pressable,
        focusNode: _focusNodeOwner.node,
        autofocus: widget.autofocus,
        enabled: !widget.isDisabled,
        cursorWhenEnabled: widget.mouseCursor ?? SystemMouseCursors.click,
        cursorWhenDisabled: SystemMouseCursors.forbidden,
        onActivate: _activate,
        visualEffects: _visualEffects,
        child: content,
      ),
    );
  }

  RCheckboxListTileSpec _createSpec(BuildContext context) {
    return RCheckboxListTileSpec(
      value: widget.value,
      tristate: widget.tristate,
      isError: widget.isError,
      semanticLabel: widget.semanticLabel,
      selected: widget.selected,
      selectedColor: widget.selectedColor,
      contentPadding: widget.contentPadding,
      controlAffinity: widget.controlAffinity,
      isThreeLine: widget.isThreeLine,
      dense: widget.dense,
      textDirection: widget.textDirection ?? Directionality.of(context),
      hasSubtitle: widget.subtitle != null,
    );
  }

  RCheckboxListTileState _createState({required RCheckboxListTileSpec spec}) {
    final p = _pressable.state;
    final isSelected =
        spec.selected;
    return RCheckboxListTileState(
      isPressed: p.isPressed,
      isHovered: p.isHovered,
      isFocused: p.isFocused,
      isDisabled: widget.isDisabled,
      isSelected: isSelected,
      isError: spec.isError,
    );
  }

  BoxConstraints _createBaseConstraints() {
    return BoxConstraints(
      minHeight: WcagConstants.kMinTouchTargetSize.height,
    );
  }

  BoxConstraints _resolveConstraints(
    BoxConstraints base,
    RCheckboxListTileResolvedTokens? tokens,
  ) {
    if (tokens == null) return base;
    return BoxConstraints(
      minHeight: math.max(base.minHeight, tokens.minHeight),
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
      ..write('Hint: Your preset may not support these overrides for this component.');

    debugPrint(message.toString());
    return true;
  }());
}

