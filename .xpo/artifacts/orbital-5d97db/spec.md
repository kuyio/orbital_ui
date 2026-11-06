# Stack Layout Component — Design Spec

## Overview

Add an `Orbital::Stack` component — a vertical flex container that replaces the ~100 occurrences of `<div class="flex flex-col gap-X">` scattered across the codebase. The component follows existing Orbital conventions: `attribute` DSL for props, `data-*` attributes for styling variants, `Orbital-Stack` CSS class in `@layer components`.

## Files to Create / Modify

| Action | Path                                                                              |
| ------ | --------------------------------------------------------------------------------- |
| Create | `orbital/app/components/orbital/stack.rb`                                         |
| Create | `orbital/frontend/stylesheets/components/stack.css`                               |
| Modify | `orbital/frontend/stylesheets/index.css` — add `@import "./components/stack.css"` |
| Create | `demo/app/views/components/_stack.html.orb`                                       |
| Modify | `demo/app/views/components/index.html.orb` — add gallery card                     |

## Component API

### Props

| Prop       | Type       | Default    | Values                                                                                                                   | Description                                 |
| ---------- | ---------- | ---------- | ------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------- |
| `gap`      | `:string`  | `"4"`      | Tailwind spacing scale: `"0"`, `"0.5"`, `"1"`, `"1.5"`, `"2"`, `"3"`, `"4"`, `"5"`, `"6"`, `"8"`, `"10"`, `"12"`, `"16"` | Spacing between children                    |
| `align`    | `:symbol`  | `:stretch` | `start`, `center`, `end`, `stretch`                                                                                      | Cross-axis alignment (`align-items`)        |
| `justify`  | `:symbol`  | `:start`   | `start`, `center`, `end`, `between`, `around`, `evenly`                                                                  | Main-axis distribution (`justify-content`)  |
| `padding`  | `:string`  | `nil`      | Same scale as `gap`                                                                                                      | Internal padding                            |
| `dividers` | `:boolean` | `false`    | —                                                                                                                        | Render visual separators between each child |

`gap` and `padding` use `:string` (not `:symbol`) because the Tailwind spacing scale includes fractional values like `"0.5"` and `"1.5"` which are not valid Ruby symbols.

All standard HTML attributes (class, id, data-_, aria-_) are forwarded via `**html_attributes`.

### Usage

```html
<!-- Basic stack -->
<Stack gap="4">
  <TextField label="Email" name="email" />
  <TextField label="Password" name="password" />
  <button>Submit</button>
</Stack>

<!-- Tight stack, centered -->
<Stack gap="1" align="center">
  <h3>Title</h3>
  <p>Subtitle</p>
</Stack>

<!-- Push footer to bottom of a full-height container -->
<Stack gap="4" justify="between" class="h-full">
  <div>Main content</div>
  <button>Action</button>
</Stack>

<!-- With dividers between children -->
<Stack gap="4" dividers>
  <CheckBox name="notif_transactions" label="Transaction alerts" checked />
  <CheckBox name="notif_security" label="Security alerts" checked />
</Stack>
```

## Implementation Details

### Ruby Component (`stack.rb`)

```ruby
class Orbital::Stack < Orbital::Component
  attribute :gap, :string, default: "4"
  attribute :align, :symbol, default: :stretch, only: %i[start center end stretch]
  attribute :justify, :symbol, default: :start, only: %i[start center end between around evenly]
  attribute :padding, :string
  attribute :dividers, :boolean, default: false

  private

  def default_attributes
    attrs = super.merge(
      class: "Orbital-Stack",
      "data-gap": @gap,
      "data-align": @align,
      "data-justify": @justify,
      "data-padding": @padding
    )
    attrs["data-dividers"] = "" if @dividers
    attrs
  end
end
```

### Rendering

The component uses a simple `orb_template`:

```ruby
orb_template <<-ORB
  <div **html_attributes>{{content}}</div>
ORB
```

### Divider Strategy

The `dividers` prop uses CSS `divide-y` on the container rather than injecting `Orbital::Separator` elements. This keeps the DOM clean and avoids needing to iterate over children in Ruby:

```css
.Orbital-Stack[data-dividers] {
  @apply divide-y divide-border;
}
```

Children get top-padding equal to the gap (via `> * + *`) instead of relying on `gap` when dividers are active, so the divider line sits between the padding.

**Decision rationale**: CSS-only dividers are simpler, more performant, and consistent with how `divide-y` is already used in the codebase (e.g. notification settings lists). If individual separator styling is needed later, a `divider` slot can be added without breaking the boolean API.

### CSS (`stack.css`)

```css
@layer components {
  .Orbital-Stack {
    @apply flex flex-col;
  }

  /* Gap scale */
  .Orbital-Stack[data-gap="0"] {
    @apply gap-0;
  }
  .Orbital-Stack[data-gap="0.5"] {
    @apply gap-0.5;
  }
  .Orbital-Stack[data-gap="1"] {
    @apply gap-1;
  }
  .Orbital-Stack[data-gap="1.5"] {
    @apply gap-1.5;
  }
  .Orbital-Stack[data-gap="2"] {
    @apply gap-2;
  }
  .Orbital-Stack[data-gap="3"] {
    @apply gap-3;
  }
  .Orbital-Stack[data-gap="4"] {
    @apply gap-4;
  }
  .Orbital-Stack[data-gap="5"] {
    @apply gap-5;
  }
  .Orbital-Stack[data-gap="6"] {
    @apply gap-6;
  }
  .Orbital-Stack[data-gap="8"] {
    @apply gap-8;
  }
  .Orbital-Stack[data-gap="10"] {
    @apply gap-10;
  }
  .Orbital-Stack[data-gap="12"] {
    @apply gap-12;
  }
  .Orbital-Stack[data-gap="16"] {
    @apply gap-16;
  }

  /* Align (cross-axis) */
  .Orbital-Stack[data-align="start"] {
    @apply items-start;
  }
  .Orbital-Stack[data-align="center"] {
    @apply items-center;
  }
  .Orbital-Stack[data-align="end"] {
    @apply items-end;
  }
  .Orbital-Stack[data-align="stretch"] {
    @apply items-stretch;
  }

  /* Justify (main-axis) */
  .Orbital-Stack[data-justify="start"] {
    @apply justify-start;
  }
  .Orbital-Stack[data-justify="center"] {
    @apply justify-center;
  }
  .Orbital-Stack[data-justify="end"] {
    @apply justify-end;
  }
  .Orbital-Stack[data-justify="between"] {
    @apply justify-between;
  }
  .Orbital-Stack[data-justify="around"] {
    @apply justify-around;
  }
  .Orbital-Stack[data-justify="evenly"] {
    @apply justify-evenly;
  }

  /* Padding — same scale as gap */
  .Orbital-Stack[data-padding="1"] {
    @apply p-1;
  }
  .Orbital-Stack[data-padding="2"] {
    @apply p-2;
  }
  .Orbital-Stack[data-padding="3"] {
    @apply p-3;
  }
  .Orbital-Stack[data-padding="4"] {
    @apply p-4;
  }
  .Orbital-Stack[data-padding="6"] {
    @apply p-6;
  }
  .Orbital-Stack[data-padding="8"] {
    @apply p-8;
  }

  /* Dividers */
  .Orbital-Stack[data-dividers] {
    @apply divide-y divide-border;
  }
}
```

## Acceptance Criteria

1. `<Stack gap="4">` renders `<div class="Orbital-Stack" data-gap="4" data-align="stretch" data-justify="start">` with correct spacing
2. `align` prop maps to the correct `items-*` CSS utility
3. `justify` prop maps to the correct `justify-*` CSS utility
4. `padding` prop applies internal padding
5. `dividers` prop renders visible separator lines between children using CSS `divide-y`
6. Extra HTML attributes (class, id, data-_, aria-_) are forwarded and merged
7. Custom classes passed via `class=` are merged with `Orbital-Stack`, not replaced
8. Component is importable and renders without errors in the demo app
9. Demo documentation page exists with examples for all prop combinations
10. Gallery card added to the components index page

## Out of Scope

- Horizontal stack (use a future `HStack` or `direction` prop — separate issue)
- Responsive gap (e.g. `gap="4 md:8"`) — can be added later via the `:breakpoints` type
- Named spacing sizes (e.g. `gap="sm"`) — keep Tailwind numeric scale for now
- Replacing all existing `flex flex-col gap-*` instances — that's a follow-up refactor issue
