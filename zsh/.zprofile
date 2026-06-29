# Login shell configuration
# This file is sourced only for login shells

# Initialize Homebrew if it exists (macOS ARM, macOS Intel, or Linuxbrew).
# Cached via _evalcache to avoid spawning brew on every login shell; the cached
# output still re-runs path_helper, so PATH stays correct.
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [ -x "$_brew" ]; then
        _evalcache brew-shellenv "$_brew" shellenv
        break
    fi
done
unset _brew

# Source our path configuration
source "$ZSH_CONFIG_DIR/.zsh/path.zsh"

# Additional environment setup
export GOPROXY=direct
export CLOUDSDK_PYTHON=python3

# NOTE: `pyenv init --path` was removed (~190ms). Python is provided by mise, whose
# shims are prepended later in .zshrc and shadow pyenv's anyway, so the pyenv block
# was dead weight. The `pyenv` command itself remains available on PATH. If a project
# needs a pyenv-only interpreter, run `eval "$(pyenv init --path)"` in that shell.
