#!/usr/bin/env python3
"""PreToolUse guard for the Scalable Capital MCP (both the Claude Code server `scalable` and the
claude.ai connector): Mike's broker rules, enforced in code rather than left to the model.

1. Broker account only. A call that names a portfolio or account must name the broker's own
   (the `portfolio_id` the `sc` CLI saved in ~/.config/scalable-cli/broker_context.json); without
   one the connector uses the broker account. `list_accessible_portfolios` and every tool about
   the savings account (Tagesgeld, overnight, fixed term), transfers, payouts, deposits or credit
   are refused. [Mike, 2026-10-04: "Only access to the Broker … not to the Tagesgeldkonto"]
2. Orders only after Mike says so. `submit_*`, `cancel_order` and `remove_savings_plan` pass only
   when Mike's latest message is an explicit confirmation, and — for a submit — a `preview_*` call
   was made in the turn he answered. That is Scalable's own rule ("explicitly confirmed in a later
   user interaction") and Mike's ("each order is placed only after Mike's explicit confirmation").

Denies with a JSON permissionDecision, which holds in every permission mode, bypass included.
Fails CLOSED: money is involved, so a guard that cannot read its input refuses.
"""

import json
import re
import sys
from pathlib import Path

TOOL = re.compile(r"^mcp__(?:scalable|claude_ai_Scalable)__(?P<name>.+)$")
FORBIDDEN = re.compile(r"accessible_portfolios|savings_account|overnight|fixed_term|tagesgeld|transfer|withdraw"
                       r"|payout|deposit|credit|interest_rate|bank_account|iban", re.I)
GATED = re.compile(r"^(submit_.+|cancel_order|remove_savings_plan)$")
ID_KEY = re.compile(r"^(portfolio|account)_?id$", re.I)
CONFIRM = re.compile(
    r"^\s*(yes|yep|ja|ok|okay|confirmed?|go ahead|do it)\b"
    r"|\b(place (it|the order|them)|submit (it|them)|confirm(ed)?|go ahead|execute (it|them)|buy it|sell it"
    r"|ja,? (bitte )?(platzier|ausführ|kauf|verkauf)\w*|bestätig\w*|ausführen)\b", re.I)
BROKER_CONTEXT = Path.home() / ".config" / "scalable-cli" / "broker_context.json"


def deny(reason: str) -> None:
    print(json.dumps({"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny",
                                             "permissionDecisionReason": f"scalable-guard: {reason}"}}))
    sys.exit(0)


def ids_in(value):
    """Every (key, value) whose key names a portfolio or account id, at any depth."""
    if isinstance(value, dict):
        for k, v in value.items():
            if ID_KEY.match(str(k)) and v not in (None, ""):
                yield k, v
            yield from ids_in(v)
    elif isinstance(value, list):
        for v in value:
            yield from ids_in(v)


def human_messages(transcript: Path) -> list[tuple[int, str]]:
    """(row index, text) of the messages Mike typed: not tool results, reminders, notifications,
    command output, compaction summaries or interruptions."""
    out = []
    for i, line in enumerate(transcript.read_text(encoding="utf-8").splitlines()):
        try:
            row = json.loads(line)
        except json.JSONDecodeError:
            continue
        if row.get("type") != "user" or row.get("isMeta") or row.get("isCompactSummary"):
            continue
        content = (row.get("message") or {}).get("content")
        if isinstance(content, list):
            if any(b.get("type") == "tool_result" for b in content if isinstance(b, dict)):
                continue
            content = " ".join(b.get("text", "") for b in content if isinstance(b, dict) and b.get("type") == "text")
        if not isinstance(content, str):
            continue
        text = content.strip()
        if not text or text.startswith("<") or text.startswith("[Request interrupted") or text.startswith("This session is being continued"):
            continue
        out.append((i, text))
    return out


def previewed_between(transcript: Path, start: int, end: int) -> bool:
    for i, line in enumerate(transcript.read_text(encoding="utf-8").splitlines()):
        if not start < i < end:
            continue
        try:
            row = json.loads(line)
        except json.JSONDecodeError:
            continue
        for b in (row.get("message") or {}).get("content") or []:
            if isinstance(b, dict) and b.get("type") == "tool_use" and TOOL.match(b.get("name", "")) \
                    and "preview_" in b.get("name", ""):
                return True
    return False


def main() -> None:
    try:
        event = json.load(sys.stdin)
    except Exception:  # noqa: BLE001
        deny("could not read the tool call; refusing (fail closed)")
    m = TOOL.match(event.get("tool_name", ""))
    if not m:
        sys.exit(0)
    name, args = m.group("name"), event.get("tool_input") or {}

    if FORBIDDEN.search(name):
        deny(f"`{name}` touches the savings account, money movement or the account list. Broker account only (Mike's rule).")

    found = list(ids_in(args))
    if found:
        try:
            broker = str(json.loads(BROKER_CONTEXT.read_text(encoding="utf-8"))["portfolio_id"])
        except Exception:  # noqa: BLE001
            deny("a portfolio/account id was given but the broker's own id is unknown here; call without it (the default is the broker account).")
        if any(str(v) != broker for _, v in found):
            deny("that portfolio/account is not the broker account. Never the Tagesgeldkonto; call without an id or with the broker's.")

    if GATED.match(name):
        try:
            transcript = Path(event["transcript_path"])
            msgs = human_messages(transcript)
        except Exception:  # noqa: BLE001
            deny("cannot read the conversation to check Mike's confirmation; refusing (fail closed).")
        if not msgs:
            deny("no message from Mike in this conversation; an order needs his explicit confirmation.")
        last_i, last_text = msgs[-1]
        if not CONFIRM.search(last_text):
            deny(f"Mike's latest message does not confirm an order ({last_text[:80]!r}). Show him the preview and wait for his explicit yes.")
        if name.startswith("submit_"):
            prev_i = msgs[-2][0] if len(msgs) > 1 else -1
            if not previewed_between(transcript, prev_i, last_i):
                deny("no preview was shown in the turn Mike answered. Preview the order, present it, and wait for his confirmation.")
    sys.exit(0)


if __name__ == "__main__":
    main()
