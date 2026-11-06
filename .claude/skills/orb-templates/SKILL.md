---
name: orb-templates
description: "ORB template syntax for Ruby ViewComponents — use when writing or editing .html.orb files"
metadata:
  author: nicbet
  version: "1.0"
---

# ORB Template Language

ORB is a JSX-inspired template language for Ruby ViewComponents. Files use the `.html.orb` extension. **Never use ERB syntax (`<%= %>`, `<% %>`) in ORB files.**

## Expressions

**Print (HTML-escaped)** — double curly braces:

```orb
<span>{{user.name}}</span>
<span>{{@instance_var}}</span>
<span>{{helper_method}}</span>
```

**Non-printing (assignment)** — percent signs:

```orb
{% user = current_user %}
<span>{{user.name}}</span>
```

## Dynamic Attributes

Single curly braces for attribute values:

```orb
<div id={dom_id(record)} class={css_classes}>
  {{content}}
</div>
```

## Attribute Splatting

```orb
<div **html_attributes>{{content}}</div>
<div **{dynamic_attributes(member)}>{{content}}</div>
```

## Conditionals

**Directive form** (on the element):

```orb
<div :if={user.admin?}>Admin only</div>
```

**Block form**:

```orb
{#if user.admin?}
  <div>Admin only</div>
{/if}
```

> Note: `{#else}`, `{#elsif}`, `{#unless}` are NOT yet supported. Use the `:if` directive or `{#if}` with separate blocks for each branch.

## Loops

**Directive form**:

```orb
<li :for="item in @items">{{item.name}}</li>
```

**Block form**:

```orb
{#for item in @items}
  <li>{{item.name}}</li>
{/for}
```

## Combining Directives

Evaluation order: `:for` > `:if` > `:unwrap` (fixed, regardless of attribute order).

```orb
<li :for="item in @items" :if={item.visible?}>{{item.name}}</li>
```

## The `:unwrap` Directive

Conditionally strip the wrapper element, keeping children:

```orb
<Tooltip description="Info" :unwrap={!@needs_tooltip}>
  <Button>Click</Button>
</Tooltip>
```

- `:unwrap` truthy → only `<Button>Click</Button>` renders
- `:unwrap` falsy → full `<Tooltip>` wrapping `<Button>` renders

## Components

Render ViewComponents as HTML tags. The `Component` suffix is omitted:

```orb
<Button url="/action" variant="primary">Click me</Button>
<Card title="Hello">Card content</Card>
```

Self-closing:

```orb
<Separator/>
<Icon name="star" size="md"/>
```

## Slots

Use `Component:SlotName` syntax:

```orb
<Card>
  <Card:Header>
    <Card:Title>My Title</Card:Title>
    <Card:Description>Details here</Card:Description>
  </Card:Header>
  Content
  <Card:Footer>Footer</Card:Footer>
</Card>
```

Slots are scoped to their **immediate parent** component tag — use the parent's tag name, not the full ancestry:

```orb
<Accordion>
  <Accordion:Item value="item-1">
    <Item:Trigger>Click to expand</Item:Trigger>
    Expanded content here
  </Accordion:Item>
</Accordion>
```

Another example — Dropdown's trigger slot:

```orb
<Dropdown>
  <Dropdown:Trigger>
    <Button variant="ghost">Custom trigger</Button>
  </Dropdown:Trigger>
  <Menu><Menu:Item>Action</Menu:Item></Menu>
</Dropdown>
```

**Do NOT use `<:slot_name>` syntax** — there is no anonymous slot syntax in ORB. Always use `<Component:Slot>`.

## Namespaces

Dot notation for sub-namespaces:

```orb
<Admin.Button url="/admin">Admin</Admin.Button>
```

Configure in `config/initializers/orb.rb`:

```ruby
ORB.namespaces = ['MyComponents', 'ThirdParty::UI']
```

## Comments

**Public** (sent to browser):

```orb
<!-- Visible in page source -->
```

**Private** (stripped during render):

```orb
{!-- Not sent to browser --}
```

## Rendering Partials / Sub-templates

ORB does not have a special partial syntax. Use the `{{render ...}}` expression to call Rails' `render` helper:

```orb
{{render "components/button"}}
{{render partial: "shared/footer", locals: { year: 2025 }}}
```

## Inline Component Templates

Define templates inside Ruby component classes:

```ruby
class MyComponent < ViewComponent::Base
  orb_template <<~'ORB'
    <div **html_attributes>{{content}}</div>
  ORB
end
```

## Key Differences from ERB

| ERB                                         | ORB                                                  |
| ------------------------------------------- | ---------------------------------------------------- |
| `<%= expression %>`                         | `{{expression}}`                                     |
| `<% code %>`                                | `{% code %}`                                         |
| `<%= render Component.new(x: 1) %>`         | `<Component x=1/>`                                   |
| `<% @items.each do \|item\| %>...<% end %>` | `{#for item in @items}...{/for}` or `:for` directive |
| `<% if condition %>...<% end %>`            | `{#if condition}...{/if}` or `:if` directive         |
| `<%= render "partial" %>`                   | `{{render "partial"}}`                               |

## Common Mistakes

1. **Using ERB tags** — `<%= %>` and `<% %>` will NOT work in `.html.orb` files
2. **Forgetting `as` on Heading/Text** — these default to `<span>` (inline); use `as="h1"`, `as="p"`, `as="div"` for block-level rendering
3. **Using `#{}` string interpolation in attributes** — use `{expression}` instead
4. **Using `else`/`elsif`** — not yet supported; use separate `{#if}` blocks
