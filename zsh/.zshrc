# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/ellord/.zsh/completions:"* ]]; then export FPATH="/Users/ellord/.zsh/completions:$FPATH"; fi
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Word navigation
bindkey '^[^[[D' backward-word    # Option + Left Arrow
bindkey '^[^[[C' forward-word     # Option + Right Arrow
bindkey '^[[1;3D' backward-word   # Alt + Left Arrow (some terminals)
bindkey '^[[1;3C' forward-word    # Alt + Right Arrow (some terminals)

# Word deletion
bindkey '^[^?' backward-delete-word    # Option + Backspace
bindkey '^[[3;3~' delete-word          # Option + Fn + Backspace (forward delete on Mac)
bindkey '^W' backward-kill-word        # Ctrl + W
bindkey '^[d' kill-word                # Option + D

alias ll="eza -al"
alias lg="lazygit"
alias tx="tmuxinator"
alias vim="nvim"
alias vi="nvim"

# Autojump (j search)
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# Secret envs
[ -f $HOME/.secrets ] && source $HOME/.secrets

# JetBrains IDE CLIs
export PATH=$PATH:$HOME/bin

# Go
export PATH=$PATH:$(go env GOPATH)/bin
export GOPATH=$(go env GOPATH)
export GOBIN=$(go env GOPATH)/bin
export GOPROXY=direct

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Old version of Python 
export PATH="$HOME/Library/Python/2.7/bin:$PATH"

# To manage Python versions - mainly for gcloud compatibility
eval "$(pyenv init -)"

# Set Python version for gcloud CLI
export CLOUDSDK_PYTHON=python3

# eza / ls colour scheme
export LS_COLORS="$(vivid generate catppuccin-mocha)"
export EZA_COLORS="$(vivid generate catppuccin-mocha)"

# Fuzzy search
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ellord/code/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/ellord/code/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/ellord/code/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ellord/code/google-cloud-sdk/completion.zsh.inc'; fi

# Helm v2
export PATH="/opt/homebrew/opt/helm@2/bin:$PATH"

# Fix for getopt
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"

export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools

# tmux-manager autocomplete

_tm() {
    local -a sessions
    sessions=(${(f)"$(tmux list-sessions -F '#S' 2>/dev/null)"})
    _describe 'tmux sessions' sessions
}

compdef _tm tm

# bun completions
[ -s "/Users/ellord/.bun/_bun" ] && source "/Users/ellord/.bun/_bun"

# bun
export BUN_INSTALL="/Users/ellord/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/ellord/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# GitHub copilot aliases
eval "$(gh copilot alias -- zsh)"

# Created by `pipx` on 2024-07-11 01:37:39
export PATH="$PATH:/Users/ellord/.local/bin"

export PATH="$HOME/.luarocks/bin:$PATH"

eval "$(starship init zsh)"

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^y' autosuggest-accept

#export EDITOR="/opt/homebrew/bin/nvim"
#export VISUAL="/opt/homebrew/bin/nvim"
. "/Users/ellord/.deno/env"
