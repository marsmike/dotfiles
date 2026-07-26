# Config is executable behavior

CLAUDE.md files, skills, hooks and memory are not documentation. **Humans skim stale docs;
agents obey stale instructions** — and stronger models execute outdated rules *more* faithfully.

## Deleting beats adding

Anthropic removed **>80% of Claude Code's system prompt** for Opus 5 / Fable 5 with no
measurable eval loss. A constraint written for a weaker model doesn't go dormant when the model
improves; it becomes a *conflicting* instruction the model spends reasoning to reconcile.

So: **spend the tokens on gotchas** — the surprising, the load-bearing, the things that
contradict what the filesystem implies. Cut anything a capable model would infer from context.
`/doctor` runs this pass automatically.

The budget is **instruction slots, shared across every tier at once** — roughly 100–150 after
the system prompt's own ~50 — and adherence degrades uniformly, so a stale rule you don't care
about taxes the rule you do. Adding to the router should displace something.

## Maintenance

- Temporary rules carry a **removal condition in the line itself**. The canonical failure is a
  "remove after migration" note that outlives its migration by months because nobody owned it.
- **Prefer a hook or skill over a text rule when enforcement matters.** A rule sits inert until
  the model happens to weight it; a hook fires whether the model cooperates or not.
- **Re-audit after every model upgrade** — treat it as a config-affecting dependency change.
- Auto-memory is a new source of stale config: it can persist a one-off steer as a standing rule,
  with no removal condition attached.

## Where things belong

Global router + nodes = policy true on every machine. Project `CLAUDE.md` = that repo's gotchas.
Memory = facts learned about Mike and the work — and it **does not sync**, since chezmoi excludes
`.claude/projects/**`, so anything that must hold everywhere has to graduate into a node.
