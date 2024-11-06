# Environment variables and base configuration
# This file is sourced first, even for non-interactive shells

# Base paths
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export ZSH_CONFIG_DIR="${ZDOTDIR:-$HOME}"

# Tool-specific paths
export PYENV_ROOT="$HOME/.pyenv"
export GOPATH=$(go env GOPATH 2>/dev/null || echo "$HOME/go")
export GOBIN="$GOPATH/bin"
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="$HOME/Library/pnpm"

# Editor
export EDITOR="$(command -v nvim || command -v vim)"
export VISUAL="$EDITOR"
