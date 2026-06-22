import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adaptive layout primitives keep unstyled package boundaries', () {
    final packageRoot = _packageRootPath();
    final importsByFile = <String, Set<String>>{
      ..._collectImportsByFile('$packageRoot/lib/src/controllers'),
      ..._collectImportsByFile('$packageRoot/lib/src/core'),
      ..._collectImportsByFile('$packageRoot/lib/src/flutter'),
    };

    for (final entry in importsByFile.entries) {
      final path = entry.key;
      final imports = entry.value;

      _expectNoImportsStartingWith(path, imports, const [
        'package:flutter/material.dart',
        'package:flutter/cupertino.dart',
        'package:go_router',
        'package:mobx',
        'package:flutter_mobx',
        'package:flutter_bloc',
        'package:flutter_riverpod',
        'package:social_monitor_',
        'package:headless',
      ]);
    }
  });
}

Map<String, Set<String>> _collectImportsByFile(String directoryPath) {
  final directory = Directory(directoryPath);
  final importsByFile = <String, Set<String>>{};

  for (final entity in directory.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) {
      continue;
    }

    final imports = <String>{};
    for (final line in entity.readAsLinesSync()) {
      final normalized = line.trim();
      if (!normalized.startsWith('import ') &&
          !normalized.startsWith('export ')) {
        continue;
      }
      final uri = _extractImportUri(normalized);
      if (uri != null) {
        imports.add(uri);
      }
    }
    importsByFile[entity.path] = imports;
  }

  return importsByFile;
}

void _expectNoImportsStartingWith(
  String path,
  Set<String> actualImports,
  List<String> forbiddenPrefixes,
) {
  final forbiddenImports = actualImports.where((uri) {
    return forbiddenPrefixes.any(uri.startsWith);
  }).toList();

  expect(forbiddenImports, isEmpty, reason: path);
}

String? _extractImportUri(String line) {
  final firstQuote = line.indexOf("'");
  if (firstQuote == -1) {
    return null;
  }

  final secondQuote = line.indexOf("'", firstQuote + 1);
  if (secondQuote == -1) {
    return null;
  }

  return line.substring(firstQuote + 1, secondQuote);
}

String _packageRootPath() {
  final current = Directory.current;
  final directPackage = Directory('${current.path}/packages/headless_adaptive');
  if (directPackage.existsSync()) {
    return directPackage.path;
  }

  if (File('${current.path}/pubspec.yaml').existsSync() &&
      Directory('${current.path}/lib').existsSync()) {
    return current.path;
  }

  var scriptDirectory = File.fromUri(Platform.script).parent;
  while (scriptDirectory.path != scriptDirectory.parent.path) {
    if (File('${scriptDirectory.path}/pubspec.yaml').existsSync() &&
        Directory('${scriptDirectory.path}/lib').existsSync() &&
        scriptDirectory.path.endsWith('headless_adaptive')) {
      return scriptDirectory.path;
    }
    scriptDirectory = scriptDirectory.parent;
  }

  throw StateError('Could not locate headless_adaptive package root.');
}
