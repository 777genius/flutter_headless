import 'dart:io';

void main(List<String> args) {
  final apiDirPath = _parseApiDir(args) ?? 'docs-site/content/api';
  final apiDir = Directory(apiDirPath);

  if (!apiDir.existsSync()) {
    stderr.writeln('API docs directory not found: $apiDirPath');
    exitCode = 2;
    return;
  }

  final markdownFiles = apiDir
      .listSync(recursive: true, followLinks: false)
      .whereType<File>()
      .where((file) => file.path.endsWith('.md'))
      .toList(growable: false);

  var changedFiles = 0;
  var fixedEmptyDescriptions = 0;
  var fixedTrailingColonDescriptions = 0;

  for (final file in markdownFiles) {
    final original = file.readAsStringSync();
    final result = _normalizeMarkdown(original);
    if (!result.changed) {
      continue;
    }

    file.writeAsStringSync(result.content);
    changedFiles++;
    fixedEmptyDescriptions += result.fixedEmptyDescriptions;
    fixedTrailingColonDescriptions += result.fixedTrailingColonDescriptions;
  }

  stdout.writeln(
    'API docs normalization done. '
    'Changed files: $changedFiles, '
    'empty descriptions fixed: $fixedEmptyDescriptions, '
    'trailing-colon descriptions fixed: $fixedTrailingColonDescriptions.',
  );
}

String? _parseApiDir(List<String> args) {
  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    if (!arg.startsWith('--api-dir=')) {
      continue;
    }
    return arg.substring('--api-dir='.length).trim();
  }
  return null;
}

_NormalizeResult _normalizeMarkdown(String input) {
  final lines = input.split('\n');
  final out = <String>[];

  var changed = false;
  var fixedEmptyDescriptions = 0;
  var fixedTrailingColonDescriptions = 0;

  for (final line in lines) {
    final rowMatch = _tableRowPattern.firstMatch(line);
    if (rowMatch == null) {
      out.add(line);
      continue;
    }

    final nameCell = rowMatch.group(1)!;
    var descriptionCell = rowMatch.group(2)!;

    final trimmedDescription = descriptionCell.trim();

    if (trimmedDescription.isEmpty) {
      descriptionCell = ' No description available in source docs. ';
      fixedEmptyDescriptions++;
      changed = true;
    } else {
      final collapsed = _collapseWhitespace(trimmedDescription);
      if (collapsed.endsWith(':')) {
        final withoutColon =
            collapsed.substring(0, collapsed.length - 1).trim();
        if (withoutColon.isNotEmpty) {
          descriptionCell = ' $withoutColon. ';
          fixedTrailingColonDescriptions++;
          changed = true;
        }
      }
    }

    out.add('|$nameCell|$descriptionCell|');
  }

  return _NormalizeResult(
    content: out.join('\n'),
    changed: changed,
    fixedEmptyDescriptions: fixedEmptyDescriptions,
    fixedTrailingColonDescriptions: fixedTrailingColonDescriptions,
  );
}

String _collapseWhitespace(String value) {
  return value.replaceAll(RegExp(r'\s+'), ' ').trim();
}

final _tableRowPattern = RegExp(r'^\|(.+?)\|(.+?)\|$');

final class _NormalizeResult {
  const _NormalizeResult({
    required this.content,
    required this.changed,
    required this.fixedEmptyDescriptions,
    required this.fixedTrailingColonDescriptions,
  });

  final String content;
  final bool changed;
  final int fixedEmptyDescriptions;
  final int fixedTrailingColonDescriptions;
}
