## What was built

`InlineStack` — a horizontal flex layout component that pairs with `Stack` to cover virtually all flex usage in the component library. Where `Stack` renders `flex-direction: column`, `InlineStack` renders `flex-direction: row`.

## Files changed

| File | Purpose |
|---|---|
| `orbital/app/components/orbital/inline_stack.rb` | Ruby component class |
| `orbital/frontend/stylesheets/components/inline-stack.css` | CSS styles |
| `orbital/frontend/stylesheets/index.css` | Added import for `inline-stack.css` |
| `orbital/frontend/stylesheets/components/stack.css` | Biome auto-formatted (pre-existing drift) |
| `demo/app/views/components/_inline-stack.html.orb` | Demo page with examples |
| `demo/app/views/components/index.html.orb` | Gallery card (alphabetical position between image and kbd) |
| `demo/app/controllers/components_controller.rb` | Added to `COMPONENTS` whitelist |
| `demo/app/controllers/search_controller.rb` | Added to search entries |
| `orbital/spec/components/orbital/inline_stack_spec.rb` | 12 RSpec examples |

## How the pieces fit together

The component follows the same three-layer pattern as every Orbital component:

1. **Ruby class** (`inline_stack.rb`) extends `Orbital::Component`, declares typed attributes via the `attribute` DSL, and builds a `data-*` attribute hash in `default_attributes`. The `orb_template` renders a `<div>` with splat attributes and a content slot.

2. **CSS** (`inline-stack.css`) targets `.Orbital-InlineStack` with `data-*` attribute selectors inside `@layer components`. Gap values set a `--inline-stack-gap` custom property consumed by a `gap:` rule. Align, justify, and padding map directly to Tailwind `@apply` utilities.

3. **Demo partial** (`_inline-stack.html.orb`) follows the standard documentation structure: canonical example, usage code block, when-to-use guidance, behaviour description, interactive examples for each prop, best practices (do/don't), and API reference table.

## Key decisions

**`wrap` as a presence-based prop** — The most common case is bare `<InlineStack wrap>` for `flex-wrap: wrap`. The `wrap="reverse"` value enables `flex-wrap: wrap-reverse`. Omitting `wrap` means no wrapping. In the Ruby component, `@wrap` is a string attribute defaulting to `nil`; in `default_attributes`, `"reverse"` emits `data-wrap="reverse"`, any other truthy value emits `data-wrap` (bare), and `nil` omits it entirely. CSS uses `[data-wrap]` as a presence selector (catches both cases), overridden by `[data-wrap="reverse"]` via source order.

**`justify` not `distribute`** — The issue originally proposed `distribute` for the main-axis prop. We kept `justify` for consistency with `Stack`, which already uses it, and because the target audience (Tailwind users) already thinks in `justify-between`, `justify-center`, etc.

**No `dividers` in v1** — Stack has dividers (horizontal lines via `::before` pseudo-elements). InlineStack could have vertical dividers, but the implementation differs and no current usage needs them. Easy to add later.

**Biome reformatted `stack.css`** — Biome enforces multi-line CSS rules. The existing `stack.css` used single-line rules that pre-dated the Biome config. Auto-formatting it was included in this change rather than a separate commit.

## Anything non-obvious

- The demo partial filename uses a hyphen (`_inline-stack.html.orb`), not an underscore — matching the convention of `_button-group`, `_navigation-menu`, `_progress-bar`, etc. The Rails controller resolves the component name from the URL slug (`inline-stack`) to the partial.
- The `attribute` DSL does not expose public reader methods — attributes are only accessible as instance variables (`@gap`, `@wrap`, etc.). Tests use `component.send(:default_attributes)` to verify behaviour.
