# Login shell configuration
# This file is sourced only for login shells

# Initialize Homebrew if it exists
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Source our path configuration
source "$ZSH_CONFIG_DIR/.zsh/path.zsh"

# Additional environment setup
export GOPROXY=direct
export CLOUDSDK_PYTHON=python3

# Initialize pyenv for login shell
if command -v pyenv >/dev/null; then
    eval "$(pyenv init --path)"
fi
