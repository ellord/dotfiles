# Environment variables and base configuration
# This file is sourced first, even for non-interactive shells

# Base paths
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export ZSH_CONFIG_DIR="${ZDOTDIR:-$HOME}"

# Environment detection (work/personal)
export DOTFILES_ENV="${DOTFILES_ENV:-$(cat ~/.dotfiles-env 2>/dev/null || echo personal)}"
export MISE_ENV="$DOTFILES_ENV"

# Tool-specific paths
export PYENV_ROOT="$HOME/.pyenv"
export GOPATH=$(go env GOPATH 2>/dev/null || echo "$HOME/go")
export GOBIN="$GOPATH/bin"
export BUN_INSTALL="$HOME/.bun"

# Platform-specific paths
if [[ "$(uname -s)" == "Darwin" ]]; then
    export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
    export PNPM_HOME="$HOME/Library/pnpm"
else
    export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
    export PNPM_HOME="$HOME/.local/share/pnpm"
fi

# Lazygit config: base config + theme symlink (swapped by dark-notify)
export LG_CONFIG_FILE="$HOME/dotfiles/lazygit/config.yml,$HOME/.config/lazygit/theme.yml"

# Editor
export EDITOR="$(command -v nvim || command -v vim)"
export VISUAL="$EDITOR"
