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

# Move a directory to the front of PATH even when it is already present.
# path_prepend is a no-op in that case, which is not enough for dirs that
# something else put behind the system ones.
path_promote() {
    # `return 0` on a missing dir, matching path_prepend/path_append, which are
    # no-ops rather than failures. A bare `return` would exit 1 and take an
    # errexit shell down with it.
    [ -d "$1" ] || return 0
    # "${(@)path:#...}" keeps empty elements, which a bare ${path:#...} would drop.
    path=("$1" "${(@)path:#"$1"}")
}

# Development tools
path_prepend "$HOME/.cargo/bin"
path_prepend "$GOBIN"
path_prepend "$BUN_INSTALL/bin"
path_prepend "$PNPM_HOME"

# Android SDK
path_append "$ANDROID_SDK_ROOT/emulator"
path_append "$ANDROID_SDK_ROOT/platform-tools"

# Local binaries
path_append "$HOME/.local/bin"
path_append "$HOME/bin"
path_append "$HOME/.luarocks/bin"
path_append "$HOME/.npm-global/bin"
path_append "$HOME/.config/claude/local/claude"

# macOS-specific paths
if [[ "$(uname -s)" == "Darwin" ]]; then
    path_prepend "/opt/homebrew/opt/gnu-getopt/bin"

    # cmux ships an `open` wrapper that routes http(s) URLs into its embedded
    # browser, but /etc/zprofile's path_helper hoists /usr/bin above the dir cmux
    # added, so /usr/bin/open shadows it. Promote it inside cmux panes only —
    # this dir also holds cmux's own ghostty/grok/cmux builds.
    if [[ -n "${CMUX_SOCKET_PATH:-}" ]]; then
        path_promote "/Applications/cmux.app/Contents/Resources/bin"
    fi

    path_append "/Applications/Obsidian.app/Contents/MacOS"
    path_append "/Applications/Docker.app/Contents/Resources/bin"
    path_append "/opt/homebrew/opt/helm@2/bin"
fi

export PATH
