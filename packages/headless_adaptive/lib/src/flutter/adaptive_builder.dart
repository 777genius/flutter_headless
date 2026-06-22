import 'package:flutter/widgets.dart';

import '../core/adaptive_environment.dart';
import '../core/adaptive_policy.dart';
import '../core/adaptive_state.dart';
import 'adaptive_scope.dart';
import 'flutter_adaptive_environment_reader.dart';

typedef AdaptiveWidgetBuilder =
    Widget Function(BuildContext context, AdaptiveState adaptive);

class AdaptiveBuilder extends StatelessWidget {
  const AdaptiveBuilder({
    super.key,
    required this.builder,
    this.policy,
    this.environment,
    this.inputCapabilities,
  });

  final AdaptivePolicy? policy;
  final AdaptiveEnvironment? environment;
  final Set<AdaptiveInputCapability>? inputCapabilities;
  final AdaptiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedPolicy =
            policy ??
            AdaptiveScope.maybePolicyOf(context) ??
            const AdaptivePolicy();
        final resolvedEnvironment =
            environment ??
            FlutterAdaptiveEnvironmentReader.fromContext(
              context,
              constraints: constraints,
              inputCapabilities: inputCapabilities,
            );
        final decision = resolvedPolicy.resolve(resolvedEnvironment);
        final state = AdaptiveState(
          environment: resolvedEnvironment,
          policy: resolvedPolicy,
          decision: decision,
        );

        return AdaptiveScope(
          policy: resolvedPolicy,
          state: state,
          child: Builder(
            builder: (context) {
              return builder(context, state);
            },
          ),
        );
      },
    );
  }
}
