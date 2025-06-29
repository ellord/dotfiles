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
    
    # Update Claude Code theme configuration
    # Using the claude CLI config command to set the theme
    claude config set -g theme "$mode"
    
    echo "Claude Code theme switched to $mode mode"
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