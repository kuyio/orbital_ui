## [0.3.0] - 2026-11-06

- Rename the gem to `orbital_ui` and the module to `OrbitalUi`, because rubygems.org already has an unrelated gem named `Orbital`. Asset paths are now `orbital_ui/index` and `orbital_ui/theme`. `Orbital-` CSS classes and `orbital-` Stimulus controllers are unchanged.
- Fix components rendering their template source instead of HTML when an app's Gemfile lists only this gem. The gem now loads `orb_template` itself.
- Document that every app must add `OrbitalUi` to `ORB.namespaces`, including apps that only use ERB.
- Remove `Dialog.turbo_frame_response`, which always raised `NoMethodError`. Use `ModalFrame` or `DialogFrame`.
- Fix the spelling of the missing required attribute error.
- Add a `src` prop to `Image` for URLs. Pass exactly one of `asset` and `src`.
- Add `gap` and `padding` props to `Card`, for its content area.

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
