## What was built

Replaced FontAwesome Free with Lucide as the primary icon source for Orbital. The variant system (`solid`/`regular`/`brands`) was removed entirely — callers just pass an icon name and the system resolves it automatically (Lucide first, FA brands fallback).

## How the pieces fit together

### Generator script (`orbital/bin/generate-icons`)

A Bun script that produces `orbital/lib/orbital/icons.rb`. It reads all SVGs from the `lucide-static` npm package, strips `width`/`height` attributes (CSS controls sizing), collapses each SVG to a single-line heredoc string, and writes a Ruby method per icon (`icon__<name>`). It also extracts the existing FA brands methods (`icon_brands__<name>`) from the current file before overwriting, preserving them verbatim.

Runnable via `bun run generate:icons` from `orbital/`. The script stays in the repo so the file can be regenerated when Lucide updates.

### Icon resolution (`Orbital::Icons.render`)

The old `render` method accepted a `variant:` keyword and walked a fallback chain through `VARIANTS`. The new method takes only a `name` argument:

1. Normalize the name (`tr('-', '_')`)
2. Try `icon__<normalized>` (Lucide) — return if found
3. Try `icon_brands__<normalized>` (FA brands) — return if found
4. Raise `ArgumentError`

This means `render("search")` hits Lucide, `render("github")` misses Lucide and hits FA brands, and callers never need to specify which set. If both sets have the same name, Lucide wins.

### Icon component (`Orbital::Icon`)

The `variant` attribute was removed. The component now has two props: `name` (required string) and `size` (symbol, default `:md`). The `call` method delegates to `Icons.render(@name)` with no extra arguments.

### IconProp concern

No changes needed — it already normalizes the `icon` prop into a `{ name:, size: }` hash and passes through to `Icon.new`. With `variant` gone, hash-form icon props in templates simplified from `icon={{name: "github", variant: "brands"}}` to `icon="github"`.

### Icon name mapping

92 unique FontAwesome icon names were remapped to Lucide equivalents across 3 library components and ~20 demo app files. Most are 1:1 (`check` → `check`, `star` → `star`). Notable renames: `magnifying-glass` → `search`, `gear` → `settings`, `bars` → `menu`, `envelope` → `mail`, `circle-notch` → `loader-circle`, `robot` → `bot`, `xmark` → `x`.

## Key decisions

- **No aliases**: old FA names like `gear` or `cog` don't work anymore — only canonical Lucide names. This keeps the API clean and avoids ambiguity.
- **Full icon sets retained**: ~2,007 Lucide + 549 FA brands = 2,556 methods. Smaller than the old file (2,806) and any Lucide icon works immediately without touching `icons.rb`.
- **No CSS changes**: Lucide SVGs use `stroke="currentColor"` inline, FA brands use `fill="currentColor"` inline. Both inherit color via `currentColor` — no variant-scoped CSS needed.
- **Dashboard icon**: used `layout-dashboard` (semantic match) instead of `chart-bar` (literal name mapping from `chart-simple`).
- **Colors nav item**: uses `paintbrush` to differentiate from Themes (`palette`).