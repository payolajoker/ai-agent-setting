---
name: design-style-vault
description: Offline archive of 30 designprompts.dev web design styles with per-style prompts, descriptions, and mode/type metadata. Use when the user wants to browse, compare, choose, or apply one of these archived aesthetics in Codex, including cases where designprompts.dev is unavailable.
---

# Design Style Vault

Use this skill when the user wants the `designprompts.dev` aesthetic but you should not depend on the live site.

## Workflow

1. If the user has not chosen a style yet, run `python scripts/list_styles.py` with optional `--mode`, `--type`, or `--query` filters and shortlist the most relevant styles.
2. If the user names a style or you already picked one, run `python scripts/show_style.py <slug>` to inspect the archived metadata and full local prompt.
3. Before doing UI implementation, read `references/styles/<slug>.md` or run `python scripts/show_style.py <slug> --prompt-only` and treat that archived prompt as the design brief.
4. Apply the chosen style only to the scope the user asked for. Preserve the existing tech stack, component patterns, and accessibility requirements unless the user asks for a broader redesign.

## Local Resources

- `references/style-index.md` lists every archived style with slug, mode, type, and short description.
- `references/styles/<slug>.md` stores the full archived prompt and metadata for one style.
- `scripts/list_styles.py` filters the archive offline.
- `scripts/show_style.py` prints one style, with `--prompt-only` for direct implementation use.

## Rules

- Do not fetch `designprompts.dev` when the local archive is sufficient.
- Do not invent missing style details; use the archived files exactly.
- If the user says they like the site in general but does not name a style, narrow the choice first instead of guessing.
- Treat the archived prompt as a design system reference, not as permission to ignore the user's repo conventions.
