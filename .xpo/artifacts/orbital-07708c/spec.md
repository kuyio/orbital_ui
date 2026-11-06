# Update dependencies, including orb_template 0.3.0

## What

Set a new baseline for the repo: Ruby floor 3.4.8, development Ruby 4.0.9, Rails 8.1.4.1 and `orb_template` 0.3.0. Refresh the other gems and npm packages in `orbital/` and `demo/` within minor and patch versions, and regenerate the Lucide icons.

## Why

The user asked for it. `orbital/orbital.gemspec` pins `orb_template` to `~> 0.2.5`, which excludes 0.3.0, so a plain `bundle update` cannot pick it up.

## orb_template 0.3.0 impact

From the gem's changelog:

- **Breaking:** requires Ruby 3.4 or newer. The new baseline satisfies this.
- `ORB.html_escape` delegates to `Temple::Utils.escape_html`, and `cgi/util` is no longer loaded, which removes the load warning on Ruby 4.0. Neither `orbital/` nor `demo/` calls `ORB.html_escape` directly or requires `cgi/util` in `app`, `lib` or `config`. Escaped output in rendered templates is still worth checking.
- `ORB::VERSION` is now defined after `require "orb"`. No code change needed.

## Acceptance Criteria

- [ ] `orbital/Gemfile.lock` and `demo/Gemfile.lock` resolve `orb_template` to 0.3.0 and Rails to 8.1.4.1
- [ ] `orbital.gemspec` declares `orb_template ~> 0.3.0`, `required_ruby_version >= 3.4.8` and `rails >= 8.1.4.1`
- [ ] `demo/Gemfile` requires Rails 8.1.4.1 or newer within 8.1
- [ ] `demo/.ruby-version` is 4.0.9 and `demo/Dockerfile` `RUBY_VERSION` is 4.0.9
- [ ] Other gems and npm packages are updated to the newest minor or patch version; no new major versions
- [ ] `orbital/lib/orbital/icons.rb` is regenerated from the installed `lucide-static`, and every icon used by components and the demo still exists
- [ ] Trivy with dev dependencies and `bun audit` report no remaining `picomatch`, `yaml`, `browserslist` or `immutable` findings in `orbital/` or `demo/`
- [ ] `make build` and `make test` pass on Ruby 4.0.9 (RSpec, demo tests, RuboCop, Biome, tsc), or any failure is reported with its output
- [ ] `orbital/` RSpec also passes on the 3.4.8 floor
- [ ] Demo app boots on 4.0.9 and component pages render correctly in a browser

## Flow

1. Edit `orbital/orbital.gemspec`, `demo/Gemfile`, `demo/.ruby-version` and `demo/Dockerfile` for the baseline.
2. Update gems with `bundle update --minor` in `orbital/`, then `demo/` (`demo` depends on `orbital` by path, so its lockfile picks up the new pins).
3. Update npm packages with `bun update` in `orbital/` and `demo/`.
4. Regenerate icons with `bun run generate:icons` in `orbital/`, and check the icon names in use against the new set.
5. Run `make build` and `make test` on 4.0.9, then `orbital/` RSpec on 3.4.8. Compare any new lint offences against the pre-update state.
6. Run the demo app and check component pages, including escaping of dynamic content.

## Decisions

- **Minor and patch only (user decision):** major versions such as `puma` 8, `solid_cable` 4, `minitest` 6, `net-ssh` 8, `marcel` 2, `prism` 2, `json` 3, `rdoc` 8, `typescript` 7 and `postcss-cli` 12 are held back and listed in a follow-up issue. If Ruby 4.0.9 needs one of them, that one is taken and noted in the completion comment.
- **Regenerate Lucide icons (user decision):** keeps `icons.rb` and its version header in step with the installed `lucide-static`.
- **Ruby baseline (user decision):** `required_ruby_version` is 3.4.8 and `.ruby-version` is 4.0.9. Library consumers can stay on 3.4.8, while development and the demo run on 4.0.9.
- **Rails baseline (user decision):** 8.1.4.1. The gemspec uses `>= 8.1.4.1`, keeping its open-ended style. `demo/Gemfile` uses `"~> 8.1.4", ">= 8.1.4.1"`, keeping the demo on the 8.1 series.
- **`demo/Dockerfile` moves to 4.0.9 with `.ruby-version`:** otherwise the image would run a different Ruby from development (it is 3.4.7 today, which is below the new floor).
- **`~> 0.3.0`, not `>= 0.3`:** keeps the existing pin style. Pre-1.0 minor releases of this gem can break, as 0.3.0 does.
- **Fix the 8 new RuboCop offences in code, not config:** the minor bump of `rubocop` enabled new cops. Five are autocorrected, and two (`text.rb`, `progress_bar.rb`) are small hand edits with no change in rendered output.
- **Fix the icon generator, not `icons.rb`:** two offences already on `main` come from `bin/generate-icons`, so autocorrecting the output would not survive regeneration. Tracked in orbital-fd975f.
- **Refresh indirect npm packages by regenerating `bun.lock` (user decision):** `bun update` moved only direct dependencies, leaving known-vulnerable indirect versions of `picomatch`, `yaml`, `browserslist` and `immutable` locked. `package.json` ranges stay as they are. No overrides or ignore rules: if a parent package blocks a fix, stop and ask.
- **Commit `make build` output:** the tracked `orbital/app/assets` bundles were unminified watch builds, so the production build replaces them with minified files. This accounts for most of the diff's deletions.

## Edge Cases

- **MEDIUM:** Ruby 4.0 removes or moves some default gems, so a locked gem can fail to load or build. This is handled as described under the minor-and-patch decision.
- **MEDIUM:** a Lucide icon renamed or removed since 1.27.0 would break any reference to it. References are updated to the new name, and the rename is noted in the completion comment, since consumers of the gem see it too.
- **MEDIUM:** a rubocop bump can add offences without any behaviour change. Mechanical fixes are in scope. If there are many, stop and ask rather than reformat broadly.
- **MEDIUM:** a failure caused by a specific dependency bump gets that one dependency held back, recorded in the completion comment, and filed as a linked issue.
- **LOW:** `kuyio-rubocop` is a git-sourced gem, so its locked revision can move on update.

## Assumptions

- Only `demo/` has a `.ruby-version`, so that is the file that changes. `orbital/` gets none and is run on 4.0.9 explicitly for verification.
- Compiled assets are rebuilt only as far as the existing build requires. They are committed only if they are already tracked and change.
