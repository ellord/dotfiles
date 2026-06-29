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
# Static GOPATH (matches `go env GOPATH`); avoids forking `go` on every shell.
# Override by exporting GOPATH before this file runs.
export GOPATH="${GOPATH:-$HOME/go}"
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

# Cache the output of slow `eval "$(tool init)"` initialisers so each new shell
# sources a small file instead of re-spawning the tool. The cache is regenerated
# whenever it is missing/empty or the tool binary is newer than the cache.
#
# Usage:  _evalcache <name> <command> [args...]   e.g.  _evalcache fzf fzf --zsh
#
# IMPORTANT: only for *static* generators. Do NOT cache `mise activate`, which
# snapshots the live $PATH (including ephemeral dirs) and must run every shell.
#
# NOTE: do NOT wrap the `source` in `emulate -L zsh` / LOCAL_OPTIONS — the cached
# init scripts intentionally mutate global options (e.g. starship needs
# `setopt promptsubst`), which a local-options scope would revert on return.
_evalcache() {
    local name=$1; shift
    local bin=$1
    [[ $bin == /* ]] || bin=${commands[$1]}
    [[ -n $bin && -x $bin ]] || return 0
    local cache=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/evalcache/$name.zsh
    if [[ ! -s $cache || $bin -nt $cache ]]; then
        [[ -d ${cache:h} ]] || mkdir -p ${cache:h}
        local out; out=$("$@" 2>/dev/null)
        [[ -n $out ]] || return 0
        print -r -- "$out" >| $cache
    fi
    source $cache
}
