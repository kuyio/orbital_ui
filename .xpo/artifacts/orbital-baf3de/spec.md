# Release 0.3.1

## What

Set `OrbitalUi::VERSION` to `0.3.1`, update `Gemfile.lock`, rename the `0.3.0` changelog section to `## [0.3.1] - 2026-11-06`, and push `main`.

## Why

The maintainer asked to cut v0.3.1. It is the first version to be published as `orbital_ui`.

## Acceptance Criteria

- [ ] `make build` produces `orbital_ui-0.3.1.gem` with only `app/`, `lib/`, `LICENSE` and `README.md`
- [ ] `make test` and `make test-rubies` pass with no warnings
- [ ] `main` is pushed and `make release-check` passes

## Decisions

- **Rename the `0.3.0` section rather than split it.** `0.3.0` was never tagged or published, so nobody can have installed it.
- **The tag is left to `make release`.** It publishes first and tags only on success, and it refuses a version that is already tagged.
- **The maintainer runs `make release`,** because `gem push` needs their rubygems sign-in and one-time password.
