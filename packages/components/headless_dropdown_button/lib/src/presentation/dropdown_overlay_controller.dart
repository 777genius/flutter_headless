import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'r_dropdown_menu.dart';
import 'r_dropdown_menu_state.dart';

/// Callback interface for overlay controller to communicate with State.
abstract interface class DropdownOverlayHost {
  BuildContext get context;
  BuildContext? get triggerContext;
  bool get isDisposed;
  FocusNode get triggerFocusNode;
  Rect Function() get anchorRectGetter;

  int? findSelectedIndex();
  int? findFirstEnabledIndex();
  bool isItemDisabled(int index);

  RDropdownMenuRenderRequest Function(BuildContext) get menuRequestBuilder;
  KeyEventResult Function(FocusNode, KeyEvent) get menuKeyHandler;

  void notifyStateChanged();
}

/// Controls dropdown overlay lifecycle.
///
/// Manages opening, closing, and phase transitions of the menu overlay.
/// Extracted from State to reduce class size and improve testability.
final class DropdownOverlayController {
  DropdownOverlayController(this._host)
      : _menuOverlay = HeadlessMenuOverlayController(
          contextGetter: () => _host.context,
          isDisposedGetter: () => _host.isDisposed,
        ) {
    _menuOverlay.phase.addListener(_onPhaseChanged);
  }

  final DropdownOverlayHost _host;
  final HeadlessMenuOverlayController _menuOverlay;
  ValueNotifier<RDropdownMenuState>? _menuStateNotifier;
  FocusNode? _menuFocusNode;

  /// Current highlighted index in menu.
  int? get highlightedIndex => _menuStateNotifier?.value.highlightedIndex;

  /// Current overlay phase.
  ROverlayPhase get overlayPhase => _mapOverlayPhase(_menuOverlay.phase.value);

  /// Whether menu is open (opening or open phase).
  bool get isMenuOpen => _menuOverlay.isOpen;

  /// Opens the dropdown menu overlay.
  void openMenu() {
    if (_menuOverlay.hasOverlay) return;

    // Initialize highlight to selected item or first enabled
    final selectedIndex = _host.findSelectedIndex();
    final initialHighlight =
        (selectedIndex != null && !_host.isItemDisabled(selectedIndex))
            ? selectedIndex
            : _host.findFirstEnabledIndex();

    _menuStateNotifier = ValueNotifier(
      RDropdownMenuState(
        highlightedIndex: initialHighlight,
        overlayPhase: ROverlayPhase.opening,
      ),
    );

    _menuFocusNode = FocusNode(debugLabel: 'DropdownMenu');

    final anchor = HeadlessMenuAnchor(
      anchorRectGetter: _host.anchorRectGetter,
      restoreFocus: _host.triggerFocusNode,
    );

    _menuOverlay.open(
      builder: (overlayContext) {
        return RDropdownMenu(
          stateNotifier: _menuStateNotifier!,
          focusNode: _menuFocusNode!,
          createMenuRequest: _host.menuRequestBuilder,
          onKeyEvent: _host.menuKeyHandler,
        );
      },
      anchor: anchor,
      // When we explicitly transfer focus into the menu, "focus loss" is not a
      // reliable dismissal signal (focus can transiently bounce during open).
      // We still want outsideTap + escape behavior.
      dismissPolicy: DismissPolicy.nonModal.copyWith(dismissOnFocusLoss: false),
      focusPolicy: const NonModalFocusPolicy(),
      focusTransfer: HeadlessMenuFocusTransferPolicy.transferToMenu,
      menuFocusNode: _menuFocusNode,
    );
  }

  /// Starts closing animation.
  void closeMenu() {
    _menuOverlay.close();
  }

  /// Completes closing and removes overlay.
  void completeClose() {
    _menuOverlay.completeClose();
  }

  /// Toggles menu open/closed.
  void toggleMenu() {
    if (isMenuOpen) {
      closeMenu();
    } else {
      openMenu();
    }
  }

  /// Updates highlight index in menu state.
  void updateHighlight(int? index) {
    if (_host.isDisposed || _menuStateNotifier == null) return;

    _menuStateNotifier!.value = RDropdownMenuState(
      highlightedIndex: index,
      overlayPhase: overlayPhase,
    );
  }

  void _onPhaseChanged() {
    if (_host.isDisposed) return;
    final newPhase = _mapOverlayPhase(_menuOverlay.phase.value);

    if (_menuStateNotifier != null) {
      _menuStateNotifier!.value = RDropdownMenuState(
        highlightedIndex: highlightedIndex,
        overlayPhase: newPhase,
      );
    }

    _host.notifyStateChanged();

    if (newPhase == ROverlayPhase.closed) {
      _cleanupAfterClose();
    }
  }

  void _cleanupAfterClose() {
    final notifier = _menuStateNotifier;
    final menuFocus = _menuFocusNode;
    _menuStateNotifier = null;
    _menuFocusNode = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier?.dispose();
      menuFocus?.dispose();
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

  /// Disposes controller resources.
  ///
  /// Should be called from State.dispose().
  void dispose() {
    final notifier = _menuStateNotifier;
    final menuFocus = _menuFocusNode;

    _menuStateNotifier = null;
    _menuFocusNode = null;

    _menuOverlay.phase.removeListener(_onPhaseChanged);
    _menuOverlay.dispose();

    if (notifier != null || menuFocus != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier?.dispose();
        menuFocus?.dispose();
      });
    }
  }
}
