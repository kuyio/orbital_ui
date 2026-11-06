## What

Add an `icon` prop to Badge that renders a built-in Icon before the badge text with proper sizing and spacing. The dot (when present) always renders on the right.

## Why

Icons inside Badge currently require manual color and spacing overrides (`<Icon class="text-green-500 mr-1"/>`). A first-class prop provides automatic sizing, spacing, and dark-mode adaptation via the existing `IconProp` concern.

## Acceptance Criteria

- [ ] `<Badge icon="check-circle">` renders an Icon (size sm) before the badge text
- [ ] Icon accepts a string name or hash (same as Menu::Item, via `IconProp` concern)
- [ ] Icon inherits the badge's text color by default (no manual tinting needed)
- [ ] Dot always renders on the right (trailing position): `[icon?] [text] [dot?]`
- [ ] Icon and dot can be used independently or together
- [ ] CSS handles spacing for icon (leading, `mr`) and dot (trailing, `ml`)
- [ ] Demo page updated with icon examples and icon+dot combination
- [ ] API reference table updated

## Flow

1. **Ruby** — update `badge.rb`:
   - Include `Orbital::Concerns::IconProp`
   - Add `attribute :icon, :any, default: nil`
   - Update template to render: `[icon] [content] [dot]`
   - May need to switch from `orb_template` to a `call` method since `render_icon` returns rendered HTML

2. **CSS** — update `badge.css`:
   - Move dot from `mr-1.5` to `ml-1.5` (trailing position)

3. **Demo** — update `_badge.html.orb`:
   - Add "Icons" example section showing icons with different variants
   - Add "Icon with Dot" example showing the combined layout
   - Update the "Status Dots" grid to reflect trailing dot position
   - Update API reference

## Decisions

- **Icon inherits text color** — no separate tone prop for the icon. The icon takes on `currentColor` from the badge, which already varies by variant. This is simpler than the issue's proposed `tone` prop and covers the common case. Users who need a specific icon color can still pass it via the hash form: `icon={{name: "star", class: "text-yellow-500"}}`.

- **Dot always trailing** — the dot renders after the text, on the right. This is the common UI pattern — the icon reinforces the label on the left, the dot indicates live status on the right. This is a breaking change from the current left-side dot, but the component is new enough that no migration is needed.

- **No `tone` prop on Badge itself** — the issue suggested a `tone` prop that could tint the badge background. Deferring this — it adds complexity (badge-level tinting interacting with variants) and the immediate need is just icon placement. Can be added later if needed.

## Edge Cases

- **LOW** — Icon-only badge (no text content): works fine, the icon renders inside the badge.
- **LOW** — Dot-only with no icon: dot renders on the right.

## Assumptions

- The `IconProp` concern's `render_icon` method returns rendered HTML, so it likely needs a `call` method rather than `orb_template` to integrate. Menu::Item uses `call` for the same reason.
- Icon size `sm` is the right default for badge context (matching Menu::Item).
