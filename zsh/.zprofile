# Login shell configuration
# This file is sourced only for login shells

# Initialize Homebrew if it exists (macOS ARM, macOS Intel, or Linuxbrew)
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
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
