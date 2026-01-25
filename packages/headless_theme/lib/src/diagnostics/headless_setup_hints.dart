/// Centralized setup hints for Headless runtime errors.
///
/// Keep these as short, copy-pastable suggestions.
///
/// Note: we mention the umbrella `headless` package as the recommended
/// onboarding path, but the underlying fix also works by importing
/// `headless_material` / `headless_cupertino` directly.
library;

String headlessGoldenPathHint() {
  return "Recommended (golden path): import 'package:headless/headless.dart' and use HeadlessMaterialApp(...).";
}

String headlessMissingCapabilityWidgetMessage({
  required String missingCapabilityType,
}) {
  return 'Missing $missingCapabilityType. ${headlessGoldenPathHint()}';
}

