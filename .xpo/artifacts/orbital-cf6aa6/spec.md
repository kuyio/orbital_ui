# Add a src prop to Image, mutually exclusive with asset

## What

`OrbitalUi::Image` accepts `src`, which is used as given, as well as `asset`, which goes through `asset_path`. An `Image` takes exactly one of them.

## Why

`Image` couldn't show external or user-uploaded images, so apps had to drop to a plain `<img>` and lose the component's defaults.

## How

- `asset` is no longer a `required` attribute, because the attribute system can only require a single attribute.
- `initialize` raises `ArgumentError` unless exactly one of the two is present, with a message that names both.
- `call` uses `@src` as given, or `asset_path(@asset)`.

## Acceptance Criteria

- [ ] `src` renders that URL unchanged, and `asset` still resolves through `asset_path`
- [ ] Passing both raises `ArgumentError`
- [ ] Passing neither raises `ArgumentError`
- [ ] A blank value counts as not passed
- [ ] The docs page and README describe both, including that they are mutually exclusive
- [ ] `make test` and `make test-rubies` pass, and every docs path returns 200

## Decisions

- **Raise at construction,** matching how required attributes already fail.
- **Blank counts as missing,** so `src={record.photo_url}` with an empty value fails clearly rather than rendering a broken image.
- **`src` is not sanitized beyond normal attribute escaping,** matching a plain `<img>`. Apps are responsible for the URLs they pass.
