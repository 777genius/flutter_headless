import 'dart:io';

import 'package:args/args.dart';

void main(List<String> args) {
  final parser = ArgParser();
  parser.addFlag(
    'help',
    abbr: 'h',
    negatable: false,
    help: 'Show usage.',
  );

  final generate = ArgParser();
  final component = ArgParser();
  component.addFlag(
    'dry-run',
    negatable: false,
    help: 'Print files without writing.',
  );
  component.addFlag(
    'force',
    negatable: false,
    help: 'Overwrite existing files.',
  );
  component.addOption(
    'path',
    defaultsTo: 'packages/components',
    help: 'Base directory for component packages.',
  );
  generate.addCommand('component', component);
  parser.addCommand('generate', generate);

  ArgResults results;
  try {
    results = parser.parse(args);
  } on ArgParserException catch (e) {
    _stderr(e.message);
    _printUsage(parser);
    exitCode = 64;
    return;
  }

  if (results['help'] == true || results.command == null) {
    _printUsage(parser);
    return;
  }

  final command = results.command!;
  switch (command.name) {
    case 'generate':
      _handleGenerate(command, parser);
    default:
      _stderr('Unknown command: ${command.name}');
      _printUsage(parser);
      exitCode = 64;
  }
}

void _handleGenerate(ArgResults command, ArgParser rootParser) {
  final sub = command.command;
  if (sub == null) {
    _stderr('Missing generate subcommand.');
    _printUsage(rootParser);
    exitCode = 64;
    return;
  }
  switch (sub.name) {
    case 'component':
      _generateComponent(sub);
    default:
      _stderr('Unknown generate subcommand: ${sub.name}');
      _printUsage(rootParser);
      exitCode = 64;
  }
}

void _generateComponent(ArgResults args) {
  if (args.rest.length != 1) {
    _stderr('Usage: generate component <name>');
    exitCode = 64;
    return;
  }

  final spec = _componentSpec(args.rest.first);
  final root = Directory.current.path;
  final basePath = _joinPath(<String>[
    root,
    args['path'] as String,
    spec.packageName,
  ]);

  final files = <_FileSpec>[
    _FileSpec(
      path: _joinPath(<String>[basePath, 'pubspec.yaml']),
      content: _pubspecTemplate(spec),
    ),
    _FileSpec(
      path: _joinPath(
          <String>[basePath, 'lib', 'headless_${spec.componentName}.dart']),
      content: _libraryTemplate(spec),
    ),
    _FileSpec(
      path:
          _joinPath(<String>[basePath, 'lib', 'r_${spec.componentName}.dart']),
      content: _facadeTemplate(spec),
    ),
    _FileSpec(
      path: _joinPath(<String>[
        basePath,
        'lib',
        'r_${spec.componentName}_style.dart',
      ]),
      content: _styleFacadeTemplate(spec),
    ),
    _FileSpec(
      path: _joinPath(<String>[
        basePath,
        'lib',
        'src',
        'presentation',
        'r_${spec.componentName}.dart',
      ]),
      content: _componentTemplate(spec),
    ),
    _FileSpec(
      path: _joinPath(<String>[
        basePath,
        'lib',
        'src',
        'presentation',
        'r_${spec.componentName}_style.dart',
      ]),
      content: _styleTemplate(spec),
    ),
    _FileSpec(
      path: _joinPath(<String>[basePath, 'README.md']),
      content: _readmeTemplate(spec),
    ),
    _FileSpec(
      path: _joinPath(<String>[basePath, 'LLM.txt']),
      content: _llmTemplate(spec),
    ),
    _FileSpec(
      path: _joinPath(<String>[basePath, 'CONFORMANCE_REPORT.md']),
      content: _conformanceTemplate(spec),
    ),
    _FileSpec(
      path: _joinPath(<String>[basePath, 'test', 'smoke_test.dart']),
      content: _smokeTestTemplate(),
    ),
    _FileSpec(
      path: _joinPath(
        <String>[basePath, 'test', 'conformance_a11y_sla_test.dart'],
      ),
      content: _a11yTestTemplate(spec),
    ),
  ];

  final dryRun = args['dry-run'] == true;
  final force = args['force'] == true;

  for (final file in files) {
    _writeFile(file, force: force, dryRun: dryRun);
  }

  _printNextSteps(spec, basePath, dryRun: dryRun);
}

ComponentSpec _componentSpec(String raw) {
  final normalized = raw
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9_]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
  if (normalized.isEmpty) {
    throw ArgumentError('Component name is empty.');
  }
  final componentName = normalized.startsWith('headless_')
      ? normalized.substring('headless_'.length)
      : normalized;
  if (componentName.isEmpty) {
    throw ArgumentError('Component name is empty.');
  }
  final packageName =
      normalized.startsWith('headless_') ? normalized : 'headless_$normalized';
  final className = 'R${_toPascalCase(componentName)}';
  final titleName = _toTitleCase(componentName);
  return ComponentSpec(
    rawName: raw,
    packageName: packageName,
    componentName: componentName,
    className: className,
    titleName: titleName,
  );
}

String _toPascalCase(String value) {
  final parts = value.split('_');
  final buffer = StringBuffer();
  for (final part in parts) {
    if (part.isEmpty) continue;
    buffer.write(part[0].toUpperCase());
    if (part.length > 1) buffer.write(part.substring(1));
  }
  return buffer.toString();
}

String _toTitleCase(String value) {
  final parts = value.split('_');
  final buffer = StringBuffer();
  for (var i = 0; i < parts.length; i++) {
    final part = parts[i];
    if (part.isEmpty) continue;
    if (i > 0) buffer.write(' ');
    buffer.write(part[0].toUpperCase());
    if (part.length > 1) buffer.write(part.substring(1));
  }
  return buffer.toString();
}

String _joinPath(List<String> parts) {
  final sep = Platform.pathSeparator;
  final buffer = StringBuffer();
  for (final part in parts) {
    if (part.isEmpty) continue;
    if (buffer.isNotEmpty && !buffer.toString().endsWith(sep)) {
      buffer.write(sep);
    }
    final cleaned =
        part.startsWith(sep) && buffer.isNotEmpty ? part.substring(1) : part;
    buffer.write(cleaned);
  }
  return buffer.toString();
}

void _writeFile(
  _FileSpec file, {
  required bool force,
  required bool dryRun,
}) {
  final target = File(file.path);
  if (target.existsSync() && !force) {
    throw StateError('File already exists: ${file.path}');
  }
  if (dryRun) {
    stdout.writeln('[dry-run] ${file.path}');
    return;
  }
  target.parent.createSync(recursive: true);
  target.writeAsStringSync(file.content);
}

void _printUsage(ArgParser parser) {
  stdout.writeln('Usage: renderless <command> [options]');
  stdout.writeln();
  stdout.writeln('Commands:');
  stdout.writeln('  generate component <name>');
  stdout.writeln();
  stdout.writeln(parser.usage);
}

void _printNextSteps(
  ComponentSpec spec,
  String basePath, {
  required bool dryRun,
}) {
  stdout.writeln();
  stdout.writeln('Generated component skeleton:');
  stdout.writeln('  ${spec.packageName}');
  stdout.writeln('  $basePath');
  stdout.writeln();
  stdout.writeln('Next steps:');
  stdout.writeln(
      '  - Add contracts in headless_contracts (renderer, resolver, overrides).');
  stdout.writeln(
      '  - Implement behavior + a11y in packages/components/${spec.packageName}.');
  stdout.writeln(
      '  - Implement presets in headless_material/headless_cupertino.');
  stdout.writeln('  - Update docs and LLM.txt.');
  stdout.writeln('  - Run tests (flutter test) for the new package.');
  if (dryRun) {
    stdout.writeln();
    stdout.writeln('Note: dry-run mode did not write files.');
  }
}

void _stderr(String message) {
  stderr.writeln(message);
}

String _pubspecTemplate(ComponentSpec spec) {
  return '''
name: ${spec.packageName}
description: Headless ${spec.titleName} component package.
version: 0.0.0
publish_to: none

environment:
  sdk: ">=3.3.0 <4.0.0"
  flutter: ">=3.16.0"

dependencies:
  flutter:
    sdk: flutter
  headless_foundation:
    path: ../../headless_foundation
  headless_contracts:
    path: ../../headless_contracts
  headless_theme:
    path: ../../headless_theme

dev_dependencies:
  flutter_test:
    sdk: flutter
  headless_test:
    path: ../../headless_test
  lints: ^5.1.1
''';
}

String _libraryTemplate(ComponentSpec spec) {
  return '''
library;

export 'r_${spec.componentName}.dart';
export 'r_${spec.componentName}_style.dart';
''';
}

String _facadeTemplate(ComponentSpec spec) {
  return '''
export 'src/presentation/r_${spec.componentName}.dart';
''';
}

String _styleFacadeTemplate(ComponentSpec spec) {
  return '''
export 'src/presentation/r_${spec.componentName}_style.dart';
''';
}

String _componentTemplate(ComponentSpec spec) {
  return '''
import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'r_${spec.componentName}_style.dart';

class ${spec.className} extends StatelessWidget {
  const ${spec.className}({
    super.key,
    this.style,
    this.overrides,
  });

  final ${spec.className}Style? style;
  final RenderOverrides? overrides;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
''';
}

String _styleTemplate(ComponentSpec spec) {
  return '''
import 'package:flutter/foundation.dart';

@immutable
final class ${spec.className}Style {
  const ${spec.className}Style();
}
''';
}

String _readmeTemplate(ComponentSpec spec) {
  return '''
# ${spec.packageName}

Headless ${spec.titleName} component for Flutter.

## Status

Skeleton generated by `renderless generate component ${spec.componentName}`.
''';
}

String _llmTemplate(ComponentSpec spec) {
  return '''
Purpose:
Headless ${spec.titleName} component (behavior + a11y).

Non-goals:
- No renderer implementation in this package.

Key types (public API):
- ${spec.className}: Component widget.
- ${spec.className}Style: Simple style sugar.
''';
}

String _conformanceTemplate(ComponentSpec spec) {
  return '''
# Conformance report: ${spec.packageName}

Status: not implemented.
''';
}

String _smokeTestTemplate() {
  return '''
import 'package:test/test.dart';

void main() {
  test('smoke', () {
    expect(true, isTrue);
  });
}
''';
}

String _a11yTestTemplate(ComponentSpec spec) {
  return '''
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    '${spec.className} a11y conformance',
    (tester) async {},
    skip: 'TODO: implement a11y conformance for ${spec.className}.',
  );
}
''';
}

final class ComponentSpec {
  const ComponentSpec({
    required this.rawName,
    required this.packageName,
    required this.componentName,
    required this.className,
    required this.titleName,
  });

  final String rawName;
  final String packageName;
  final String componentName;
  final String className;
  final String titleName;
}

final class _FileSpec {
  const _FileSpec({
    required this.path,
    required this.content,
  });

  final String path;
  final String content;
}
