# Adopt security stack from orb_template

## What

Add `make security` (Trivy, `bundle-audit`, Brakeman) and `make test-rubies`, modelled on `orb_template`'s Makefile and `trivy.yaml`, adapted to this repo's two projects. `make test` runs `security`.

## Why

The user asked to adopt it. A Trivy run during orbital-07708c found high-severity npm advisories that no existing `make` target would have caught.

## Acceptance Criteria

- [ ] `make security` covers both `orbital/` and `demo/`, and fails on HIGH or CRITICAL findings
- [ ] `make test` runs `security`
- [ ] `make test-rubies` runs `orbital/` RSpec on 3.4.8 and 4.0.9, and fails if another version manager ignores the selection
- [ ] A deliberately vulnerable dev dependency makes `make security` fail (checked once, not committed)
- [ ] `make help` lists the new targets

## Flow

1. Add a root `trivy.yaml` based on `orb_template`'s: `exit-code: 1`, HIGH and CRITICAL, `vuln`, `secret` and `misconfig` scanners, skipping `.ruby-lsp`, `node_modules`, `vendor`, `tmp`, `log`, `storage` and `.xpo`.
2. Add `trivy` (report-only pass for lower severities, then the enforcing pass), `audit`, `brakeman`, `security` and `test-rubies` to the root `Makefile`.
3. Add `bundler-audit` to `orbital/Gemfile`. `demo/Gemfile` already has it, along with Brakeman.
4. Add `bun audit` for both projects.
5. Run everything and resolve what it reports.

## Decisions

- **Scan dev dependencies, unlike `orb_template`:** Trivy skips them by default, and that hid all 7 findings in `orbital/`. Parcel, Sass and the other build tools are dev dependencies here.
- **Add `bun audit`:** in orbital-07708c it flagged nested `picomatch` 2.3.1 copies in `demo/bun.lock` that Trivy did not report.
- **`test-rubies` covers `orbital/` only:** `demo/` has a pinned `.ruby-version` and no tests.

## Edge Cases

- **MEDIUM (tested):** Brakeman does not parse `.orb` templates: a planted `raw(params[...])` was caught in `.erb` and missed in `.orb`. On the gem, `--force` caught a planted command injection but not a `raw(params[...])` in a component class. `make brakeman` scans both the demo and the gem, and a `Makefile` comment records these limits so a clean result is not over-read.
- **MEDIUM:** `audit` and `trivy` need network access for their databases, so `make test` will fail offline. Same behaviour as `orb_template`; revisit if it gets in the way.
- **LOW:** the Dockerfile's `DS-0026` (no `HEALTHCHECK`) is LOW, so it appears in the report-only pass without failing.

## Assumptions

- `trivy` is a local prerequisite, as in `orb_template`. The repo has no CI workflows, so CI is out of scope.

## Open Questions

None. The user approved this approach.
