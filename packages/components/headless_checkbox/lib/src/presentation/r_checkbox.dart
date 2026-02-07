import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:headless_contracts/renderers.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_theme/headless_theme.dart';

import 'r_checkbox_style.dart';

/// A headless checkbox component.
///
/// - State is controlled: the widget does NOT store value internally.
/// - Interaction (pointer/keyboard/focus) is handled by this component.
/// - Visuals are delegated to [RCheckboxRenderer] capability.
///
/// API is intentionally close to Flutter's Checkbox/CupertinoCheckbox:
/// [value], [tristate], [onChanged], [focusNode], [autofocus], [mouseCursor],
/// [semanticLabel], [isError].
class RCheckbox extends StatefulWidget {
  const RCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.tristate = false,
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor,
    this.semanticLabel,
    this.isError = false,
    this.style,
    this.slots,
    this.overrides,
  }) : assert(
          tristate || value != null,
          'If tristate is false, value must be non-null.',
        );

  /// Whether this checkbox is checked.
  ///
  /// If [tristate] is true, this can also be null (indeterminate).
  final bool? value;

  /// Called when the value should change.
  ///
  /// If null, the checkbox is disabled.
  final ValueChanged<bool?>? onChanged;

  /// If true, this checkbox cycles through true/false/null.
  final bool tristate;

  /// Optional focus node for external focus management.
  final FocusNode? focusNode;

  /// Whether the checkbox should be focused initially.
  final bool autofocus;

  /// Mouse cursor when enabled.
  final MouseCursor? mouseCursor;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  /// Whether the checkbox wants to show an error state.
  final bool isError;

  /// Simple, Flutter-like styling sugar.
  ///
  /// Internally converted to `RenderOverrides.only(RCheckboxOverrides.tokens(...))`.
  /// If [overrides] is provided, it takes precedence over this style.
  final RCheckboxStyle? style;

  /// Optional visual slots for partial customization.
  final RCheckboxSlots? slots;

  /// Per-instance override bag for preset customization.
  final RenderOverrides? overrides;

  bool get isDisabled => onChanged == null;

  @override
  State<RCheckbox> createState() => _RCheckboxState();
}

class _RCheckboxState extends State<RCheckbox> {
  late final HeadlessFocusNodeOwner _focusNodeOwner;
  late HeadlessPressableController _pressable;
  late final HeadlessPressableVisualEffectsController _visualEffects;

  @override
  void initState() {
    super.initState();
    _focusNodeOwner = HeadlessFocusNodeOwner(
      external: widget.focusNode,
      debugLabel: 'RCheckbox',
    );
    _pressable = HeadlessPressableController(isDisabled: widget.isDisabled)
      ..addListener(_onPressableChanged);
    _visualEffects = HeadlessPressableVisualEffectsController();
  }

  void _onPressableChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(RCheckbox oldWidget) {
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
    final renderer = HeadlessThemeProvider.maybeCapabilityOf<RCheckboxRenderer>(
      context,
      componentName: 'RCheckbox',
    );
    if (renderer == null) {
      final hasTheme = HeadlessThemeProvider.of(context) != null;
      final exception = hasTheme
          ? const MissingCapabilityException(
              capabilityType: 'RCheckboxRenderer',
              componentName: 'RCheckbox',
            )
          : const MissingThemeException();
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: StackTrace.current,
          library: 'headless_checkbox',
          context: ErrorDescription('while building RCheckbox'),
        ),
      );
      return HeadlessMissingCapabilityWidget(
        componentName: 'RCheckbox',
        message: headlessMissingCapabilityWidgetMessage(
          missingCapabilityType: 'RCheckboxRenderer',
        ),
      );
    }

    final theme = HeadlessThemeProvider.themeOf(context);
    final tokenResolver = theme.capability<RCheckboxTokenResolver>();
    final overrides = _trackOverrides(mergeStyleIntoOverrides(
      style: widget.style,
      overrides: widget.overrides,
      toOverride: (s) => s.toOverrides(),
    ));

    final spec = _createSpec();
    final state = _createState(spec: spec);
    final baseConstraints = _createBaseConstraints();

    final resolvedTokens = tokenResolver?.resolve(
      context: context,
      spec: spec,
      states: state.toWidgetStates(),
      constraints: baseConstraints,
      overrides: overrides,
    );

    final constraints = _resolveConstraints(baseConstraints, resolvedTokens);

    final request = RCheckboxRenderRequest(
      context: context,
      spec: spec,
      state: state,
      semantics: RCheckboxSemantics(
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
    _reportUnconsumedOverrides('RCheckbox', overrides);

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

  RCheckboxSpec _createSpec() {
    return RCheckboxSpec(
      value: widget.value,
      tristate: widget.tristate,
      isError: widget.isError,
      semanticLabel: widget.semanticLabel,
    );
  }

  RCheckboxState _createState({required RCheckboxSpec spec}) {
    final p = _pressable.state;
    return RCheckboxState(
      isPressed: p.isPressed,
      isHovered: p.isHovered,
      isFocused: p.isFocused,
      isDisabled: widget.isDisabled,
      isSelected: spec.tristate ? spec.value != false : spec.value == true,
      isError: spec.isError,
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
    RCheckboxResolvedTokens? tokens,
  ) {
    if (tokens == null) return base;
    return BoxConstraints(
      minWidth: math.max(base.minWidth, tokens.minTapTargetSize.width),
      minHeight: math.max(base.minHeight, tokens.minTapTargetSize.height),
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
