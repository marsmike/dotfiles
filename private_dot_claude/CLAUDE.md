@RTK.md

# Router

This file routes; it does not answer. All content lives in `~/.claude/nodes/`.

**Standing rule:** read `~/.claude/nodes/index.md` first. Open only the top matching node.
If that node points elsewhere, follow one edge — then stop.

| When the question is about | Go to |
|---|---|
| What Mike knows, has read, or wrote down; research, notes, prior work | `nodes/obsidian.md` |
| Several agents on one repo; worktrees, branching, committing, merging | `nodes/parallel-agents.md` |
| Cloning a repo, installing a package, running someone else's script | `nodes/external-code.md` |
| Language choice, package manager, env vars, file naming | `nodes/tooling.md` |
| Editing CLAUDE.md, skills, hooks, or memory | `nodes/config.md` |
| Who Mike is, which machine, where things live, the Companion owl | `nodes/mike.md` |

The Obsidian vault at `~/Documents/TheVoid` is the default place to look for anything Mike
already knows. Check it before answering from scratch or searching the web.

Project-specific rules live in that project's own `CLAUDE.md` and its memory. Do not look
for them here, and do not copy them here.
