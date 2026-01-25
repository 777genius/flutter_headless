import 'package:flutter/widgets.dart';

/// Fallback widget shown when a required Headless capability is missing.
///
/// Policy:
/// - In debug/profile, missing theme/capability should be caught early by asserts.
/// - In release, we avoid crashing apps; instead, we render this small diagnostic
///   placeholder and report the error via [FlutterError.reportError].
final class HeadlessMissingCapabilityWidget extends StatelessWidget {
  const HeadlessMissingCapabilityWidget({
    super.key,
    required this.componentName,
    required this.message,
  });

  final String componentName;
  final String message;

  @override
  Widget build(BuildContext context) {
    // Keep this minimal and widget-only (no Material/Cupertino dependency).
    return Semantics(
      container: true,
      label: 'Headless error',
      child: ColoredBox(
        color: const Color(0xFFFFE6E6),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF660000),
            ),
            child: Text(
              '[Headless] $componentName is not configured.\n$message',
            ),
          ),
        ),
      ),
    );
  }
}

