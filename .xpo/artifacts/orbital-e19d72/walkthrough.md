# Walkthrough: name KUY.io Inc. in LICENSE and the gemspec

## What changed and why

`LICENSE` and the gemspec had named an individual since the initial checkin, while `package.json` already named the company. All three now agree.

- `LICENSE`: `Copyright (c) 2025 KUY.io Inc.` The MIT text is otherwise unchanged.
- `orbital.gemspec`: `authors` is `["KUY.io Inc."]` and `email` is `["dev@kuy.io"]`.
- `CHANGELOG.md`: an entry under Unreleased.

## Decisions

- **The year stays 2025**, because that is when the work was first published.
- **History is not rewritten.** Earlier `LICENSE` revisions keep the old name, and copies obtained under them keep those terms.
- **Sample names in the docs site are unchanged.** They are demo data and do not affect the package.

## Checks

A built gem has the new values in its metadata and its `LICENSE`, and still holds 74 files. `Gemfile.lock` did not change. The full `make test` was not rerun, because only metadata and text changed.
