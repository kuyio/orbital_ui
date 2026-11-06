# Walkthrough: add a Form component with model binding

## What was built and why

Every field in a form was wired by hand: `name`, `value`, `label` and `error`. `<Form>` wraps `form_with`, and fields written as `<Form:TextField name="email"/>` fill those in from the model.

```orb
<Form model={@transfer}>
  <Form:Select name="to" options={accounts}/>
  <Form:TextField name="amount" prefix="$"/>
  <Form:Submit>Transfer</Form:Submit>
</Form>
```

## How the pieces fit together

- `app/components/orbital_ui/form.rb`: renders `form_with`. Any `with_*` call goes to the builder through `method_missing`.
- `app/components/orbital_ui/form/builder.rb`: `OrbitalUi::Form::Builder`, a Rails form builder. `with_text_field` becomes `TextField`, found through `ORB.namespaces` and then `OrbitalUi`, so an app can override a field.
- `Form:TextField` is not a real ViewComponent slot. ORB compiles it to `with_text_field`, and the builder renders it immediately into the template, so fields stay where they're written and work inside `Grid`.
- `frontend/stylesheets/components/form.css`: a flex column with a `gap` prop on `Stack`'s scale.

## Key decisions

- **Ported from existing MIT-licensed KUY.io code, under the `OrbitalUi` namespace.** It can be consolidated later. Compared with the original, it uses Rails' `field_name` and `field_id`, drops the per-form `namespace` option, adds `gap`, and doesn't set a default `name` on the submit button.
- **No global `field_error_proc` override.** Orbital's fields don't use Rails' tag helpers, and a gem shouldn't change that setting for the whole app.
- **`Select` keeps `selected`.** `value` is an addition, because the builder passes `value`. Options are compared as strings, so a model's integer matches.
- **`Form:CheckBox` has its own method.** Orbital's `value` is the HTML value, so the model's value becomes `checked`, and a hidden `0` is sent so unchecking updates the model.
- **Explicit attributes win,** except that `name` is always scoped when there's a model.
- **Turbo components were left out,** by the maintainer's decision.

## Non-obvious things

- A form inside a dialog's Turbo Frame shouldn't use `turbo_frame: "_top"`, because a 422 would then replace the page. Fernhill keeps the form in the frame, renders errors there, and answers success with `turbo_stream.refresh`, keeping the flash for that next request. RuboCop's flash rule is wrong for that case, so it has an inline exception with the reason.
- Tests rendering a form need a request for the CSRF token, so `test_helper.rb` has `request_view_context`. A helper named `test_*` would run as a test.
- `with_hidden_field` accepts and ignores a block, because ORB passes one, and Ruby warns otherwise. The warnings guard caught this.

## Checks

Fernhill's dialog was exercised in a browser: invalid transfers show errors in place with values kept and the page unchanged, and a valid one closes the dialog and updates the page.

`make test` and `make test-rubies` pass with 152 tests and no warnings, and the same tests pass on Rails 7.1. All 42 docs paths return 200. The package has 77 files, with the two form files new. A scan of the changed files found no internal names.

## Known limits

- The submit button in Fernhill's dialog footer is outside the form, so it still needs a matching `form` attribute and `id`.
- `turbo_stream.refresh` is written in Fernhill, not offered by the gem.
