#!/usr/bin/env bash
# This script will set the squix color scheme based on system appearance
# Called by dark-notify when macOS switches between light/dark mode.
#
# squix reads its config only at startup and has no live reload, so this
# rewrites color_scheme in place; the next squix launch picks up the change.

set -o errexit
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_NAME=${0##*/}

IFS= read -rd '' USAGE <<EOF || :
Set squix dark/light mode.
Usage: $ ${SCRIPT_NAME} light|dark
EOF

squix_set_theme() {
    local mode="$1"
    local config_file="$HOME/.config/squix/config.yaml"

    # squix ships no catppuccin-latte; terracotta is its only light scheme.
    local scheme
    if [[ "$mode" == "light" ]]; then
        scheme="terracotta"
    else
        scheme="catppuccin-mocha"
    fi

    if [[ ! -f "$config_file" ]]; then
        echo "squix config file not found at $config_file" >&2
        exit 3
    fi

    # macOS sed requires -i '', GNU sed uses -i (no argument)
    local sed_inplace=(-i)
    if [[ "$(uname -s)" == "Darwin" ]]; then
        sed_inplace=(-i '')
    fi

    if grep -q "^color_scheme:" "$config_file"; then
        sed "${sed_inplace[@]}" "s/^color_scheme: .*/color_scheme: $scheme/" "$config_file"
    else
        printf 'color_scheme: %s\n' "$scheme" >>"$config_file"
    fi
    echo "squix color scheme switched to $scheme ($mode mode)"
}

mode="$1"
if [[ -z "$mode" ]]; then
    echo "Missing required argument 'mode'." >&2
    echo "$USAGE" >&2
    exit 1
elif [[ "$mode" != light ]] && [[ "$mode" != dark ]]; then
    echo "Mode must be 'light' or 'dark'." >&2
    echo "$USAGE" >&2
    exit 2
fi

squix_set_theme "$mode"
