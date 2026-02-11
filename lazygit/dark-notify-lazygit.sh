#!/usr/bin/env bash
# This script will set the lazygit theme based on system appearance
# Called by dark-notify when macOS switches between light/dark mode

set -o errexit
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_NAME=${0##*/}

IFS= read -rd '' USAGE <<EOF || :
Set lazygit dark/light mode.
Usage: $ ${SCRIPT_NAME} light|dark
EOF

lazygit_set_theme() {
    local mode="$1"
    local theme_link="$HOME/.config/lazygit/theme.yml"
    local dotfiles_dir="$HOME/dotfiles/lazygit"

    # Determine which theme file to link
    local theme_file
    if [[ "$mode" == "light" ]]; then
        theme_file="$dotfiles_dir/theme-light.yml"
    else
        theme_file="$dotfiles_dir/theme-dark.yml"
    fi

    # Update symlink
    ln -sf "$theme_file" "$theme_link"
    echo "lazygit theme switched to $mode mode"
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

lazygit_set_theme "$mode"
