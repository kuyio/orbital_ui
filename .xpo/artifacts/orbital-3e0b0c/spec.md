# Move gem to repo root, demo to test/dummy, and meet the public gem standard

## What

Put the gem at the repo root and the docs app at `test/dummy`, with one bundle and one JS package. Slim the dummy app to what the docs site needs, replace Kamal with a root `Dockerfile`, and bring packaging, tests, tooling, Makefile and licensing up to the public gem standard.

## Why

Orbital is a maintained public gem and is about to get its first rubygems.org release. Today the package would ship logs, frontend sources and config, the gemspec still has TODO placeholders, tests use RSpec, and the two-project layout makes consumers install with a glob and duplicates every dependency and tool.

## Acceptance Criteria

- [ ] `orbital/` contents are at the root and `demo/` is `test/dummy`, moved with `git mv`; renames are detected in the final diff
- [ ] One root `Gemfile` using `gemspec`, one `package.json`, one `bun.lock`; no `path: "../orbital"` or `file:../orbital` remain
- [ ] `.ruby-version` is `4.0.9`, `required_ruby_version` is `>= 3.4`, `RUBIES` is `3.4.12 4.0.9`
- [ ] Rails dependency is `>= 7.1`, verified by running the tests against Rails 7.1 (or raised, with the reason recorded)
- [ ] `spec.files` is explicit; the built package holds only `app/`, `lib/`, `LICENSE` and `README.md`
- [ ] Gemspec has no TODOs and no `bindir`, `executables` or `require_paths`; all URIs exist
- [ ] `LICENSE.txt` renamed to `LICENSE`; `log/development.log` and `sig/` removed; logs ignored; `CHANGELOG.md` stays in the repo
- [ ] Makefile has every core target from `Makefile.lib`, with `release` enabled and Brakeman using `--force`; extras do not change core behaviour
- [ ] `trivy.yaml` is the standard template, unchanged; `make trivy` fails on MEDIUM and above
- [ ] Tests are Minitest; RSpec is gone; `test/dummy` is excluded from the test task
- [ ] `bundler-audit` and `brakeman` are development dependencies; Rakefile does not load `bundler/gem_tasks`
- [ ] `.rubocop.yml` only inherits from `kuyio-rubocop`, and any override has a comment saying why
- [ ] `kuyio-rubocop`, `view_component` and other dependencies are at their latest versions, or the reason for holding back is recorded
- [ ] Lucide ISC and Feather MIT notices are in the package and survive `bin/generate-icons`; Font Awesome attribution comments are kept
- [ ] Dummy app stays on Rails 8.1.4.1, boots without Active Record, and every docs page renders
- [ ] `master.key`, `credentials.yml.enc`, Kamal and its config are gone; a root `Dockerfile` builds the docs site
- [ ] `make test`, `make test-rubies` and `make build` pass, or failures are reported
- [ ] A scan of the repo finds no internal hostnames, repository names, paths or credentials

## Flow

1. Capture the baseline: built gem CSS and JS sizes, and the rendered output of every docs page.
2. `git mv` `orbital/*` to the root and `demo/*` to `test/dummy`, resolving collisions (README, CLAUDE.md, Procfile.dev, `.postcssrc`, `.gitattributes`, lockfiles).
3. Merge `Gemfile`, `package.json`, lockfiles, Makefile, `.gitignore`, `biome.json`, `tsconfig.json`, docs and agent instructions at the root. Point the dummy's `boot.rb` at the root Gemfile.
4. Pin Tailwind sources so the shipped gem CSS does not scan `test/dummy`, and repoint the dummy's `orbital/theme` import. Compare built CSS with the baseline.
5. Slim the dummy: load only the frameworks it uses, and remove the database, Solid gems, jobs, mailers, storage and unused gems and scripts.
6. Remove Kamal and credentials; read `SECRET_KEY_BASE` from the environment in production; add the root `Dockerfile`.
7. Rewrite the gemspec, Rakefile, `.rubocop.yml`, Makefile and `trivy.yaml`; rename `LICENSE`; remove the log and `sig/`.
8. Port the three spec files to Minitest with the same assertions.
9. Add the third-party notices to `bin/generate-icons`, `lib/orbital/icons.rb` and the README.
10. Update dependencies, rebuild assets, run all checks, and compare rendered pages with the baseline.

## Decisions

- **Root `Dockerfile`, no Kamal.** The user confirmed Kamal is not in use. `deploy.yml` was never edited from the generator default.
- **Delete the Rails key and credentials; do not rewrite history.** The key was committed publicly, and it only protected `secret_key_base`, which nothing else reads. Rewriting history would not make it private again, so it is treated as compromised and retired.
- **`trivy.yaml` is the template unchanged.** It no longer sets `include-dev-deps`, so Trivy stops scanning npm dev dependencies. The separate `bun-audit` target covers them, at high and critical.
- **`LICENSE` stays plain MIT.** Third-party notices go in the `icons.rb` header, written by the generator so regeneration keeps them, and in a README section, both of which are in the package.
- **Lucide notice includes Feather's MIT text**, because Lucide's own `LICENSE` requires it for the icons derived from Feather.
- **`brakeman` scans the gem and the dummy, both with `--force`**, so the dummy keeps the coverage it has today.
- **Generated dummy builds are untracked** and built with `bun run build:dummy`. The `jsbundling-rails` and `cssbundling-rails` gems are removed, because they look for Bun in `Rails.root` and only add precompile hooks. The `Dockerfile` runs the build itself.
- **`parcel build` uses `--no-cache`.** With the cache, a build after `parcel watch` reports minified sizes but leaves the unminified files on disk.
- **`protect_from_forgery` is explicit in the dummy's `ApplicationController`.** Brakeman reads the Rails version from a `Gemfile.lock` next to the app, and there isn't one in `test/dummy`, so it no longer credits `load_defaults`.
- **Tests boot a small standalone app, not the dummy,** so they can also run on the Rails floor. The classes use `ActiveSupport::TestCase`, which is Minitest, because the Rails cops require `assert_not_*`.
- **Dummy code follows `kuyio-rubocop`.** Three docs-only exceptions use inline disables with reasons, and `.rubocop.yml` has no overrides.

## Edge Cases

- **HIGH:** Tailwind auto-detection at the root would pull docs classes into the gem's shipped CSS. Pin sources and compare builds.
- **HIGH:** `.xpo/` is committed to this public repo, so the issue text, comments and walkthrough must not name internal infrastructure.
- **MEDIUM:** Turbo must boot without Action Cable and Active Job. Confirm with a production eager-load boot.
- **MEDIUM:** the MEDIUM Trivy gate may surface new findings. Fix them or report them; do not suppress them without a written reason.
- **MEDIUM:** squash merge relies on rename detection to keep `git log --follow` working. Check before merge.
- **LOW:** `kuyio-rubocop` 0.6.0 may flag existing code. Fix it, or add a commented override.

## Assumptions

- Keep Tailwind; replacing it is a separate decision.
- No publishing, tag or `make release` in this issue.
- Nothing is committed or pushed without the user's approval.
