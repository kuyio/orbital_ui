## What was built

`Grid` — a CSS Grid layout component that completes the layout trio (Stack, InlineStack, Grid). Renders a grid container with configurable columns and gap. Column spanning is handled by a `data-grid-span` attribute on child elements — no sub-component needed.

## Files changed

| File | Purpose |
|---|---|
| `orbital/app/components/orbital/grid.rb` | Ruby component class |
| `orbital/frontend/stylesheets/components/grid.css` | CSS: columns, gap scale, child span rules |
| `orbital/frontend/stylesheets/index.css` | Added import for `grid.css` |
| `demo/app/views/components/_grid.html.orb` | Demo page with examples |
| `demo/app/views/components/index.html.orb` | Gallery card |
| `demo/app/controllers/components_controller.rb` | Added to `COMPONENTS` whitelist |
| `demo/app/controllers/search_controller.rb` | Added to search entries |
| `orbital/spec/components/orbital/grid_spec.rb` | RSpec tests |

## How the pieces fit together

Grid follows the same pattern as Stack and InlineStack: a Ruby component with typed attributes, `{{content}}` passthrough template, and CSS styled via `data-*` attribute selectors in `@layer components`.

The key difference is how spanning works. Instead of a sub-component, spanning is pure CSS: `.Orbital-Grid > [data-grid-span="N"] { grid-column: span N; }`. Any direct child of a Grid can span columns by adding the `data-grid-span` attribute — no wrapper element, no slot registration.

## Key decisions

**No sub-component for spanning** — We iterated through four approaches during review:
1. `Grid:Cell` (slot syntax) — failed because ORB resolves `:` as a slot, requiring `renders_many` and forcing all children through the slot system
2. `Grid::Cell` (namespace syntax) — also triggered slot lookup in ORB
3. `Grid.Cell` (namespace component) — worked but added an unnecessary wrapper div
4. `data-grid-span` attribute — the final design: no component, no extra DOM node, just a CSS selector on the child. Simplest possible solution.

**Column scale: 1–6, 12** — covers common layouts. Rare counts (7–11) can use raw Tailwind class overrides.

**No responsive columns in v1** — responsive column counts (e.g. 1 on mobile, 3 on desktop) are deferred. Users can achieve this now with Tailwind class overrides on the Grid element.

## Anything non-obvious

- The CSS uses a child combinator (`.Orbital-Grid > [data-grid-span]`) so `data-grid-span` only works on direct children, not deeply nested elements. This is intentional — grid column spanning only applies to direct grid items.
- Components that forward `data-*` attributes (most Orbital components do via `**html_attributes`) can accept `data-grid-span` directly: `<TextField label="Card" data-grid-span="3"/>`.
