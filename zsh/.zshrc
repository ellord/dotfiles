## Interactive shell configuration

# Completion configuration
if [[ ":$FPATH:" != *":/Users/ellord/.zsh/completions:"* ]]; then 
    export FPATH="/Users/ellord/.zsh/completions:$FPATH"
fi
autoload -U edit-command-line
zle -N edit-command-line

# Key bindings
bindkey '^X^E' edit-command-line
bindkey '^[^[[D' backward-word    # Option + Left Arrow
bindkey '^[^[[C' forward-word     # Option + Right Arrow
bindkey '^[[1;3D' backward-word   # Alt + Left Arrow
bindkey '^[[1;3C' forward-word    # Alt + Right Arrow
bindkey '^[^?' backward-delete-word    # Option + Backspace
bindkey '^[[3;3~' delete-word          # Option + Fn + Backspace
bindkey '^W' backward-kill-word        # Ctrl + W
bindkey '^[d' kill-word                # Option + D
bindkey '^y' autosuggest-accept

# Aliases
alias ll="eza -al"
alias lg="lazygit"
alias tx="tmuxinator"
alias vim="nvim"
alias vi="nvim"

# Theme and colors
export LS_COLORS="$(vivid generate catppuccin-mocha)"
export EZA_COLORS="$(vivid generate catppuccin-mocha)"

# Tool initialization for interactive use
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f $HOME/.secrets ] && source $HOME/.secrets
eval "$(pyenv init -)"
eval "$(starship init zsh)"
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Google Cloud SDK
if [ -f '/Users/ellord/code/google-cloud-sdk/path.zsh.inc' ]; then 
    . '/Users/ellord/code/google-cloud-sdk/path.zsh.inc'
fi
if [ -f '/Users/ellord/code/google-cloud-sdk/completion.zsh.inc' ]; then 
    . '/Users/ellord/code/google-cloud-sdk/completion.zsh.inc'
fi

# tmux-manager autocomplete
_tm() {
    local -a sessions
    sessions=(${(f)"$(tmux list-sessions -F '#S' 2>/dev/null)"})
    _describe 'tmux sessions' sessions
}
compdef _tm tm

# Additional completions
[ -s "/Users/ellord/.bun/_bun" ] && source "/Users/ellord/.bun/_bun"

# GitHub copilot
eval "$(gh copilot alias -- zsh)"

# Deno
. "/Users/ellord/.deno/env"
