import 'package:flutter/foundation.dart';

/// Триггеры закрытия overlay.
enum DismissTrigger {
  outsideTap,
  escapeKey,
  focusLoss,
}

/// Политика закрытия overlay через внешние триггеры.
///
/// Делаем sealed + пресеты, чтобы:
/// - дефолты были const (нужно для optional params),
/// - можно было добавлять новые триггеры аддитивно.
sealed class DismissPolicy {
  const DismissPolicy();

  /// Overlay не закрывается автоматически.
  static const DismissPolicy none = _NoDismissPolicy();

  /// Стандартная политика для modal: outsideTap + escapeKey.
  static const DismissPolicy modal = DismissByTriggers(
    <DismissTrigger>{
      DismissTrigger.outsideTap,
      DismissTrigger.escapeKey,
    },
  );

  /// Стандартная политика для non-modal: outsideTap + escapeKey + focusLoss.
  static const DismissPolicy nonModal = DismissByTriggers(
    <DismissTrigger>{
      DismissTrigger.outsideTap,
      DismissTrigger.escapeKey,
      DismissTrigger.focusLoss,
    },
  );

  factory DismissPolicy.byTriggers(
    Set<DismissTrigger> triggers, {
    bool barrierDismissible = true,
  }) {
    return DismissByTriggers(triggers, barrierDismissible: barrierDismissible);
  }

  bool get barrierDismissible;

  bool get dismissOnOutsideTap;
  bool get dismissOnEscape;
  bool get dismissOnFocusLoss;

  DismissPolicy copyWith({
    bool? dismissOnOutsideTap,
    bool? dismissOnEscape,
    bool? dismissOnFocusLoss,
    bool? barrierDismissible,
  });
}

final class _NoDismissPolicy extends DismissPolicy {
  const _NoDismissPolicy();

  @override
  bool get barrierDismissible => false;

  @override
  bool get dismissOnOutsideTap => false;

  @override
  bool get dismissOnEscape => false;

  @override
  bool get dismissOnFocusLoss => false;

  @override
  DismissPolicy copyWith({
    bool? dismissOnOutsideTap,
    bool? dismissOnEscape,
    bool? dismissOnFocusLoss,
    bool? barrierDismissible,
  }) {
    final nextTriggers = <DismissTrigger>{};
    if (dismissOnOutsideTap ?? false) {
      nextTriggers.add(DismissTrigger.outsideTap);
    }
    if (dismissOnEscape ?? false) nextTriggers.add(DismissTrigger.escapeKey);
    if (dismissOnFocusLoss ?? false) nextTriggers.add(DismissTrigger.focusLoss);

    final nextBarrierDismissible = barrierDismissible ?? false;

    if (nextTriggers.isEmpty && !nextBarrierDismissible) {
      return const _NoDismissPolicy();
    }

    return DismissByTriggers(
      nextTriggers,
      barrierDismissible: nextBarrierDismissible,
    );
  }
}

@immutable
final class DismissByTriggers extends DismissPolicy {
  const DismissByTriggers(
    this.triggers, {
    this.barrierDismissible = true,
  });

  final Set<DismissTrigger> triggers;

  @override
  final bool barrierDismissible;

  @override
  bool get dismissOnOutsideTap => triggers.contains(DismissTrigger.outsideTap);

  @override
  bool get dismissOnEscape => triggers.contains(DismissTrigger.escapeKey);

  @override
  bool get dismissOnFocusLoss => triggers.contains(DismissTrigger.focusLoss);

  @override
  DismissPolicy copyWith({
    bool? dismissOnOutsideTap,
    bool? dismissOnEscape,
    bool? dismissOnFocusLoss,
    bool? barrierDismissible,
  }) {
    final nextTriggers = {...triggers};

    void apply(DismissTrigger trigger, bool? enabled) {
      if (enabled == null) return;
      if (enabled) {
        nextTriggers.add(trigger);
      } else {
        nextTriggers.remove(trigger);
      }
    }

    apply(DismissTrigger.outsideTap, dismissOnOutsideTap);
    apply(DismissTrigger.escapeKey, dismissOnEscape);
    apply(DismissTrigger.focusLoss, dismissOnFocusLoss);

    return DismissByTriggers(
      nextTriggers,
      barrierDismissible: barrierDismissible ?? this.barrierDismissible,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DismissByTriggers &&
        setEquals(other.triggers, triggers) &&
        other.barrierDismissible == barrierDismissible;
  }

  @override
  int get hashCode => Object.hash(Object.hashAll(triggers), barrierDismissible);
}
