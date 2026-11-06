# Walkthrough: release 0.3.2

## What changed and why

`0.3.2` makes the `rails new -j bun -c tailwind` setup work, and adds `Form`. `0.3.1`, the first published version, had neither the install generator nor the `TextField` fixes.

- `lib/orbital_ui/version.rb`: `VERSION = "0.3.2"`.
- `Gemfile.lock` and `demos/fernhill/Gemfile.lock`: updated, because both record the gem's version.
- `CHANGELOG.md`: the Unreleased entries now sit under `## [0.3.2] - 2026-11-06`.

## Non-obvious things

- `make release` needs a clean tree, so the demo's lockfile has to change in the bump commit.
- Stop `make docs` or `make dev` before releasing, because `parcel watch` rewrites the shipped assets unminified.
- `make release` tags `v0.3.2` after publishing, so the tag isn't created here.

## Checks

`make test` and `make test-rubies` pass with 152 tests and no warnings, and the same tests pass on Rails 7.1. `lint-js`, `typecheck` and `bun-audit` pass. `orbital_ui-0.3.2.gem` has 77 files, holding only `app/`, `lib/`, `LICENSE` and `README.md`, with the minified CSS and JS. A scan of all tracked files found no internal names or secrets.

`marcel` and `prism` remain behind, capped by `activestorage`, `rubocop-ast` and `minitest`. Everything else is at its latest, in the root and the demo.

The `Form` docs page was checked in a browser in light mode. That found the docs code panels showing HTML entities, filed as `orbital-92be63`, which doesn't affect the gem.
