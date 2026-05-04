# Releasing Headless 1.1

This repository uses a lockstep `1.1.0` release set. Publish packages in the
order below so downstream dependencies are already available on pub.dev.

## Release order

1. `anchored_overlay_engine`
2. `headless_tokens`
3. `headless_foundation`
4. `headless_contracts`
5. `headless_theme`
6. `headless_material`
7. `headless_textfield`
8. `headless_cupertino`
9. `headless_adaptive`
10. `headless_test`
11. `headless_button`
12. `headless_checkbox`
13. `headless_switch`
14. `headless_dropdown_button`
15. `headless_autocomplete`
16. `headless`

## Preconditions

- clean git state
- authenticated `dart pub` / `flutter pub` session
- all package versions/changelogs already prepared
- `RELEASE_NOTES.md` updated for the release

## Verify release readiness

Run the full local release aggregate:

```bash
dart run melos run release:check
```

This aggregate runs:

- bootstrap
- analyze
- Dart and Flutter tests
- browser tests (`apps/example/test/browser` on a Chrome-capable environment)
- golden tests
- desktop integration tests
- release guardrails
- `pub publish --dry-run` for the release set

Web-specific integration coverage is kept separate because `flutter drive -d chrome`
requires a running WebDriver server. When you want to include that lane, start
`chromedriver` on port `4444` and run:

```bash
dart run melos run test:integration:web
```

Chrome-based browser tests do not require `chromedriver`, but they do require
an environment where Flutter can start its local Chrome test harness. Run them
with:

```bash
dart run melos run test:browser
```

If local macOS picks Brave instead of Google Chrome and the lane hangs during
suite startup, force Chrome explicitly:

```bash
CHROME_EXECUTABLE="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" dart run melos run test:browser
```

## Tag the release

Create and push the repository tag after `release:check` is green:

```bash
git tag -a v1.1.0 -m "Headless 1.1.0"
git push origin v1.1.0
```

The tag triggers the release-readiness workflow in CI.

## Publish to pub.dev

Manual publish uses the checked-in release order:

```bash
dart run tools/headless_cli/bin/publish_release.dart --yes
```

If publication is interrupted, resume from the failed package:

```bash
dart run tools/headless_cli/bin/publish_release.dart --yes --from headless_textfield
```

`publish_release.dart` refuses to run from a dirty git worktree.

## After publish

- verify package pages on pub.dev
- create the GitHub release using `RELEASE_NOTES.md`
- announce the published release set
