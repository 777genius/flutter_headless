import 'adaptive_decision.dart';
import 'adaptive_environment.dart';
import 'adaptive_policy.dart';

final class AdaptiveState {
  const AdaptiveState({
    required this.environment,
    required this.policy,
    required this.decision,
  });

  final AdaptiveEnvironment environment;
  final AdaptivePolicy policy;
  final AdaptiveDecision decision;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AdaptiveState &&
            other.environment == environment &&
            other.policy == policy &&
            other.decision == decision;
  }

  @override
  int get hashCode => Object.hash(environment, policy, decision);
}
