# Walkthrough: add gap and padding props to Card

## What changed and why

Card bodies often needed a `flex flex-col gap-X` wrapper just to space their children, and compact or flush cards couldn't change their padding.

- `app/components/orbital_ui/card.rb`: adds `gap` and `padding`, rendered as `data-gap` and `data-padding` on `.Orbital-Card-Content`.
- `frontend/stylesheets/components/card.css`: `[data-gap]` makes the content a flex column, and each value sets `--card-gap` or `--card-padding`. The scale matches `Stack`, and `padding` also accepts `0`.
- `test/dummy/app/views/components/_card.html.orb`: two new examples and a props table.
- `test/components/orbital_ui/card_test.rb`: covers the default output and where the attributes land.

## Key decisions

- **No default gap.** A default would make every existing Card's content a flex column and stack inline children, so `gap` is opt-in.
- **The content div uses a splat, `<div **content_attributes>`.** On a plain HTML tag, a bound attribute renders nil as `data-gap=""`, which would match the `[data-gap]` selector and change every Card. The splat omits nil values, and a test covers this.
- **`padding` leaves the top at 0 below a header,** matching the default layout, because the header has its own bottom padding. When the content comes first, the top uses the same value.
- **Header and footer padding don't change.** The props only apply to the content area, so a small `padding` can look uneven next to a header.

## Non-obvious things

- `var(--card-padding, 1.5rem)` has a fallback, so an unknown value such as `padding="7"` keeps the default padding instead of dropping to 0.
- `gap="7"` still makes a flex column, with no gap. Like `Stack`, the props aren't validated.
- The existing wrapper divs on docs pages were left alone. Replacing them is separate cleanup.

## Checks

`make test` and `make test-rubies` pass with 34 tests, and the same tests pass on Rails 7.1. The package has 74 files, and all 41 docs paths return 200. Padding and gap were measured in a browser with and without a header. The shipped JS is byte-identical, and the CSS only gained 29 Card rules.
