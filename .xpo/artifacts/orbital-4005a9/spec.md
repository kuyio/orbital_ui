## What

Add a `fullwidth` boolean prop to the Button component that applies `width: 100%` when set. Replaces the `class="w-full"` override pattern used in card footers and form layouts.

## Why

`<Button class="w-full">` appears multiple times in the demo pages, typically in card footers. A first-class prop is more discoverable, consistent with Select (which already has `fullwidth`), and avoids leaking Tailwind into component usage.

## Acceptance Criteria

- [ ] `<Button fullwidth>` renders with `data-fullwidth` attribute and fills its container width
- [ ] CSS rule `.Orbital-Button[data-fullwidth] { @apply w-full; }` in `button.css`
- [ ] Defaults to `false` (no `data-fullwidth` emitted)
- [ ] Demo page updated with a fullwidth example
- [ ] API reference table updated
- [ ] Existing tests pass

## Flow

1. **Ruby** — add `attribute :fullwidth, :boolean, default: false` to `button.rb`. In `default_attributes`, emit `"data-fullwidth": @fullwidth || nil` (same pattern as `data-disabled`).

2. **CSS** — add `.Orbital-Button[data-fullwidth] { @apply w-full; }` to `button.css`.

3. **Demo** — add a "Full Width" example section to `_button.html.orb` showing fullwidth buttons in a card-like container. Update the API reference table with the new prop.

## Decisions

- **`data-fullwidth` not BEM modifier** — Button uses `data-*` attributes for all props (`data-variant`, `data-size`, `data-disabled`). Select uses a BEM modifier (`Orbital-Select--fullwidth`) because its Styles helper is set up that way. Staying consistent with Button's own pattern.

- **`|| nil` guard** — same pattern as `data-disabled`: when `false`, `nil` prevents the attribute from being emitted at all, so the CSS presence selector only matches when explicitly enabled.
