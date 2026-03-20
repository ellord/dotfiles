#!/usr/bin/env bash
set -euo pipefail

# Central dispatcher for dark-notify theme switching.
# Called by dark-notify when macOS switches between light/dark mode.
#
# Usage: dark-notify-all.sh light|dark

DOTFILES_DIR="$HOME/dotfiles"

mode="${1:-}"
if [[ -z "$mode" ]]; then
    echo "Missing required argument 'mode'." >&2
    exit 1
elif [[ "$mode" != light && "$mode" != dark ]]; then
    echo "Mode must be 'light' or 'dark'." >&2
    exit 2
fi

update_shell_colors() {
    if ! command -v vivid &>/dev/null; then
        return
    fi
    local colors
    if [[ "$mode" == "dark" ]]; then
        colors="$(vivid generate catppuccin-mocha)"
    else
        colors="$(vivid generate catppuccin-latte)"
    fi
    export LS_COLORS="$colors"
    export EZA_COLORS="$colors"
}

dispatch_tool_scripts() {
    "$DOTFILES_DIR/claude/.claude/dark-notify-claude.sh" "$mode" || true
    "$DOTFILES_DIR/k9s/dark-notify-k9s.sh" "$mode" || true
    "$DOTFILES_DIR/lazygit/dark-notify-lazygit.sh" "$mode" || true
}

update_shell_colors
dispatch_tool_scripts
