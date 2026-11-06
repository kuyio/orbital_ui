## What

Replace FontAwesome Free as the icon source with Lucide, keeping the existing server-side inline SVG rendering pipeline (`Orbital::Icons.render` → method dispatch → `html_safe` SVG string). FontAwesome brand icons (e.g. `github`) stay as-is. The variant system is removed entirely — `render` tries Lucide first, then FA brands automatically. Callers just pass an icon name. All 92 icon name references across the library and demo app are remapped to Lucide equivalents.

## Why

FontAwesome Free has inconsistent coverage across variants and a limited free set. Lucide (~1500 icons, MIT license) is the icon set ShadCN uses — since Orbital follows ShadCN conventions, Lucide is a natural fit. Lucide's consistent stroke-based design (2px stroke, 24×24 viewBox) also eliminates the solid/regular variant split entirely.

## Acceptance Criteria

- [ ] `Orbital::Icons.render("search")` returns a Lucide inline SVG
- [ ] `Orbital::Icons.render("github")` returns a FontAwesome brand SVG (automatic fallback)
- [ ] `Icon` component accepts only `name` and `size` — no `variant` attribute
- [ ] All 92 icon references across the library and demo app use Lucide names
- [ ] Components with hardcoded icon names (`Alert`, `Spinner`, `Select`, `Dropdown`, `Accordion::Item`, `NavigationMenu`, `Menu::Sub`, `CheckBox`, `Avatar`) use correct Lucide names
- [ ] Icon CSS handles stroke-based SVGs (Lucide) and fill-based SVGs (FA brands) correctly
- [ ] Spinner component still animates correctly with the Lucide replacement
- [ ] Icon documentation page reflects new icon set, updated examples, no variant system
- [ ] Demo app renders all icons correctly (visual verification)
- [ ] Full Lucide icon set available (~1500 icons), full FA brands set retained (~549 icons)

## Flow

### Step 1: Write the generator script

Create `orbital/bin/generate-icons` — a Bun script that produces `orbital/lib/orbital/icons.rb`.

**Prerequisites:**
- `lucide-static` installed as a dev dependency in `orbital/package.json` (`bun add -d lucide-static`)
- Add `"generate:icons": "bun bin/generate-icons"` to `orbital/package.json` scripts

**What the script does:**

1. Read all SVGs from `node_modules/lucide-static/icons/*.svg`
2. For each Lucide SVG:
   - Parse the SVG string
   - Strip `width` and `height` attributes (CSS controls sizing)
   - Keep `viewBox="0 0 24 24"`, `fill="none"`, `stroke="currentColor"`, `stroke-width="2"`, `stroke-linecap="round"`, `stroke-linejoin="round"`
   - Generate a `self.icon__<name>` method returning the `html_safe` SVG string
3. Read the current `icons.rb` and extract all `icon_brands__*` methods verbatim (FA brand SVGs, `fill="currentColor"`)
4. Write the new `icons.rb` combining both sets
5. Print summary: "Generated 1,523 Lucide + 549 FA brands = 2,072 icon methods"

**Method naming convention:**
- Lucide icons: `self.icon__<name>` (e.g. `icon__search`, `icon__settings`)
- FA brands: `self.icon_brands__<name>` (e.g. `icon_brands__github`)

### Step 2: Generate the new `icons.rb`

Run `bun run generate:icons` from `orbital/` to produce the new file.

The `Orbital::Icons` module changes:
- Remove `VARIANTS` constant entirely
- `render` method simplifies to a Lucide-first lookup with automatic FA brands fallback:

```ruby
def self.render(name)
  normalized = name.to_s.tr('-', '_')

  lucide = :"icon__#{normalized}"
  return send(lucide) if respond_to?(lucide)

  brands = :"icon_brands__#{normalized}"
  return send(brands) if respond_to?(brands)

  raise ArgumentError, "Icon '#{name}' not found."
end
```

No `variant` parameter. No `brands` flag. Just give it a name — it finds the icon.

### Step 3: Update `Orbital::Icon` component

In `orbital/app/components/orbital/icon.rb`:
- Remove `attribute :variant` entirely
- `call` simplifies — just passes name:

```ruby
def call
  tag.div(**html_attributes) do
    Orbital::Icons.render(@name)
  end
end
```

Component API becomes just `name` (required string) and `size` (symbol).

### Step 4: Update `Orbital::Concerns::IconProp`

The concern normalizes `icon` into an options hash for `Icon.new`. With `variant` gone, the hash form simplifies to just `{ name: "...", size: :sm }`. The current code already handles this — no structural changes needed. But audit all `IconProp` usages to confirm no caller passes `variant:` in hash form.

### Step 5: Update icon CSS

In `orbital/frontend/stylesheets/components/icon.css`:
- SVG sizing rules (via `[data-size]`) still apply — no change needed
- Lucide SVGs use `stroke="currentColor"` inline, FA brands use `fill="currentColor"` inline
- No variant-scoped CSS needed — inline attributes handle color inheritance

### Step 6: Apply icon name mapping

**Library components** (hardcoded icon names):

| File | Current FA Name | New Lucide Name |
|------|----------------|-----------------|
| `alert.rb` | `circle-check` | `circle-check` |
| `alert.rb` | `triangle-exclamation` | `triangle-alert` |
| `alert.rb` | `circle-exclamation` | `circle-alert` |
| `alert.rb` | `circle-info` | `info` |
| `navigation_menu.rb` | `bars` | `menu` |
| `menu/sub.rb` | `chevron-right` | `chevron-right` |
| `check_box.rb` | `check` | `check` |
| `select.rb` | `chevron-down` | `chevron-down` |
| `spinner.rb` | `circle-notch` | `loader-circle` |
| `dropdown.rb` | `chevron-down` | `chevron-down` |
| `accordion/item.rb` | `chevron-down` | `chevron-down` |
| `avatar.rb` | `user` | `user` |

**Full icon name mapping** (all 92 unique FA names → Lucide):

| FontAwesome Name | Lucide Name | Notes |
|-----------------|-------------|-------|
| `align-center` | `align-center` | |
| `align-left` | `align-left` | |
| `align-right` | `align-right` | |
| `arrow-left` | `arrow-left` | |
| `arrow-right` | `arrow-right` | |
| `arrow-right-from-bracket` | `log-out` | |
| `arrow-right-to-bracket` | `log-in` | |
| `arrow-up-right-from-square` | `external-link` | |
| `bars` | `menu` | |
| `bell` | `bell` | |
| `bold` | `bold` | |
| `bolt` | `zap` | |
| `book` | `book-open` | |
| `bookmark` | `bookmark` | |
| `brush` | `paintbrush` | |
| `chart-simple` | `chart-bar` | |
| `check` | `check` | |
| `check-circle` | `circle-check` | FA alias → canonical Lucide |
| `chevron-down` | `chevron-down` | |
| `chevron-left` | `chevron-left` | |
| `chevron-right` | `chevron-right` | |
| `circle` | `circle` | |
| `circle-check` | `circle-check` | |
| `circle-exclamation` | `circle-alert` | |
| `circle-info` | `info` | |
| `circle-notch` | `loader-circle` | Spinner replacement |
| `clock` | `clock` | |
| `cog` | `settings` | FA alias for gear |
| `comment` | `message-circle` | |
| `compass` | `compass` | |
| `copy` | `copy` | |
| `credit-card` | `credit-card` | |
| `cube` | `box` | |
| `door-open` | `log-out` | Contextually used for sign-out |
| `download` | `download` | |
| `ellipsis-vertical` | `ellipsis-vertical` | |
| `envelope` | `mail` | |
| `file` | `file` | |
| `file-code` | `file-code` | |
| `file-pdf` | `file-text` | Lucide has no PDF-specific icon |
| `film` | `clapperboard` | |
| `filter` | `filter` | |
| `floppy-disk` | `save` | |
| `folder` | `folder` | |
| `folder-open` | `folder-open` | |
| `gear` | `settings` | |
| `github` | `github` | **Resolved via FA brands fallback** |
| `headset` | `headphones` | |
| `heart` | `heart` | |
| `home` | `house` | FA alias → canonical Lucide |
| `house` | `house` | |
| `inbox` | `inbox` | |
| `italic` | `italic` | |
| `link` | `link` | |
| `list` | `list` | |
| `lock` | `lock` | |
| `magnifying-glass` | `search` | |
| `moon` | `moon` | |
| `palette` | `palette` | |
| `paste` | `clipboard-paste` | |
| `pen` | `pen` | |
| `pencil` | `pencil` | |
| `plus` | `plus` | |
| `puzzle-piece` | `puzzle` | |
| `robot` | `bot` | |
| `rocket` | `rocket` | |
| `rotate-left` | `undo-2` | |
| `rotate-right` | `redo-2` | |
| `save` | `save` | |
| `scissors` | `scissors` | |
| `server` | `server` | |
| `share` | `share` | |
| `share-nodes` | `share-2` | |
| `shield-halved` | `shield` | |
| `sliders` | `sliders-horizontal` | |
| `spinner` | `loader-circle` | Same as circle-notch |
| `star` | `star` | |
| `sun` | `sun` | |
| `swatchbook` | `palette` | |
| `table` | `table` | |
| `table-cells` | `layout-grid` | |
| `tag` | `tag` | |
| `trash` | `trash-2` | |
| `trash-can` | `trash-2` | Both map to same Lucide icon |
| `triangle-exclamation` | `triangle-alert` | |
| `truck` | `truck` | |
| `underline` | `underline` | |
| `universal-access` | `accessibility` | |
| `user` | `user` | |
| `user-plus` | `user-plus` | |
| `users` | `users` | |
| `xmark` | `x` | |

**Files to update** (complete list):

Library components:
- `orbital/app/components/orbital/alert.rb` — 4 icon names
- `orbital/app/components/orbital/navigation_menu.rb` — 1 icon name
- `orbital/app/components/orbital/spinner.rb` — 1 icon name

Demo app:
- `demo/app/components/demo/app_frame.rb` — 5 icon names + remove all variant references
- `demo/app/views/components/index.html.orb` — ~15 icon references
- `demo/app/views/components/_icon.html.orb` — ~20 icon references + remove variant usage
- `demo/app/views/components/_button.html.orb` — 4 icon references
- `demo/app/views/components/_separator.html.orb` — 6 icon references
- `demo/app/views/components/_button-group.html.orb` — 5 icon references
- `demo/app/views/components/_accordion.html.orb` — 8 icon references
- `demo/app/views/components/_dropdown.html.orb` — 5 icon references
- `demo/app/views/components/_popover.html.orb` — 1 icon reference
- `demo/app/views/components/_tooltip.html.orb` — 4 icon references
- `demo/app/views/components/_expander.html.orb` — 4 icon references
- `demo/app/views/components/_card.html.orb` — 2 icon references
- `demo/app/views/components/_popcard.html.orb` — 2 icon references
- `demo/app/views/components/_navigation-menu.html.orb` — 11 icon references
- `demo/app/views/components/_menu.html.orb` — 25+ icon references
- `demo/app/views/components/_badge.html.orb` — 7 icon references
- `demo/app/views/components/_avatar.html.orb` — 4 icon references
- `demo/app/views/components/_text-field.html.orb` — 3 icon references
- `demo/app/views/static_pages/index.html.orb` — 30+ icon references
- `demo/app/views/static_pages/blocks.html.orb` — 20+ icon references

### Step 7: Update Icon documentation page

Rewrite `demo/app/views/components/_icon.html.orb`:
- Update description to reference Lucide instead of FontAwesome
- Remove all variant examples and documentation — just `<Icon name="search"/>` and `<Icon name="github"/>` (brands resolved automatically)
- Update "Common Icons" grid to show Lucide equivalents
- Update API reference table: `name` (required string) and `size` (symbol) only
- Add a note about the stroke-based design (consistent 2px stroke, 24×24 viewBox)
- Note that FA brand icons (GitHub, Slack, etc.) are still available by name

### Step 8: Visual verification

- Start the demo app and verify every page that uses icons
- Specifically check: Alert variants, Spinner animation, Select/Dropdown arrows, Accordion chevrons, NavigationMenu hamburger, Avatar fallback icon, all Menu icons
- Check both light and dark themes

## Decisions

**Kill the variant system entirely — automatic Lucide → FA brands fallback**
Callers should not need to know which icon set a name lives in. `render("github")` tries Lucide first (no match), then FA brands (match — returns it). This eliminates the `variant` attribute from the `Icon` component and every template. The Lucide-first lookup order means if both sets have an icon with the same name, Lucide wins — which is the right default since we're migrating to Lucide.

**Keep all Lucide + all FA brands, not just the 92 in use**
The `icons.rb` file is auto-generated. Pruning to only used icons saves file size but creates friction when new icons are needed. Keeping the full sets (~1500 Lucide + ~549 FA brands ≈ 2050 methods) is still smaller than the current file (2806 methods).

**Generator script at `orbital/bin/generate-icons`**
Follows the existing `orbital/bin/` convention (`console`, `setup`). Runnable via `bun run generate:icons` from `orbital/`. Stays in the repo so the file can be regenerated when Lucide updates.

**Strip `width`/`height` from Lucide SVGs**
CSS controls icon sizing via `data-size`. Stripping inline dimensions and keeping only `viewBox="0 0 24 24"` lets the SVG scale cleanly.

**No CSS changes for stroke vs fill**
Lucide SVGs have `stroke="currentColor"` and `fill="none"` inline. FA brands SVGs have `fill="currentColor"` inline. Both inherit color from the parent via `currentColor`. No variant-scoped CSS needed.

**`door-open` → `log-out`**
In the demo app, `door-open` is used in a sign-out context. Lucide has no door icon, but `log-out` is the standard sign-out icon and matches the semantic intent.

**`file-pdf` → `file-text`**
Lucide has no PDF-specific icon. `file-text` is the closest general-purpose document icon.

## Edge Cases

**HIGH — Spinner animation:**
The `Spinner` component uses `circle-notch` (a circle with a notch/gap) and CSS rotation. Lucide's `loader-circle` is visually similar. Verify the CSS animation works correctly with stroke-based rendering — if the animation looks wrong, try `loader` or `loader-2` instead.

**MEDIUM — Icons that rely on fill appearance:**
Some FA solid icons (like `circle`, `star`) are visually filled. Lucide equivalents are outlined (stroke-only). For most UI contexts the outlined style works fine. Audit specific usages and confirm the outlined style is acceptable.

**LOW — FA alias deduplication:**
Some FA names in use are aliases (`home`/`house`, `cog`/`gear`, `check-circle`/`circle-check`). After mapping, these converge to the same Lucide name. No functional issue.

## Assumptions

- Lucide's `lucide-static` npm package contains all ~1500 icons as individual SVG files
- The demo app's Parcel build does not process `icons.rb` (pure Ruby, not a JS import)
- No external consumers depend on specific FA icon method names in `icons.rb`
- The `IconProp` concern needs no structural changes — just name/size pass through to `Icon.new`

## Open Questions

None — all resolved. Mapping will be validated during tophat.
