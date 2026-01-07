# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/ellord/.zsh/completions:"* ]]; then export FPATH="/Users/ellord/.zsh/completions:$FPATH"; fi
# Interactive shell configuration

# Load modular configuration files
for config_file ($ZSH_CONFIG_DIR/.zsh/*.zsh(N)); do
    source $config_file
done

# Completion configuration
fpath_append() {
    if [ -d "$1" ] && [[ ":$FPATH:" != *":$1:"* ]]; then
        export FPATH="$1:$FPATH"
    fi
}

fpath_append "$ZSH_CONFIG_DIR/.zsh/completions"
autoload -U edit-command-line
zle -N edit-command-line

# Key bindings
source "$ZSH_CONFIG_DIR/.zsh/keybindings.zsh"

# Aliases
source "$ZSH_CONFIG_DIR/.zsh/aliases.zsh"

# Theme and colors
if command -v vivid >/dev/null; then
    # Check if system is in dark mode (only works on macOS)
    if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
        export LS_COLORS="$(vivid generate catppuccin-mocha)"
        export EZA_COLORS="$LS_COLORS"
    else
        export LS_COLORS="$(vivid generate catppuccin-latte)"
        export EZA_COLORS="$LS_COLORS"
    fi
fi

# Tool initialization for interactive use
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && source /opt/homebrew/etc/profile.d/autojump.sh
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"
[ -f "$HOME/.secrets" ] && source "$HOME/.secrets"

# Auto theme switching based on system appearance
if command -v dark-notify >/dev/null; then
  # Start dark-notify if not already running
  if ! pgrep -x "dark-notify" >/dev/null; then
    dark-notify -c "source ~/.zshrc; update_theme" >/dev/null 2>&1 &
  fi
  
  # Start dark-notify for Claude Code theme switching
  if ! pgrep -f "dark-notify.*claude" >/dev/null; then
    dark-notify -c "$HOME/dotfiles/claude/.claude/dark-notify-claude.sh" >/dev/null 2>&1 &
  fi

  # Start dark-notify for k9s theme switching
  if ! pgrep -f "dark-notify.*k9s" >/dev/null; then
    dark-notify -c "$HOME/dotfiles/k9s/dark-notify-k9s.sh" >/dev/null 2>&1 &
  fi
fi

# Initialize tools if they exist
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
command -v pyenv >/dev/null && eval "$(pyenv init -)"
command -v starship >/dev/null && eval "$(starship init zsh)"
command -v gh >/dev/null && eval "$(gh copilot alias -- zsh)"

# Tool-specific configurations
if [ -d "$HOME/code/google-cloud-sdk" ]; then
    source "$HOME/code/google-cloud-sdk/path.zsh.inc"
    source "$HOME/code/google-cloud-sdk/completion.zsh.inc"
fi

# pnpm
export PNPM_HOME="/Users/ellord/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
