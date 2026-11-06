## [Unreleased]

- Add `Form`, which wraps `form_with` and fills each field's name, value, label and validation error from a model.
- `Select` accepts `value` as well as `selected`, and matches integer values against its options.
- Importing the theme now makes an app's `dark:` utilities follow Orbital's `dark` class. Without it, they follow the OS setting.
- Add `bin/rails generate orbital_ui:install`, which sets up `ORB.namespaces`, the layout tags and, in `-c tailwind` apps, the Tailwind theme.
- Move `Expander`'s CSS into the components layer, so app utilities can override it.
- `Accordion` trigger content now fills the trigger's width.
- Fix `TextField` dropping attributes such as `id`, `class`, `data-*`, `aria-*`, `min` and `step`. They now go on the input.
- Fix `TextField` with `multiline` not showing its `value`.
- Fix `TextField` placeholders looking like typed values in dark mode.
- Document using Orbital in `-c tailwind` and `-c sass` apps, and that Orbital's stylesheet includes Tailwind's reset.

## [0.3.1] - 2026-11-06

- Rename the gem to `orbital_ui` and the module to `OrbitalUi`, because rubygems.org already has an unrelated gem named `Orbital`. Asset paths are now `orbital_ui/index` and `orbital_ui/theme`. `Orbital-` CSS classes and `orbital-` Stimulus controllers are unchanged.
- Fix components rendering their template source instead of HTML when an app's Gemfile lists only this gem. The gem now loads `orb_template` itself.
- Document that every app must add `OrbitalUi` to `ORB.namespaces`, including apps that only use ERB.
- Remove `Dialog.turbo_frame_response`, which always raised `NoMethodError`. Use `ModalFrame` or `DialogFrame`.
- Fix the spelling of the missing required attribute error.
- Add a `src` prop to `Image` for URLs. Pass exactly one of `asset` and `src`.
- Add `gap` and `padding` props to `Card`, for its content area.
- Fix `Expander` ignoring `vertical`, `class` and other attributes.
- Fix `CheckBox` rendering an invalid `</input>` end tag.
- Fix `Popcard` ignoring `position` and `on`. A subclass that redefines an attribute now replaces the inherited one.

## [0.2.0] - 2026-11-06

- Move the gem to the repository root. The docs app is now its dummy app, at `test/dummy`.
- Require Ruby `>= 3.4` and Rails `>= 7.1`.
- Package only `app/`, `lib/`, `LICENSE` and `README.md`.
- Rename `LICENSE.txt` to `LICENSE`, and add third-party notices for Lucide, Feather and Font Awesome.
- Change the copyright holder in `LICENSE` and the gem's author to KUY.io Inc., with `dev@kuy.io` as its email.
- Replace RSpec with Minitest.
- Shipped CSS no longer includes utility classes picked up by accident from non-component files, such as `.absolute`, `.fixed` and `.block`.

## [0.1.0] - 2025-11-29

- Initial release
