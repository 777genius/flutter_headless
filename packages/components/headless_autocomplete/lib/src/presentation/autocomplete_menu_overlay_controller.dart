import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';

import 'r_autocomplete_menu_overlay.dart';
import 'r_autocomplete_menu_state.dart';
import '../logic/autocomplete_debug_log.dart';

abstract interface class AutocompleteMenuOverlayHost {
  BuildContext get context;
  bool get isDisposed;
  Rect Function() get anchorRectGetter;
  FocusNode get anchorFocusNode;
  int? get highlightedIndex;
  RDropdownMenuRenderRequest Function(BuildContext) get menuRequestBuilder;
  void notifyStateChanged();
}

final class AutocompleteMenuOverlayController {
  AutocompleteMenuOverlayController(this._host)
      : _menuOverlay = HeadlessMenuOverlayController(
          contextGetter: () => _host.context,
          isDisposedGetter: () => _host.isDisposed,
        ) {
    _menuOverlay.phase.addListener(_onPhaseChanged);
  }

  final AutocompleteMenuOverlayHost _host;
  final HeadlessMenuOverlayController _menuOverlay;

  ValueNotifier<RAutocompleteMenuState>? _menuStateNotifier;
  bool _isClosingProgrammatic = false;
  bool _wasDismissed = false;

  bool get wasDismissed => _wasDismissed;
  void resetDismissed() => _wasDismissed = false;

  bool get isMenuOpen => _menuOverlay.isOpen;
  bool get hasOverlay => _menuOverlay.hasOverlay;
  int? get highlightedIndex => _menuStateNotifier?.value.highlightedIndex;
  ROverlayPhase get overlayPhase => _mapOverlayPhase(_menuOverlay.phase.value);

  void openMenu() {
    if (_menuOverlay.hasOverlay) return;
    _menuStateNotifier = ValueNotifier(
      RAutocompleteMenuState(
        highlightedIndex: _host.highlightedIndex,
        overlayPhase: ROverlayPhase.opening,
      ),
    );

    final anchor = HeadlessMenuAnchor(
      anchorRectGetter: _host.anchorRectGetter,
      restoreFocus: _host.anchorFocusNode,
    );

    _menuOverlay.open(
      builder: (overlayContext) => RAutocompleteMenuOverlay(
        stateNotifier: _menuStateNotifier!,
        createMenuRequest: _host.menuRequestBuilder,
        anchorFocusNode: _host.anchorFocusNode,
      ),
      anchor: anchor,
      // We close autocomplete menus on input focus loss in AutocompleteCoordinator.
      // Using focusLoss dismiss here can cause close+reopen flicker during selection
      // (programmatic text updates, focus transfers).
      dismissPolicy: DismissPolicy.modal,
      focusPolicy: const NonModalFocusPolicy(),
      focusTransfer: HeadlessMenuFocusTransferPolicy.keepFocusOnAnchor,
    );
  }

  void closeMenu({required bool programmatic}) {
    if (!_menuOverlay.hasOverlay) return;
    _isClosingProgrammatic = programmatic;
    _menuOverlay.close();
  }

  void completeClose() {
    _menuOverlay.completeClose();
  }

  void updateHighlight(int? index) {
    final notifier = _menuStateNotifier;
    if (notifier == null) return;
    notifier.value = RAutocompleteMenuState(
      highlightedIndex: index,
      overlayPhase: overlayPhase,
    );
  }

  void refreshMenuState() {
    final notifier = _menuStateNotifier;
    if (notifier == null) return;
    notifier.value = RAutocompleteMenuState(
      highlightedIndex: _host.highlightedIndex,
      overlayPhase: overlayPhase,
    );
  }

  void dispose() {
    _menuOverlay.phase.removeListener(_onPhaseChanged);
    _menuOverlay.dispose();
    _disposeMenuState();
  }

  void _onPhaseChanged() {
    if (_host.isDisposed) return;
    final newPhase = _mapOverlayPhase(_menuOverlay.phase.value);
    autocompleteDebugLog(
      'menuPhase: ${_menuOverlay.phase.value} mapped=$newPhase programmatic=$_isClosingProgrammatic dismissed=$_wasDismissed',
    );

    final notifier = _menuStateNotifier;
    if (notifier != null) {
      notifier.value = RAutocompleteMenuState(
        highlightedIndex: _host.highlightedIndex,
        overlayPhase: newPhase,
      );
    }

    if (_menuOverlay.phase.value == OverlayPhase.closing &&
        !_isClosingProgrammatic) {
      _wasDismissed = true;
    }

    _host.notifyStateChanged();

    if (newPhase == ROverlayPhase.closed) {
      _isClosingProgrammatic = false;
      _disposeMenuState();
    }
  }

  void _disposeMenuState() {
    final notifier = _menuStateNotifier;
    _menuStateNotifier = null;
    if (notifier == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.dispose();
    });
  }

  ROverlayPhase _mapOverlayPhase(OverlayPhase phase) {
    return switch (phase) {
      OverlayPhase.opening => ROverlayPhase.opening,
      OverlayPhase.open => ROverlayPhase.open,
      OverlayPhase.closing => ROverlayPhase.closing,
      OverlayPhase.closed => ROverlayPhase.closed,
    };
  }
}
