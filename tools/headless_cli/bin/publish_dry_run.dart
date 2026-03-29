import 'package:headless_cli/src/release_manifest.dart';

Future<void> main() async {
  for (final package in releasePackages) {
    await runPublishCommand(package, dryRun: true);
  }
}
