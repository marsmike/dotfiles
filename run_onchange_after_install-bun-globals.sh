#!/bin/bash
# Install the bun-global CLIs that managed configs depend on.
#
# Without this, a fresh machine gets ~/.config/ccstatusline/settings.json and
# ~/.local/bin/cc-usage-segment but neither binary, so the status line silently
# renders nothing. Homebrew leaves are tracked in
# private_dot_config/homebrew/leaves.txt; bun globals had no equivalent.
#
# pi (Pi coding agent) reads ~/.pi/agent/{models,settings}.json, also managed here.
#
# chezmoi reruns this script whenever its contents change, so adding or
# removing a package below is enough to trigger a reinstall on next apply.
# Packages already installed are bumped to latest on each run (`bun update -g`).
#
# packages: ccstatusline ccusage @earendil-works/pi-coding-agent

set -u

# package:binary — scoped packages install a binary with a different name.
PACKAGES="ccstatusline:ccstatusline ccusage:ccusage @earendil-works/pi-coding-agent:pi"

if ! command -v bun >/dev/null 2>&1; then
    echo "install-bun-globals: bun not found, skipping ($PACKAGES)" >&2
    exit 0
fi

for entry in $PACKAGES; do
    pkg="${entry%:*}"
    bin="${entry##*:}"
    # Check the binary rather than the package dir: a half-removed install
    # can leave node_modules behind without a working executable.
    if [ -x "$HOME/.bun/bin/$bin" ]; then
        bun update -g "$pkg" >/dev/null 2>&1 \
            || echo "install-bun-globals: FAILED to update $pkg" >&2
        continue
    fi
    echo "install-bun-globals: installing $pkg" >&2
    bun add -g "$pkg" >/dev/null 2>&1 \
        || echo "install-bun-globals: FAILED to install $pkg" >&2
done

exit 0
