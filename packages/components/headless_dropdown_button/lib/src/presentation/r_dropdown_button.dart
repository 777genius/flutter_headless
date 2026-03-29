import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import '../logic/dropdown_menu_keyboard_controller.dart';
import 'dropdown_anchor_rect_resolver.dart';
import 'dropdown_menu_key_event_adapter.dart';
import 'dropdown_overlay_controller.dart';
import 'dropdown_pointer_signal_handler.dart';
import 'dropdown_selection_controller.dart';
import 'missing_dropdown_button_renderer_widget.dart';
import '../render_request/r_dropdown_request_composer.dart';
import 'render_overrides_debug.dart';
import 'r_dropdown_request_factory.dart';
import 'r_dropdown_style.dart';
import 'r_dropdown_options_resolver.dart';
import 'r_dropdown_option.dart';
import 'r_dropdown_button_host.dart';
import 'r_dropdown_trigger_shell.dart';

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
  late final DropdownPointerSignalHandler _pointerSignalHandler;
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
    _pointerSignalHandler = DropdownPointerSignalHandler(
      triggerContextGetter: () => _triggerKey.currentContext,
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
      menuPointerSignalHandler: _pointerSignalHandler.handle,
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

  void closeMenu() => _host.closeMenu();

  Rect _anchorRect() => resolveDropdownAnchorRect(
        triggerKey: _triggerKey,
        lastAnchorRect: _lastAnchorRect,
        cacheRect: (rect) => _lastAnchorRect = rect,
      );

  void _toggleMenu() => _overlay.toggleMenu();

  @override
  Widget build(BuildContext context) {
    final renderer =
        HeadlessThemeProvider.maybeCapabilityOf<RDropdownButtonRenderer>(
      context,
      componentName: 'RDropdownButton',
    );
    if (renderer == null) {
      return buildMissingDropdownButtonRenderer(context: context);
    }
    final overrides = trackRenderOverrides(mergeStyleIntoOverrides(
      style: widget.style,
      overrides: widget.overrides,
      toOverride: (s) => s.toOverrides(),
    ));
    final content = renderer.render(_createTriggerRequest(context, overrides));
    reportUnconsumedRenderOverrides('RDropdownButton', overrides);
    return RDropdownTriggerShell(
      triggerKey: _triggerKey,
      isDisabled: widget.isDisabled,
      isExpanded: _overlay.isMenuOpen,
      semanticLabel: widget.semanticLabel,
      controller: _pressable,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onToggleMenu: _toggleMenu,
      onArrowDown: openMenu,
      onEscape: closeMenu,
      onFocusLost: _selection.resetTypeahead,
      visualEffects: _visualEffects,
      child: content,
    );
  }

  List<RDropdownOption<T>> _options() => _optionsResolver.resolve(
        items: widget.items,
        itemAdapter: widget.itemAdapter,
        options: widget.options,
      );

  ListboxItemId? _selectedId() => _optionsResolver.selectedId(
        value: widget.value,
        items: widget.items,
        itemAdapter: widget.itemAdapter,
        options: widget.options,
      );

  List<HeadlessListItemModel> _itemsForRender() =>
      _optionsResolver.itemsForRender(
        items: widget.items,
        itemAdapter: widget.itemAdapter,
        options: widget.options,
      );

  RDropdownButtonStateSnapshot _stateSnapshot() {
    final p = _pressable.state;
    return RDropdownButtonStateSnapshot(
      overlayPhase: _overlay.overlayPhase,
      isMenuOpen: _overlay.isMenuOpen,
      selectedIndex: _selection.findSelectedIndex(),
      highlightedIndex: _overlay.highlightedIndex,
      isTriggerPressed: p.isPressed,
      isTriggerHovered: p.isHovered,
      isTriggerFocused: p.isFocused,
    );
  }

  RDropdownButtonSpec _createSpec() => RDropdownButtonSpec(
        placeholder: widget.placeholder,
        semanticLabel: widget.semanticLabel,
        variant: widget.variant,
        size: widget.size,
      );
  RDropdownTriggerRenderRequest _createTriggerRequest(
    BuildContext context,
    RenderOverrides? overrides,
  ) {
    return createDropdownTriggerRequest(
      composer: _requestComposer,
      context: context,
      spec: _createSpec(),
      state: _stateSnapshot(),
      isDisabled: widget.isDisabled,
      items: _itemsForRender(),
      commands: createDropdownCommands(
        openMenu: openMenu,
        closeMenu: closeMenu,
        selectIndex: _selection.selectByIndex,
        highlight: _selection.highlightIndex,
        completeClose: _overlay.completeClose,
      ),
      visualEffects: _visualEffects,
      slots: widget.slots,
      overrides: overrides,
    );
  }

  RDropdownMenuRenderRequest _createMenuRequest(BuildContext context) {
    final overrides = trackRenderOverrides(mergeStyleIntoOverrides(
      style: widget.style,
      overrides: widget.overrides,
      toOverride: (s) => s.toOverrides(),
    ));
    return createDropdownMenuRequest(
      composer: _requestComposer,
      context: context,
      spec: _createSpec(),
      state: _stateSnapshot(),
      isDisabled: widget.isDisabled,
      items: _itemsForRender(),
      commands: createDropdownCommands(
        openMenu: openMenu,
        closeMenu: closeMenu,
        selectIndex: _selection.selectByIndex,
        highlight: _selection.highlightIndex,
        completeClose: _overlay.completeClose,
      ),
      slots: widget.slots,
      overrides: overrides,
    );
  }
}
