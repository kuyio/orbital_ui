# Test that every component and slot renders

## What

Add a test suite that finds every component from the files in `app/components`, renders it, and renders each of its slots.

## Why

The tests render only a few components. The bugs found in this release cycle, raw template source and `NameError`s from unresolved tags, were all render-time failures that the docs site hid and a render sweep caught.

## How

- `test_helper.rb` adds `OrbitalUi` to `ORB.namespaces`, the setup the README requires of every app.
- Tests are generated, one per component and one per slot, from `app/components` and each class's `registered_slots`.
- A small table holds required arguments, for the few components and slots that need them.

## Checks on each render

- The output is non-empty HTML and well-formed.
- It contains no raw template syntax such as `{{`, `{%` or `**html_attributes`.
- A rendered slot's content appears in the output.

## Acceptance Criteria

- [ ] Every class under `app/components`, apart from `Component` and concerns, has a generated test
- [ ] Every registered slot has a generated test
- [ ] A new component or slot is covered automatically, and fails with a clear message if it needs arguments that aren't in the table
- [ ] Removing the `orb_template` require or the namespace setup makes the suite fail
- [ ] `make test`, `make test-rubies` and the Rails 7.1 run pass
- [ ] Bugs the suite finds are filed and reported rather than hidden

## Out of scope

- Testing every variant and prop value
- Visual checks
