#!/usr/bin/env bash
# Switch Delta's catppuccin theme between light and dark mode.
# Called by dark-notify when macOS switches between light/dark mode.

set -euo pipefail

mode="${1:-}"
if [[ -z "$mode" ]]; then
    echo "Missing required argument 'mode'." >&2
    exit 1
elif [[ "$mode" != light && "$mode" != dark ]]; then
    echo "Mode must be 'light' or 'dark'." >&2
    exit 2
fi

GITCONFIG_LOCAL="$HOME/.gitconfig.local"

if [[ ! -f "$GITCONFIG_LOCAL" ]]; then
    echo "gitconfig.local not found at $GITCONFIG_LOCAL" >&2
    exit 3
fi

if [[ "$mode" == "light" ]]; then
    theme="catppuccin-latte"
else
    theme="catppuccin-mocha"
fi

git config --file "$GITCONFIG_LOCAL" delta.features "$theme"
echo "delta theme switched to $theme ($mode mode)"
