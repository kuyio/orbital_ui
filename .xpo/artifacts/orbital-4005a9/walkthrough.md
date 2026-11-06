## What was built

Added a `fullwidth` boolean prop to the Button component. When set, the button expands to fill the full width of its container via `width: 100%`.

## Files changed

| File | Purpose |
|---|---|
| `orbital/app/components/orbital/button.rb` | Added `fullwidth` attribute and `data-fullwidth` emission |
| `orbital/frontend/stylesheets/components/button.css` | Added `.Orbital-Button[data-fullwidth] { @apply w-full; }` |
| `demo/app/views/components/_button.html.orb` | Added "Full Width" example section and API reference row |

## How the pieces fit together

The change adds one attribute to the Button class and one CSS rule. The `fullwidth` prop follows the exact same pattern as `disabled`:

- Ruby: `attribute :fullwidth, :boolean, default: false`
- In `default_attributes`: `"data-fullwidth": @fullwidth || nil` — the `|| nil` guard ensures the attribute is omitted entirely when `false`, so the CSS presence selector `[data-fullwidth]` only matches when explicitly enabled.
- CSS: `.Orbital-Button[data-fullwidth] { @apply w-full; }` — a single rule using a presence selector (no value check needed since the attribute is either present or absent).

## Key decisions

**`data-fullwidth` attribute, not BEM modifier** — Select and Dropdown use BEM modifiers (`Orbital-Select--fullwidth`) because they use the Styles helper for class composition. Button uses `data-*` attributes for all its props (`data-variant`, `data-size`, `data-disabled`), so `data-fullwidth` is consistent with Button's own pattern.

## Anything non-obvious

Nothing — this is a mechanical addition following an established pattern. The `fullwidth` naming matches Select, Dropdown, and TextField exactly (lowercase, one word).
