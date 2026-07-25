# Parallel agents

Mike routinely runs several Claude Code sessions against one repository. Treat filesystem
isolation as the default, not an optimization.

## Isolate before writing

**In a git repo, call `EnterWorktree` before the first write.** Name it after the task, never
after the agent or session (`x-bookmark-ingest`, not `session-2`).

Skip it for read-only work — questions, code reading, review, search — and in non-git
directories such as `~/Documents/TheVoid`, where `EnterWorktree` cannot work at all.

## Never commit what this session did not author

Unfamiliar entries in `git status` belong to another agent that is probably still working.

- Leave them alone and say they are there.
- Never speculate about their origin in a commit message. A wrong provenance note is worse
  than an uncommitted file, and it is far harder to undo once pushed.
- Stage explicit paths. `git add -A` and `git commit -a` are unsafe here.

## Merging back

- `git diff <base>..<branch>` before merging. Check for scope creep in files adjacent to the
  task — that is the common failure, not the task itself.
- Merge one branch at a time. Never merge two agent branches in parallel.
- `ExitWorktree` with `keep` if the work outlives the session, `remove` once it is merged.

## Gotchas

- `worktree.baseRef` defaults to `fresh`, so a new worktree branches from `origin/<default>`
  and will **not** contain local unpushed commits. Check `git log origin/main..main` first if
  the task builds on unpushed work.
- Stateful MCP servers are shared across worktrees. One holding a per-directory index
  reintroduces exactly the collision the worktree removed.
- `node_modules` is not shared; each worktree needs its own install.
