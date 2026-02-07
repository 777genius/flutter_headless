import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';

import '../logic/autocomplete_config.dart';
import '../logic/autocomplete_coordinator.dart';
import '../logic/autocomplete_selection_mode.dart';
import '../logic/autocomplete_selection_mode_computer.dart';
import '../sources/sources.dart';
import 'a11y/r_autocomplete_combobox_semantics.dart';
import 'autocomplete_field_slots_resolver.dart';
import 'r_autocomplete_field.dart';
import 'r_autocomplete_style.dart';

/// Headless autocomplete (input + menu).
///
/// Supports three source modes:
/// - **Local**: synchronous, in-memory filtering via [source]
/// - **Remote**: asynchronous API calls with debouncing and error handling
/// - **Hybrid**: combines local and remote sources for instant + async results
///
/// Example (local with source):
/// ```dart
/// RAutocomplete<Country>(
///   source: RAutocompleteLocalSource(
///     options: (q) => countries.where((c) => c.name.contains(q.text)),
///   ),
///   itemAdapter: countryAdapter,
///   onSelected: (v) => setState(() => selected = v),
/// )
/// ```
///
/// Example (remote):
/// ```dart
/// RAutocomplete<User>(
///   source: RAutocompleteRemoteSource(
///     load: (q) => api.searchUsers(q.text),
///     policy: RAutocompleteRemotePolicy(
///       query: RAutocompleteQueryPolicy(minQueryLength: 2),
///     ),
///   ),
///   itemAdapter: userAdapter,
///   onSelected: selectUser,
/// )
/// ```
class RAutocomplete<T> extends StatefulWidget {
  /// Creates an autocomplete with the given [source].
  const RAutocomplete({
    super.key,
    required this.source,
    required this.itemAdapter,
    this.onSelected,
    this.selectedValues,
    this.onSelectionChanged,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.disabled = false,
    this.readOnly = false,
    this.initialValue,
    this.placeholder,
    this.semanticLabel,
    this.style,
    this.fieldSlots,
    this.fieldOverrides,
    this.menuSlots,
    this.menuOverrides,
    this.openOnFocus = true,
    this.openOnInput = true,
    this.openOnTap = true,
    this.closeOnSelected = true,
    this.maxOptions,
    this.hideSelectedOptions = false,
    this.pinSelectedOptions = false,
    this.selectedValuesPresentation,
    this.clearQueryOnSelection = false,
  })  : assert(
          controller == null || initialValue == null,
          'initialValue is only supported when controller is null.',
        ),
        assert(
          onSelectionChanged == null && selectedValues == null,
          'Use RAutocomplete.multiple for multiple selection.',
        ),
        assert(
          selectedValuesPresentation == null,
          'selectedValuesPresentation is only supported in multiple mode.',
        ),
        assert(
          clearQueryOnSelection == false,
          'clearQueryOnSelection is only supported in multiple mode.',
        );

  /// Creates a multiple-selection autocomplete.
  const RAutocomplete.multiple({
    super.key,
    required this.source,
    required this.itemAdapter,
    required this.selectedValues,
    required this.onSelectionChanged,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.disabled = false,
    this.readOnly = false,
    this.initialValue,
    this.placeholder,
    this.semanticLabel,
    this.style,
    this.fieldSlots,
    this.fieldOverrides,
    this.menuSlots,
    this.menuOverrides,
    this.openOnFocus = true,
    this.openOnInput = true,
    this.openOnTap = true,
    this.closeOnSelected = false,
    this.maxOptions,
    this.hideSelectedOptions = false,
    this.pinSelectedOptions = false,
    this.selectedValuesPresentation,
    this.clearQueryOnSelection = true,
  })  : onSelected = null,
        assert(
          controller == null || initialValue == null,
          'initialValue is only supported when controller is null.',
        );

  /// Data source for autocomplete options.
  final RAutocompleteSource<T> source;
  final HeadlessItemAdapter<T> itemAdapter;
  final ValueChanged<T>? onSelected;
  final List<T>? selectedValues;
  final ValueChanged<List<T>>? onSelectionChanged;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool disabled;
  final bool readOnly;
  final TextEditingValue? initialValue;

  final String? placeholder;
  final String? semanticLabel;

  /// Simple, Flutter-like styling sugar for field and options menu.
  ///
  /// Internally converted to RenderOverrides for the input field and menu.
  /// If explicit overrides are provided, they take precedence.
  final RAutocompleteStyle? style;

  final RTextFieldSlots? fieldSlots;
  final RenderOverrides? fieldOverrides;
  final RDropdownButtonSlots? menuSlots;
  final RenderOverrides? menuOverrides;

  final bool openOnFocus;
  final bool openOnInput;
  final bool openOnTap;
  final bool closeOnSelected;
  final int? maxOptions;

  /// Multiple mode: hides already-selected options from the menu.
  final bool hideSelectedOptions;

  /// Multiple mode: pins selected options to the top of the menu.
  final bool pinSelectedOptions;

  /// Multiple mode: presentation of selected values inside the field.
  ///
  /// This is interpreted by preset renderers. Headless core only exposes the data
  /// and commands through the renderer capability.
  final RAutocompleteSelectedValuesPresentation? selectedValuesPresentation;

  /// Multiple mode: whether to clear the query text after a successful selection.
  final bool clearQueryOnSelection;

  bool get isMultiple => onSelectionChanged != null;

  bool get isDisabled {
    if (disabled) return true;
    if (isMultiple) return false;
    return onSelected == null;
  }

  @override
  State<RAutocomplete<T>> createState() => _RAutocompleteState<T>();
}

class _RAutocompleteState<T> extends State<RAutocomplete<T>> {
  final GlobalKey _fieldKey = GlobalKey();
  late AutocompleteCoordinator<T> _coordinator;
  late AutocompleteSelectionMode<T> _selectionMode;
  final AutocompleteSelectionModeComputer<T> _selectionModeComputer =
      AutocompleteSelectionModeComputer<T>();
  Rect? _lastAnchorRect;

  Iterable<T> Function(TextEditingValue) get _localOptionsBuilder {
    final source = widget.source;
    final local = switch (source) {
      RAutocompleteLocalSource<T>() => source,
      RAutocompleteHybridSource<T>(:final local) => local,
      _ => null,
    };
    if (local == null) return (_) => const Iterable.empty();

    return (query) {
      final normalizedText = local.policy.query.normalize(query.text);
      if (normalizedText == null) return const Iterable.empty();
      if (normalizedText == query.text) return local.options(query);

      final newLen = normalizedText.length;
      final base = query.selection.baseOffset.clamp(0, newLen);
      final extent = query.selection.extentOffset.clamp(0, newLen);
      final normalizedQuery = query.copyWith(
        text: normalizedText,
        selection: TextSelection(baseOffset: base, extentOffset: extent),
        composing: TextRange.empty,
      );
      return local.options(normalizedQuery);
    };
  }

  bool get _localCacheEnabled {
    final source = widget.source;
    final local = switch (source) {
      RAutocompleteLocalSource<T>() => source,
      RAutocompleteHybridSource<T>(:final local) => local,
      _ => null,
    };
    return local?.policy.cache ?? true;
  }

  AutocompleteConfig<T> get _config => AutocompleteConfig(
        optionsBuilder: _localOptionsBuilder,
        localCacheEnabled: _localCacheEnabled,
        itemAdapter: widget.itemAdapter,
        disabled: widget.disabled,
        selectionMode: _selectionMode,
        openOnFocus: widget.openOnFocus,
        openOnInput: widget.openOnInput,
        openOnTap: widget.openOnTap,
        closeOnSelected: widget.closeOnSelected,
        maxOptions: widget.maxOptions,
        placeholder: widget.placeholder,
        semanticLabel: widget.semanticLabel,
        menuSlots: widget.menuSlots,
        menuOverrides: _effectiveMenuOverrides(),
        clearQueryOnSelection:
            _selectionMode.isMultiple ? widget.clearQueryOnSelection : false,
        hideSelectedOptions: widget.hideSelectedOptions,
        pinSelectedOptions: widget.pinSelectedOptions,
        source: widget.source,
      );
  AutocompleteSelectionMode<T> _computeSelectionMode() =>
      _selectionModeComputer.compute(
        onSelected: widget.onSelected,
        onSelectionChanged: widget.onSelectionChanged,
        selectedValues: widget.selectedValues,
        itemAdapter: widget.itemAdapter,
      );

  @override
  void initState() {
    super.initState();
    _selectionMode = _computeSelectionMode();
    _coordinator = AutocompleteCoordinator<T>(
      contextGetter: () => context,
      notifyStateChanged: _notifyStateChanged,
      anchorRectGetter: _anchorRect,
      controller: widget.controller,
      focusNode: widget.focusNode,
      initialValue: widget.initialValue,
      config: _config,
    );
  }

  @override
  void didUpdateWidget(RAutocomplete<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectionMode = _computeSelectionMode();
    _coordinator.updateConfig(
      config: _config,
      controller: widget.controller,
      focusNode: widget.focusNode,
      initialValue: widget.initialValue,
    );
  }

  @override
  void dispose() {
    _coordinator.dispose();
    super.dispose();
  }

  void _notifyStateChanged() {
    if (mounted) setState(() {});
  }

  bool get _isMenuOpen => _coordinator.isMenuOpen;
  bool get _isDisabled => _coordinator.isDisabled;

  Rect _anchorRect() {
    final renderBox =
        _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) {
      return _lastAnchorRect ?? Rect.zero;
    }
    final topLeft = renderBox.localToGlobal(Offset.zero);
    _lastAnchorRect = topLeft & renderBox.size;
    return _lastAnchorRect!;
  }

  @override
  Widget build(BuildContext context) {
    final fieldOverrides = _effectiveFieldOverrides();
    final effectiveSlots = resolveAutocompleteFieldSlots<T>(
      context: context,
      baseSlots: widget.fieldSlots,
      selectionMode: _selectionMode,
      itemAdapter: widget.itemAdapter,
      selectedValuesPresentation: widget.selectedValuesPresentation,
      setSelectedIdsOptimistic: _coordinator.setSelectedIdsOptimistic,
      requestFocus: _coordinator.requestFocus,
    );
    return RAutocompleteComboboxSemantics(
      enabled: !_isDisabled,
      readOnly: widget.readOnly,
      expanded: _isMenuOpen,
      label: widget.semanticLabel,
      activeDescendantLabel: _coordinator.activeDescendantSemanticsLabel,
      child: RAutocompleteField(
        key: _fieldKey,
        controller: _coordinator.controller,
        focusNode: _coordinator.focusNode,
        autofocus: widget.autofocus,
        enabled: !_isDisabled,
        readOnly: widget.readOnly,
        placeholder: widget.placeholder,
        semanticLabel: widget.semanticLabel,
        focusHover: _coordinator.focusHover,
        slots: effectiveSlots,
        overrides: fieldOverrides,
        onChanged: (_) {},
        onSubmitted: (_) {},
        onKeyEvent: _coordinator.handleKeyEvent,
        onTapContainer: _coordinator.handleTapContainer,
      ),
    );
  }

  RenderOverrides? _effectiveFieldOverrides() {
    return mergeStyleIntoOverrides(
      style: widget.style?.field,
      overrides: widget.fieldOverrides,
      toOverride: (s) => s.toOverrides(),
    );
  }

  RenderOverrides? _effectiveMenuOverrides() {
    return mergeStyleIntoOverrides(
      style: widget.style?.options,
      overrides: widget.menuOverrides,
      toOverride: (s) => s.toOverrides(),
    );
  }
}
