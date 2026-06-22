import 'package:flutter/widgets.dart';

import '../core/adaptive_policy.dart';
import '../core/adaptive_state.dart';

class AdaptiveScope extends InheritedWidget {
  const AdaptiveScope({
    super.key,
    required this.policy,
    required super.child,
    this.state,
  });

  final AdaptivePolicy policy;
  final AdaptiveState? state;

  static AdaptivePolicy? maybePolicyOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AdaptiveScope>()?.policy;
  }

  static AdaptivePolicy policyOf(BuildContext context) {
    final policy = maybePolicyOf(context);
    if (policy == null) {
      throw FlutterError(
        'AdaptiveScope.policyOf() called with a context that does not contain '
        'an AdaptiveScope.',
      );
    }
    return policy;
  }

  static AdaptiveState? maybeStateOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AdaptiveScope>()?.state;
  }

  static AdaptiveState stateOf(BuildContext context) {
    final state = maybeStateOf(context);
    if (state == null) {
      throw FlutterError(
        'AdaptiveScope.stateOf() called with a context that does not contain '
        'an AdaptiveState. Use this inside or below AdaptiveBuilder.',
      );
    }
    return state;
  }

  @override
  bool updateShouldNotify(covariant AdaptiveScope oldWidget) {
    return policy != oldWidget.policy || state != oldWidget.state;
  }
}
