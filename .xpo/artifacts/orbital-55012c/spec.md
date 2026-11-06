# Rename the gem and module to orbital_ui / OrbitalUi at 0.3.0

## What

Rename the gem and repo to `orbital_ui`, the Ruby module to `OrbitalUi`, and the matching directories and asset paths to `orbital_ui/`. Set the version to 0.3.0 and put publishing back in `make release`.

## Why

Rubygems.org already has `Orbital`, which blocks the name, and `orbital_ui` is free. The gem can therefore be published, which makes the GitHub-only install and tag-only release from 0.2.1 unnecessary. A module that follows the gem name means the gem loads by Rails and Zeitwerk defaults, with no shim file or custom inflection.

## Changes

- `orbital.gemspec` becomes `orbital_ui.gemspec`, with the new `name` and `homepage`.
- `lib/orbital*`, `app/components/orbital`, `test/components/orbital`, `test/orbital_test.rb`, `app/assets/{javascripts,stylesheets}/orbital` and the asset manifest move to `orbital_ui` names.
- `Orbital::` and `module Orbital` become `OrbitalUi`, including `ORB.namespaces` and `bin/generate-icons`.
- Asset paths become `orbital_ui/index` and `orbital_ui/theme`.
- `Makefile`: `GEM_NAME`, and `release` returns to `release-check test build`, then `gem push`, then the tag.
- `README.md`, `CLAUDE.md`, `AGENTS.md`, `theming/`, `package.json`, the lockfiles and `version.rb`.
- `CHANGELOG.md`: 0.2.1 was never released, so its fixes move into 0.3.0.

## Acceptance Criteria

- [ ] An app listing only `orbital_ui`, with the documented initializer, loads the gem and renders every component
- [ ] `make build` produces `orbital_ui-0.3.0.gem` holding only `app/`, `lib/`, `LICENSE` and `README.md`
- [ ] `make test` and `make test-rubies` pass, and every docs path returns 200
- [ ] No `Orbital::`, `module Orbital` or `kuyio/orbital` remains outside `.xpo/` and past changelog entries
- [ ] All gemspec URIs point at `kuyio/orbital_ui`

## Decisions

- **`OrbitalUi`, not `OrbitalUI`.** The all-caps form needs a custom inflection rule in every app that autoloads the gem; `OrbitalUi` is the default for `orbital_ui`.
- **`Orbital-` CSS classes and `orbital-` Stimulus names stay.** They aren't tied to how the gem loads, and "Orbital" stays as the product name.
- **History starts again after this merge,** as the maintainer asked. The old history is kept in a backup outside the repo, and merge SHAs recorded in `.xpo/` will no longer resolve in the new repo.

## Known limit

Gemspec URIs return 404 until `kuyio/orbital_ui` exists and is pushed.
