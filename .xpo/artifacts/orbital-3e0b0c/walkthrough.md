# Walkthrough: move the gem to the repo root and the docs app to `test/dummy`

## What was built and why

Orbital used to be two projects side by side: `orbital/` (the gem) and `demo/` (the docs site), each with its own Gemfile, `package.json`, lockfile and tooling. Consumers had to install from GitHub with a glob, every dependency was declared twice, and the package would have shipped logs, frontend sources and config.

The gem is now at the root and the docs site is a Rails dummy app at `test/dummy`. There is one bundle and one JS package. Packaging, tests, the Makefile and licensing now meet the public gem conventions, ready for a first rubygems.org release. This change does not publish anything.

## How the pieces fit together

**One bundle.** The root `Gemfile` uses `gemspec` for runtime dependencies and lists development tools and the gems the dummy needs. `test/dummy/config/boot.rb` points `BUNDLE_GEMFILE` at the root Gemfile, so the dummy loads the gem directly from the checkout.

**One JS package.** The root `package.json` has `build` for the gem's shipped assets and `build:dummy*` / `watch:dummy:*` for the docs site. `Procfile.dev` runs all of them with the web server. `web` comes first because foreman offsets `PORT` by process position, and this keeps the docs site on its expected port.

**What ships.** `spec.files` is an explicit list: `Dir["{app,lib}/**/*", "LICENSE", "README.md"]`. The package has 74 files. Anything else, including `CHANGELOG.md`, `frontend/` and `test/`, stays in the repo. Check it with `tar -xOf <file>.gem data.tar.gz | tar -tz`.

**Tests.** `test/test_helper.rb` boots a small standalone app, not the dummy. The dummy is pinned to the latest Rails, while the tests also need to run on the Rails floor (`>= 7.1`). The classes use `ActiveSupport::TestCase`, which is Minitest, because the Rails cops in `kuyio-rubocop` require `assert_not_*`. The `Rakefile` excludes `test/dummy` from the test task and does not load `bundler/gem_tasks`, so `make release` stays the only release path.

**The dummy.** `test/dummy/config/application.rb` loads only Active Model, Action Controller and Action View. It has no database, Active Job, Action Cable or Solid gems. Turbo still works, and a production eager load confirms none of those frameworks come back.

**Docker.** The root `Dockerfile` replaces Kamal, which was never in use. It installs gems and JS packages, builds assets, and runs the docs site as a non-root user with a health check on `/up`. Production needs `SECRET_KEY_BASE` in the environment.

## Key decisions

- **Tailwind sources are pinned.** At the root, auto-detection would have scanned `test/dummy` and pulled docs classes into the gem's shipped CSS. `frontend/stylesheets/index.css` now uses `@import "tailwindcss" source(none)` with explicit `@source` lines. `@source` must follow the last `@import`, or Biome rejects it.
- **The shipped CSS got smaller.** It went from 71.65 kB to 68.46 kB by losing 21 stray utility selectors (such as `.absolute` and `.border`) that were matched from words in the source, not from real use. No component uses them and none were added. The `CHANGELOG.md` and README record this, because an app could have relied on them by accident.
- **Credentials are retired, not rewritten.** `master.key` was committed publicly and only protected `secret_key_base`, which nothing else reads. It stays in git history, so treat it as compromised. Rewriting history would not make it private again.
- **`trivy.yaml` is the standard template, unchanged.** It no longer scans npm dev dependencies. `make bun-audit` covers them, at high and critical only.
- **`LICENSE` stays plain MIT.** Third-party notices are in the README and in the `lib/orbital/icons.rb` header. `bin/generate-icons` writes that header, so regenerating the icons keeps it. Lucide's license also requires Feather's MIT text for derived icons, so both are included. All 549 brand icons are Font Awesome Free 7.1.0 (CC BY 4.0).
- **`brakeman` scans the gem and the dummy**, both with `--force`, so the dummy keeps its coverage.
- **Generated dummy builds are untracked.** `jsbundling-rails` and `cssbundling-rails` are gone, because they look for Bun in `Rails.root` and only add precompile hooks. Run `bun run build:dummy`; the `Dockerfile` does this itself.
- **The Rails floor stays at `>= 7.1`.** The tests pass and all 30 component doc partials render on Rails 7.1.6 with Ruby 3.4.12.

## Non-obvious things

- `parcel build` uses `--no-cache`. With the cache, a build after `parcel watch` reports minified sizes but leaves unminified files on disk.
- `ApplicationController` in the dummy sets `protect_from_forgery` explicitly. Brakeman reads the Rails version from a `Gemfile.lock` next to the app, and there isn't one in `test/dummy`, so it no longer credits `load_defaults`.
- The `Dockerfile` precompiles from `WORKDIR /rails/test/dummy`. From the root, `rails` picks up the gem's `Rakefile`, which has no `assets:precompile`. A `RUN cd` also works, but fails Trivy's DS-0013 at the MEDIUM gate.
- Three docs-only RuboCop exceptions use inline disables with reasons. `.rubocop.yml` has no overrides.
- `marcel` and `prism` are one release behind because their parent gems cap them.

## Known limits

- `changelog_uri` returns 404 until `CHANGELOG.md` is at the root on `main` on GitHub.
- Files rewritten too heavily for rename detection show as new, so `git log --follow` won't trace them: `Gemfile`, `Gemfile.lock`, `orbital.gemspec`, `Rakefile`, `.rubocop.yml`, `.dockerignore`, `CHANGELOG.md`, `Procfile.dev` and the compiled CSS.
- The version is still `0.1.0`, which the changelog already lists as released. Decide on a bump before publishing.
- `Dialog.turbo_frame_response` raises `NoMethodError`. Nothing calls it. Tracked separately as `orbital-2b9b13`.

## For consumers

Apps installing from GitHub must drop `glob: "orbital/*.gemspec"` from their Gemfile, because the gemspec is now at the root. `Orbital::Component` has not moved.
