# Add gap and padding props to Card

## What

`Card` accepts `gap`, the spacing between direct children of its content area, and `padding`, which overrides that area's padding.

```orb
<Card gap="4">
  <TextField name="a" label="A"/>
  <Button>Submit</Button>
</Card>

<Card gap="2" padding="4">...</Card>
<Card padding="0"><table>...</table></Card>
```

## Why

Card bodies often wrap their children in `<div class="flex flex-col gap-X">` just to space them, and compact or flush cards have no way to change the padding.

## How

- `attribute :gap, :string` and `attribute :padding, :string`, both defaulting to nil, as `data-gap` and `data-padding` on `.Orbital-Card-Content`.
- `[data-gap]` makes the content a flex column, with the same scale as `Stack`.
- `padding="N"` sets the left, right and bottom padding. The top stays 0 below a header, to match the current layout, and is N when the content comes first.

## Acceptance Criteria

- [ ] A Card with neither prop renders the same HTML and CSS rules as today
- [ ] `gap` and `padding` appear on the content area, not the Card root
- [ ] Rendered spacing and padding are correct in a browser, with and without a header
- [ ] The built CSS only gains rules
- [ ] The docs page shows both props, and its API table lists them
- [ ] `make test` and `make test-rubies` pass, and every docs path returns 200

## Decisions

- **No default gap.** The issue suggested considering one, but it would make every existing Card's content a flex column and stack any inline children. Opt-in keeps existing Cards unchanged.
- **Values follow `Stack`:** strings, with no validation, so an unknown value has no effect.
- **Header and footer padding don't change.** The props only apply to the content area, as the issue describes.
- **Existing docs pages keep their wrapper divs.** Replacing them is cleanup for another change.
