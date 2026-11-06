# Walkthrough: bump version to 0.2.0

## What changed and why

The maintainer asked for a `v0.2.0` tag, and the gem still said 0.1.0.

- `lib/orbital/version.rb`: `VERSION = "0.2.0"`.
- `Gemfile.lock`: updated with `bundle lock`, because the gemspec's version is recorded there.
- `CHANGELOG.md`: the Unreleased entries now sit under `## [0.2.0] - 2026-11-06`.

## Non-obvious things

- **The tag was made by hand, without publishing.** It uses the same form as `make release`: annotated, with the message `v0.2.0`.
- **`make release` will refuse 0.2.0 while the tag exists.** `release-check` stops on an already tagged version, and `release` normally creates the tag itself after `gem push`. To publish 0.2.0 through `make release`, delete the tag first, locally and on GitHub. The target recreates it after publishing.
- **The `0.1.0` changelog entry is unchanged.** That version was never published to rubygems.org.

## Checks

`make test` and `make test-rubies` pass. `make build` produces `orbital-0.2.0.gem` with 74 files.
