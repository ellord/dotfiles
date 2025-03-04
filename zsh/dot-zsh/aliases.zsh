# Centralised aliases

alias ll="eza -al"
alias lg="lazygit"
alias nv="neovide --frame=none . >/dev/null 2>&1 &"
alias tx="tmuxinator"
alias vim="nvim"
alias vi="nvim"

# Function to update theme based on system appearance
update_theme() {
  if command -v vivid >/dev/null; then
    if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
      export LS_COLORS="$(vivid generate nightfox)"
    else
      export LS_COLORS="$(vivid generate dawnfox)"
    fi
    export EZA_COLORS="$LS_COLORS"
  fi
}

# Alias to manually update theme
alias update-theme="update_theme"
