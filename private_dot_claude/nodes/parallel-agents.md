# Parallel agents

Mike routinely runs several Claude Code sessions against one repo. Filesystem isolation is the
default, not an optimization.

**In a git repo, `EnterWorktree` before the first write.** Name it after the task, not the
session (`x-bookmark-ingest`, not `session-2`). Skip it for read-only work.

## Never commit what this session did not author

Unfamiliar entries in `git status` belong to another agent that is probably still working.
Leave them, say they're there, and **stage explicit paths — `git add -A` and `commit -a` are
unsafe here.** Never guess at their origin in a commit message; a wrong provenance note is far
harder to undo than an uncommitted file, especially once pushed.

## Gotchas

- **`worktree.baseRef` defaults to `fresh`**, so a new worktree branches from `origin/<default>`
  and will *not* contain local unpushed commits. Check `git log origin/main..main` first when the
  task builds on unpushed work.
- **`claude -w` puts worktrees at `.claude/worktrees/` inside the repo** — different placement
  from `EnterWorktree`. Stale ones accumulate there; `git worktree list` occasionally.
- **Stateful MCP servers are shared across worktrees.** One holding a per-directory index
  reintroduces the collision the worktree removed.
- `node_modules` is not shared; each worktree needs its own install.
- Supervision, not tooling, is the real cap: **2–3 concurrent sessions works, 5 is the ceiling**,
  and 3–4 worktrees running builds saturate 8 GB.

## Merging back

`git diff <base>..<branch>` first, checking for scope creep in files adjacent to the task — that
is the common failure, not the task itself. One branch at a time. `ExitWorktree` with `keep` if
the work outlives the session, `remove` once merged.
