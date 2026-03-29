import 'dart:io';

Future<void> main(List<String> args) async {
  final device = _resolveDevice(args);
  final command = <String>[
    'test',
    'integration_test',
    '-d',
    device,
  ];

  stdout.writeln(
    '[headless_cli] Running apps/example integration tests on device: $device',
  );

  final result = await Process.start(
    'flutter',
    command,
    workingDirectory: 'apps/example',
    mode: ProcessStartMode.inheritStdio,
  );

  final exitCode = await result.exitCode;
  if (exitCode != 0) {
    stderr.writeln(
      '[headless_cli] Integration tests failed with exit code $exitCode.',
    );
    exit(exitCode);
  }
}

String _resolveDevice(List<String> args) {
  if (args.isNotEmpty) {
    return args.first;
  }
  final environmentDevice = Platform.environment['HEADLESS_INTEGRATION_DEVICE'];
  if (environmentDevice != null && environmentDevice.isNotEmpty) {
    return environmentDevice;
  }
  return 'macos';
}
