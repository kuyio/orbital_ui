# Walkthrough: load orb_template from the gem, and make GitHub the install and release path

## What was wrong

`lib/orbital.rb` required `view_component` but not `orb_template`. `Bundler.require` only loads gems listed directly in an app's Gemfile, not their dependencies. An app listing only `orbital` therefore never loaded ORB, and components using `orb_template` output their template source as text, such as `<span **html_attributes>`.

Nothing caught it because the root `Gemfile` lists `orb_template`, so the docs site loads it. The tests only checked attributes, not rendered output. The bug predates the move to the repo root.

## What changed

- `lib/orbital.rb`: `require "orb_template"`.
- `test/components/orbital/orb_rendering_test.rb`: renders Badge, Card and Stack. `test_helper` uses `bundler/setup` without `Bundler.require`, so it loads only what the gem loads, as an app listing only `orbital` would. All three tests failed before the fix.
- `README.md`: installs from GitHub with a tag, warns that the `Orbital` gem on rubygems.org is unrelated, and notes the workaround for `v0.2.0`.
- `Makefile`: `release` runs `release-check` and `test`, then tags and pushes the tag. There is no `gem push`.
- `CHANGELOG.md`, `version.rb` and `Gemfile.lock`: 0.2.1.

## Key decisions

- **`release` follows `kuyio-rubocop`,** which is also not published: the tag is the release. `build` is no longer a prerequisite, because nothing uses the file. `make build` still works as a check.
- **`v0.2.0` was not moved.** Moving a pushed tag would catch out anyone already using it, so the fix is a new version and the README carries the workaround.
- **`allowed_push_host` stays in the gemspec.** It is a required field and does nothing unless someone publishes.

## Non-obvious things

- GitHub installs ignore `spec.files`, so apps get the whole repo on disk. The 74-file package only applies to a built gem.
- Lookups on rubygems.org are case-sensitive, but the `Orbital` gem still blocks the name. A lowercase lookup returning 404 does not mean a name is free, so check the capitalised forms too.
- `lib/orbital.rb` also assumes Active Model is loaded. An app that loads Action Controller without the Active Model railtie gets a `NameError`. This was left as it is; it only affects unusual setups.

## Checks

`make test` and `make test-rubies` pass with 23 tests. The same tests pass on Rails 7.1. `make build` produces 74 files. A new app listing only `orbital` from GitHub was tested before tagging; see the issue's comment.

## Possible follow-up

Publishing under another name, such as `orbital_ui`, is a separate decision and not part of this change.
