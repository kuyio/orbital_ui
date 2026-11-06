# Load orb_template from the gem, and make GitHub the install and release path

## What

Require `orb_template` from `lib/orbital.rb` so components work in an app that lists only `orbital`. Document GitHub as the install source, change `make release` to tag without publishing, and release `v0.2.1`.

## Why

An app that lists only `orbital` gets raw template source from 26 of the 37 top-level components. The gem can't be published as `orbital`, because rubygems.org already has `Orbital` (since 2012), so GitHub is how people install it. The README's `bundle add orbital` and the `gem push` in `make release` both assume otherwise.

## Flow

1. Add a test that renders ORB components using only the gem's own requires. Confirm it fails.
2. Add the require to `lib/orbital.rb`. Confirm it passes.
3. Update the README, `Makefile` and `CHANGELOG.md`, and bump the version to 0.2.1.
4. Run all checks, merge, and push `main`.
5. Install from the pushed commit on GitHub in a new app listing only `orbital`, and render every component.
6. Tag `v0.2.1` and push the tag.

## Acceptance Criteria

- [ ] The new test fails without the require and passes with it
- [ ] An app listing only `orbital` from GitHub has no components rendering raw source
- [ ] The README installs from GitHub with a tag, and has a note for `v0.2.0`
- [ ] `make release` runs `release-check` and `test`, then tags and pushes the tag, with no `gem push`
- [ ] `make test`, `make test-rubies` and `make build` pass
- [ ] `v0.2.1` is on GitHub, and `v0.2.0` is not moved

## Decisions

- **`v0.2.0` stays where it is.** Moving a pushed tag would catch out anyone already using it.
- **`release` follows `kuyio-rubocop`,** which is also not published: checks, then tag.
- **The gemspec's `allowed_push_host` stays.** It is a required field, and it does nothing unless someone publishes.

## Out of scope

- Renaming the gem to publish it under another name
- Changing the gem standard, which is not in this repo
