import 'dart:io';

import 'package:args/args.dart';
import 'package:headless_cli/src/release_manifest.dart';

Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addFlag(
      'yes',
      abbr: 'y',
      negatable: false,
      help: 'Actually publish packages to pub.dev in release order.',
    )
    ..addOption(
      'from',
      help: 'Resume publishing from this package name.',
    );

  final results = parser.parse(args);
  if (!(results['yes'] as bool)) {
    stderr.writeln(
      '[headless_cli] Refusing to publish without --yes. Run release:check first, then rerun with --yes when you are ready.',
    );
    exit(64);
  }

  final fromPackage = results['from'] as String?;
  if (fromPackage != null && releasePackageByName(fromPackage) == null) {
    stderr.writeln(
      '[headless_cli] Unknown package passed to --from: $fromPackage',
    );
    exit(64);
  }

  await ensureCleanGitState();

  for (final package in releasePackagesFrom(fromPackage)) {
    await runPublishCommand(package, dryRun: false);
  }
}
