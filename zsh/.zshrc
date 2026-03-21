# Add deno completions to search path
if [[ ":$FPATH:" != *":$HOME/.zsh/completions:"* ]]; then export FPATH="$HOME/.zsh/completions:$FPATH"; fi
# Interactive shell configuration

# Load modular configuration files
for config_file ($ZSH_CONFIG_DIR/.zsh/*.zsh(N)); do
    source $config_file
done

# Load environment-specific config files
for config_file ($HOME/dotfiles/env/$DOTFILES_ENV/zsh/dot-zsh/*.zsh(N)); do
    source $config_file
done

# Completion configuration
fpath_append() {
    if [ -d "$1" ] && [[ ":$FPATH:" != *":$1:"* ]]; then
        export FPATH="$1:$FPATH"
    fi
}

fpath_append "$ZSH_CONFIG_DIR/.zsh/completions"
fpath_append "$HOME/.docker/completions"
autoload -U edit-command-line
zle -N edit-command-line

# Key bindings
source "$ZSH_CONFIG_DIR/.zsh/keybindings.zsh"

# Aliases
source "$ZSH_CONFIG_DIR/.zsh/aliases.zsh"

# Theme and colors
if command -v vivid >/dev/null; then
    # On macOS, follow system appearance; elsewhere default to dark
    _vivid_theme="catppuccin-mocha"
    if [[ "$(uname -s)" == "Darwin" ]] && [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" != "Dark" ]]; then
        _vivid_theme="catppuccin-latte"
    fi
    export LS_COLORS="$(vivid generate "$_vivid_theme")"
    export EZA_COLORS="$LS_COLORS"
    unset _vivid_theme
fi

# Tool initialization for interactive use
if [ -f /opt/homebrew/etc/profile.d/autojump.sh ]; then
    source /opt/homebrew/etc/profile.d/autojump.sh
elif [ -f /usr/share/autojump/autojump.sh ]; then
    source /usr/share/autojump/autojump.sh
fi
command -v fzf >/dev/null && eval "$(fzf --zsh)"
[ -f "$HOME/.secrets" ] && source "$HOME/.secrets"

# Auto theme switching based on system appearance (macOS only)
if [[ "$(uname -s)" == "Darwin" ]] && command -v dark-notify >/dev/null; then
  if ! pgrep -x "dark-notify" >/dev/null; then
    dark-notify -c "$HOME/dotfiles/dark-notify-all.sh" >/dev/null 2>&1 &!
  fi
fi

# Initialize tools if they exist
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
command -v mise >/dev/null && eval "$(mise activate zsh)"
command -v starship >/dev/null && eval "$(starship init zsh)"

