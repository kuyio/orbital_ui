# Walkthrough: release 0.3.1

## What changed and why

The maintainer asked to cut v0.3.1, the first version to be published as `orbital_ui`.

- `lib/orbital_ui/version.rb`: `VERSION = "0.3.1"`.
- `Gemfile.lock`: updated with `bundle lock`.
- `CHANGELOG.md`: the `0.3.0` section is now `## [0.3.1] - 2026-11-06`.

## Key decisions

- **The `0.3.0` section was renamed, not split.** `0.3.0` was never tagged or published, so nobody can have installed it.
- **The tag is left to `make release`.** It publishes first and tags only on success, and it refuses a version that is already tagged, so tagging by hand would block it.
- **The maintainer runs `make release`,** because `gem push` needs their rubygems sign-in and one-time password.

## Non-obvious things

- Stop `bin/dev` before releasing. `parcel watch` rewrites the shipped assets unminified, and `release-check` refuses a dirty tree.

## Checks

`make test` and `make test-rubies` pass with 117 tests and no warnings. `orbital_ui-0.3.1.gem` has 74 files, holding only `app/`, `lib/`, `LICENSE` and `README.md`, with the minified CSS and JS.
