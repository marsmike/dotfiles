# Obsidian vault

`~/Documents/TheVoid`. **Not a git repo** (Obsidian Sync), so worktrees and branch discipline
do not apply — and `EnterWorktree` cannot work there at all.

## Looking something up

1. `Index.md` — LLM-maintained map, one line per active note. Cheap first pass, not a substitute
   for search.
2. Then semantic search. The vault's `CLAUDE.md` has the wrapper and score calibration.
   **No keyword fallback by design** — if search fails, stop rather than grepping.
3. Active content is `02_Projects/`, `03_Areas/`, `04_Resources/`. Exclude `00_Memory/`,
   `01_Capture/`, `05_Archive/`.

## Before writing into it

**Read `~/Documents/TheVoid/CLAUDE.md` first** — PARA placement, the two-phase distill workflow
with its mandatory review checkpoint, enrichment levels, frontmatter. Don't improvise structure.
