import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:anchored_overlay_engine/anchored_overlay_engine.dart';
import 'headless_menu_anchor.dart';
import 'headless_menu_state.dart';

/// Reusable controller for anchored menu overlays.
final class HeadlessMenuOverlayController {
  HeadlessMenuOverlayController({
    required BuildContext Function() contextGetter,
    required bool Function() isDisposedGetter,
  })  : _contextGetter = contextGetter,
        _isDisposedGetter = isDisposedGetter;

  final BuildContext Function() _contextGetter;
  final bool Function() _isDisposedGetter;

  final ValueNotifier<OverlayPhase> _phaseNotifier =
      ValueNotifier(OverlayPhase.closed);
  final ValueNotifier<HeadlessMenuState> _stateNotifier =
      ValueNotifier(const HeadlessMenuState(phase: OverlayPhase.closed));

  OverlayHandle? _overlayHandle;

  ValueListenable<OverlayPhase> get phase => _phaseNotifier;
  ValueListenable<HeadlessMenuState> get state => _stateNotifier;

  bool get isOpen => _stateNotifier.value.isOpen;
  bool get hasOverlay => _overlayHandle != null;

  void open({
    required Widget Function(BuildContext overlayContext) builder,
    required HeadlessMenuAnchor anchor,
    required DismissPolicy dismissPolicy,
    required FocusPolicy focusPolicy,
    required HeadlessMenuFocusTransferPolicy focusTransfer,
    FocusNode? menuFocusNode,
  }) {
    if (_overlayHandle != null) return;
    if (focusTransfer == HeadlessMenuFocusTransferPolicy.transferToMenu) {
      assert(menuFocusNode != null);
    }

    final controller = AnchoredOverlayEngineHost.of(
      _contextGetter(),
      componentName: 'HeadlessMenu',
    );

    _overlayHandle = controller.show(
      OverlayRequest(
        overlayBuilder: (overlayContext) => builder(overlayContext),
        anchor: OverlayAnchor(rect: anchor.anchorRectGetter),
        dismiss: dismissPolicy,
        focus: focusPolicy,
        restoreFocus: anchor.restoreFocus,
      ),
    );

    _overlayHandle!.phase.addListener(_onPhaseChanged);
    _onPhaseChanged();

    _scheduleFocusTransfer(
      focusTransfer: focusTransfer,
      menuFocusNode: menuFocusNode,
      anchorFocusNode: anchor.restoreFocus,
    );
  }

  void close() {
    _overlayHandle?.close();
  }

  void completeClose() {
    _overlayHandle?.completeClose();
  }

  void toggle({
    required Widget Function(BuildContext overlayContext) builder,
    required HeadlessMenuAnchor anchor,
    required DismissPolicy dismissPolicy,
    required FocusPolicy focusPolicy,
    required HeadlessMenuFocusTransferPolicy focusTransfer,
    FocusNode? menuFocusNode,
  }) {
    if (isOpen) {
      close();
      return;
    }
    open(
      builder: builder,
      anchor: anchor,
      dismissPolicy: dismissPolicy,
      focusPolicy: focusPolicy,
      focusTransfer: focusTransfer,
      menuFocusNode: menuFocusNode,
    );
  }

  void dispose() {
    _overlayHandle?.phase.removeListener(_onPhaseChanged);
    final handle = _overlayHandle;
    _overlayHandle = null;

    if (handle != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          handle.close();
          handle.completeClose();
        } catch (_) {}
      });
    }

    _phaseNotifier.dispose();
    _stateNotifier.dispose();
  }

  void _onPhaseChanged() {
    final handle = _overlayHandle;
    if (handle == null || _isDisposedGetter()) return;

    final newPhase = handle.phase.value;
    if (_phaseNotifier.value != newPhase) {
      _phaseNotifier.value = newPhase;
      _stateNotifier.value = HeadlessMenuState(phase: newPhase);
    }

    if (newPhase == OverlayPhase.closed) {
      _cleanupAfterClose();
    }
  }

  void _cleanupAfterClose() {
    _overlayHandle?.phase.removeListener(_onPhaseChanged);
    _overlayHandle = null;
  }

  void _scheduleFocusTransfer({
    required HeadlessMenuFocusTransferPolicy focusTransfer,
    FocusNode? menuFocusNode,
    FocusNode? anchorFocusNode,
  }) {
    final focusNode = switch (focusTransfer) {
      HeadlessMenuFocusTransferPolicy.transferToMenu => menuFocusNode,
      HeadlessMenuFocusTransferPolicy.keepFocusOnAnchor => anchorFocusNode,
    };
    if (focusNode == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isDisposedGetter()) return;
      if (_overlayHandle == null) return;
      if (focusNode.canRequestFocus) {
        focusNode.requestFocus();
      }
    });
  }
}
