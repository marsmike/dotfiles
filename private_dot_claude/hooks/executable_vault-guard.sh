#!/usr/bin/env python3
"""PreToolUse guard: make deletions inside the Obsidian vault recoverable.

The vault is writable by design — it is the agent's memory substrate, and the
journal, distill and enrichment workflows all need to write. Writes are also
recoverable: Obsidian Sync keeps file version history.

Deletion is the irreversible operation, so that is the only thing gated. `rm` is
blocked inside the vault; `trash` (macOS /usr/bin/trash) does the same job
recoverably and is what the Obsidian CLI's own `delete` did.

Matching is *positional*, not substring: a destructive verb only counts when it
appears in command position, and the vault only counts when it appears among
that command's own arguments. Heredoc bodies are stripped first. Without this,
prose mentioning `rm` or the vault — a commit message, an echo, a doc edit —
trips the guard, which is how v1 blocked the very commit that introduced it.

Blocks with exit 2 and an explanation on stderr, which PreToolUse surfaces to
the model as a correction rather than a hard failure. Fails open on any parse
error: a guard that breaks unrelated work would be worse than the risk it covers.
"""

import json
import os
import re
import shlex
import sys

VAULT = os.path.realpath(os.path.expanduser("~/Documents/TheVoid"))
VAULT_NAME = "TheVoid"

DESTRUCTIVE_VERBS = {"rm", "rmdir", "shred", "truncate"}
SEPARATORS = {";", "|", "||", "&", "&&", "\n", "(", ")", "{", "}"}
# Words after which the next token starts a fresh command.
CONTINUATIONS = {"then", "else", "do", "&&", "||", "|", ";", "sudo", "xargs", "time", "env"}

HEREDOC = re.compile(r"<<-?\s*(['\"]?)(\w+)\1.*?^\2$", re.DOTALL | re.MULTILINE)


def strip_heredocs(command: str) -> str:
    """Remove heredoc bodies — they are data, not commands."""
    prev = None
    while prev != command:
        prev = command
        command = HEREDOC.sub("<<STRIPPED", command)
    # An unterminated heredoc (still open at end of string): drop the remainder.
    m = re.search(r"<<-?\s*['\"]?\w+['\"]?", command)
    if m and "<<STRIPPED" not in command[m.start():m.end()]:
        nl = command.find("\n", m.end())
        if nl != -1:
            command = command[:nl]
    return command


def commands(command: str):
    """Yield [verb, *args] for each command position in a shell string.

    Lines are lexed separately: shlex treats a newline as plain whitespace, so a
    single pass would read `rm` on the line after a heredoc as an argument of the
    previous command rather than as a new command. Per-line is also the safer
    bias for a guard — it over-detects rather than under-detects.
    """
    for line in command.splitlines():
        if line.strip():
            yield from _line_commands(line)


def _line_commands(command: str):
    try:
        lexer = shlex.shlex(command, posix=True, punctuation_chars=True)
        lexer.whitespace_split = True
        tokens = list(lexer)
    except ValueError:
        return  # unbalanced quotes — fail open

    current: list[str] = []
    fresh = True
    for tok in tokens:
        if tok in SEPARATORS or set(tok) <= {";", "|", "&"}:
            if current:
                yield current
            current = []
            fresh = True
            continue
        if fresh:
            if tok in CONTINUATIONS:
                continue
            current = [tok]
            fresh = False
        else:
            current.append(tok)
    if current:
        yield current


def in_vault(path: str) -> bool:
    if VAULT_NAME in path:
        return True
    candidate = os.path.realpath(os.path.expanduser(path)) if path.startswith(("~", "/")) else None
    return bool(candidate and (candidate == VAULT or candidate.startswith(VAULT + os.sep)))


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return 0

    if payload.get("tool_name") != "Bash":
        return 0
    command = (payload.get("tool_input") or {}).get("command") or ""
    if not command:
        return 0

    cwd = payload.get("cwd") or ""
    cwd_in_vault = os.path.realpath(cwd).startswith(VAULT) if cwd else False

    for parts in commands(strip_heredocs(command)):
        verb, args = os.path.basename(parts[0]), parts[1:]
        if verb in DESTRUCTIVE_VERBS:
            pass
        elif verb == "find" and any(a == "-delete" for a in args):
            pass
        else:
            continue

        paths = [a for a in args if not a.startswith("-")]
        # Relative paths resolve against cwd; absolute ones speak for themselves.
        if any(in_vault(p) for p in paths):
            break
        if cwd_in_vault and (not paths or any(not p.startswith("/") for p in paths)):
            break
    else:
        return 0

    sys.stderr.write(
        f"Blocked: irreversible delete inside the Obsidian vault ({VAULT}).\n\n"
        "The vault is writable on purpose — write, append and edit freely, and "
        "Obsidian Sync keeps version history for those. Deletion is the one "
        "operation it cannot undo, so use the trash instead:\n\n"
        "    trash <path>          # recoverable, same effect\n\n"
        "This applies to deleting distilled captures too. If you genuinely need "
        "an unrecoverable delete, ask Mike rather than working around this.\n"
    )
    return 2


if __name__ == "__main__":
    sys.exit(main())
