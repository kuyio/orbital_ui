# Walkthrough: security stack

## What was built and why

`make security` runs Trivy, `bundle-audit`, `bun audit` and Brakeman across `orbital/` and `demo/`, and `make test` now includes it. `make test-rubies` runs `orbital/` RSpec on each supported Ruby (3.4.8 and 4.0.9).

The setup follows `orb_template`'s Makefile and `trivy.yaml`. It was prompted by orbital-07708c, where a manual Trivy run found high-severity npm advisories that no `make` target would have caught.

## How the pieces fit together

| Target | Scans | Fails on |
|---|---|---|
| `trivy` | whole repo: lockfiles, secrets, misconfigurations | HIGH, CRITICAL |
| `audit` | both `Gemfile.lock` files | any advisory |
| `bun-audit` | both `bun.lock` files | high, critical |
| `brakeman` | `demo/`, then the gem | any warning |

`trivy` makes two passes: the first reports lower severities without failing, the second enforces the gate from `trivy.yaml`. That's why the LOW `DS-0026` (no Dockerfile `HEALTHCHECK`) appears in the output without failing the build.

## Where this differs from orb_template, and why

- **`pkg.include-dev-deps: true`:** Trivy skips dev dependencies by default. Parcel and Sass are dev dependencies here, and with the default, 7 real findings in `orbital/` were reported as 0.
- **`bun audit` added:** Trivy doesn't report packages nested in `bun.lock`, such as `anymatch/picomatch`. `bun audit` does.
- **Brakeman runs twice:** the gem isn't a Rails app, so it needs `--force`. It runs from the demo bundle because the gem's Gemfile doesn't include Brakeman.
- **`test-rubies` covers `orbital/` only:** `demo/` pins its Ruby in `.ruby-version` and has no tests.

## Non-obvious limits

- **Brakeman does not parse `.orb` templates.** A planted `raw(params[...])` was caught in `.erb` and missed in `.orb`. It was also missed in a component class, while a command injection in the same kind of class was caught. A clean Brakeman result therefore says little about XSS in views and components, which is most of this library. The `Makefile` records this, and nothing closes the gap yet.
- **Moderate npm findings don't fail the build, and `bun audit` hides them** because of `--audit-level=high`. Trivy's report-only pass lists them, except nested `bun.lock` entries, so a moderate finding in a nested package appears in neither.
- **`make test` now needs `trivy` installed and network access**, because `audit` and `trivy` update their databases. It fails offline.

## How it was verified

Each gate was shown to fail on a planted issue, then pass after removal:

- A vulnerable dev dependency (`picomatch` 2.3.1) failed `make trivy`, `make bun-audit` and `make security`. This also confirms `include-dev-deps` is honoured from the config file.
- A command injection in a gem component failed `make brakeman`.
- `bundle-audit` run directly failed on the pre-update `demo/Gemfile.lock` (245 advisories). `make audit` itself wasn't run against a vulnerable lockfile.
- A moderate-only finding (`yaml` 2.8.1) passed `make bun-audit` and `make trivy`, as intended.
- `make test-rubies RUBIES=9.9.9` failed with a clear message.

On the clean tree, `make security`, `make test` and `make test-rubies` all pass.
