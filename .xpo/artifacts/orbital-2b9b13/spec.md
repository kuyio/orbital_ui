# Remove Dialog.turbo_frame_response and fix the missing-attribute typo

## What

Remove `OrbitalUi::Dialog.turbo_frame_response`, and correct `Misssing required attribute` to `Missing required attribute`.

## Why

The method calls `Turbo::StreamsHelper.turbo_stream`, which is an instance method, so it always raises `NoMethodError`. It has never worked, nothing in this repo calls it, and it would need `turbo-rails`, which the gemspec doesn't declare. The documented way to open a dialog from a response is `ModalFrame` or `DialogFrame`, and both render correctly.

## Acceptance Criteria

- [ ] `Dialog` no longer defines `turbo_frame_response`, and `Dialog` still renders
- [ ] A missing required attribute raises `Missing required attribute :name`, covered by a test
- [ ] Icon renders with a name, covered by a test
- [ ] `make test` and `make test-rubies` pass, and every docs path returns 200

## Decisions

- **Remove rather than fix.** Fixing it would add a Turbo dependency for a helper that duplicates `ModalFrame`. An app wanting a Turbo Stream can call `turbo_stream.update` with a component directly.

## Out of scope

- Other deprecated methods in `lib/orbital_ui.rb`
