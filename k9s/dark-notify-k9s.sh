#!/usr/bin/env bash
# This script will set the k9s theme based on system appearance
# Called by dark-notify when macOS switches between light/dark mode

set -o errexit
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_NAME=${0##*/}

IFS= read -rd '' USAGE <<EOF || :
Set k9s dark/light mode.
Usage: $ ${SCRIPT_NAME} light|dark
EOF

k9s_set_theme() {
    local mode="$1"
    local config_file="$HOME/.config/k9s/config.yaml"
    
    # Determine which theme to use
    local theme
    if [[ "$mode" == "light" ]]; then
        theme="catppuccin-latte-transparent"
    else
        theme="catppuccin-mocha-transparent"
    fi
    
    # Update k9s config file
    if [[ -f "$config_file" ]]; then
        # Use sed to update the skin line
        if grep -q "skin:" "$config_file"; then
            # Replace existing skin line
            sed -i '' "s/skin: .*/skin: $theme/" "$config_file"
        else
            # Add skin line to ui section
            sed -i '' "/ui:/,/^[^ ]/ s/\(^    defaultsToFullScreen: false\)/\1\n    skin: $theme/" "$config_file"
        fi
        echo "k9s theme switched to $theme ($mode mode)"
    else
        echo "k9s config file not found at $config_file" >&2
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

k9s_set_theme "$mode"