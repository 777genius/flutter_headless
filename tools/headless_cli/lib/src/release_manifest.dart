import 'dart:io';

const releasePackages = <ReleasePackage>[
  ReleasePackage('anchored_overlay_engine', 'packages/anchored_overlay_engine'),
  ReleasePackage('headless_tokens', 'packages/headless_tokens'),
  ReleasePackage('headless_foundation', 'packages/headless_foundation'),
  ReleasePackage('headless_contracts', 'packages/headless_contracts'),
  ReleasePackage('headless_theme', 'packages/headless_theme'),
  ReleasePackage('headless_material', 'packages/headless_material'),
  ReleasePackage(
    'headless_textfield',
    'packages/components/headless_textfield',
  ),
  ReleasePackage('headless_cupertino', 'packages/headless_cupertino'),
  ReleasePackage('headless_adaptive', 'packages/headless_adaptive'),
  ReleasePackage('headless_test', 'packages/headless_test'),
  ReleasePackage('headless_button', 'packages/components/headless_button'),
  ReleasePackage('headless_checkbox', 'packages/components/headless_checkbox'),
  ReleasePackage('headless_switch', 'packages/components/headless_switch'),
  ReleasePackage(
    'headless_dropdown_button',
    'packages/components/headless_dropdown_button',
  ),
  ReleasePackage(
    'headless_autocomplete',
    'packages/components/headless_autocomplete',
  ),
  ReleasePackage('headless', 'packages/headless'),
];

final class ReleasePackage {
  const ReleasePackage(this.name, this.path);

  final String name;
  final String path;

  String get pubspecPath => '$path/pubspec.yaml';

  bool get usesFlutter => File(pubspecPath).readAsStringSync().contains(
        'flutter:',
      );
}

ReleasePackage? releasePackageByName(String name) {
  for (final package in releasePackages) {
    if (package.name == name) {
      return package;
    }
  }
  return null;
}

Iterable<ReleasePackage> releasePackagesFrom(String? fromPackage) sync* {
  var shouldYield = fromPackage == null;
  for (final package in releasePackages) {
    if (!shouldYield && package.name == fromPackage) {
      shouldYield = true;
    }
    if (shouldYield) {
      yield package;
    }
  }
}

Future<void> ensureCleanGitState() async {
  final result = await Process.run('git', const ['status', '--short']);
  final stdoutOutput = result.stdout.toString().trim();
  final stderrOutput = result.stderr.toString().trim();

  if (result.exitCode != 0) {
    stderr.writeln('[headless_cli] Failed to inspect git state.');
    if (stderrOutput.isNotEmpty) {
      stderr.writeln(stderrOutput);
    }
    exit(result.exitCode);
  }

  if (stdoutOutput.isEmpty) {
    return;
  }

  stderr.writeln(
    '[headless_cli] Refusing to publish from a dirty git state. Commit or revert these changes first:',
  );
  stderr.writeln(stdoutOutput);
  exit(1);
}

Future<void> runPublishCommand(
  ReleasePackage package, {
  required bool dryRun,
}) async {
  final executable = package.usesFlutter ? 'flutter' : 'dart';
  final args = <String>[
    'pub',
    'publish',
    if (dryRun) '--dry-run' else '--force'
  ];

  stdout.writeln(
    '[headless_cli] ${package.name}: running "$executable ${args.join(' ')}"',
  );

  final result = await Process.start(
    executable,
    args,
    workingDirectory: package.path,
    mode: ProcessStartMode.inheritStdio,
  );
  final exitCode = await result.exitCode;
  if (exitCode == 0) {
    return;
  }

  stderr.writeln(
    '[headless_cli] ${package.name} publish ${dryRun ? 'dry-run' : 'command'} failed with exit code $exitCode.',
  );
  exit(exitCode);
}
