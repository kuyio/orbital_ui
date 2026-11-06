# Walkthrough: rename the gem and module to orbital_ui / OrbitalUi at 0.3.0

## What changed and why

Rubygems.org already has an unrelated gem named `Orbital`, which blocks the name, and `orbital_ui` is free. The gem, repo and Ruby module now share one name, so publishing is possible again.

- **Gem:** `orbital_ui.gemspec`, with `name` and `homepage` updated. All metadata URLs point at `kuyio/orbital_ui`.
- **Module:** `Orbital` is now `OrbitalUi` everywhere, including `isolate_namespace`, `ORB.namespaces` and the header `bin/generate-icons` writes.
- **Directories:** `lib/orbital_ui`, `lib/orbital_ui.rb`, `app/components/orbital_ui`, `test/components/orbital_ui`, `app/assets/{javascripts,stylesheets}/orbital_ui` and `app/assets/config/orbital_ui_manifest.js`.
- **Asset paths:** apps now use `stylesheet_link_tag "orbital_ui/index"`, and the themes are under `orbital_ui/`.
- **Makefile:** `GEM_NAME`, and `release` runs `release-check test build`, then `gem push`, then tags. This reverses the tag-only release from 0.2.1.
- **README and changelog:** `bundle add orbital_ui`. Version 0.2.1 was never released, so its fixes are listed under 0.3.0.

## Key decisions

- **`OrbitalUi`, not `OrbitalUI`.** Zeitwerk maps `orbital_ui` to `OrbitalUi` by default. The all-caps form needs a custom inflection rule, which would be another thing to go wrong in apps. Because the module follows the gem name, `Bundler.require` loads it with no shim file.
- **`Orbital-` CSS classes and `orbital-` Stimulus names stay.** They aren't tied to how the gem loads, and renaming nearly 700 references would only add churn. `orbital:popover:*` JavaScript events stay for the same reason. "Orbital" remains the product name in prose.
- **`orbital-` xpo issue IDs stay,** so existing issues keep their IDs.

## Non-obvious things

- `bun install` does not update the workspace name in `bun.lock`, so it was changed by hand and confirmed with `bun install --frozen-lockfile`.
- `ORB.namespaces += %w[OrbitalUi]` is still required in every app. See `orbital-e1b2e4`.

## Checks

- `make test` and `make test-rubies` pass with 23 tests, and the same tests pass on Rails 7.1.
- `make build` produces `orbital_ui-0.3.0.gem` with 74 files: `app/`, `lib/`, `LICENSE` and `README.md`.
- In a new app listing only `orbital_ui`, with the documented initializer, 35 of the 37 top-level components render with no arguments, and Icon and Image correctly report a missing required attribute. `Orbital` is not defined.
- All 41 docs paths return 200, and the gem's built CSS and JS are byte-identical to the previous build.

## After this merge

History starts again with one commit, and the old history is kept in a backup outside the repo. Merge SHAs recorded in `.xpo/` for earlier issues no longer resolve in the new repo; the issues, specs and walkthroughs all remain.

Gemspec URIs return 404 until `kuyio/orbital_ui` exists and is pushed.
