# Walkthrough: test that every component and slot renders

## What was built and why

The tests rendered only a few components, so render-time bugs reached a release candidate while the docs site hid them. `test/components/orbital_ui/every_component_test.rb` now finds every component from the files in `app/components` and generates a test for each one and for each way of filling its slots. New components and slots are covered automatically.

Each render must be non-empty, valid HTML, checked with `Nokogiri::HTML5`, with no raw template syntax. A slot's content must appear in the output, apart from the components in `IGNORES_BLOCK`, which render their own slots or markup.

## How the pieces fit together

- `ARGUMENTS` holds required arguments, keyed by class. Slots use the same table through their renderable class, so there is one list.
- `slot_setters` reads `registered_slots`. A polymorphic slot such as `Menu`'s `menu_items` has a `renderable_hash`, with one setter per type, such as `with_item`.
- `test_helper.rb` sets `ORB.namespaces`, as the README requires of every app, and `load_defaults`, which also removes a Rails 7.1 deprecation warning.
- `test_helper.rb` overrides `Warning.warn` to raise on any warning from this gem's own code. Warnings from dependencies still print, so they can't break the build.

## Bugs it found, all fixed here

- `orbital-e2394d`: `Expander` ignored `html_attributes`, so `vertical` and `class` were dropped. `CheckBox` rendered an invalid `</input>`, because a splat on an HTML tag goes through `content_tag`. It now uses `tag.input`.
- `orbital-5b6a71`: `Popcard` ignored `position` and `on`. It redefines attributes it inherits from `Popover`, so each was processed twice: the first pass consumed the caller's value with `kwargs.delete`, and the second reset it to the default. `attribute` now replaces an inherited definition. The `method redefined` warnings were the only visible symptom.

## Non-obvious things

- The component initializer consumes the hash it is given, so `arguments_for` passes a copy. `Component.new(hash)` empties a caller's hash; `new(**hash)` should avoid it.
- `Card::Header` only renders its title, description and action slots, so plain block content is dropped. That is noted, not changed.
- The suite only renders with default props and minimal arguments. It doesn't cover every variant or any JavaScript behaviour.

## Checks

The suite was tested by reintroducing bugs. Removing the `orb_template` require, the namespace setup, the `Expander`, `CheckBox` or attribute fixes, `Image`'s `src` or `Card`'s splat each makes it fail, as does breaking a template.

`make test` and `make test-rubies` pass with 117 tests and no warnings, and the same tests pass on Rails 7.1 with `-w`. All 41 docs paths return 200. The package has 74 files. The `Expander` `vertical` example was checked in a browser.
