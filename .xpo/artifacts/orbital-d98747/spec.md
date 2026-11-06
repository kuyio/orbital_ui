# Add the Fernhill demo app under demos/fernhill

## What

Move Fernhill, the fictional finance app, into the repo at `demos/fernhill`, depending on the gem with `path: "../.."`. Add `make demo` to install and run it, a short README, and a link from the main README.

## Why

It shows the components working together in a real app, which `test/dummy` doesn't, and it runs the current code, so it can catch problems the render tests can't. It found real bugs when it was first built.

## Acceptance Criteria

- [ ] `make demo` works from a fresh clone and serves the app
- [ ] It has no `master.key`, `credentials.yml.enc`, absolute paths, logs, build output or `node_modules` in git
- [ ] It's excluded from the published gem: the package still has 75 files
- [ ] `make test`, `make test-rubies` and `make build` still pass, and an advisory in the demo's dependencies doesn't need a gem release to be held back
- [ ] The gem's shipped CSS and JS don't change
- [ ] The app works in a browser, as it did before the move
- [ ] A scan finds no internal names or secrets

## Decisions

- **`test/dummy` stays.** It documents every component. Fernhill shows them together.
- **Its workarounds stay,** such as the `Tooltip` classes and hand-built table, and go as the follow-up issues are fixed.
- **`make demo` is an extra target.** Core targets don't change, as the standard requires.
- **`trivy.yaml` stays the standard template.**

## Unknown

How the root's RuboCop, Trivy, Brakeman, Biome and Docker builds treat a second app. Find out by running them, and record what was done here.

## Out of scope

- Releasing, and any change to the gem's code.
