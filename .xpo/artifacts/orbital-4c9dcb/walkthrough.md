## What was built

Added an `icon` prop to Badge and moved the `dot` to a trailing (right-side) position. Badge layout is now `[icon?] [text] [dot?]`.

## Files changed

| File | Purpose |
|---|---|
| `orbital/app/components/orbital/badge.rb` | Added `icon` prop via `IconProp` concern, switched to `call` method |
| `orbital/frontend/stylesheets/components/badge.css` | Added icon spacing, changed dot from `mr-1.5` to `ml-1.5` |
| `demo/app/views/components/_badge.html.orb` | Added Icons and Icon with Dot sections, reordered examples |

## How the pieces fit together

Badge switched from `orb_template` to a `call` method using `safe_join`, following the same pattern as Menu::Item. This was necessary because `render_icon` (from the `IconProp` concern) returns rendered HTML that can't be embedded in an ORB template string.

The `call` method builds the badge as:
```ruby
safe_join([render_icon, content, dot_span].compact)
```

Icon spacing is handled by CSS: `.Orbital-Badge > .Orbital-Icon { @apply -ml-0.5 mr-1; }` — the negative left margin optically aligns the icon with the badge edge, and the right margin separates it from the text.

The dot moved from leading (`mr-1.5`) to trailing (`ml-1.5`). This is a breaking change from the previous position but the dot prop was only added in the previous issue (orbital-cd7cf2), so no migration concern.

## Key decisions

**No `tone` prop** — the issue proposed a `tone` prop that could tint the badge background and icon color. Deferred — the icon inherits `currentColor` from the badge variant, which handles the common case. Users who need a specific icon color can use the hash form: `icon={{name: "star", class: "text-yellow-500"}}`.

**Dot always trailing** — rather than conditionally positioning the dot based on whether an icon is present, the dot is always on the right. This matches the common 2026 UI pattern and simplifies the CSS (no conditional classes needed).

## Anything non-obvious

- The `IconProp` concern's `render_icon` method accepts both a string (`icon="star"`) and a hash (`icon={{name: "github", variant: "brands"}}`), same as Menu::Item. The hash form allows full control over icon options.
- The filled-badge dot contrast overrides from orbital-cd7cf2 continue to work unchanged — the CSS selectors target `.Orbital-Badge-Dot` regardless of its position in the DOM.
