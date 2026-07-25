# Obsidian vault

`~/Documents/TheVoid` — Mike's knowledge base. **Not a git repo** (syncs via Obsidian Sync),
so git workflows, worktrees, and branch discipline do not apply there.

Treat it as the default source for anything Mike already knows: prior research, decisions,
reading, project state. Check it before answering from scratch or reaching for the web.

## How to look something up

1. Read `~/Documents/TheVoid/Index.md` — an LLM-maintained map, one line per active note.
   Cheap first pass, not a substitute for search.
2. Then search semantically. The vault's `CLAUDE.md` documents the wrapper script and the
   score calibration; there is no keyword fallback by design.
3. Active content is `02_Projects/`, `03_Areas/`, `04_Resources/` only. Exclude `00_Memory/`
   (the agent's own state), `01_Capture/` (raw inbox), and `05_Archive/` (frozen).

## Before writing anything into it

**Read `~/Documents/TheVoid/CLAUDE.md` first.** It is long and load-bearing: PARA placement,
the two-phase distill workflow with a mandatory review checkpoint, enrichment levels,
frontmatter taxonomy, and a list of things never to do. Do not improvise vault structure.

The short version: if a note already covers the topic, enrich it rather than adding a new
one; every distilled note carries its source; never link into `01_Capture/` or `05_Archive/`.

## Related

Captures arrive from Readwise and X bookmarks. The `obsidian:` and `readwise:` plugins carry
the skills for processing them.
