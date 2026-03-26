# Centralised aliases

alias ll="eza -al"
alias lg="lazygit"
alias tx="tmuxinator"
alias vim="nvim"
alias vi="nvim"

# macOS-only aliases
if [[ "$(uname -s)" == "Darwin" ]]; then
    alias nv="neovide --frame=none . >/dev/null 2>&1 &"
    alias pwdcp='pwd | tee /dev/stderr | tr -d "\n" | pbcopy'
fi

# Function to update theme based on system appearance
update_theme() {
  if command -v vivid >/dev/null; then
    local _use_dark=true
    if [[ "$(uname -s)" == "Darwin" ]] && [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" != "Dark" ]]; then
      _use_dark=false
    fi
    if $_use_dark; then
      export LS_COLORS="$(vivid generate catppuccin-mocha)"
    else
      export LS_COLORS="$(vivid generate catppuccin-latte)"
    fi
    export EZA_COLORS="$LS_COLORS"
  fi
}

# Alias to manually update theme
alias update-theme="update_theme"

# Remote servers typically don't have terminfo for custom terminal emulators.
# Fall back to xterm-256color for SSH to ensure colors and keybindings work.
if [[ "$TERM" == "xterm-ghostty" || "$TERM" == "wezterm" ]]; then
    alias ssh='TERM=xterm-256color ssh'
    alias gcloud='TERM=xterm-256color gcloud'
fi
