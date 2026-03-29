import 'dart:io';

void main() {
  final errors = <String>[];

  _requireRootFile('LICENSE', errors);
  _requireRootFile('RELEASE_NOTES.md', errors);

  for (final package in _releasePackages) {
    _checkPackageMetadata(package, errors);
    _checkPackageChangelog(package, errors);
    _checkRuntimeFiles(package, errors);
  }

  if (errors.isNotEmpty) {
    stderr.writeln('[headless_cli] Release guardrails failed:');
    for (final error in errors) {
      stderr.writeln('- $error');
    }
    exit(1);
  }

  stdout.writeln('[headless_cli] Release guardrails passed.');
}

void _requireRootFile(String path, List<String> errors) {
  if (!File(path).existsSync()) {
    errors.add('Missing required root file: $path');
  }
}

void _checkPackageMetadata(_ReleasePackage package, List<String> errors) {
  final pubspecPath = '${package.path}/pubspec.yaml';
  final pubspec = File(pubspecPath).readAsStringSync();

  _requireContains(pubspec, pubspecPath, 'version: 1.0.0', errors);
  _requireContains(
    pubspec,
    pubspecPath,
    'homepage: https://github.com/777genius/flutter_headless',
    errors,
  );
  _requireContains(
    pubspec,
    pubspecPath,
    'repository: https://github.com/777genius/flutter_headless',
    errors,
  );
  _requireContains(
    pubspec,
    pubspecPath,
    'issue_tracker: https://github.com/777genius/flutter_headless/issues',
    errors,
  );

  if (pubspec.contains('publish_to: none')) {
    errors.add('$pubspecPath still contains publish_to: none');
  }
  if (pubspec.contains(RegExp(r'^\s+path:\s', multiLine: true))) {
    errors.add('$pubspecPath still contains path dependencies');
  }
}

void _checkPackageChangelog(_ReleasePackage package, List<String> errors) {
  final changelogPath = '${package.path}/CHANGELOG.md';
  final changelogFile = File(changelogPath);
  if (!changelogFile.existsSync()) {
    errors.add('Missing package changelog: $changelogPath');
    return;
  }

  final contents = changelogFile.readAsStringSync();
  if (!contents.contains('## 1.0.0')) {
    errors.add('$changelogPath is missing a 1.0.0 entry');
  }
}

void _checkRuntimeFiles(_ReleasePackage package, List<String> errors) {
  final root = Directory('${package.path}/lib');
  if (!root.existsSync()) return;

  for (final entity in root.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final lines = entity.readAsLinesSync();
    if (lines.length > 300) {
      errors.add('${entity.path} exceeds 300 lines (${lines.length})');
    }

    for (var index = 0; index < lines.length; index++) {
      final line = lines[index];
      if (_buildMethodPattern.hasMatch(line)) {
        errors.add(
          '${entity.path}:${index + 1} contains a forbidden _build* method',
        );
      }
    }
  }
}

void _requireContains(
  String contents,
  String path,
  String needle,
  List<String> errors,
) {
  if (!contents.contains(needle)) {
    errors.add('$path is missing "$needle"');
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

final _buildMethodPattern = RegExp(r'\b_build[A-Za-z0-9_]*\s*\(');

final class _ReleasePackage {
  const _ReleasePackage(this.name, this.path);

  final String name;
  final String path;
}
