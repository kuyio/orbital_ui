## What

Add an `<InlineStack>` layout component — a horizontal flex container that mirrors `<Stack>` in API and implementation pattern. Where `Stack` renders `flex-direction: column`, `InlineStack` renders `flex-direction: row`. Together they cover virtually all flex usage and eliminate ~30+ raw `<div class="flex ...">` instances from the demo pages.

## Why

Horizontal flex containers like `<div class="flex items-center gap-2">` appear extensively across the codebase (12+ times in `index.html.orb` alone, many more in partial demos). Each instance manually specifies alignment and distribution with raw Tailwind utilities. A dedicated component provides:

- Consistent naming and defaults across the codebase
- Attribute-driven styling via `data-*` selectors (matching the Orbital pattern)
- A compositional pair with `Stack` for nested layouts

## Acceptance Criteria

- [ ] `<InlineStack>` renders a horizontal flex container with `Orbital-InlineStack` class
- [ ] Supports `gap`, `align`, `justify`, `padding`, `wrap` props
- [ ] Gap scale matches Stack exactly (0, 0.5, 1, 1.5, 2, 3, 4, 5, 6, 8, 10, 12, 16)
- [ ] Align maps to cross-axis: `start`, `center`, `end`, `stretch` (default: `stretch`)
- [ ] Justify maps to main-axis: `start`, `center`, `end`, `between`, `around`, `evenly` (default: `start`)
- [ ] `wrap` is presence-based: omitted = no wrap, bare `wrap` = `flex-wrap: wrap`, `wrap="reverse"` = `flex-wrap: wrap-reverse`
- [ ] CSS is defined in `@layer components` using `data-*` attribute selectors
- [ ] Demo partial (`_inline_stack.html.orb`) showcases gap, alignment, justify, wrap, and padding variants
- [ ] Demo partial is included in the component gallery index
- [ ] All existing tests pass; new component has test coverage

## Flow

1. **Ruby component** — create `orbital/app/components/orbital/inline_stack.rb`
   - Extend `Orbital::Component`
   - Attributes: `gap` (string, default `"4"`), `align` (symbol, default `:stretch`), `justify` (symbol, default `:start`), `padding` (string), `wrap` (string, default `nil`)
   - `default_attributes`:
     - Always: `class: "Orbital-InlineStack"`, `data-gap`, `data-align`, `data-justify`, `data-padding`
     - When `@wrap` is `"reverse"`: emit `data-wrap="reverse"`
     - When `@wrap` is any other non-nil value: emit `data-wrap` (bare)
     - When `@wrap` is nil: omit `data-wrap` entirely
   - `orb_template` renders `<div **html_attributes>{{content}}</div>`

2. **CSS** — create `orbital/frontend/stylesheets/components/inline-stack.css`
   - Base: `.Orbital-InlineStack { @apply flex flex-row; }`
   - Gap, align, justify, padding rules mirror `stack.css` exactly (same scale, same `--inline-stack-gap` custom property pattern)
   - `[data-wrap] { @apply flex-wrap; }` — presence selector catches all wrap values
   - `[data-wrap="reverse"] { @apply flex-wrap-reverse; }` — overrides by source order (equal specificity)
   - Wrap in `@layer components { ... }`

3. **CSS import** — add `@import "./components/inline-stack.css";` to `orbital/frontend/stylesheets/index.css` (adjacent to the Stack import)

4. **Demo partial** — create `demo/app/views/components/_inline_stack.html.orb`
   - Sections: canonical example, gap variants, alignment variants, justify variants, wrap + wrap-reverse demo, padding, combined with Stack (nesting)
   - Follow the structure of `_stack.html.orb`

5. **Gallery entry** — add InlineStack section to `demo/app/views/components/index.html.orb`

6. **Tests** — add component specs following existing test patterns

## Decisions

- **`justify` not `distribute`** — the issue proposed `distribute` for the main-axis prop, but Stack already uses `justify` for the same concept. Consistency within the component library is more important than a slightly more descriptive name. Using `justify` means developers learn one vocabulary for both components.

- **No `dividers` prop in v1** — Stack supports `data-dividers` with horizontal border lines via `::before` pseudo-elements. InlineStack could support vertical dividers, but the implementation is slightly different (vertical line orientation, height calculation) and none of the current horizontal flex instances in the codebase use dividers. Omitting keeps the scope tight; can be added later if needed.

- **`wrap` as presence-based prop** — bare `wrap` attribute enables wrapping (the common case: `<InlineStack wrap>`), `wrap="reverse"` enables reverse wrapping, and omitting it means no wrapping. This keeps the ergonomic 90% case simple while still covering the full flexbox wrapping surface. In the Ruby component, `@wrap` is a string attribute defaulting to `nil`; any non-nil, non-`"reverse"` value (including bare attribute) triggers `flex-wrap: wrap`. CSS uses a `[data-wrap]` presence selector overridden by `[data-wrap="reverse"]`.

- **Default `align: stretch`** — matches Stack's default and CSS flexbox default. Most common override in the codebase is `center` (e.g. `items-center`), but `stretch` is the correct default for a general-purpose container.

## Edge Cases

- **MEDIUM** — Empty InlineStack: renders an empty `<div>` with the class. No special handling needed (matches Stack behavior), but the demo should not showcase empty usage.
- **LOW** — User passes both `class` and component props: handled by `Component` base class which merges user classes with the default `Orbital-InlineStack` class.
- **LOW** — Invalid gap/align/justify values: handled by the `attribute` DSL's `:only` constraint (silently falls back to default).

## Assumptions

- Bare attributes in `.orb` templates (e.g. `<InlineStack wrap>`) arrive as a non-nil value in the Ruby component (empty string or `"true"`).
- The `Component` base class handles HTML attribute merging the same way for all subclasses.
- The CSS import order in `index.css` does not affect specificity (all in `@layer components`).
- Test patterns exist for other layout components that can be followed.

## Open Questions

None — the implementation closely mirrors the existing Stack component, and all design decisions align with established patterns.
