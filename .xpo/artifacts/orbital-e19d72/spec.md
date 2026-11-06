# Change LICENSE copyright holder and gemspec author to KUY.io Inc.

## What

Change the copyright line in `LICENSE` to `Copyright (c) 2025 KUY.io Inc.`, and set the gemspec's `authors` to `KUY.io Inc.` and `email` to `dev@kuy.io`.

## Why

The gem is maintained by KUY.io Inc., and `package.json` already names the company as author, with `dev@kuy.io` as its address. `LICENSE` and the gemspec have named an individual since the initial checkin. Both reach the public: `LICENSE` ships in the gem, and `authors` shows on the rubygems.org page.

## How

Edit the `LICENSE` line and the two gemspec fields. Keep the year, because 2025 is when the work was first published. Add a `CHANGELOG.md` entry under Unreleased.

## Acceptance Criteria

- [ ] `LICENSE` names KUY.io Inc., with the MIT text otherwise unchanged
- [ ] Gemspec `authors` is `["KUY.io Inc."]` and `email` is `["dev@kuy.io"]`
- [ ] `make build` still packages `LICENSE`, and the built gem's metadata has the new values

## Out of scope

- Git history, including the earlier `LICENSE` revisions
- Sample names in the docs site
