# Walkthrough: add a src prop to Image, mutually exclusive with asset

## What changed and why

`Image` only accepted `asset`, so it couldn't show external or user-uploaded images.

- `app/components/orbital_ui/image.rb`: adds `src`, used as given. `asset` still goes through `asset_path`. `initialize` raises `ArgumentError` unless exactly one of them is present.
- `test/components/orbital_ui/image_test.rb`: covers `src`, `asset`, both, neither and blank values.
- `test/dummy/app/views/components/_image.html.orb`: a "From a URL" example, an updated API table, and no more advice to use a plain `<img>` for URLs.
- `README.md` and `CHANGELOG.md`: updated.

## Key decisions

- **`asset` is no longer a `required` attribute.** The attribute system can only require a single attribute, so the either-or rule lives in `initialize`, after `super` has assigned both values.
- **It raises when the component is created,** the same time required attributes fail.
- **Blank counts as not passed,** so an empty `src={record.photo_url}` fails clearly rather than rendering a broken image.
- **`src` gets normal attribute escaping only,** the same as a plain `<img>`. Apps are responsible for the URLs they pass.

## Non-obvious things

- The tests' standalone app has no asset pipeline, so `asset_path("logo.svg")` returns `/logo.svg` there. The fingerprinted URL only appears in an app with a pipeline, such as the docs site.

## Checks

`make test` and `make test-rubies` pass with 30 tests, and the same tests pass on Rails 7.1. The package has 74 files. All 41 docs paths return 200. In the docs site's HTML, `src="/icon.png"` comes through unchanged and `asset` images get fingerprinted URLs. The page was not checked in a browser.
