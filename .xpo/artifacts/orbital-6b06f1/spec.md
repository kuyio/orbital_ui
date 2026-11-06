# Release 0.3.2

## What

Set `OrbitalUi::VERSION` to `0.3.2`, update the root and `demos/fernhill` lockfiles, move the Unreleased changelog entries under `## [0.3.2] - 2026-11-06`, and push `main`.

## Acceptance Criteria

- [ ] `make build` produces `orbital_ui-0.3.2.gem` with only `app/`, `lib/`, `LICENSE` and `README.md`, and the minified assets
- [ ] `make test` and `make test-rubies` pass with no warnings, and the demo's lockfile is current
- [ ] Dependencies are at their latest, or the reason is recorded
- [ ] No internal names or secrets in the repo
- [ ] `main` is pushed and `make release-check` passes

## Decisions

- **The maintainer runs `make release`,** because `gem push` needs their rubygems sign-in and one-time password. It tags `v0.3.2` after publishing.
