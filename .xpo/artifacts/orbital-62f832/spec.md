# Make Orbital work with `rails new -j bun -c tailwind` and `-c sass`

## What

An app created with `rails new -j bun -c tailwind` or `-c sass` gets a working Orbital by running the install generator. `-c tailwind` is the expected common path. Orbital is a full UI kit, so its stylesheet includes Tailwind's reset, and the docs say so.

## Changes

- `frontend/stylesheets/components/expander.css`: move into `@layer components`, so app utilities can override it.
- `app/assets/stylesheets/orbital_ui/theme.css`: add `@custom-variant dark (&:where(.dark, .dark *));`, so an app's `dark:` utilities follow Orbital's `.dark` class.
- `lib/generators/orbital_ui/install/install_generator.rb`: new, `bin/rails generate orbital_ui:install`.
- `README.md`, `theming/` and the themes docs page: use the generator and working paths. Drop `tailwindcss-rails`, the Node package route, and the claim that Orbital only styles its components.
- `app/components/orbital_ui/accordion/item.rb`: the trigger's content fills its width.
- `app/components/orbital_ui/text_field.rb` and `frontend/stylesheets/components/text-field.css`: fixes from `orbital-abfab4`, and a themed placeholder colour.
- `CHANGELOG.md`: an Unreleased section.

## The generator

1. `config/initializers/orb.rb`: creates it with `ORB.namespaces += %w[OrbitalUi]`, or appends that line to an existing file that lacks it.
2. `app/assets/stylesheets/orbital_ui.tailwind.css`: when the app has `app/assets/stylesheets/application.tailwind.css`, writes the Tailwind integration from the gem's `theme.css`, and adds `@import "./orbital_ui.tailwind.css";` after the `tailwindcss` import. Other apps, such as `-c sass`, need nothing here, and are told so without it reading as a problem.
3. `app/views/layouts/application.html.erb`: adds Orbital's stylesheet before the app's first stylesheet tag, its JavaScript tag, and a `dialogs` Turbo Frame inside `<body>`. If it can't place the tags, it prints them.
4. In a Tailwind app, changes `stylesheet_link_tag :app` to `"application"`, because `:app` links the raw Tailwind sources, whose imports fail in the browser.

Running it again is safe. It refreshes the theme file and adds nothing twice.

## Acceptance Criteria

- [ ] `rails new -j bun -c tailwind` plus the generator: a real app built from Orbital components works under `bin/dev`, including interactive components, a server-loaded dialog, `bg-primary`, `dark:` following `.dark`, and utilities overriding components, with no browser errors
- [ ] `rails new -j bun -c sass` plus the generator: components render and are interactive, and `:root` overrides in the app's stylesheet apply
- [ ] The generator is covered by tests: a Tailwind app, a Sass app, a re-run, an existing initializer, an existing dialog frame, and no layout file
- [ ] Nothing in the repo's docs or code mentions `tailwindcss-rails`
- [ ] The package's only new file is the generator
- [ ] `make test` and `make test-rubies` pass with no warnings, and every docs path returns 200

## Decisions

- **Orbital keeps Tailwind's reset.** It's a full UI kit, so its stylesheet affects the whole app, including with `-c sass`.
- **Only `cssbundling-rails`' Tailwind path is supported by the generator.** `tailwindcss-rails` is dropped, along with the engine approach.
- **The generator reads `theme.css` when it runs,** so the repo holds no second copy.
- **Only the Tailwind integration is copied, not the colour values.** They stay in the gem's stylesheet, so upgrades still bring new colours. A new theme token needs a re-run to work as a utility.
- **The dialog frame is a plain `<turbo-frame>` tag,** so the layout still renders in an app without `turbo-rails`.
- **No version bump or release.** This goes under Unreleased until the maintainer cuts a release.
- **Theme overrides stay outside `@layer`.** This is documented rather than changed, because moving the variables into a layer would change how existing overrides behave.
