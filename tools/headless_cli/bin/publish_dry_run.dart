import 'dart:io';

Future<void> main() async {
  for (final package in _releasePackages) {
    final pubspec = File('${package.path}/pubspec.yaml').readAsStringSync();
    final usesFlutter = pubspec.contains('flutter:');
    final executable = usesFlutter ? 'flutter' : 'dart';
    final args = <String>['pub', 'publish', '--dry-run'];

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
    if (exitCode != 0) {
      stderr.writeln(
        '[headless_cli] ${package.name} publish dry-run failed with exit code $exitCode.',
      );
      exit(exitCode);
    }
  }
}

const _releasePackages = <_ReleasePackage>[
  _ReleasePackage(
      'anchored_overlay_engine', 'packages/anchored_overlay_engine'),
  _ReleasePackage('headless_tokens', 'packages/headless_tokens'),
  _ReleasePackage('headless_foundation', 'packages/headless_foundation'),
  _ReleasePackage('headless_contracts', 'packages/headless_contracts'),
  _ReleasePackage('headless_theme', 'packages/headless_theme'),
  _ReleasePackage('headless_adaptive', 'packages/headless_adaptive'),
  _ReleasePackage('headless_material', 'packages/headless_material'),
  _ReleasePackage('headless_cupertino', 'packages/headless_cupertino'),
  _ReleasePackage('headless_test', 'packages/headless_test'),
  _ReleasePackage('headless', 'packages/headless'),
  _ReleasePackage('headless_button', 'packages/components/headless_button'),
  _ReleasePackage('headless_checkbox', 'packages/components/headless_checkbox'),
  _ReleasePackage('headless_switch', 'packages/components/headless_switch'),
  _ReleasePackage(
    'headless_dropdown_button',
    'packages/components/headless_dropdown_button',
  ),
  _ReleasePackage(
      'headless_textfield', 'packages/components/headless_textfield'),
  _ReleasePackage(
    'headless_autocomplete',
    'packages/components/headless_autocomplete',
  ),
];

final class _ReleasePackage {
  const _ReleasePackage(this.name, this.path);

  final String name;
  final String path;
}
