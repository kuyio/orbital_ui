# Document that apps must add Orbital to ORB.namespaces

## What

Make `ORB.namespaces += %w[Orbital]` a required setup step in the README, for every app that uses Orbital components.

## Why

Orbital's own templates use bare tags such as `<Icon>`, which ORB resolves through `ORB.namespaces`. Without the setting, Alert, CheckBox, Dialog, Dropdown, Select and Spinner raise `NameError`, including when rendered from ERB. The README only mentioned the setting for apps writing ORB templates.

## Decision

Document it for now, as the maintainer decided. The gem does not add itself to the list, and its tags stay unqualified. If an app has its own component with the same name in an earlier namespace, Orbital's templates may pick that one up; this is unverified and not addressed here.

## Acceptance Criteria

- [ ] The README's installation steps include the initializer, and say that every app needs it
- [ ] Following those steps in a new app, all components render, apart from those missing required attributes
- [ ] `CHANGELOG.md` records it under 0.2.1, which is not yet tagged

## Out of scope

- Code changes to the gem or its templates
