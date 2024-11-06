## Login shell configuration

# Editor
export EDITOR='/opt/homebrew/bin/nvim'
export VISUAL='/opt/homebrew/bin/nvim'

# Python configuration
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
export CLOUDSDK_PYTHON=python3
export PATH="$PATH:$HOME/.local/bin"
export PATH="$HOME/Library/Python/2.7/bin:$PATH"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Development tools
export GOPATH=$(go env GOPATH)
export GOBIN=$(go env GOPATH)/bin
export GOPROXY=direct
export PATH="$PATH:$GOPATH/bin"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Android SDK
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools

# Package managers
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Additional tools
export PATH="$HOME/.luarocks/bin:$PATH"
export PATH="/opt/homebrew/opt/helm@2/bin:$PATH"
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
export PATH="$PATH:$HOME/bin"
