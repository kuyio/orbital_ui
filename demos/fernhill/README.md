# Fernhill

A demo of [Orbital](../../README.md): a personal finance dashboard for a made-up company, built with Orbital components and ORB templates in a standard `rails new -j bun -c tailwind` app.

All the data is fictional, and it has no database. It's a demo of the UI rather than a pattern for handling money.

## Run it

From the repo root:

```bash
make demo
```

Then open http://localhost:3000. You'll need Ruby and [Bun](https://bun.sh/).

## What to look at

- `app/views/dashboard/show.html.orb`: the main page, using Orbital's components with Tailwind utilities for layout.
- `app/views/transfers/new.html.orb`: a dialog loaded from the server into a Turbo Frame.
- `app/views/shared/_nav.html.orb`: a responsive navigation bar.
- `app/assets/stylesheets/application.tailwind.css`: Orbital's theme import and a brand color override.
- `app/javascript/controllers/`: the app's own Stimulus controllers, working alongside Orbital's.

## How it was set up

```bash
rails new fernhill -j bun -c tailwind
bundle add orbital_ui
bin/rails generate orbital_ui:install
```

Its `Gemfile` points at this repo with `path: "../.."`, so it runs the current code. In your own app, use `gem "orbital_ui"`.
