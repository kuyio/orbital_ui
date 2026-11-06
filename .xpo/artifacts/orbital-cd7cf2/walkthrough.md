### Rationale

Rather than inventing new markup or CSS variables, this reuses the exact `tone` token vocabulary already established by `Orbital::Text` and `Orbital::Alert` (`bg-tone-success`, `bg-tone-warning`, etc.), so the dot automatically gets dark-mode support for free. The alternative — keeping the hand-rolled `<span>` with a hardcoded Tailwind color — is exactly what this issue exists to remove.

### Changes

- `orbital/app/components/orbital/badge.rb` — adds the `dot` attribute (`only:` restricted to the six tone symbols, `default: nil`) and updates `orb_template` to conditionally render `<span class="Orbital-Badge-Dot" data-tone={@dot} :if={@dot}>` before `{{content}}`, using the same `:if={...}` conditional pattern already used in `dialog.rb`/`select.rb`/`text_field.rb`.
- `orbital/frontend/stylesheets/components/badge.css` — adds `.Orbital-Badge-Dot` (size/shape/margin) plus six `[data-tone="..."]` color rules, following the existing `[data-variant="..."]` selector style in the same file.
- `demo/app/views/components/_badge.html.orb` — "Status Dots" section shows a grid of all six dot tones across primary, secondary, and outline badge variants. The former "Dots with Variants" section was merged into this single comprehensive grid.
- `orbital/app/assets/stylesheets/orbital/index.css` (+ `.map`) — regenerated build output from `bun run build`; picks up the new `.Orbital-Badge-Dot` rules and adds `--color-foreground` to the compiled `@theme` block (needed because `bg-foreground` wasn't referenced by any component before now, so Tailwind hadn't emitted it).

### Post-review fixes

**Default dot uses `currentColor`** — The `default` dot originally used `bg-foreground`, which rendered dark on light backgrounds. On a primary badge (dark bg, white text), the dot was invisible. Changed to `background-color: currentColor` so the dot inherits the badge's text color — white on primary/destructive, dark on outline/secondary. Works correctly across all variants without per-variant overrides.

**`--tone-info` design token updated** — Changed from sky-500/sky-400 to blue-500/blue-400:
- Light mode: `#0ea5e9` → `#2b7fff` (blue-500)
- Dark mode: `#38bdf8` → `#6db3ff` (blue-400)

This affects all components using `tone-info` (Badge dots, Alert info variant, Text info tone).

**Filled badge dot contrast** — Primary and destructive badges have inverted backgrounds (dark bg on light theme, light bg on dark theme). The tone-colored dots need the opposite theme's values to maintain contrast:
- Light theme, filled badge (dark bg): uses the lighter dark-mode tone values (`#22c55e`, `#eab308`, `#ef4444`, `#6db3ff`, `#a1a1aa`)
- Dark theme, filled badge (light bg): uses the darker light-mode tone values (`#16a34a`, `#ca8a04`, `#dc2626`, `#2b7fff`, `#71717a`)

Implemented via a base override on `:is(.Orbital-Badge[data-variant="default"], .Orbital-Badge[data-variant="destructive"])` with a `.dark` class override for dark mode.

### Decisions

- `default` and `subdued` dots have no precedent in this codebase (`Alert`'s icon only supports `success`/`warning`/`danger`/`info`). `default` uses `currentColor`; `subdued` uses `bg-muted-foreground`, mirroring how `Text`'s `subdued` tone maps to `text-muted-foreground`.
- `magic` (a valid `Text` tone) was deliberately excluded from `dot`'s `only:` list — there's no `bg-tone-magic` utility in use anywhere, and it isn't a status-indicator color.

### How to verify

1. Run `make test` (all pass).
2. `make demo-dev` and visit the Badge doc page: confirm the "Status Dots" grid shows all six tones across primary, secondary, and outline variants.
3. Toggle dark mode — confirm dot colors flip for contrast on filled badges (primary/destructive get darker dots, outline/secondary get lighter dots).
4. Confirm `<Badge>Badge</Badge>` (no `dot`) renders with no extra `<span>`.

### What to look out for

- The filled-badge dot overrides use hardcoded hex values (the opposite theme's tones). If the design tokens change, these must be updated manually. A future improvement could use CSS custom properties to avoid duplication.
- The `orb_template` now spans multiple lines with a newline/indentation around `{{content}}` even when `dot` is nil. This only adds whitespace text nodes, not an extra element, but worth a quick visual check that badge padding/line-height still look right in tightly-packed layouts.
