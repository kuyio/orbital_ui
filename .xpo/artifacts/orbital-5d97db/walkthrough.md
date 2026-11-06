# Stack Layout Component — Walkthrough

## What changed

Added `Orbital::Stack`, a vertical flex container component with five props: `gap`, `align`, `justify`, `padding`, and `dividers`.

### Files created

- **`orbital/app/components/orbital/stack.rb`** — Component class. `gap` and `padding` are `:string` type (not `:symbol`) because the Tailwind spacing scale includes fractional values like `"0.5"` that aren't valid Ruby symbols. `dividers` sets `data-dividers: true` (not `""`) because the `deep_tidy` pipeline strips empty strings via `.presence`.

- **`orbital/frontend/stylesheets/components/stack.css`** — All styling via `@layer components` with data-attribute selectors. Gap values are stored in a `--stack-gap` CSS custom property (see below).

- **`demo/app/views/components/_stack.html.orb`** — Demo page with examples for all props: gap sizes, alignment, justify, dividers, and padding.

### Files modified

- **`orbital/frontend/stylesheets/index.css`** — Added `@import "./components/stack.css"`.
- **`demo/app/views/components/index.html.orb`** — Added gallery card.
- **`demo/app/controllers/components_controller.rb`** — Added `"stack"` to the `COMPONENTS` allowlist (otherwise the route 302s to `/components`).

## Key decisions

### `--stack-gap` custom property

The gap scale is stored as a `--stack-gap` CSS custom property rather than using `@apply gap-*` directly. This lets the divider positioning reference the same value. Without it, the divider pseudo-element wouldn't know how far to offset itself.

### Divider centering with pseudo-elements

The original approach used `@apply divide-y divide-border`, which had two problems:

1. **Tailwind v4 wraps `@apply` output in `:where()`** (specificity 0), which lost to the base reset's `html :where(*) { border-width: 0 }` (specificity 0,0,1). The dividers were invisible.
2. **`border-top` on children sits flush at the gap boundary**, not centered in the gap space.

The fix uses an absolutely-positioned `::before` pseudo-element on non-first children, pulled up by `calc(-0.5 * var(--stack-gap) - 0.5px)` to sit at the exact midpoint of the gap. This avoids interfering with children's own padding or pseudo-elements in practice.

### `data-dividers: true` not `""`

The attribute utilities pipeline calls `deep_tidy`, which runs `.to_s.strip.presence` on non-boolean values — empty strings become `nil` and get compacted out. Using `true` survives because `tidy_value` preserves `TrueClass` directly.
