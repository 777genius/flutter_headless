import 'package:flutter/widgets.dart';

import '../core/adaptive_environment.dart';
import '../core/adaptive_policy.dart';
import '../core/adaptive_state.dart';
import '../core/adaptive_value.dart';
import 'adaptive_builder.dart';

typedef AdaptiveValueWidgetBuilder<T> =
    Widget Function(BuildContext context, T value, AdaptiveState adaptive);

class AdaptiveValueBuilder<T> extends StatelessWidget {
  const AdaptiveValueBuilder({
    super.key,
    required this.value,
    required this.builder,
    this.policy,
    this.environment,
    this.inputCapabilities,
  });

  final AdaptiveValue<T> value;
  final AdaptiveValueWidgetBuilder<T> builder;
  final AdaptivePolicy? policy;
  final AdaptiveEnvironment? environment;
  final Set<AdaptiveInputCapability>? inputCapabilities;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      policy: policy,
      environment: environment,
      inputCapabilities: inputCapabilities,
      builder: (context, adaptive) {
        return builder(
          context,
          value.resolve(adaptive.decision.screenClass),
          adaptive,
        );
      },
    );
  }
}
