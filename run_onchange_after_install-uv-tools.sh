#!/bin/bash
# Install the uv-managed CLI tools this setup expects.
#
# Companion to run_onchange_after_install-bun-globals.sh. Homebrew leaves are
# tracked in private_dot_config/homebrew/leaves.txt; bun and uv tools had no
# equivalent.
#
# claude-monitor is optional: cc-usage-segment guards on its presence and the
# status line works without it. Installing it here means the rate_limits
# capture (see cc-usage-segment) starts working on a fresh machine without a
# manual step.
#
# chezmoi reruns this script whenever its contents change, so adding or
# removing a tool below is enough to trigger installation on next apply.
#
# tools: claude-monitor

set -u

TOOLS="claude-monitor"

if ! command -v uv >/dev/null 2>&1; then
    echo "install-uv-tools: uv not found, skipping ($TOOLS)" >&2
    exit 0
fi

for tool in $TOOLS; do
    # `uv tool list` names the package, which is what `uv tool install` takes.
    if uv tool list 2>/dev/null | grep -q "^${tool} "; then
        continue
    fi
    echo "install-uv-tools: installing $tool" >&2
    uv tool install "$tool" >/dev/null 2>&1 \
        || echo "install-uv-tools: FAILED to install $tool" >&2
done

exit 0
