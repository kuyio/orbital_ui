# Walkthrough: update Lucide and caniuse-lite, and use made-up people in docs samples

## What changed and why

Two new package releases put the gem behind the latest-dependencies rule, and the public docs site used a real person's name, handle and email as sample data.

- `package.json` and `bun.lock`: `lucide-static` 1.70.0 and `caniuse-lite` 1.0.30001823.
- `lib/orbital/icons.rb`: regenerated with `make icons`. Lucide added 5 icons and removed none. The generated header keeps the Lucide, Feather and Font Awesome notices.
- Docs samples in `_avatar`, `_popcard`, `components/index`, `blocks` and `themes`: now Sam Taylor, `@samtaylor` and `sam@example.com`.

The gem's built CSS and JS are byte-identical to the previous build, so only `icons.rb` changes in the package.

## Key decisions

- **Sam Taylor, not Alex Rivera.** Alex Rivera is already a separate person beside these samples on the `blocks` page, so reusing the name would have shown duplicates.
- **`initials="ST"` on replacements that passed an email.** `Avatar` shows a Gravatar image if `email` has one, then `initials`, then the default icon. Without `initials`, those samples would have fallen through to the icon. The Recent Activity row on `blocks` had no email and keeps its icon, like the rows around it.
- **Only the Avatar page keeps `email`.** It documents that attribute. Elsewhere an `example.com` address would only cause a failed Gravatar request in the browser.

## Non-obvious things

- The Avatar page used to show a real photo, supplied by the old address. No sample address has a Gravatar now, so the page shows only initials and the default icon, and the Fallback Chain caption says so. To show a photo again, add a Gravatar to a company address and use it in that example.
- Search for the bare first name as well as the full name when checking samples. `components/index` and the `blocks` activity row used it alone.

## Checks

`make test`, `make test-rubies`, `make build`, `lint-js`, `typecheck` and `bun-audit` pass, and `bun outdated` is clean. The package still has 74 files. All 41 docs paths return 200 with no server errors. The pages were not checked by eye.

## Known limits

- `author:` lines in `.claude/skills` and git history still carry the old name. Both were out of scope.
