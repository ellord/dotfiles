# Centralised path management
# This keeps all PATH modifications in one place

path_prepend() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1:$PATH"
    fi
}

path_append() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$PATH:$1"
    fi
}

# Development tools
path_prepend "$PYENV_ROOT/bin"
path_prepend "$HOME/.cargo/bin"
path_prepend "$GOBIN"
path_prepend "$BUN_INSTALL/bin"
path_prepend "$PNPM_HOME"
path_prepend "/opt/homebrew/opt/gnu-getopt/bin"

# Android SDK
path_append "$ANDROID_SDK_ROOT/emulator"
path_append "$ANDROID_SDK_ROOT/platform-tools"

# Local binaries
path_append "$HOME/.local/bin"
path_append "$HOME/bin"
path_append "$HOME/.luarocks/bin"
path_append "$HOME/.npm-global/bin"

# Homebrew optional packages
path_append "/opt/homebrew/opt/helm@2/bin"

export PATH
