@RTK.md

# Router

This file routes; it does not answer. Content lives in `~/.claude/nodes/`.

**Standing rule:** open the one node that matches, follow at most one edge from it, then stop.

| When the question is about | Go to |
|---|---|
| What Mike knows, has read, or wrote down; research, notes, prior work | `nodes/obsidian.md` → the vault's own `Index.md` + `CLAUDE.md` |
| Several agents on one repo; worktrees, committing, merging | `nodes/parallel-agents.md` |
| Cloning a repo, installing a package, running someone else's script | `nodes/external-code.md` |
| Language, package manager, env vars, file naming | `nodes/tooling.md` |
| Editing CLAUDE.md, skills, hooks, or memory | `nodes/config.md` |
| Who Mike is, which machine, where things live, the owl | `nodes/mike.md` |

The vault at `~/Documents/TheVoid` is the default place to look for anything Mike already
knows — check it before answering from scratch or searching the web.

Project rules live in that project's own `CLAUDE.md`. Don't look for them here or copy them here.
