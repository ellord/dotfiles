# Shared aliases (bash + zsh)

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

# Function to update theme based on system appearance.
# Priority: forwarded $THEME_MODE (SSH) > cached file (macOS dark-notify) > inline.
update_theme() {
  if [[ -n "$THEME_MODE" ]] && command -v vivid >/dev/null; then
    case "$THEME_MODE" in
      dark)  export LS_COLORS="$(vivid generate catppuccin-mocha)" ;;
      light) export LS_COLORS="$(vivid generate catppuccin-latte)" ;;
      *)     export LS_COLORS="$(vivid generate catppuccin-mocha)" ;;
    esac
    export EZA_COLORS="$LS_COLORS"
  elif [[ -f "$HOME/.local/state/shell-theme-colors" ]]; then
    source "$HOME/.local/state/shell-theme-colors"
  elif command -v vivid >/dev/null; then
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
    alias gcloud='TERM=xterm-256color gcloud'
fi

# ssh wrapper: OS-agnostic TERM fallback + macOS appearance forwarding.
# Forwards THEME_MODE so remote shells can apply dark/light theme colours.
# Remote sshd must AcceptEnv THEME_MODE (see sshd_config.d/60-theme-mode.conf).
ssh() {
    local -a env_prefix=()
    if [[ "$TERM" == "xterm-ghostty" || "$TERM" == "wezterm" ]]; then
        env_prefix+=(TERM=xterm-256color)
    fi
    if [[ "$(uname -s)" == "Darwin" ]]; then
        if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
            env_prefix+=(THEME_MODE=dark)
        else
            env_prefix+=(THEME_MODE=light)
        fi
    fi
    env "${env_prefix[@]}" ssh -o SendEnv=THEME_MODE "$@"
}
