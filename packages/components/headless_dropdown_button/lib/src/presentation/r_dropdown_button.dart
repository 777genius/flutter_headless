import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import '../logic/dropdown_menu_keyboard_controller.dart';
import 'dropdown_menu_key_event_adapter.dart';
import 'dropdown_overlay_controller.dart';
import 'dropdown_selection_controller.dart';
import '../render_request/r_dropdown_request_composer.dart';
import 'render_overrides_debug.dart';
import 'r_dropdown_style.dart';
import 'r_dropdown_options_resolver.dart';
import 'r_dropdown_option.dart';
import 'r_dropdown_button_host.dart';

/// Headless dropdown button (single selection).
class RDropdownButton<T> extends StatefulWidget {
  const RDropdownButton({
    super.key,
    this.items,
    this.itemAdapter,
    this.options,
    this.value,
    this.onChanged,
    this.disabled = false,
    this.placeholder,
    this.variant = RDropdownVariant.outlined,
    this.size = RDropdownSize.medium,
    this.style,
    this.semanticLabel,
    this.autofocus = false,
    this.focusNode,
    this.slots,
    this.overrides,
  }) : assert(
          (options != null && items == null && itemAdapter == null) ||
              (options == null && items != null && itemAdapter != null),
          'Provide either options, or items + itemAdapter.',
        );

  final List<T>? items;
  final HeadlessItemAdapter<T>? itemAdapter;
  final List<RDropdownOption<T>>? options;
  final T? value;
  final ValueChanged<T>? onChanged;
  final bool disabled;
  final String? placeholder;
  final RDropdownVariant variant;
  final RDropdownSize size;

  /// Simple, Flutter-like styling sugar.
  ///
  /// Internally converted to `RenderOverrides.only(RDropdownOverrides.tokens(...))`.
  /// If [overrides] is provided, it takes precedence over this style.
  final RDropdownStyle? style;
  final String? semanticLabel;
  final bool autofocus;
  final FocusNode? focusNode;
  final RDropdownButtonSlots? slots;
  final RenderOverrides? overrides;
  bool get isDisabled => disabled || onChanged == null;

  @override
  State<RDropdownButton<T>> createState() => _RDropdownButtonState<T>();
}

class _RDropdownButtonState<T> extends State<RDropdownButton<T>> {
  late final HeadlessFocusNodeOwner _focusNodeOwner;
  FocusNode get _focusNode => _focusNodeOwner.node;
  late DropdownOverlayController _overlay;
  late DropdownSelectionController<T> _selection;
  late DropdownMenuKeyboardController _menuKeyboard;
  late HeadlessPressableController _pressable;
  late final HeadlessPressableVisualEffectsController _visualEffects;
  final _requestComposer = const RDropdownRequestComposer();
  late final RDropdownButtonHost<T> _host;
  final RDropdownOptionsResolver<T> _optionsResolver =
      RDropdownOptionsResolver<T>();
  final GlobalKey _triggerKey = GlobalKey();
  Rect? _lastAnchorRect;
  bool _isDisposed = false;
  @override
  void initState() {
    super.initState();
    _focusNodeOwner = HeadlessFocusNodeOwner(
      external: widget.focusNode,
      debugLabel: 'RDropdownButton',
    );
    _host = RDropdownButtonHost<T>(
      contextGetter: () => context,
      triggerContextGetter: () => _triggerKey.currentContext,
      triggerFocusNodeGetter: () => _focusNode,
      anchorRectGetter: _anchorRect,
      isDisposedGetter: () => _isDisposed,
      optionsGetter: _options,
      selectedIdGetter: _selectedId,
      selectedValueGetter: () => widget.value,
      onChanged: widget.onChanged,
      menuRequestBuilder: (ctx) => _createMenuRequest(ctx),
      menuKeyHandler: (node, event) => handleDropdownMenuKeyEvent(
        controller: _menuKeyboard,
        node: node,
        event: event,
      ),
      notifyStateChanged: () => setState(() {}),
    );
    _overlay = DropdownOverlayController(_host);
    _selection = DropdownSelectionController<T>(_host);
    _menuKeyboard = DropdownMenuKeyboardController(_host);
    _host.bind(overlay: _overlay, selection: _selection);
    _pressable = HeadlessPressableController(isDisabled: widget.isDisabled)
      ..addListener(_onPressableChanged);
    _visualEffects = HeadlessPressableVisualEffectsController();
  }

  void _onPressableChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(RDropdownButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.focusNode != oldWidget.focusNode) {
      _focusNodeOwner.update(widget.focusNode);
    }

    // Clear state if disabled changes (POLA invariant)
    if (widget.isDisabled && !oldWidget.isDisabled) {
      _pressable.setDisabled(true);

      if (_overlay.isMenuOpen) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_isDisposed) {
            _overlay.closeMenu();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _selection.dispose();
    _overlay.dispose();
    _pressable.removeListener(_onPressableChanged);
    _pressable.dispose();
    _visualEffects.dispose();

    _focusNodeOwner.dispose();
    super.dispose();
  }

  void openMenu() {
    if (widget.isDisabled) return;
    _selection.resetTypeahead();
    _overlay.openMenu();
  }

  void closeMenu() {
    _host.closeMenu();
  }

  void navigateUp() => _selection.navigateUp();
  void navigateDown() => _selection.navigateDown();
  void navigateToFirst() => _selection.navigateToFirst();
  void navigateToLast() => _selection.navigateToLast();
  void selectHighlighted() => _selection.selectHighlighted();
  void handleTypeahead(String char) => _selection.handleTypeahead(char);

  Rect _anchorRect() {
    final renderBox =
        _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) {
      return _lastAnchorRect ?? Rect.zero;
    }
    final topLeft = renderBox.localToGlobal(Offset.zero);
    _lastAnchorRect = topLeft & renderBox.size;
    return _lastAnchorRect!;
  }

  void _toggleMenu() => _overlay.toggleMenu();

  @override
  Widget build(BuildContext context) {
    final renderer =
        HeadlessThemeProvider.maybeCapabilityOf<RDropdownButtonRenderer>(
      context,
      componentName: 'RDropdownButton',
    );
    if (renderer == null) {
      final hasTheme = HeadlessThemeProvider.of(context) != null;
      final exception = hasTheme
          ? const MissingCapabilityException(
              capabilityType: 'RDropdownButtonRenderer',
              componentName: 'RDropdownButton',
            )
          : const MissingThemeException();
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: StackTrace.current,
          library: 'headless_dropdown_button',
          context: ErrorDescription('while building RDropdownButton'),
        ),
      );
      return HeadlessMissingCapabilityWidget(
        componentName: 'RDropdownButton',
        message: headlessMissingCapabilityWidgetMessage(
          missingCapabilityType: 'RDropdownButtonRenderer',
        ),
      );
    }

    final overrides = trackRenderOverrides(mergeStyleIntoOverrides(
      style: widget.style,
      overrides: widget.overrides,
      toOverride: (s) => s.toOverrides(),
    ));
    final request = _createTriggerRequest(context, overrides);
    final content = renderer.render(request);
    reportUnconsumedRenderOverrides('RDropdownButton', overrides);

    // Semantics must be reachable from the widget's root for tests and accessibility.
    return Semantics(
      button: true,
      enabled: !widget.isDisabled,
      expanded: _overlay.isMenuOpen,
      label: widget.semanticLabel,
      // Accessibility activation: screen readers should be able to "tap" the trigger.
      // Component owns activation; renderers must not add a second activation path.
      onTap: widget.isDisabled ? null : _toggleMenu,
      child: HeadlessPressableRegion(
        key: _triggerKey,
        controller: _pressable,
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        enabled: !widget.isDisabled,
        cursorWhenEnabled: SystemMouseCursors.click,
        cursorWhenDisabled: SystemMouseCursors.forbidden,
        onActivate: _toggleMenu,
        onArrowDown: openMenu,
        onFocusChanged: (focused) {
          if (!focused) _selection.resetTypeahead();
        },
        visualEffects: _visualEffects,
        child: content,
      ),
    );
  }

  List<RDropdownOption<T>> _options() {
    return _optionsResolver.resolve(
      items: widget.items,
      itemAdapter: widget.itemAdapter,
      options: widget.options,
    );
  }

  ListboxItemId? _selectedId() => _optionsResolver.selectedId(
        value: widget.value,
        items: widget.items,
        itemAdapter: widget.itemAdapter,
        options: widget.options,
      );

  List<HeadlessListItemModel> _itemsForRender() {
    return _optionsResolver.itemsForRender(
      items: widget.items,
      itemAdapter: widget.itemAdapter,
      options: widget.options,
    );
  }

  RDropdownButtonSpec _createSpec() {
    return RDropdownButtonSpec(
      placeholder: widget.placeholder,
      semanticLabel: widget.semanticLabel,
      variant: widget.variant,
      size: widget.size,
    );
  }

  RDropdownCommands _createCommands() {
    return RDropdownCommands(
      open: openMenu,
      close: closeMenu,
      selectIndex: _selection.selectByIndex,
      highlight: _selection.highlightIndex,
      completeClose: _overlay.completeClose,
    );
  }

  RDropdownTriggerRenderRequest _createTriggerRequest(
    BuildContext context,
    RenderOverrides? overrides,
  ) {
    final p = _pressable.state;
    final spec = _createSpec();
    final commands = _createCommands();

    return _requestComposer.createTriggerRequest(
      context: context,
      spec: spec,
      overlayPhase: _overlay.overlayPhase,
      selectedIndex: _selection.findSelectedIndex(),
      highlightedIndex: _overlay.highlightedIndex,
      isTriggerPressed: p.isPressed,
      isTriggerHovered: p.isHovered,
      isTriggerFocused: p.isFocused,
      isDisabled: widget.isDisabled,
      isExpanded: _overlay.isMenuOpen,
      items: _itemsForRender(),
      commands: commands,
      visualEffects: _visualEffects,
      slots: widget.slots,
      overrides: overrides,
    );
  }

  RDropdownMenuRenderRequest _createMenuRequest(BuildContext context) {
    final p = _pressable.state;
    final spec = _createSpec();
    final commands = _createCommands();
    final overrides = trackRenderOverrides(mergeStyleIntoOverrides(
      style: widget.style,
      overrides: widget.overrides,
      toOverride: (s) => s.toOverrides(),
    ));

    return _requestComposer.createMenuRequest(
      context: context,
      spec: spec,
      overlayPhase: _overlay.overlayPhase,
      selectedIndex: _selection.findSelectedIndex(),
      highlightedIndex: _overlay.highlightedIndex,
      isTriggerPressed: p.isPressed,
      isTriggerHovered: p.isHovered,
      isTriggerFocused: p.isFocused,
      isDisabled: widget.isDisabled,
      isExpanded: _overlay.isMenuOpen,
      items: _itemsForRender(),
      commands: commands,
      slots: widget.slots,
      overrides: overrides,
    );
  }
}
