import 'dart:io';

Future<void> main() async {
  final packageRoots = _findGoldenPackageRoots();
  if (packageRoots.isEmpty) {
    stderr.writeln('[headless_cli] No golden-tagged test packages were found.');
    exit(1);
  }

  for (final packageRoot in packageRoots) {
    stdout.writeln(
      '[headless_cli] Running golden tests in $packageRoot',
    );
    final result = await Process.start(
      'flutter',
      const ['test', '--tags', 'golden'],
      workingDirectory: packageRoot,
      mode: ProcessStartMode.inheritStdio,
    );

    final exitCode = await result.exitCode;
    if (exitCode == 0) {
      continue;
    }

    stderr.writeln(
      '[headless_cli] Golden tests failed in $packageRoot with exit code $exitCode.',
    );
    exit(exitCode);
  }
}

List<String> _findGoldenPackageRoots() {
  final packagesRoot = Directory('packages');
  final packageRoots = <String>{};

  for (final entity in packagesRoot.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('_test.dart')) {
      continue;
    }
    final contents = entity.readAsStringSync();
    if (!contents.contains("@Tags(['golden'])")) {
      continue;
    }

    final testSegment =
        '${Platform.pathSeparator}test${Platform.pathSeparator}';
    final markerIndex = entity.path.indexOf(testSegment);
    if (markerIndex == -1) {
      continue;
    }
    packageRoots.add(entity.path.substring(0, markerIndex));
  }

  final sortedRoots = packageRoots.toList()..sort();
  return sortedRoots;
}
