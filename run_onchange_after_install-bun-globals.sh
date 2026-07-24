#!/bin/bash
# Install the bun-global CLIs that managed configs depend on.
#
# Without this, a fresh machine gets ~/.config/ccstatusline/settings.json and
# ~/.local/bin/cc-usage-segment but neither binary, so the status line silently
# renders nothing. Homebrew leaves are tracked in
# private_dot_config/homebrew/leaves.txt; bun globals had no equivalent.
#
# chezmoi reruns this script whenever its contents change, so adding or
# removing a package below is enough to trigger a reinstall on next apply.
#
# packages: ccstatusline ccusage

set -u

PACKAGES="ccstatusline ccusage"

if ! command -v bun >/dev/null 2>&1; then
    echo "install-bun-globals: bun not found, skipping ($PACKAGES)" >&2
    exit 0
fi

for pkg in $PACKAGES; do
    # Check the binary rather than the package dir: a half-removed install
    # can leave node_modules behind without a working executable.
    if [ -x "$HOME/.bun/bin/$pkg" ]; then
        continue
    fi
    echo "install-bun-globals: installing $pkg" >&2
    bun add -g "$pkg" >/dev/null 2>&1 \
        || echo "install-bun-globals: FAILED to install $pkg" >&2
done

exit 0
