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

# Create the file if missing. It's included from ~/.gitconfig (see CLAUDE.md), so
# git silently ignores a missing include and `git config --file` would create it
# anyway — bailing here just leaves delta.features unset (falls back to the base
# catppuccin-mocha default, i.e. stuck dark even in light mode).
if [[ ! -f "$GITCONFIG_LOCAL" ]]; then
    touch "$GITCONFIG_LOCAL"
fi

if [[ "$mode" == "light" ]]; then
    theme="catppuccin-latte"
else
    theme="catppuccin-mocha"
fi

git config --file "$GITCONFIG_LOCAL" delta.features "$theme"
echo "delta theme switched to $theme ($mode mode)"
