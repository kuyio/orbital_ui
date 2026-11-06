# Walkthrough: add the Fernhill demo app under demos/fernhill

## What was built and why

Fernhill is a personal finance dashboard for a made-up company, first built to prove the `rails new -j bun -c tailwind` setup. It found real bugs when it was built, and it shows the components working together in a real app, which `test/dummy` doesn't. `test/dummy` stays as the documentation of each component.

- `demos/fernhill`: a standard Rails app, with `gem "orbital_ui", path: "../.."`, so it always runs the current code.
- `make demo`: runs its `bin/setup`, which installs dependencies and starts `bin/dev`. It clears `BUNDLE_GEMFILE` so the root bundle can't leak in.
- `make docs`: runs `make setup`, then `bin/dev` for the docs site. `make dev` stays as the plain command.
- The main README links to the demo, and the demo has its own short README.

## Key decisions

- **Its workarounds stay,** such as the `Tooltip` child classes and the hand-built table. They go as `orbital-4ca9ca` and `orbital-8c907e` are fixed, which checks that those fixes help.
- **No credentials.** `master.key` and `credentials.yml.enc` were left out. It has no database or secrets, and Rails generates a development secret itself.
- **The transfer action validates on the server,** because this is public sample code. Browser validation alone would be a bad pattern to copy.
- **`trivy.yaml` stays the standard template,** so Trivy scans the demo too.

## How the repo's checks treat a second app

- The published gem isn't affected, because `spec.files` only lists `app/`, `lib/`, `LICENSE` and `README.md`.
- RuboCop and Brakeman cover the demo, so it follows `kuyio-rubocop` with no overrides, and sets `protect_from_forgery` explicitly. Brakeman needs that because there's no version it can credit `load_defaults` to.
- Trivy scans its lockfiles.
- Biome and the test task don't reach it.
- `.dockerignore` excludes it from the docs site image.

## Non-obvious things

- An advisory in the demo's dependencies fails `make test`, and so blocks `make release`, until its lockfile is updated.
- The demo's `Gemfile.lock` records the gem's version. Run `bundle install` in `demos/fernhill` and commit the result with each version bump, because `make release` needs a clean tree.
- `bin/dev` needs a terminal, because Tailwind's `--watch` exits when stdin closes.
- `make docs` runs `parcel watch`, which rewrites the gem's built assets unminified. Run `git restore app/assets` or `make assets` before committing or releasing.

## Checks

`make demo` was run from a clean copy of what git would contain, and the app was exercised in a browser with no console errors: chart, menus, Accordion, search, dark mode and the transfer flow. Requests with a bad amount, an unknown account or no CSRF token were rejected.

`make test` and `make test-rubies` pass with 139 tests and no warnings. The package still has 75 files, the gem's built CSS and JS didn't change, and the Docker build passes. A scan of the demo's files found no internal names, personal details, absolute paths or secrets.

`make docs` was checked with a dry run, and its `make setup` step was run. Its `bin/dev` step is the same command as `make dev`.
