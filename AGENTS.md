# Orbital

Ruby/Rails component library (gem at the repo root) + docs app (`test/dummy`), built with ORB templates, Tailwind CSS, and Stimulus. Compiled with Parcel on Bun.

## Component Rules

1. Prefer Orbital components over raw Tailwind utility divs.
2. Each component needs: a `.rb` in `app/components/orbital_ui/`, a `.css` in `frontend/stylesheets/components/`, and a demo doc page (follow the `documentation-style-guide` skill).
3. Add a Stimulus controller in `frontend/javascript/controllers/` (prefixed `orbital-`) only when CSS-only solutions aren't feasible.
4. CSS: `Orbital-` prefix, BEM conventions (`Orbital-Card-Header`), `@layer components` block, `data-*` attributes for variants/state.
5. Load the `orb-templates` skill before writing or editing `.html.orb` files.

## Issue Tracking

Uses `xpo` (Exponential) via MCP — never shell out to the CLI. Issue IDs use prefix `orbital-`.

### Workflow

Load the `xpo-workflow` skill before starting any issue. Key gates:

1. **Spec** → iterate with user → **Plan** (`PLANNED`)
2. **Start** (`mcp__xpo__start`) → **Implement** → **Completion comment**
3. **User review loop** → iterate until approved
4. **Walkthrough** → **Commit** (type-prefixed: `feature:`, `bugfix:`, `chore:`, `refactor:`) → **Merge** (`mcp__xpo__merge` with `commit_message`)

### Hard Rules

1. Every code change must be backed by an xpo issue in DOING before any file is modified.
2. Never start work on a BACKLOG issue without explicit user approval.
3. Bugs found during implementation: file immediately, link to the originating issue.
4. If an MCP tool call fails, report the error. Never fall back to the CLI.

### Agent Identity

Set `assignee` when transitioning to DOING: `<Agent Name> <agent@<host>.local>`.

<!-- xpo:begin 1.5.0 sha256:dd491caea2a7 -->
## Exponential (xpo)

This project uses `xpo` (Exponential) via the MCP server registered in `.mcp.json`.
Always use the MCP tools — never shell out to the `xpo` CLI.

Issue IDs in this project use the prefix `orbital` (e.g. `orbital-a1b2c3`).

### Hard Rules

1. Every code change must be backed by an xpo issue transitioned to DOING before any file is modified.
2. Never start work on a BACKLOG issue without explicit user approval to transition it.
3. Bugs discovered during implementation may be filed and fixed without approval — file the issue, link it to the current work, and fix it.
4. Before beginning any implementation task, load the `xpo` skill and follow it.
5. If an MCP tool call fails, report the error to the user. Never fall back to the CLI.

<!-- xpo:end -->
