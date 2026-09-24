# Obsidian vault

`~/Documents/TheVoid`. A git repo (`marsmike/TheVoid`) whose one committer is the pipeline:
`pipeline_run.py begin`/`end`, run every 3 h by a Claude cloud routine in its own clone. Never
run git in it yourself. Edits made on the Mac reach git only through Obsidian Git's auto
commit-and-sync, not through the cloud's `begin`. PDFs and other binaries are git-ignored
(they live only in Obsidian Sync).

## Looking something up

1. `Now.md`, then `Index.md` — generated, one line per active note. Cheap first pass.
2. Then search: `search.py` in the toolkit (BM25, plus semantic when installed); the vault's
   `AGENTS.md` has the command. Grepping `Index.md` and `description:` lines is fine.
3. Active content is `02_Projects/`, `03_Areas/`, `04_Resources/`. Exclude `00_Memory/`,
   `01_Capture/`, `05_Archive/`.

## Before writing into it

**Read `~/Documents/TheVoid/AGENTS.md` first** (there is no CLAUDE.md) — PARA placement, the
two-phase distill with its review checkpoint, enrichment levels, frontmatter, generated files
never edited by hand. New material enters as a capture in `01_Capture/`.
