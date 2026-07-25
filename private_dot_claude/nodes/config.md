# Config is executable behavior

CLAUDE.md files, skills, hooks, and memory are not documentation. **Humans skim stale docs;
agents obey stale instructions.** Stronger models make this worse, not better — they execute
outdated rules more faithfully.

## Maintenance rules

- Temporary rules carry a **removal condition in the line itself**. No open-ended workarounds.
  The canonical failure is a "remove after migration" note that outlives its migration by
  months because nobody owned it.
- **Prefer a hook or skill over a text rule when enforcement matters.** A rule sits inert until
  the model happens to weight it; a skill fires at a specific decision point, and a hook fires
  whether the model cooperates or not.
- **Re-audit after every model upgrade.** A guardrail written for a weaker model becomes noise,
  and conflicting instructions cost more than the worst case they were added to prevent.
- Before adding a rule, check whether a skill already enforces it structurally. If so, the rule
  is redundant and competes for attention with everything else.

## The line budget

Instruction-following degrades **uniformly, not selectively** — past a threshold the model
gets slightly less reliable at everything, including the rules you care most about. It does
not triage and drop the least important first.

Target **under 60 lines** for any CLAUDE.md. The global one is a router precisely so it can
stay far under that; content lives in these nodes and is read on demand.

Adding to the router should displace something, not append to it.

## Where things belong

- **Global router + nodes** — policy that holds on every machine and in every repo.
- **Project `CLAUDE.md`** — procedure, gotchas, and conventions for that repo. Spend most of
  its tokens on gotchas, not on what the filesystem already reveals.
- **Memory** — facts learned about Mike and the work. Note that memory does **not** sync
  across machines; chezmoi excludes `.claude/projects/**`. Anything that must hold everywhere
  has to graduate into the global nodes to travel.
