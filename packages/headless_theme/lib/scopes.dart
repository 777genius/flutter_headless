import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'src/theme/capability_overrides.dart';
import 'src/theme/headless_theme_overrides_scope.dart';

Widget _buildTwoCapabilitiesScope<A extends Object, B extends Object>({
  required Widget child,
  required A? capabilityA,
  required B? capabilityB,
}) {
  if (capabilityA == null && capabilityB == null) return child;

  final overrides = CapabilityOverrides.build((b) {
    if (capabilityA != null) b.set<A>(capabilityA);
    if (capabilityB != null) b.set<B>(capabilityB);
  });

  return HeadlessThemeOverridesScope(overrides: overrides, child: child);
}

/// Scoped capability overrides for buttons without generics.
class HeadlessButtonScope extends StatelessWidget {
  const HeadlessButtonScope({
    super.key,
    this.renderer,
    this.tokenResolver,
    required this.child,
  });

  final RButtonRenderer? renderer;
  final RButtonTokenResolver? tokenResolver;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _buildTwoCapabilitiesScope<RButtonRenderer, RButtonTokenResolver>(
      child: child,
      capabilityA: renderer,
      capabilityB: tokenResolver,
    );
  }
}

/// Scoped capability overrides for dropdowns without generics.
class HeadlessDropdownScope extends StatelessWidget {
  const HeadlessDropdownScope({
    super.key,
    this.renderer,
    this.tokenResolver,
    required this.child,
  });

  final RDropdownButtonRenderer? renderer;
  final RDropdownTokenResolver? tokenResolver;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _buildTwoCapabilitiesScope<RDropdownButtonRenderer,
        RDropdownTokenResolver>(
      child: child,
      capabilityA: renderer,
      capabilityB: tokenResolver,
    );
  }
}

/// Scoped capability overrides for text fields without generics.
class HeadlessTextFieldScope extends StatelessWidget {
  const HeadlessTextFieldScope({
    super.key,
    this.renderer,
    this.tokenResolver,
    required this.child,
  });

  final RTextFieldRenderer? renderer;
  final RTextFieldTokenResolver? tokenResolver;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _buildTwoCapabilitiesScope<RTextFieldRenderer,
        RTextFieldTokenResolver>(
      child: child,
      capabilityA: renderer,
      capabilityB: tokenResolver,
    );
  }
}

/// Scoped capability overrides for checkboxes without generics.
class HeadlessCheckboxScope extends StatelessWidget {
  const HeadlessCheckboxScope({
    super.key,
    this.renderer,
    this.tokenResolver,
    required this.child,
  });

  final RCheckboxRenderer? renderer;
  final RCheckboxTokenResolver? tokenResolver;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _buildTwoCapabilitiesScope<RCheckboxRenderer,
        RCheckboxTokenResolver>(
      child: child,
      capabilityA: renderer,
      capabilityB: tokenResolver,
    );
  }
}

/// Scoped capability overrides for checkbox list tiles without generics.
class HeadlessCheckboxListTileScope extends StatelessWidget {
  const HeadlessCheckboxListTileScope({
    super.key,
    this.renderer,
    this.tokenResolver,
    required this.child,
  });

  final RCheckboxListTileRenderer? renderer;
  final RCheckboxListTileTokenResolver? tokenResolver;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _buildTwoCapabilitiesScope<RCheckboxListTileRenderer,
        RCheckboxListTileTokenResolver>(
      child: child,
      capabilityA: renderer,
      capabilityB: tokenResolver,
    );
  }
}
