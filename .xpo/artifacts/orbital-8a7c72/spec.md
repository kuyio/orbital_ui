# Add a Form component with model binding

## What

```orb
<Form model={@transfer} gap="4">
  <Form:Select name="to" options={accounts}/>
  <Form:TextField name="amount" prefix="$"/>
  <Form:CheckBox name="recurring"/>
  <Form:Submit>Transfer</Form:Submit>
</Form>
```

`<Form>` wraps `form_with`. Each field gets `name`, `id`, `value`, `label` and `error` from the model, unless they're set explicitly. Fields render where they're written, so they work inside layouts such as `Grid`.

## Why

Every field is wired by hand today, and validation errors take the most code. The Fernhill demo avoided showing them for that reason.

## Changes

- `app/components/orbital_ui/form.rb` and `form/builder.rb`, ported from existing MIT-licensed KUY.io code, under the `OrbitalUi` namespace.
- `frontend/stylesheets/components/form.css`: flex column, with a `gap` prop on `Stack`'s scale.
- `Select`: accepts `value` as well as `selected`, and compares values as strings, so a model's integer matches an option.
- `CheckBox` through the form: `checked` comes from the model, and a hidden `0` is sent when unchecked.
- A docs page, README section and tests.
- Fernhill: a `Transfer` model with validations, errors shown in the dialog, and success closing it.

## Acceptance Criteria

- [ ] Values, labels, ids, scoped names and validation errors come from the model, and explicit attributes win
- [ ] Password fields never render their value
- [ ] Fields work nested inside layout components
- [ ] `Form:Select` and `Form:CheckBox` reflect the model
- [ ] Fernhill: an invalid transfer shows errors inside the dialog, and a valid one closes it and updates the page, in a browser
- [ ] `make test`, `make test-rubies` and the Rails 7.1 run pass with no warnings, and every docs path returns 200
- [ ] No internal names are added

## Decisions

- **Rails' `field_name` and `field_id`,** rather than a custom tag helper.
- **No global `field_error_proc` override.** Orbital's fields don't use Rails' tag helpers, and a gem shouldn't change that setting for the whole app.
- **`Select` keeps `selected`.** `value` is an addition, so nothing breaks.
- **Field components are found through `ORB.namespaces`, then `OrbitalUi`,** so an app can override a field.
- **Fernhill closes the dialog with `turbo_stream.refresh`.** A reusable pattern or Turbo components are separate work.

## Out of scope

- Turbo components.
