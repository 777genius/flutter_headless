import 'package:flutter/widgets.dart';

/// Политика управления фокусом для overlay.
///
/// Сейчас используется как scaffold для стабильного публичного API.
/// Полная реализация trap/initialFocus может добавляться аддитивно.
sealed class FocusPolicy {
  const FocusPolicy();
}

/// Non-modal overlay: фокус остаётся свободным.
final class NonModalFocusPolicy extends FocusPolicy {
  const NonModalFocusPolicy({
    this.restoreOnClose = true,
  });

  /// Восстановить фокус на trigger при закрытии.
  final bool restoreOnClose;
}

/// Modal overlay: по умолчанию предполагает trap + restore.
final class ModalFocusPolicy extends FocusPolicy {
  const ModalFocusPolicy({
    this.trap = true,
    this.restoreOnClose = true,
    this.initialFocus,
  });

  final bool trap;
  final bool restoreOnClose;
  final FocusNode? initialFocus;
}
