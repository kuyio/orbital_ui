# Walkthrough: remove Dialog.turbo_frame_response and fix the missing-attribute typo

## What changed and why

- `app/components/orbital_ui/dialog.rb`: removed `turbo_frame_response`. It called `Turbo::StreamsHelper.turbo_stream`, which is an instance method, so it always raised `NoMethodError`. Nothing called it.
- `lib/orbital_ui/components/attributes.rb`: the error now reads `Missing required attribute`.
- `test/components/orbital_ui/orb_rendering_test.rb`: Icon renders with a name, and raises the corrected error without one.
- `CHANGELOG.md`: both are listed under 0.3.0.

## Key decision

Remove rather than fix. Fixing it would add a Turbo dependency for a helper that duplicates `ModalFrame` and `DialogFrame`, which are the documented way to open a dialog from a response. The method never worked, so removing it can't break anything that relied on it.

## Non-obvious things

- Icon and Image raising in the earlier component sweep was not a bug. The sweep rendered every component with no arguments, and both have a required attribute. Both render correctly with it.
- These tests don't set `ORB.namespaces`, so they can't render Dialog or the other components that use bare tags. The docs site covers those.

## Checks

`make test` and `make test-rubies` pass with 25 tests. The package has 74 files. All 41 docs paths return 200, and a Turbo Frame request to `/contact` returns the `dialogs` frame.
