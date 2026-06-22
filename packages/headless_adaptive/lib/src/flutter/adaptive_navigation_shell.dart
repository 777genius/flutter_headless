import 'package:flutter/widgets.dart';

import '../core/adaptive_environment.dart';
import '../core/adaptive_layout.dart';
import '../core/adaptive_policy.dart';
import '../core/adaptive_state.dart';
import 'adaptive_builder.dart';

typedef AdaptiveNavigationShellBuilder =
    Widget Function(
      BuildContext context,
      AdaptiveNavigationShellState state,
      Widget body,
    );

final class AdaptiveNavigationShellState {
  const AdaptiveNavigationShellState({required this.adaptive});

  final AdaptiveState adaptive;

  AdaptiveNavigationPattern get pattern {
    return adaptive.decision.navigationPattern;
  }

  bool get usesCompactNavigation => adaptive.decision.usesCompactNavigation;
}

class AdaptiveNavigationShell extends StatelessWidget {
  const AdaptiveNavigationShell({
    super.key,
    required this.body,
    required this.builder,
    this.policy,
    this.environment,
    this.inputCapabilities,
  });

  final Widget body;
  final AdaptiveNavigationShellBuilder builder;
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
          AdaptiveNavigationShellState(adaptive: adaptive),
          body,
        );
      },
    );
  }
}
