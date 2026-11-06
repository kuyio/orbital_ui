# Update Lucide and caniuse-lite, and use made-up people in docs samples

## What

Update `lucide-static` to 1.70.0 and `caniuse-lite` to its latest release, regenerate `lib/orbital/icons.rb`, rebuild assets, and replace the real person in the docs samples with a made-up one.

## Why

Dependencies must stay at their latest versions. The docs site is public, and a real name, handle and email should not be its sample data.

## Flow

1. Update both packages with Bun.
2. Run `make icons` and diff the icon names. Any icon removed by Lucide must not be used by a component or docs page.
3. Rebuild the gem's assets and compare them with the current build.
4. Replace the samples in `_avatar`, `_popcard`, `blocks` and `themes` with Sam Taylor, `@samtaylor` and `sam@example.com`.
5. Run the full checks and load every docs page.

## Decisions

- **Sam Taylor, not Alex Rivera.** Alex Rivera is already a separate person next to these samples on the `blocks` page.
- **Replacements pass `initials="ST"`.** `Avatar` falls back to an icon when it has no `initials`, so without them the samples would lose their initials.
- **Only the Avatar page keeps `email`.** It documents that attribute. Other pages drop it, because an `example.com` address only produces a failed Gravatar request.
- **The Fallback Chain caption changes.** No sample address has a Gravatar, so the page no longer shows a photo, and the caption says so. To show a photo again, add a Gravatar to a company address and use it in that example.

## Acceptance Criteria

- [ ] `bun outdated` is clean
- [ ] `icons.rb` keeps the Lucide, Feather and Font Awesome notices
- [ ] No icon in use was removed
- [ ] No real person's name, handle or email remains in `test/dummy`
- [ ] Every docs page returns 200
- [ ] `make test`, `make test-rubies` and `make build` pass

## Out of scope

- `author:` lines in `.claude/skills`, which are skill metadata rather than sample data
- Git history
