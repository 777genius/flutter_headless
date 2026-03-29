import 'dart:io';

Future<void> main(List<String> args) async {
  final config = _parseArgs(args);
  final targets = _integrationTargets(includeWeb: config.includeWeb);
  final pubExitCode = await _runPubGet();

  stdout.writeln(
    '[headless_cli] Running apps/example integration tests on device: ${config.device}',
  );
  stdout.writeln(
    '[headless_cli] Found ${targets.length} integration targets.',
  );
  if (!config.includeWeb) {
    final skippedWebTargets = _integrationTargets(includeWeb: true).length -
        targets.length;
    if (skippedWebTargets > 0) {
      stdout.writeln(
        '[headless_cli] Skipping $skippedWebTargets web-only integration target(s). Run with --include-web on a webdriver-enabled Chrome setup to include them.',
      );
    }
  }
  if (pubExitCode != 0) {
    stderr.writeln(
      '[headless_cli] Failed to prepare apps/example dependencies (exit $pubExitCode).',
    );
    exit(pubExitCode);
  }

  for (var index = 0; index < targets.length; index++) {
    final target = targets[index];
    stdout.writeln(
      '[headless_cli] (${index + 1}/${targets.length}) $target',
    );
    await _prepareTargetRun(device: config.device);
    final exitCode = await _runIntegrationTarget(
      target: target,
      device: config.device,
    );
    if (exitCode == 0) {
      continue;
    }
    stderr.writeln(
      '[headless_cli] Integration target failed: $target (exit $exitCode).',
    );
    exit(exitCode);
  }
}

final class _RunnerConfig {
  const _RunnerConfig({
    required this.device,
    required this.includeWeb,
  });

  final String device;
  final bool includeWeb;
}

_RunnerConfig _parseArgs(List<String> args) {
  String? explicitDevice;
  var includeWeb = false;

  for (final arg in args) {
    if (arg == '--include-web') {
      includeWeb = true;
      continue;
    }
    explicitDevice ??= arg;
  }

  return _RunnerConfig(
    device: _resolveDevice(explicitDevice),
    includeWeb: includeWeb,
  );
}

String _resolveDevice(String? explicitDevice) {
  if (explicitDevice != null && explicitDevice.isNotEmpty) {
    return explicitDevice;
  }
  final environmentDevice = Platform.environment['HEADLESS_INTEGRATION_DEVICE'];
  if (environmentDevice != null && environmentDevice.isNotEmpty) {
    return environmentDevice;
  }
  if (Platform.isLinux) {
    return 'linux';
  }
  if (Platform.isWindows) {
    return 'windows';
  }
  return 'macos';
}

List<String> _integrationTargets({required bool includeWeb}) {
  final directory = Directory('apps/example/integration_test');
  final targets = directory
      .listSync(recursive: true)
      .whereType<File>()
      .map((file) => file.path)
      .where((path) => path.endsWith('_test.dart'))
      .where((path) => !path.contains('/helpers/'))
      .where((path) => includeWeb || !path.endsWith('_web_test.dart'))
      .map(_relativeTargetPath)
      .toList()
    ..sort();
  return targets;
}

String _relativeTargetPath(String absoluteOrRelativePath) {
  final normalized = absoluteOrRelativePath.replaceAll('\\', '/');
  const prefix = 'apps/example/';
  return normalized.startsWith(prefix)
      ? normalized.substring(prefix.length)
      : normalized;
}

Future<int> _runIntegrationTarget({
  required String target,
  required String device,
}) async {
  final result = await Process.start(
    'flutter',
    [
      'drive',
      '--no-pub',
      '--driver=test_driver/integration_test.dart',
      '--target=$target',
      '-d',
      device,
    ],
    workingDirectory: 'apps/example',
    environment: _integrationEnvironment(),
    mode: ProcessStartMode.inheritStdio,
  );
  return result.exitCode;
}

Future<int> _runPubGet() async {
  final result = await Process.start(
    'flutter',
    ['pub', 'get'],
    workingDirectory: 'apps/example',
    environment: _integrationEnvironment(),
    mode: ProcessStartMode.inheritStdio,
  );
  return result.exitCode;
}

Future<void> _prepareTargetRun({required String device}) async {
  if (device != 'macos') return;
  final result = await Process.run(
    'pkill',
    ['-f', 'headless_example.app/Contents/MacOS/headless_example'],
    environment: _integrationEnvironment(),
  );
  if (result.exitCode == 0) {
    stdout.writeln('[headless_cli] Terminated stale headless_example process.');
  }
}

Map<String, String> _integrationEnvironment() {
  final environment = Map<String, String>.from(Platform.environment);
  final currentPath = environment['PATH'] ?? '';
  final pathEntries = currentPath
      .split(Platform.isWindows ? ';' : ':')
      .where((entry) => entry.isNotEmpty)
      .toSet();

  final home = Platform.environment['HOME'];
  if (home == null || home.isEmpty) {
    return environment;
  }

  final gemRoot = Directory('$home/.gem/ruby');
  if (!gemRoot.existsSync()) {
    return environment;
  }

  for (final versionDir in gemRoot.listSync()) {
    if (versionDir is! Directory) {
      continue;
    }
    final binDir = '${versionDir.path}/bin';
    if (Directory(binDir).existsSync()) {
      pathEntries.add(binDir);
    }
  }

  environment['PATH'] = pathEntries.join(Platform.isWindows ? ';' : ':');
  return environment;
}
