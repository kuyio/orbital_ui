## What

Add a `<Grid>` layout component — a CSS Grid container that replaces raw `grid grid-cols-X gap-X` patterns. Column spanning is handled via `data-grid-span` attributes on child elements.

## Why

Raw `<div class="grid grid-cols-X gap-X">` appears 20+ times across the demo pages — for the component gallery, best-practice do/don't columns, form layouts, and stat tiles. A dedicated component provides consistent naming and attribute-driven configuration, completing the layout trio (Stack, InlineStack, Grid).

## Acceptance Criteria

- [x] `<Grid>` renders a CSS Grid container with `Orbital-Grid` class
- [x] Supports `columns` and `gap` props
- [x] Column counts: 1–6, plus 12 for dashboard grids
- [x] Gap scale matches Stack/InlineStack exactly (0, 0.5, 1, 1.5, 2, 3, 4, 5, 6, 8, 10, 12, 16)
- [x] Children with `data-grid-span="N"` span multiple columns
- [x] Plain children occupy one column by default
- [x] CSS is defined in `@layer components` using `data-*` attribute selectors
- [x] Demo partial showcases basic grids, gap variants, and span control
- [x] Demo partial is included in the component gallery index
- [x] All existing tests pass; new component has test coverage

## Flow

1. **Ruby component** — `orbital/app/components/orbital/grid.rb`
   - Extend `Orbital::Component`
   - Attributes: `columns` (string, default `"1"`), `gap` (string, default `"4"`)
   - `default_attributes` merges `class: "Orbital-Grid"` with `data-columns`, `data-gap`
   - `orb_template` renders `<div **html_attributes>{{content}}</div>` (passthrough, like Stack)

2. **CSS** — `orbital/frontend/stylesheets/components/grid.css`
   - Base: `.Orbital-Grid { @apply grid; }`
   - Column rules: `[data-columns="1"]` through `[data-columns="6"]` plus `[data-columns="12"]`
   - Gap: same custom property pattern as Stack/InlineStack (`--grid-gap`, same scale)
   - Child spans: `.Orbital-Grid > [data-grid-span="N"]` using `grid-column: span N`

3. **CSS import** — `@import "./components/grid.css";` in `orbital/frontend/stylesheets/index.css`

4. **Demo partial** — `demo/app/views/components/_grid.html.orb`

5. **Gallery entry** — alphabetically between `expander` and `heading`

6. **Controller/search** — added to `COMPONENTS` whitelist and search entries

7. **Tests** — RSpec tests for Grid

## Decisions

- **No sub-component for spanning** — column spanning uses a `data-grid-span` attribute on child elements, targeted by `.Orbital-Grid > [data-grid-span="N"]` CSS selectors. No wrapper component, no extra DOM node. Iterated through slot-based, namespace, and standalone component approaches before settling on the simplest solution.

- **String columns, not integer** — using string type for `columns` to match the `data-*` attribute pattern established by gap.

- **Column scale: 1–6, 12** — covers the common cases. 7–11 are rare enough that raw Tailwind is fine.

- **No responsive columns in v1** — use Tailwind breakpoint overrides on the `class` prop for responsive behavior.

- **Span scale: 2–6, 12** — span 1 is the default (no attribute needed).

## Edge Cases

- **MEDIUM** — `data-grid-span` exceeding `columns`: CSS grid handles this gracefully, no validation needed.
- **LOW** — Grid with zero children: renders an empty grid div, same as Stack behavior.
- **LOW** — `data-grid-span` on a non-direct child: the `>` combinator in CSS ensures only direct children are affected.
