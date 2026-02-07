import 'dart:convert';
import 'dart:io';

final class GuardrailIssue {
  GuardrailIssue({
    required this.packageName,
    required this.message,
  });

  final String packageName;
  final String message;

  @override
  String toString() => '[$packageName] $message';
}

Future<void> main(List<String> args) async {
  final root = Directory.current;
  final packagesDir = Directory(_join(root.path, 'packages'));
  if (!packagesDir.existsSync()) {
    stderr.writeln('Guardrails: packages/ not found from ${root.path}');
    exitCode = 2;
    return;
  }

  final pubspecs = <File>[];
  await for (final e in packagesDir.list(recursive: true, followLinks: false)) {
    if (e is File && e.path.endsWith('${Platform.pathSeparator}pubspec.yaml')) {
      pubspecs.add(e);
    }
  }

  final packageInfos = <_PackageInfo>[];
  for (final pubspec in pubspecs) {
    final dir = pubspec.parent;
    final yaml = await pubspec.readAsString();
    final name = _parsePubspecName(yaml);
    if (name == null) continue;
    packageInfos.add(_PackageInfo(
      name: name,
      dirPath: dir.path,
      pubspecPath: pubspec.path,
      yaml: yaml,
    ));
  }

  final componentPackages = packageInfos
      .where(
        (p) => p.dirPath.contains(
          '${Platform.pathSeparator}components${Platform.pathSeparator}',
        ),
      )
      .toList(growable: false);
  final componentNames = componentPackages.map((p) => p.name).toSet();

  final issues = <GuardrailIssue>[];

  // 0) Public API discipline: never import another package's internal `src/`.
  _checkNoCrossPackageSrcImports(
    issues: issues,
    packageInfos: packageInfos,
    root: root,
  );

  // 0b) Public API discipline (strict): cross-package imports must use
  // `package:<pkg>/<pkg>.dart` entrypoints only.
  _checkCrossPackageImportsUseEntrypointsOnly(
    issues: issues,
    packageInfos: packageInfos,
    root: root,
  );

  // 0c) Export discipline: entrypoints must not export internal src/ directly.
  // Instead, re-export via public `lib/*.dart` modules to keep a stable surface.
  _checkEntrypointsDoNotExportSrc(
    issues: issues,
    packageInfos: packageInfos,
  );

  // 0d) Lockstep versioning: all packages in this monorepo must share
  // the same pubspec `version:` to prevent drift and compatibility skew.
  _checkLockstepVersions(
    issues: issues,
    packageInfos: packageInfos,
  );

  // 0e) Facade dependency rule: internal packages MUST NOT depend on the `headless`
  // facade package (it is for apps only). This prevents cycles and keeps
  // library-to-library dependencies explicit.
  _checkNoPackageDependsOnFacade(
    issues: issues,
    packageInfos: packageInfos,
    facadePackageName: 'headless',
  );

  // 0f) Version bump discipline: if public API changed compared to base ref,
  // lockstep version MUST be bumped at least MINOR.
  _checkVersionBumpDiscipline(
    issues: issues,
    packageInfos: packageInfos,
    baseRefEnvVar: 'HEADLESS_GUARDRAILS_BASE_REF',
  );

  for (final p in packageInfos) {
    // 1) LLM.txt MUST exist for publishable packages (in this repo: all packages/*).
    final llm = File(_join(p.dirPath, 'LLM.txt'));
    if (!llm.existsSync()) {
      issues.add(GuardrailIssue(
        packageName: p.name,
        message: 'MUST: missing LLM.txt',
      ));
    }

    // 2) For components: MUST have conformance report.
    final isComponent = componentNames.contains(p.name);
    if (isComponent) {
      final report = File(_join(p.dirPath, 'CONFORMANCE_REPORT.md'));
      if (!report.existsSync()) {
        issues.add(GuardrailIssue(
          packageName: p.name,
          message: 'MUST: missing CONFORMANCE_REPORT.md for component package',
        ));
      }
    }

    // 3) No component->component deps (ISP/DDD guardrail).
    if (isComponent) {
      final deps = _parsePubspecDependencies(p.yaml);
      for (final dep in deps) {
        if (componentNames.contains(dep) && dep != p.name) {
          issues.add(GuardrailIssue(
            packageName: p.name,
            message:
                'MUST: component package depends on another component: $dep',
          ));
        }
      }
    }
  }

  // 4) Code guardrails for scaling components.
  for (final p in componentPackages) {
    final libDir = Directory(_join(p.dirPath, 'lib'));
    _checkDartFiles(
      issues: issues,
      packageName: p.name,
      rootDir: libDir,
      fileLineLimit: 300,
      forbidBuildMethods: true,
    );
  }

  final exampleLibDir = Directory(
    _join(root.path, _join('apps', _join('example', 'lib'))),
  );
  _checkDartFiles(
    issues: issues,
    packageName: 'apps/example',
    rootDir: exampleLibDir,
    fileLineLimit: 300,
    forbidBuildMethods: true,
  );

  if (issues.isEmpty) {
    stdout.writeln('Guardrails: OK (${packageInfos.length} packages checked)');
    return;
  }

  stdout.writeln('Guardrails: FAILED');
  for (final i in issues) {
    stdout.writeln('- $i');
  }
  stdout.writeln('Total issues: ${issues.length}');
  exitCode = 1;
}

final class _PackageInfo {
  const _PackageInfo({
    required this.name,
    required this.dirPath,
    required this.pubspecPath,
    required this.yaml,
  });

  final String name;
  final String dirPath;
  final String pubspecPath;
  final String yaml;
}

void _checkNoCrossPackageSrcImports({
  required List<GuardrailIssue> issues,
  required List<_PackageInfo> packageInfos,
  required Directory root,
}) {
  final dartFiles = <File>[];

  // Scan all package code + example app (so it also follows the public API rule).
  final scanRoots = <Directory>[
    Directory(_join(root.path, 'packages')),
    Directory(_join(root.path, _join('apps', 'example'))),
  ];

  for (final dir in scanRoots) {
    if (!dir.existsSync()) continue;
    for (final f in _listFilesRecursively(dir)) {
      if (!f.path.endsWith('.dart')) continue;
      if (_isIgnoredPath(f.path)) continue;
      dartFiles.add(f);
    }
  }

  // Find package owner for a file by the longest matching prefix.
  final sortedInfos = packageInfos.toList()
    ..sort((a, b) => b.dirPath.length.compareTo(a.dirPath.length));

  String? ownerForFile(String filePath) {
    final sep = Platform.pathSeparator;
    for (final p in sortedInfos) {
      final prefix = p.dirPath.endsWith(sep) ? p.dirPath : '${p.dirPath}$sep';
      if (filePath.startsWith(prefix)) return p.name;
    }
    return null;
  }

  final re = RegExp(
    r'''^\s*(import|export)\s+['"]package:([a-zA-Z0-9_]+)\/([^'"]+)['"]''',
  );

  for (final f in dartFiles) {
    final owner = ownerForFile(f.path);
    final lines = f.readAsLinesSync();
    for (final line in lines) {
      final m = re.firstMatch(line);
      if (m == null) continue;
      final packageName = m.group(2)!;
      final packagePath = m.group(3)!;
      if (!packagePath.startsWith('src/')) continue;
      if (owner != null && owner == packageName) continue;

      issues.add(
        GuardrailIssue(
          packageName: owner ?? 'repo',
          message:
              'MUST: do not import/export other package internal src API: package:$packageName/$packagePath (in ${_relativePath(f.path)})',
        ),
      );
    }
  }
}

void _checkCrossPackageImportsUseEntrypointsOnly({
  required List<GuardrailIssue> issues,
  required List<_PackageInfo> packageInfos,
  required Directory root,
}) {
  final knownPackageNames = packageInfos.map((p) => p.name).toSet();
  final dartFiles = <File>[];

  final scanRoots = <Directory>[
    Directory(_join(root.path, 'packages')),
    Directory(_join(root.path, _join('apps', 'example'))),
  ];

  for (final dir in scanRoots) {
    if (!dir.existsSync()) continue;
    for (final f in _listFilesRecursively(dir)) {
      if (!f.path.endsWith('.dart')) continue;
      if (_isIgnoredPath(f.path)) continue;
      dartFiles.add(f);
    }
  }

  final sortedInfos = packageInfos.toList()
    ..sort((a, b) => b.dirPath.length.compareTo(a.dirPath.length));

  String? ownerForFile(String filePath) {
    final sep = Platform.pathSeparator;
    for (final p in sortedInfos) {
      final prefix = p.dirPath.endsWith(sep) ? p.dirPath : '${p.dirPath}$sep';
      if (filePath.startsWith(prefix)) return p.name;
    }
    return null;
  }

  final re = RegExp(
    r'''^\s*(import|export)\s+['"]package:([a-zA-Z0-9_]+)\/([^'"]+)['"]''',
  );

  for (final f in dartFiles) {
    final owner = ownerForFile(f.path);
    final lines = f.readAsLinesSync();
    for (final line in lines) {
      final m = re.firstMatch(line);
      if (m == null) continue;
      final targetPackage = m.group(2)!;
      final targetPath = m.group(3)!;
      if (!knownPackageNames.contains(targetPackage)) continue;
      if (owner != null && owner == targetPackage) continue;

      final allowed = '$targetPackage.dart';
      if (targetPath == allowed) continue;

      issues.add(
        GuardrailIssue(
          packageName: owner ?? 'repo',
          message:
              'MUST: cross-package imports must use entrypoint only: package:$targetPackage/$allowed (found package:$targetPackage/$targetPath in ${_relativePath(f.path)})',
        ),
      );
    }
  }
}

void _checkEntrypointsDoNotExportSrc({
  required List<GuardrailIssue> issues,
  required List<_PackageInfo> packageInfos,
}) {
  final reRelative = RegExp(r'''^\s*export\s+['"]src/''');
  for (final p in packageInfos) {
    final entrypoint = File(_join(p.dirPath, _join('lib', '${p.name}.dart')));
    if (!entrypoint.existsSync()) continue;

    final rePackage = RegExp(r'''^\s*export\s+['"]package:${p.name}/src/''');

    for (final line in entrypoint.readAsLinesSync()) {
      if (!line.contains('export')) continue;
      if (reRelative.hasMatch(line) || rePackage.hasMatch(line)) {
        issues.add(
          GuardrailIssue(
            packageName: p.name,
            message:
                'MUST: entrypoint must not export internal src/ directly: ${_relativePath(entrypoint.path)} (line: ${line.trim()})',
          ),
        );
        break;
      }
    }
  }
}

void _checkLockstepVersions({
  required List<GuardrailIssue> issues,
  required List<_PackageInfo> packageInfos,
}) {
  String? expected;

  for (final p in packageInfos) {
    final v = _parsePubspecVersion(p.yaml);
    if (v == null) {
      issues.add(
        GuardrailIssue(
          packageName: p.name,
          message: 'MUST: pubspec.yaml is missing required `version:`',
        ),
      );
      continue;
    }
    expected ??= v;
  }

  if (expected == null) return;

  for (final p in packageInfos) {
    final v = _parsePubspecVersion(p.yaml);
    if (v == null) continue;
    if (v != expected) {
      issues.add(
        GuardrailIssue(
          packageName: p.name,
          message:
              'MUST: lockstep versioning — expected version $expected but found $v (pubspec: ${_relativePath(p.pubspecPath)})',
        ),
      );
    }
  }
}

void _checkNoPackageDependsOnFacade({
  required List<GuardrailIssue> issues,
  required List<_PackageInfo> packageInfos,
  required String facadePackageName,
}) {
  for (final p in packageInfos) {
    if (p.name == facadePackageName) continue;
    final deps = _parsePubspecDependencies(p.yaml);
    if (!deps.contains(facadePackageName)) continue;
    issues.add(
      GuardrailIssue(
        packageName: p.name,
        message:
            'MUST: package must not depend on facade `$facadePackageName` (use core packages directly). pubspec: ${_relativePath(p.pubspecPath)}',
      ),
    );
  }
}

void _checkVersionBumpDiscipline({
  required List<GuardrailIssue> issues,
  required List<_PackageInfo> packageInfos,
  required String baseRefEnvVar,
}) {
  final baseRef = Platform.environment[baseRefEnvVar]?.trim();
  if (baseRef == null || baseRef.isEmpty) {
    // Local runs: no base ref context, so this check is skipped.
    return;
  }

  final baseSha = _gitMergeBase(baseRef);
  if (baseSha == null) {
    issues.add(
      GuardrailIssue(
        packageName: 'workspace',
        message:
            'MUST: $baseRefEnvVar is set to "$baseRef" but git merge-base failed. Ensure CI fetches enough history (fetch-depth: 0).',
      ),
    );
    return;
  }

  final changedFiles = _gitChangedFiles(baseSha);
  if (changedFiles.isEmpty) return;

  final changedPublicApiFiles =
      changedFiles.where(_isPublicApiDartFilePath).toList(growable: false);
  if (changedPublicApiFiles.isEmpty) return;

  final currentLockstep = _currentLockstepVersion(packageInfos);
  if (currentLockstep == null) {
    // Lockstep check will report details; avoid double noise.
    return;
  }

  final canonicalPubspecRelPath =
      _canonicalPubspecPathForLockstep(packageInfos);
  if (canonicalPubspecRelPath == null) return;

  final basePubspecYaml =
      _gitShowText(baseSha, canonicalPubspecRelPath)?.trim();
  if (basePubspecYaml == null || basePubspecYaml.isEmpty) {
    // Can't compare (e.g. new package or shallow history). Fail because base ref
    // is explicitly provided in CI, so we expect to be able to read it.
    issues.add(
      GuardrailIssue(
        packageName: 'workspace',
        message:
            'MUST: cannot read base pubspec via git show for $canonicalPubspecRelPath at $baseSha. Ensure CI fetches full history.',
      ),
    );
    return;
  }

  final baseVersion = _parsePubspecVersion(basePubspecYaml);
  if (baseVersion == null) {
    issues.add(
      GuardrailIssue(
        packageName: 'workspace',
        message:
            'MUST: base pubspec is missing `version:` ($canonicalPubspecRelPath @ $baseSha)',
      ),
    );
    return;
  }

  final curr = _Semver.tryParse(currentLockstep);
  final base = _Semver.tryParse(baseVersion);
  if (curr == null || base == null) {
    // If we can't parse semver, make it explicit. Lockstep may still be used,
    // but the discipline check requires comparable versions.
    issues.add(
      GuardrailIssue(
        packageName: 'workspace',
        message:
            'MUST: lockstep version must be semver (x.y.z). current="$currentLockstep" base="$baseVersion"',
      ),
    );
    return;
  }

  final bumpedAtLeastMinor = curr.major > base.major ||
      (curr.major == base.major && curr.minor > base.minor);
  if (bumpedAtLeastMinor) return;

  // Patch-only bump is not enough if public API changed.
  final examples = changedPublicApiFiles.take(5).map((e) => e).join(', ');
  final more = changedPublicApiFiles.length > 5
      ? ' (+${changedPublicApiFiles.length - 5} more)'
      : '';
  issues.add(
    GuardrailIssue(
      packageName: 'workspace',
      message:
          'MUST: public API changed ($baseSha..HEAD) but lockstep version not bumped at least MINOR. base=$baseVersion current=$currentLockstep. Examples: $examples$more',
    ),
  );
}

String? _currentLockstepVersion(List<_PackageInfo> packageInfos) {
  for (final p in packageInfos) {
    final v = _parsePubspecVersion(p.yaml);
    if (v != null) return v;
  }
  return null;
}

String? _canonicalPubspecPathForLockstep(List<_PackageInfo> packageInfos) {
  // Prefer the facade package if present (stable path), otherwise use first.
  final headless = packageInfos.where((p) => p.name == 'headless').toList();
  final chosen =
      headless.isNotEmpty ? headless.first : packageInfos.firstOrNull;
  if (chosen == null) return null;
  return _relativePath(chosen.pubspecPath);
}

bool _isPublicApiDartFilePath(String path) {
  // Public API is considered everything in packages/*/lib/** except lib/src/**.
  // This aligns with the "no entrypoint export src/" discipline enforced above.
  if (!path.startsWith('packages/')) return false;
  if (!path.contains('/lib/')) return false;
  if (path.contains('/lib/src/')) return false;
  return path.endsWith('.dart');
}

String? _gitMergeBase(String baseRef) {
  final result = Process.runSync(
    'git',
    ['merge-base', baseRef, 'HEAD'],
    runInShell: true,
  );
  if (result.exitCode != 0) return null;
  final out = (result.stdout as String).trim();
  if (out.isEmpty) return null;
  return out;
}

List<String> _gitChangedFiles(String baseSha) {
  final result = Process.runSync(
    'git',
    ['diff', '--name-only', '$baseSha...HEAD'],
    runInShell: true,
  );
  if (result.exitCode != 0) return const [];
  final out = (result.stdout as String).trim();
  if (out.isEmpty) return const [];
  return const LineSplitter()
      .convert(out)
      .where((e) => e.trim().isNotEmpty)
      .toList();
}

String? _gitShowText(String rev, String relPath) {
  final result = Process.runSync(
    'git',
    ['show', '$rev:$relPath'],
    runInShell: true,
  );
  if (result.exitCode != 0) return null;
  return result.stdout as String;
}

final class _Semver {
  const _Semver({
    required this.major,
    required this.minor,
    required this.patch,
  });

  final int major;
  final int minor;
  final int patch;

  static _Semver? tryParse(String raw) {
    // Accept `x.y.z` and ignore prerelease/build metadata.
    final m = RegExp(r'^(\d+)\.(\d+)\.(\d+)').firstMatch(raw.trim());
    if (m == null) return null;
    final major = int.tryParse(m.group(1)!);
    final minor = int.tryParse(m.group(2)!);
    final patch = int.tryParse(m.group(3)!);
    if (major == null || minor == null || patch == null) return null;
    return _Semver(major: major, minor: minor, patch: patch);
  }
}

String? _parsePubspecName(String yaml) {
  for (final line in const LineSplitter().convert(yaml)) {
    final trimmed = line.trimRight();
    if (trimmed.startsWith('name:')) {
      return trimmed.substring('name:'.length).trim();
    }
  }
  return null;
}

String? _parsePubspecVersion(String yaml) {
  for (final line in const LineSplitter().convert(yaml)) {
    final trimmed = line.trimRight();
    if (trimmed.startsWith('version:')) {
      return trimmed.substring('version:'.length).trim();
    }
  }
  return null;
}

Set<String> _parsePubspecDependencies(String yaml) {
  // Tiny parser: only top-level keys under dependencies/dev_dependencies.
  final deps = <String>{};

  void parseBlock(String header) {
    final lines = const LineSplitter().convert(yaml);
    var inBlock = false;
    var indent = 0;
    for (final raw in lines) {
      final line = raw.replaceAll('	', '  ');
      if (!inBlock) {
        if (line.trim() == '$header:') {
          inBlock = true;
          indent = _leadingSpaces(line) + 2;
        }
        continue;
      }

      if (line.trim().isEmpty) continue;
      final currentIndent = _leadingSpaces(line);
      if (currentIndent < indent) {
        inBlock = false;
        continue;
      }

      final trimmed = line.trimLeft();
      if (trimmed.startsWith('#')) continue;
      final colon = trimmed.indexOf(':');
      if (colon <= 0) continue;
      final key = trimmed.substring(0, colon).trim();
      if (key.isEmpty) continue;
      deps.add(key);
    }
  }

  parseBlock('dependencies');
  parseBlock('dev_dependencies');
  return deps;
}

int _leadingSpaces(String s) {
  var i = 0;
  while (i < s.length && s.codeUnitAt(i) == 0x20) {
    i++;
  }
  return i;
}

String _join(String a, String b) {
  if (a.endsWith(Platform.pathSeparator)) return '$a$b';
  return '$a${Platform.pathSeparator}$b';
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

void _checkDartFiles({
  required List<GuardrailIssue> issues,
  required String packageName,
  required Directory rootDir,
  required int fileLineLimit,
  required bool forbidBuildMethods,
}) {
  if (!rootDir.existsSync()) return;

  final dartFiles = <File>[];
  for (final f in _listFilesRecursively(rootDir)) {
    if (!f.path.endsWith('.dart')) continue;
    if (_isIgnoredPath(f.path)) continue;
    dartFiles.add(f);
  }

  for (final f in dartFiles) {
    final lineCount = _countLines(f);
    if (lineCount > fileLineLimit) {
      issues.add(GuardrailIssue(
        packageName: packageName,
        message:
            'MUST: file exceeds $fileLineLimit lines ($lineCount): ${_relativePath(f.path)}',
      ));
    }

    if (forbidBuildMethods) {
      final match = _findFirstBuildMethodMatch(f);
      if (match != null) {
        issues.add(GuardrailIssue(
          packageName: packageName,
          message:
              'MUST: no `_build*` methods in lib code: ${_relativePath(f.path)} (match: $match)',
        ));
      }
    }
  }
}

Iterable<File> _listFilesRecursively(Directory dir) sync* {
  for (final e in dir.listSync(recursive: true, followLinks: false)) {
    if (e is File) yield e;
  }
}

bool _isIgnoredPath(String path) {
  final sep = Platform.pathSeparator;
  return path.contains('$sep' 'build' '$sep') ||
      path.contains('$sep' '.dart_tool' '$sep') ||
      path.contains('$sep' '.git' '$sep');
}

int _countLines(File f) {
  var count = 0;
  for (final _ in f.readAsLinesSync()) {
    count++;
  }
  return count;
}

String? _findFirstBuildMethodMatch(File f) {
  final re = RegExp(r'_build[A-Za-z0-9_]*\s*\(');
  for (final line in f.readAsLinesSync()) {
    final m = re.firstMatch(line);
    if (m != null) return m.group(0);
  }
  return null;
}

String _relativePath(String path) {
  final root = Directory.current.path;
  if (path.startsWith(root)) {
    final p = path.substring(root.length);
    if (p.startsWith(Platform.pathSeparator)) return p.substring(1);
    return p;
  }
  return path;
}
