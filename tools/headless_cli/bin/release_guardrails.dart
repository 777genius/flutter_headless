import 'dart:io';

import 'package:headless_cli/src/release_manifest.dart';

void main() {
  final errors = <String>[];

  _requireRootFile('LICENSE', errors);
  _requireRootFile('RELEASE_NOTES.md', errors);
  _requireRootFile('RELEASING.md', errors);

  for (final package in releasePackages) {
    _checkPackageMetadata(package, errors);
    _checkPackageDocs(package, errors);
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

void _checkPackageMetadata(ReleasePackage package, List<String> errors) {
  final pubspecPath = package.pubspecPath;
  final pubspec = File(pubspecPath).readAsStringSync();

  _requireContains(pubspec, pubspecPath, 'version: $releaseVersion', errors);
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

void _checkPackageDocs(ReleasePackage package, List<String> errors) {
  final license = File('${package.path}/LICENSE');
  if (!license.existsSync()) {
    errors.add('Missing package LICENSE: ${license.path}');
  }

  final readme = File('${package.path}/README.md');
  if (!readme.existsSync()) {
    errors.add('Missing package README: ${readme.path}');
  }
}

void _checkPackageChangelog(ReleasePackage package, List<String> errors) {
  final changelogPath = '${package.path}/CHANGELOG.md';
  final changelogFile = File(changelogPath);
  if (!changelogFile.existsSync()) {
    errors.add('Missing package changelog: $changelogPath');
    return;
  }

  final contents = changelogFile.readAsStringSync();
  if (!contents.contains('## $releaseVersion')) {
    errors.add('$changelogPath is missing a $releaseVersion entry');
  }
}

void _checkRuntimeFiles(ReleasePackage package, List<String> errors) {
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

final _buildMethodPattern = RegExp(r'\b_build[A-Za-z0-9_]*\s*\(');
