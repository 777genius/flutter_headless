import 'package:meta/meta.dart';

import 'headless_theme.dart';
import '../diagnostics/headless_setup_hints.dart';

/// Exception thrown when a required capability is missing from the theme.
///
/// This exception uses a standardized format for ecosystem consistency.
/// The format is fixed to make errors searchable in logs and issues.
///
/// See `docs/implementation/I05_theme_capabilities_v1.md` → "2.1 Стандарт формата ошибки".
@immutable
final class MissingCapabilityException implements Exception {
  const MissingCapabilityException({
    required this.capabilityType,
    required this.componentName,
  });

  /// The type name of the missing capability (e.g., "RButtonRenderer").
  final String capabilityType;

  /// The public name of the component that requires the capability.
  final String componentName;

  @override
  String toString() {
    // MUST: Fixed prefix for searchability
    return '[Headless] Missing required capability: $capabilityType\n'
        'Component: $componentName\n'
        '${headlessGoldenPathHint()}\n'
        'Preset fix (fastest): HeadlessMaterialApp(...) / HeadlessCupertinoApp(...)\n'
        'Custom fix (HeadlessApp): provide $capabilityType in HeadlessTheme.capability<T>()\n'
        'Example:\n'
        '  class MyTheme extends HeadlessTheme {\n'
        '    @override\n'
        '    T? capability<T>() =>\n'
        '        T == $capabilityType ? MyImpl() as T : null;\n'
        '  }\n'
        'Spec: docs/SPEC_V1.md\n'
        'Conformance: docs/CONFORMANCE.md';
  }
}

/// Require a capability from the theme, throwing a standardized error if missing.
///
/// This is the central guard for capability discovery.
/// Components should use this instead of checking [HeadlessTheme.capability]
/// directly when the capability is required.
///
/// Example:
/// ```dart
/// final renderer = requireCapability<RButtonRenderer>(
///   theme,
///   componentName: 'RTextButton',
/// );
/// ```
///
/// Throws [MissingCapabilityException] if the capability is not available.
T requireCapability<T>(
  HeadlessTheme theme, {
  required String componentName,
}) {
  final capability = theme.capability<T>();

  if (capability == null) {
    throw MissingCapabilityException(
      capabilityType: T.toString(),
      componentName: componentName,
    );
  }

  return capability;
}
