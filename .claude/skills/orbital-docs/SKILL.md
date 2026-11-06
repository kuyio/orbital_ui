---
name: orbital-docs
description: Guidelines on writing docs for orbital components
metadata:
  author: nicbet
  version: "1.0"
---

# Documentation Style Guide for Orbital Component Pages

This guide defines the structure, conventions, and patterns for documenting Orbital components in the demo app. Every component page should follow this format consistently.

## Page Structure (in order)

### 1. Header

```orb
<div class="mb-8">
  <Heading size="2xl" as="h1" class="mb-2">ComponentName</Heading>
  <Text size="lg" tone="subdued" as="h2">
    One or two sentences describing what the component does and why you'd use it.
  </Text>
</div>
```

### 2. Canonical Example

A single, representative live example using `<Example>`. This should show the component in its most common, realistic usage — not the simplest possible version.

```orb
<div class="mb-8">
  <Example source={'
    <Component ...>...</Component>
  '}/>
</div>
```

- Use `align="start"` for components that need top/left alignment (accordions, menus, text-heavy content)
- Use `resizable` for components with responsive behaviour (NavigationMenu)
- Default alignment is center, which works for buttons, badges, icons, etc.

### 3. Usage

Code snippet + prose explanation of the basic API.

```orb
<div class="mb-12">
  <Heading size="lg" as="h2" class="mb-4">Usage</Heading>
  <div class="border rounded-lg bg-card overflow-hidden">
    <CodeBlock code={"<Component prop=\"value\">Content</Component>"}/>
  </div>
  <Prose class="mt-4">
    <p>Explain the basic API, slot structure, and how props map to behaviour.</p>
  </Prose>
</div>
```

If the component has a nested slot structure, add a tree diagram:

```orb
<div class="border rounded-lg bg-muted/50 overflow-hidden mt-4">
  <CodeBlock code={"Component\n├── Component:SlotA\n│   ├── SlotA:NestedSlot\n│   └── (default content)\n└── Component:SlotB"}/>
</div>
```

### 4. When to Use

Prose section explaining when this component is the right choice, and what alternatives to consider.

```orb
<div class="mb-12">
  <Heading size="lg" as="h2" class="mb-4">When to Use</Heading>
  <Prose>
    <p>When this component is appropriate...</p>
    <p>When NOT to use it, and what to use instead (with links)...</p>
    <p>Comparison with related components...</p>
  </Prose>
</div>
```

- Always link to alternative components using `<a href="/components/component-name">Component</a>`
- Mention 2-3 concrete use cases
- Mention at least one "don't use this for X, use Y instead"

### 5. Behaviour

Prose section explaining how the component works at runtime.

```orb
<div class="mb-12">
  <Heading size="lg" as="h2" class="mb-4">Behaviour</Heading>
  <Prose>
    <p>What HTML element it renders as...</p>
    <p>Interactive behaviour (keyboard, mouse, touch)...</p>
    <p>State management, animations, accessibility...</p>
  </Prose>
</div>
```

### 6. Examples

Multiple live examples, each with a heading, prose description, and `<Example>` component.

```orb
<div class="flex flex-col gap-12 mb-12">
  <div>
    <Heading size="md" as="h3" class="mb-2">Example Name</Heading>
    <Prose class="mb-4">
      <p>Short explanation of what this example demonstrates and when you'd use this pattern.</p>
    </Prose>
    <Example source={'
      <Component ...>...</Component>
    '}/>
  </div>
  <!-- more examples... -->
</div>
```

- Every example MUST have a `<Prose>` description before it — never a bare `<Example>`
- Use `<Text tone="subdued">` descriptions are OLD style — always use `<Prose>` instead
- For code-only examples (no live preview), use `<CodeBlock>` inside a bordered container
- For components that need full width (Expander, NavigationMenu), add `w-full` to the wrapper div inside the source

### 7. Best Practices (Do / Don't)

Two-column grid with green "Do" and red "Don't" cards.

```orb
<div class="mb-12">
  <Heading size="lg" as="h2" class="mb-4">Best Practices</Heading>
  <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
    <div class="border rounded-lg p-4 border-green-500/30 bg-green-500/5">
      <Heading size="sm" as="h4" class="mb-2 text-green-600">Do</Heading>
      <Prose>
        <ul>
          <li>Actionable, specific guidance.</li>
          <li>Reference props with <code>code</code> formatting.</li>
        </ul>
      </Prose>
    </div>
    <div class="border rounded-lg p-4 border-red-500/30 bg-red-500/5">
      <Heading size="sm" as="h4" class="mb-2 text-red-600">Don't</Heading>
      <Prose>
        <ul>
          <li>Specific anti-patterns with reasoning.</li>
          <li>Suggest alternatives when saying don't.</li>
        </ul>
      </Prose>
    </div>
  </div>
</div>
```

- 3-5 items per column
- Be specific and actionable, not vague ("Use consistent sizes" not "Be consistent")

### 8. API Reference

Tables for props and slots.

**Props table:**

```orb
<div>
  <Heading size="lg" as="h2" class="mb-4">API Reference</Heading>
  <div class="border rounded-lg overflow-hidden">
    <table class="w-full text-sm">
      <thead class="bg-muted">
        <tr>
          <th class="text-left px-4 py-2 font-medium">Prop</th>
          <th class="text-left px-4 py-2 font-medium">Type</th>
          <th class="text-left px-4 py-2 font-medium">Values</th>
          <th class="text-left px-4 py-2 font-medium">Default</th>
        </tr>
      </thead>
      <tbody class="divide-y">
        <tr>
          <td class="px-4 py-2 font-mono text-xs">propName</td>
          <td class="px-4 py-2">Type</td>
          <td class="px-4 py-2 font-mono text-xs">value1, value2</td>
          <td class="px-4 py-2 font-mono text-xs">default</td>
        </tr>
      </tbody>
    </table>
  </div>
</div>
```

**Slots table** (for components with named slots):

```orb
<Heading size="sm" as="h4" class="mb-2 mt-6">Slots</Heading>
<div class="border rounded-lg overflow-hidden">
  <table class="w-full text-sm">
    <thead class="bg-muted">
      <tr>
        <th class="text-left px-4 py-2 font-medium">Slot</th>
        <th class="text-left px-4 py-2 font-medium">Description</th>
      </tr>
    </thead>
    <tbody class="divide-y">
      <tr>
        <td class="px-4 py-2 font-mono text-xs">Component:SlotName</td>
        <td class="px-4 py-2">What this slot is for.</td>
      </tr>
    </tbody>
  </table>
</div>
```

- For components with sub-components (Card:Header, Menu:Item), add separate sections with `<Heading size="sm" as="h4">` for each
- Use `font-mono text-xs` for prop names and values
- Mark required props with `required` in the default column
- For components with no props, use a single row with `colspan="4"` and a descriptive message

## Text & Prose Rules

- **Always use `<Prose>`** for explanatory text — never raw `<p>`, `<div>` with inline text classes, or `<Text as="p">`
- `<Prose>` handles: paragraph spacing (`mb-3`), list styling, link underlines, `<code>` styling, and consistent font size/colour
- Inside `<Prose>`, use plain HTML: `<p>`, `<ul>`, `<li>`, `<a>`, `<code>`, `<strong>` — no Orbital components needed
- For inline code references to props/values, use `<code>propName</code>` inside Prose (it styles automatically)
- For links to other components: `<a href="/components/component-name">Component</a>` (Prose styles the underline)

## Component References

- **ORB slot syntax**: `<Component:Slot>` — there is NO anonymous `<:slot>` syntax
- **Nested slots**: Use the parent's name as prefix: `<Card:Header>` then `<Header:Title>` (not `<Card:Title>`)
- **Icon prop**: Many components accept `icon` as string (`icon="star"`) or hash (`icon={{name: "github", variant: "brands"}}`)
- **Position prop**: Floating components use compass directions: `auto, n, ne, e, se, s, sw, w, nw`
- **Modal triggers**: `<Button modal="dialog-id">` for inline, `<Button modal url="/path">` for async Turbo

## Demo::Example Component

- `source={'...'}` — ORB source string, rendered live and shown as syntax-highlighted code
- `align="start"` — top/left align the preview (default is center)
- `resizable` — adds a horizontal resize handle for testing responsive behaviour
- `context={{key: value}}` — pass Ruby locals to the inline template

## Pages Still Using Old Format

The following component pages may still use the old format (raw `<pre><code>`, `<details>` for code, `<Text tone="subdued">` for descriptions). When updating them, convert to the format described above:

- Popover, Select, Separator, Spinner, Text, TextField, Tooltip, Typography
