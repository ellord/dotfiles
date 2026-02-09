#!/usr/bin/env bash
# This script will set the Claude Code theme based on system appearance
# Called by dark-notify when macOS switches between light/dark mode

set -o errexit
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_NAME=${0##*/}

IFS= read -rd '' USAGE <<EOF || :
Set Claude Code dark/light mode.
Usage: $ ${SCRIPT_NAME} light|dark
EOF

claude_set_theme() {
    local mode="$1"
    local config_file="$HOME/.claude.json"

    if [[ -f "$config_file" ]]; then
        local tmp
        tmp=$(jq --arg theme "$mode" '.theme = $theme' "$config_file")
        printf '%s\n' "$tmp" > "$config_file"
        echo "Claude Code theme switched to $mode mode"
    else
        echo "Claude config file not found at $config_file" >&2
        exit 3
    fi
}

# Parse arguments
mode="$1"
if [[ -z "$mode" ]]; then
    echo "Missing required argument 'mode'." >&2
    exit 1
elif [[ "$mode" != light ]] && [[ "$mode" != dark ]]; then
    echo "Mode must be 'light' or 'dark'." >&2
    exit 2
fi

claude_set_theme "$mode"