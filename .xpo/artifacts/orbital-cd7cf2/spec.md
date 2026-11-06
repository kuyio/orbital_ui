Add a `dot` prop to Badge that renders a small colored circle, replacing hand-rolled status dot markup.

## Problem

Status dots inside Badge are currently built with raw HTML and hardcoded colors:

```html
<Badge variant="outline" class="w-fit">
  <span class="inline-block w-2 h-2 rounded-full bg-yellow-400 mr-1.5"></span>
  Pending Setup
</Badge>
```

This bypasses the design system's tone tokens and won't adapt to dark mode.

## Proposed API

```html
<Badge dot="warning">Pending Setup</Badge>
<Badge dot="success">Active</Badge>
<Badge dot="danger">Failed</Badge>
```

## Implementation

- Add `attribute :dot, :symbol, default: nil, only: [:default, :success, :warning, :danger, :info, :subdued]` to `orbital/app/components/orbital/badge.rb`.
- When `dot` is present (non-nil), render `<span class="Orbital-Badge-Dot" data-tone="...">` as the first child inside the badge, before `content`. When `dot` is nil, render nothing extra (current behavior unchanged).
- Dot is a small circle: `w-2 h-2 rounded-full` (matches the size used in the hand-rolled markup being replaced).
- Color mapping per `data-tone`, using the existing tone-token utilities already in use by `Alert`/`Text` (no new tokens needed):
  - `success` → `bg-tone-success`
  - `warning` → `bg-tone-warning`
  - `danger` → `bg-tone-danger`
  - `info` → `bg-tone-info`
  - `subdued` → `bg-muted-foreground` (mirrors `Text`'s `subdued` tone, which maps to `text-muted-foreground`)
  - `default` → `bg-foreground`
  - Note: `magic` is intentionally excluded — it exists as a `Text` tone but has no background-tone precedent in this codebase and isn't a status-dot use case.
- Spacing: the dot owns its own right margin (e.g. `mr-1.5`) in `Orbital-Badge-Dot` CSS so consumers never add spacing manually.
- The dot renders identically across all existing `variant` values (`default`, `secondary`, `destructive`, `ghost`, `outline`) — `dot` and `variant` are independent attributes.
- Add the CSS rules to `orbital/frontend/stylesheets/components/badge.css` under `@layer components`, following `Orbital-` / BEM conventions and `data-*` variant selectors, consistent with the rest of the file.
- Update the Badge demo doc page to add examples of `dot` with each tone value, per the `documentation-style-guide` skill.

## Acceptance Criteria

- `<Badge dot="warning">Pending Setup</Badge>` renders a `span.Orbital-Badge-Dot[data-tone="warning"]` before the text content, with no consumer-supplied markup or spacing classes needed.
- Omitting `dot` (or passing no value) renders Badge exactly as it does today, with no extra span.
- All six tone values (`default`, `success`, `warning`, `danger`, `info`, `subdued`) render with the color mapping specified above, and pick up dark-mode variants automatically via the existing CSS custom properties (no hardcoded colors).
- Passing a symbol outside the `only:` list raises the standard ORB/ViewComponent attribute validation error (consistent with `variant`'s existing behavior).
- Demo doc page shows at least one example per tone.