import 'package:flutter/widgets.dart';

import '../core/adaptive_environment.dart';
import '../core/adaptive_policy.dart';
import '../core/adaptive_value.dart';
import 'adaptive_builder.dart';

class AdaptiveMaxWidth extends StatelessWidget {
  const AdaptiveMaxWidth({
    super.key,
    required this.child,
    this.policy,
    this.environment,
    this.inputCapabilities,
    this.maxWidth,
    this.alignment = Alignment.topCenter,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final AdaptivePolicy? policy;
  final AdaptiveEnvironment? environment;
  final Set<AdaptiveInputCapability>? inputCapabilities;
  final AdaptiveValue<double>? maxWidth;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      policy: policy,
      environment: environment,
      inputCapabilities: inputCapabilities,
      builder: (context, adaptive) {
        final resolvedMaxWidth =
            maxWidth?.resolveDecision(adaptive.decision) ??
            adaptive.decision.maxContentWidth;
        final constrained = ConstrainedBox(
          constraints: BoxConstraints(maxWidth: resolvedMaxWidth),
          child: child,
        );

        return Align(
          alignment: alignment,
          child: Padding(padding: padding, child: constrained),
        );
      },
    );
  }
}
