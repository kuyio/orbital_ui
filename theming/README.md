# Orbital Theme Customization Demo

This folder contains examples demonstrating how to customize the Orbital component library's appearance using CSS variables.

## Quick Start

The Orbital component library is designed to be easily themable. All visual styling is controlled through CSS variables that you can override in your host application.

### Basic Usage

1. **Import Orbital's CSS** in your application first
2. **Define your overrides** after importing Orbital

```html
<!-- In your HTML -->
<link rel="stylesheet" href="path/to/orbital_ui/index.css">
<link rel="stylesheet" href="your-custom-theme.css">
```

Or in CSS:

```css
/* In your main CSS file */
@import "orbital_ui/index.css";

:root {
  --primary: hotpink;
  --primary-foreground: white;
  --radius: 1rem;
}
```

## Example: Pink Theme

See [`custom-theme.css`](./custom-theme.css) for a complete pink theme example that demonstrates:

- Overriding primary and secondary colors
- Customizing semantic feedback colors
- Adjusting border radius
- Creating a matching dark mode variant

### To Use the Pink Theme:

```html
<link rel="stylesheet" href="orbital_ui/index.css">
<link rel="stylesheet" href="theming/custom-theme.css">
```

## How It Works

Orbital uses a **two-layer variable system**:

1. **Theme Variables** (`:root`) - Define color values you can override
2. **Component Variables** (`@theme`) - Map Tailwind utilities to theme variables

When you override a variable in `:root`, all components using that color automatically update.

### Example: Changing Primary Color

```css
:root {
  --primary: #your-brand-color;
  --primary-foreground: white;
}
```

This single change affects:
- Primary buttons (`<Button variant="primary">`)
- Primary badges (`<Badge variant="primary">`)
- Input focus states
- Link colors
- And more...

## Variable Categories

### Essential Color Variables

These are the most commonly overridden variables:

| Variable | Used By | Default |
|----------|---------|---------|
| `--primary` | Buttons, badges, links, focus states | `#171717` |
| `--primary-foreground` | Text on primary backgrounds | `#fafafa` |
| `--secondary` | Secondary buttons, hover states | `#f5f5f5` |
| `--destructive` | Error states, destructive actions | `#e40014` |
| `--radius` | All component border radius | `0.5rem` |

### Complete Variable Reference

See the bottom of [`custom-theme.css`](./custom-theme.css) for a complete list of all available CSS variables and their usage.

## Dark Mode

Orbital includes built-in dark mode support. To enable:

### Host App Implementation

Add the `dark` class to your `<html>` or `<body>` element:

```html
<html class="dark">
  <!-- Your app -->
</html>
```

### Custom Dark Mode Theme

Override the `.dark` selector to customize dark mode colors:

```css
.dark {
  --primary: #ff69b4;
  --primary-foreground: #1a0010;
  --card: #2a0f1e;
  --card-foreground: #ffe6f5;
  /* ... other dark mode overrides */
}
```

## Minimal Override Example

You don't need to override everything. Define only what you want to change:

```css
:root {
  /* Just change your brand color */
  --primary: #your-brand-color;
  --primary-foreground: white;
  
  /* Make corners more rounded */
  --radius: 0.75rem;
}
```

All other variables will use Orbital's sensible defaults.

## Host App Responsibilities

Orbital **only styles** `.Orbital-*` components. Your host application controls:

- Page background colors
- Body text colors and fonts
- Global margins and padding
- Layout and spacing outside of components

### Example Host App CSS

```css
/* Your app's CSS */
html {
  background-color: #f9fafb;
}

body {
  margin: 0;
  padding: 20px;
  font-family: 'Inter', system-ui, sans-serif;
  color: #1f2937;
}

/* Then import and optionally override Orbital */
@import "orbital_ui/index.css";

:root {
  --primary: #your-brand-color;
}
```

## Tips & Best Practices

### 1. Use Semantic Colors

Orbital uses semantic color naming (primary, secondary, destructive) rather than specific colors (blue, red). This makes theming easier and more maintainable.

### 2. Test Both Light and Dark Modes

If your app supports dark mode, make sure to test your theme overrides in both modes:

```css
:root {
  --primary: #0066cc; /* Light mode */
}

.dark {
  --primary: #66b3ff; /* Dark mode - brighter for contrast */
}
```

### 3. Maintain Contrast Ratios

When overriding colors, ensure sufficient contrast between foreground and background colors for accessibility:

- `--primary` and `--primary-foreground` should have good contrast
- Same for `--secondary`, `--destructive`, etc.

### 4. Override Only What You Need

Start with minimal overrides. Orbital's defaults are designed to work well together. Only override specific variables when you need to match your brand.

### 5. Typography Customization

You can customize font sizes and line heights for Text and Heading components:

```css
:root {
  /* Make body text slightly larger */
  --text-body-md: 15px;
  --text-body-md--line-height: 22px;
  
  /* Adjust heading sizes */
  --text-heading-2xl: 28px;
  --text-heading-2xl--line-height: 36px;
}
```

## Questions or Issues?

If you have questions about theming or encounter issues, please refer to the main project documentation or open an issue on the project repository.
