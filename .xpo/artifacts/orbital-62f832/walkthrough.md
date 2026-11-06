# Walkthrough: make Orbital work with `rails new -j bun -c tailwind` and `-c sass`

## What was built and why

Testing an app with its own Tailwind next to the gem found gaps, and walking through a real `rails new` found more. A new app now gets a working Orbital from one generator, with `-c tailwind` as the expected path and `-c sass` also supported.

```bash
rails new myapp -j bun -c tailwind
bundle add orbital_ui
bin/rails generate orbital_ui:install
```

## How the pieces fit together

`lib/generators/orbital_ui/install/install_generator.rb` does the setup, and running it again is safe:

1. `config/initializers/orb.rb` gets `ORB.namespaces += %w[OrbitalUi]`, created or appended.
2. In a Tailwind app, `app/assets/stylesheets/orbital_ui.tailwind.css` is written from the gem's `theme.css`, and imported after `tailwindcss` in `application.tailwind.css`.
3. The layout gets Orbital's stylesheet and JavaScript before the app's first stylesheet, and a `dialogs` Turbo Frame inside `<body>`. If it can't place the tags, it prints them.
4. In a Tailwind app, `stylesheet_link_tag :app` becomes `"application"`.

In the gem:

- `theme.css` adds `@custom-variant dark (&:where(.dark, .dark *));`, so an app's `dark:` utilities follow Orbital's `.dark` class instead of the OS setting.
- `Expander`'s CSS moved into `@layer components`. It was the only unlayered component, so app utilities couldn't override it.
- `Accordion`'s trigger content now fills its width.
- `TextField` placeholders use a theme colour. See `orbital-abfab4` for its other fixes, made in the same change.

The README, `theming/` and the themes docs page now use the generator and paths that resolve from an installed gem.

## Key decisions

- **The maintainer dropped `tailwindcss-rails`.** An earlier version used its experimental engine support, with a path into `builds/`. The generator now only looks for `application.tailwind.css`, the file `-c tailwind` creates.
- **Orbital keeps Tailwind's reset.** It's a full UI kit, so its stylesheet affects the whole app, including `-c sass`. The docs no longer claim it only styles its components.
- **The generator reads `theme.css` when it runs,** so the repo holds no second copy. It only copies the Tailwind integration. Colour values stay in the gem's stylesheet, so upgrades bring new colours, but a new theme token needs a re-run to work as a utility.
- **The dialog frame is a plain `<turbo-frame>`,** so the layout still renders in an app without `turbo-rails`.
- **Theme overrides stay outside `@layer`.** Orbital's variables aren't in a layer, so a layered override loses. Changing that could change how existing overrides behave, so it's documented instead.

## Non-obvious things

- `stylesheet_link_tag :app` links every file in `app/assets`, including the raw Tailwind sources. Their `@import`s then fail in the browser, which is why the generator replaces it. The Rails comment above that tag is removed too, since it would no longer be true.
- `-c` only accepts `tailwind`, `bootstrap`, `bulma`, `postcss` or `sass`.
- `bin/dev` needs a terminal. Tailwind's `--watch` exits when stdin closes, and foreman then stops everything.
- On a plain HTML tag, a bound attribute renders nil as an empty string, so generated markup here avoids that.

## Checks

A fictional finance app, built with only the documented steps and run under `bin/dev`, was exercised in a browser: components, Stimulus, a server-loaded dialog that changes the page, dark mode, a brand colour override, and a narrow window, with no console errors. That is what found the `TextField`, `Accordion` and placeholder bugs and the generator's gaps.

`make test` and `make test-rubies` pass with 139 tests and no warnings, and the same tests pass on Rails 7.1. All 41 docs paths return 200. The package has 75 files, and the generator is the only new one.

## Known limits

- The `-c sass` browser check ran before the last few fixes, and didn't cover a dialog.
- Rough edges from that app are filed as follow-ups: `orbital-4ca9ca`, `orbital-8a965f`, `orbital-0de15d`, `orbital-eb84b2` and `orbital-89e408`, with notes on `orbital-8c907e`.
