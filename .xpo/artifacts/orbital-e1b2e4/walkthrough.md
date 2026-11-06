# Walkthrough: document that apps must add Orbital to ORB.namespaces

## What changed and why

Orbital's own templates use bare tags such as `<Icon>` and `<Modal>`, which ORB resolves through `ORB.namespaces`. The gem doesn't add itself to that list, so in an app without the setting, Alert, CheckBox, Dialog, Dropdown, Select and Spinner raise `NameError`, even when rendered from ERB. The docs site sets it in `test/dummy/config/initializers/orb.rb`, which hid the problem.

- `README.md`: the installation steps now require `ORB.namespaces += %w[Orbital]` in an initializer, for every app. The old ORB-only mention in Usage is gone.
- `CHANGELOG.md`: an entry under 0.2.1.

## Key decision

Document it for now, as the maintainer decided. The gem's code is unchanged.

Two alternatives remain open: having the gem add itself to the list, which an app's `ORB.namespaces = [...]` would overwrite, or qualifying the tags in the gem's own templates, which still needs testing against how ORB resolves qualified names.

## Non-obvious things

- Use `+=` rather than `=`, so an app keeps any namespaces already in the list.
- ORB checks namespaces in order. If an app has its own component with the same name in an earlier namespace, Orbital's templates may pick that one up. This comes from reading `lookup_component` and has not been tested.

## Checks

In a new app with a real `config/initializers/orb.rb`, loading the gem at `a69c19e`, 35 of the 37 top-level components render with no arguments. Icon and Image correctly report a missing required attribute. The full `make test` was not rerun, because only documentation changed.

## State at merge

`v0.2.1` is not tagged, so the README's install line names a tag that doesn't exist yet.
