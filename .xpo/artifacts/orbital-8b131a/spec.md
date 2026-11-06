# Bump version to 0.2.0

## What

Set `Orbital::VERSION` to `0.2.0`, update `Gemfile.lock`, and move the Unreleased changelog entries under `## [0.2.0] - 2026-11-06`. After the merge, tag that commit `v0.2.0` and push the tag.

## Why

The maintainer asked for a `v0.2.0` tag. A tag on a commit whose gem still says 0.1.0 would not match the code it names.

## Acceptance Criteria

- [ ] `make build` produces `orbital-0.2.0.gem`
- [ ] `make test` and `make test-rubies` pass
- [ ] `v0.2.0` is on GitHub and points at the bump commit

## Decisions

- **The tag is made by hand, at the maintainer's request, without publishing.** The format matches `make release`: annotated, with the message `v0.2.0`.

## Edge Cases

- **MEDIUM:** `release-check` refuses a version that is already tagged, so `make release` will stop at 0.2.0 while this tag exists. Report this to the maintainer.

## Out of scope

- Publishing to rubygems.org
- The `0.1.0` changelog entry, which stays as written
